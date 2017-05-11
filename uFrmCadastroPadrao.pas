unit uFrmCadastroPadrao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListBox, FMX.Edit, FMX.SearchBox, FMX.TabControl, FireDAC.Phys.MongoDBWrapper,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MongoDBDataSet, FireDAC.Stan.Async, FireDAC.DApt,
  uFrmMensagensPadrao, mongo.FMX.Edit, Classes.Utils.View;

type   //declara um tipo de variavel especifica
		TAcao = (tpInsert, tpUpdate, tpLista);

type
  TfrmCadastroPadrao = class(TForm)
    Panel2: TPanel;
    btnNovo: TButton;
    ActionList1: TActionList;
    acSalvar: TAction;
    acExcluir: TAction;
    acSair: TAction;
    acNovo: TAction;
    acEditar: TAction;
    btnSalvar: TButton;
    btnExcluir: TButton;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    TabControl1: TTabControl;
    tabLista: TTabItem;
    tabCadastro: TTabItem;
    ListBox1: TListBox;
    SearchBox1: TSearchBox;
    ListBoxItem1: TListBoxItem;
    changeTabLista: TChangeTabAction;
    changeTabCadastro: TChangeTabAction;
    ListBox2: TListBox;
    dsMongo: TFDMongoDataSet;
    btnVoltar: TButton;
    acVoltar: TAction;
    procedure acNovoExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure acSalvarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
    const Item: TListBoxItem);
    procedure FormDestroy(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
    //procedure Button2Click(Sender: TObject);
    procedure acVoltarExecute(Sender: TObject);
    //procedure ListBoxItem6Click(Sender: TObject);
  private
  { Private declarations }
    //cria as variaveis da published
    FBanco: String;
    FAcao: TAcao;  //ação do tipo, insert ou update
    FCollection: String;
    //passa por parametro um obj do tipo MongoDOC
    procedure fnc_PreencheMongoDoc(var MongoDoc : TMongoDocument);
    //passa por parametro um obj do tipo MongoUpd
    procedure fnc_PreencherMongoUpd(var MongoUpd : TMongoUpdate);
    //limpa os doc do tMongoEdit
    procedure fnc_limparCampos;
    //carrega as info do BD para os listBox //para atualia as listbox quando os dados sao gravados
    procedure fnc_atualizaLista;
    //para gerencia os form exclui e atualiza o novo inserido
    procedure fnc_gerenciarForms;
    //parametro, passa o inteiro e a const que e o listBoxI, para percorre para acha o campo chave((definido no criação do TeditMongo
    procedure fnc_buscarCampoChave(var i: Integer; const Item: TListBoxItem);
    //atualiza os campos para a edição das informaçoes ja gravadas no BD
    procedure fnc_PreencherRegistros;
    //exclui registros
    procedure fnc_excluirRegistro;
    //exibe a mensagem passando os paremetros que serao mostrados nela, tipo para dada cor
    procedure fnc_ExibirMensagem(Tit, Msg : String; tpMsg : TTipoMensagem);
    //exibe os botôes de acordo com a tab que esta no form
    procedure fnc_exibirBotoes;
    //
    procedure SetUtils(const Value: TUtilsView);

  public
    { Public declarations }
    //var que e instanciada a classe UtilsView para reuso do codigo dela
     FUtils: TUtilsView;
    //para preencher os list Box --- virtual-> permite que seu metodo seja sobrescrito com o msm com o msm nome em um subclasse de parametros diferentes
    procedure fnc_montarGrid; virtual; abstract;

  published//metodos de execução runtime -> quando o prog esta executando
    { Public published }
    //acao do tipo acaod(update, insert, lista)
    property Acao : TAcao read FAcao write FAcao;
    //banco e colection, usadas para receber o banco de dados(nome) e a tabela
    property Banco : String read FBanco write FBanco;
    property Collection : String read FCollection write FCollection;
    //propriedade para usa a classe classeUtilsView
    property Utils: TUtilsView read FUtils write SetUtils;
  end;

var
  frmCadastroPadrao: TfrmCadastroPadrao;

implementation

{$R *.fmx}

uses uDmDados, ufrmPrincipal, mongo.Types;

//pucha\mostra a tab cadastro novamente para a edição
procedure TfrmCadastroPadrao.acEditarExecute(Sender: TObject);
begin
  changeTabCadastro.ExecuteTarget(Self);
  fnc_exibirBotoes;
end;

//executa a exclusao de um item selectionado(aonde o cursor se encontra)
procedure TfrmCadastroPadrao.acExcluirExecute(Sender: TObject);
begin
  fnc_excluirRegistro;//chama a função de excluir registro
  fnc_ExibirMensagem('Excluir Registro', 'Registro Excluido com Sucesso', tpErro);
  fnc_atualizaLista;  //atualiza a lista
  changeTabLista.ExecuteTarget(Self);//sai da tab de cadastro e volta pra tab de lista
  fnc_exibirBotoes;
end;

//chama a tab cadastro para ser preenchido um novo cregistro
procedure TfrmCadastroPadrao.acNovoExecute(Sender: TObject);
begin
  Self.FAcao := tpInsert; // chama de acordo com o botao, ex como é o actNovo, chama a função tpInsert
  fnc_limparCampos;//limpa os campos dos registros antes de trocar a tela
  changeTabCadastro.ExecuteTarget(Self); // para quando clicar em novo, chama a pag de cadastro a tab cadastro
  fnc_exibirBotoes;
end;

//salva os registros no mongoDOc  -> var MongoDoc passa como referencia, quando a funcao termina, doc vai esta preenchudo
//varre todos os componentes que tem no formulario
procedure TfrmCadastroPadrao.fnc_PreencheMongoDoc(var MongoDoc: TMongoDocument);
var
  i: Integer;
begin
  for i := Self.ComponentCount - 1 downto 0 do //roda os componetes do formulario
  begin
   if (Self.Components[i] is TMongoEdit) then
  begin
    case TMongoEdit(Self.Components[i]).MongoTipoCampo of //pega o tipo que o componente e, defino na criação do mongoEdit
    Texto://se for texto
      begin
      //add ao mongoDoc, o que esta em mongoDocEdit
        MongoDoc.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).Text);
      end;
    Numerico:
      begin
        MongoDoc.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toNumerico);
      end;
    Moeda:
      begin
        MongoDoc.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toMoeda);
      end;
    DataHora:
      begin
       MongoDoc.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toDataHora);
      end;
    end;
  end;
  end;
end;

//passa parametro, classe tmongoUpdate 'permite alterar os valores para dps ser usada'-> tipo mongoDOc que preenche os documentos, e devolve ele (a classe) para a função fazer o insert,// que nem a funão preencherMongoDoc
procedure TfrmCadastroPadrao.fnc_PreencherMongoUpd(var MongoUpd : TMongoUpdate);
var
  i: Integer;
begin
  for i := Self.ComponentCount - 1 downto 0 do//percorre os componentes
  begin
    if (Self.Components[i] is TMongoEdit) then//se for do tipo tEditMongo
    begin

      //Verificando se é o CampoChave
      if TMongoEdit(Self.Components[i]).CampoChave then
        //'confição para fazer update 'match' tipo o were nos outros banco de dados,,
        //.add(recebe a chave(Teditmongo e o valor(toNumerico),
        MongoUpd.Match().Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toNumerico);

      //Percorre os Campos para Preencher o Set
      //setando os campos
      //case parametro e moongoTipoCampo, definido pelos TeditMongo la na interface,'text, numerico...
      case TMongoEdit(Self.Components[i]).MongoTipoCampo of
      Texto:
        begin
        //modufy.set.field'seta o campo'..     mongoupdtate,'modifica o campo' e o valoor, .text
          MongoUpd.Modify().&Set().Field(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).Text);
        end;
      Numerico:
        begin
          MongoUpd.Modify().&Set().Field(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toNumerico);
        end;
      Moeda:
        begin
          MongoUpd.Modify().&Set().Field(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toMoeda);
        end;
      DataHora:
        begin
          MongoUpd.Modify().&Set().Field(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toDataHora);
        end;
      end;
    end;
  end;
end;

//carrega as info do BD para os listBox //para atualia as listbox quando os dados sao gravados
procedure TfrmCadastroPadrao.fnc_atualizaLista;
begin
  Utils.fnc_carregarDataSet(FBanco, FCollection,dsMongo);
  fnc_montarGrid;
end;

//exibe os botões salvar, novo, voltar e excluir de acordo com oq a tab está
procedure TfrmCadastroPadrao.fnc_exibirBotoes;
begin
  btnSalvar.Align := TAlignLayout(2); //(2)-> top (posicao de alinhamento do botao)
  case TabControl1.TabIndex of       //seleciona a tab
    0 ://tab lista
      begin
          btnSalvar.Visible := false;
          btnExcluir.Visible := false;
          btnVoltar.Visible := false;
          btnNovo.Visible := true;
      end;
    1 ://tab cadastro
      begin
          btnSalvar.Visible := true;
          btnExcluir.Visible := true;
          btnVoltar.Visible := true;
          btnNovo.Visible := false;
      end;
  end;
  btnSalvar.Align := TAlignLayout(3); //(3) left
end;

//salva os dados no BD
procedure TfrmCadastroPadrao.acSalvarExecute(Sender: TObject);
var
 //declarou a var MongoDoc ;;TMongoDocument, ja e classe do pacote mongo; herda da classe TmongoDocument(ctrl + shift + a) atalho para declarar essa classe na uses
 MongoDoc : TMongoDocument;
 //declarou o mongo update para salvar as alterações caso edição
 MongoUpd : TMongoUpdate;
begin
  try //para que no final limpe o mongo doc para novo salvamento
    case FAcao of //tipo de variavel que guarda, se a ação vai ser edta, salva ou lista

      tpInsert:   //se FAcao por == tpInsert
      begin
        with dmDados do
        begin
          //criou a var mongodoc, Faz a conexão com o banco de dados- parametro,=>conexão com 0 FConMongo recebe em DMDADOS na procedure create
          // env-> classe que monitora a conexao para caso aja erro
          try
          // pega o nome do banco em FBanco e a tabela FCollection que sendo chamado para uso la em ufrmcadastroServiço  com o self na procedure formCreate
          // logo vai ser inserido no documento MongoDoc  que esta sendo preenchido em fnc_PreencheMongoDoc(monoDoc)
          //no banco passado e na colection passa, que vai pegar de acordo com o from representou no create , vai inserir o documento, com insert[mongo DOc]
            fnc_PreencheMongoDoc(MongoDoc);
            //insere os registros do mongoDoc no banco do mongo
            FConMongo[FBanco][FCollection].Insert(MongoDoc);
            fnc_ExibirMensagem('Inserir Registro', 'Registro Inserido com Sucesso', tpSucesso);
          finally
            MongoDoc.Free;    //limpa o mongo doc
          end;
        end;
      end;

      tpUpdate:
      begin
        //tipo mongoDoc, cria uma 'instancia da classe MongoUpdate
        //faz a conexão com o BD
        MongoUpd := TMongoUpdate.Create(dmDados.FConMongo.Env);
        try
          with dmDados do
          begin
            fnc_PreencherMongoUpd(MongoUpd); //preencheu o mongoUpd criado logo a cima
            FConMongo[FBanco][FCollection].Update(MongoUpd);//salva oq foi atualizado no BD
            fnc_ExibirMensagem('Atualizar Registro', 'Registro Atualizado com Sucesso', tpInfo);
          end;
        finally
          MongoUpd.Free; //apaga o mongoUpd
        end;

      end;
    end;
  finally    //atualize a lista e volta para o list
    fnc_atualizaLista;//antes de salvar , atualiza os registros do listBox
    changeTabLista.ExecuteTarget(Self);
    fnc_exibirBotoes;
  end;
end;

//volta a tab Lista, aonde contem os dados listados
procedure TfrmCadastroPadrao.acVoltarExecute(Sender: TObject);
begin
  FAcao := tpLista;
  changeTabLista.ExecuteTarget(Self);
  fnc_exibirBotoes;
end;

//--------------

//gerencia os forms, atualiza retirando da memoria e atualiza o novo form estanciado
procedure TfrmCadastroPadrao.fnc_gerenciarForms;
begin
//se formPrincipal.FormAtual existir, limpa ele, e dps...
  if Assigned(frmPrincipal.FormAtual) then
    frmPrincipal.FormAtual.Free;
//.. pega o forme que estancio novo, e joga na memoria
  frmPrincipal.FormAtual := Self;
end;

//função para verificar se o id ja possui um igual, e n deixa muda, em caso de edição
procedure TfrmCadastroPadrao.fnc_buscarCampoChave(var i: Integer; const Item: TListBoxItem);
var
  Local_i: Integer;
begin
  //Pesquisar por Campo Chave e Colocar como Somente Leitura
  //percorre todos os componentes da tela
  for Local_i := Self.ComponentCount - 1 downto 0 do//percorre todos os campos da tela
  begin
    if (Self.Components[Local_i] is TMongoEdit) then //aonde for tEdit Mongo
    begin
    //verifica se o campo chave ta ativo,, se ta true
      if TMongoEdit(Self.Components[Local_i]).CampoChave then
      begin
      // Item.data-> pega o obj que salvou la no listbox1//   //locate e msm coisa que(procura no banco)  -> dmDados.FConMongo[FBanco][FCollection].FIND('parametroDOcodigo'));
      //self.componentes[local_i].MongoCampo-> pega o id do banco,, para n precisa trabalha com o id enorme do BD oferece
        dsMongo.Locate(TMongoEdit(Self.Components[Local_i]).MongoCampo, Integer(Item.Data)); //Item.Data=> pega o id que do dado que esta no listbox(referente ao BD)

        //para n se repetir o campo chave
        if FAcao <> tpInsert then//verifica a ação, se acao for diferente de insert, == (o registro ja foi inserido agr quer fazer update)
        // pega o campo chave, que achou dentro do for, e faz esse ser readOnly, se e 3 vai ficar 3 (n vai poder alterar)
         //TMongoEdit(Self.Components[Local_i]).ReadOnly := true;  //readonly n deixa edita o codigo la na interface
      end;
    end;
  end;
end;

//preenche os campos de cadastro para edição dos dados la na interface
procedure TfrmCadastroPadrao.fnc_PreencherRegistros;
var
  i: Integer;
begin
  //percorre os componentes e Preencher o Seu Valor jogando no edit
  for i := Self.ComponentCount - 1 downto 0 do
  begin
    if (Self.Components[i] is TMongoEdit) then //verifica se o componente e tEditMongo
    begin
      //pega o tEditMongo a propriedade de texto dele vai recebe := dataset, e o campo que quer pegar (mongocampo do tEdit mongo  e força ele para string
      //vai la no dataset, pois c cursor esta parado nele, dai pegou oq esta no campo
      TMongoEdit(Self.Components[i]).Text := dsMongo.FieldByName(TMongoEdit(Self.Components[i]).MongoCampo).AsString;
    end;
  end;
end;

//exclui um resgistro do BD, de acordo com a chave que esta no TeditMongo
procedure TfrmCadastroPadrao.fnc_excluirRegistro;
var //OBSSSS::::: n preciso de parametro pos a chave esta embutida nos TeditMongo
  i: Integer;
begin
     //varre os componentes
  for i := Self.ComponentCount - 1 downto 0 do
  begin
    if (Self.Components[i] is TMongoEdit) then//se o componente for do tipo TeditMongo
    begin
      if TMongoEdit(Self.Components[i]).CampoChave then//se componente e um campo chave
      begin//dmDados,'busca a conexão com o mongo'
      //passou o banco e a tabela, ai chama a função remove, math(Were'aonde')  e recebe a chave e o valor do campo                         //valor         //exec-> ja exclui o registro la no BD
        dmDados.FConMongo[FBanco][FCollection].Remove.Match.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toNumerico).&End.Exec;
      end;
    end;
  end;
end;

procedure TfrmCadastroPadrao.fnc_ExibirMensagem(Tit, Msg : String; tpMsg : TTipoMensagem);
var //cria um novo forme de mensagem
  FormMensagem : TfrmMensagemPadrao;
begin
       //estancia o form para essa variavel
  FormMensagem := TfrmMensagemPadrao.Create(Self);
    //mensagem chama a função de atualiza mensagem, façando o titulo msg e tipo
  FormMensagem.fnc_atualizarMensagem(Tit, Msg, tpMsg);
    //exibe a mensaegem, passando o lyout que quer ser exibido
  frmPrincipal.exibirMensagem(FormMensagem.layoutMensagem);
end;

//limpa os TeditMongo, para novos registros
procedure TfrmCadastroPadrao.fnc_limparCampos;
var  //varre os componentes que e de TMongoedit e limpa ele
  i: Integer;
begin
  for i := Self.ComponentCount - 1 downto 0 do
    begin
    if (Self.Components[i] is TMongoEdit) then
    begin
        TMongoEdit(Self.Components[i]).Text := '';
    end;
  end;
end;

//acoes para quando se cria o formPadrao
procedure TfrmCadastroPadrao.FormCreate(Sender: TObject);
begin
   //estancia um objto da classe ultilView
    FUtils:= TutilsView.Create;
   //gerencia a instancias dos formularios, para limpar o antigo e colocar o novo
    fnc_gerenciarForms;
   // quando abrir o formPadrao, sera aberta na tab lista(0), e nao na cadastro(1).
   TabControl1.TabIndex := 0;
   //faz com que suma as tabes na parte superior
   TabControl1.TabPosition := TabControl1.TabPosition.tpNone;
  //atualizar o listbox, com os registros
  fnc_atualizaLista;
  //exibi os botões salvar, excluir, voltar.. de acordo com a tab que esta
  fnc_exibirBotoes;
end;

//função que fecha um formulario ou retira da memoria
procedure TfrmCadastroPadrao.FormDestroy(Sender: TObject);
begin
  FUtils.Destroy;
  dsMongo.Close;
end;

//add as informações que serao editadas na tab cadastro, para a edição ao clicar no listBox da msm
procedure TfrmCadastroPadrao.ListBox1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
var
  i : integer;
begin
//a partir desse momento o form padrao vai atribuir uma ação de update
 //quando clicar no list box, vai se feita uma aação de update
  Self.Acao := tpUpdate;//atribui a ação para editar e jogar no fnc_buscarCampoChave(i, Item); para faze a edição
  //verifica a duplicidade de id
  fnc_buscarCampoChave(i, Item);
  //preenche todos os registros
  fnc_PreencherRegistros;
  //e troca a tab lista para cadastro
  changeTabCadastro.ExecuteTarget(Self); //altera para a tab de cadastro para poder fazer o cadastro
  fnc_exibirBotoes;
end;


procedure TfrmCadastroPadrao.SetUtils(const Value: TUtilsView);
begin
  FUtils := Value;
end;

end.
