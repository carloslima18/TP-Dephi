unit uFrmFaturamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.ListBox, FMX.Layouts, FMX.TabControl, FMX.Edit, FMX.SearchBox,
  System.Actions, FMX.ActnList, Classes.Utils.View, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.MongoDBDataSet, uDmDados;

type
  TfrmFaturamento = class(TForm)
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    Label1: TLabel;
    TabControl1: TTabControl;
    tabFaturamento: TTabItem;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    lblCliente: TLabel;
    ListBoxItem2: TListBoxItem;
    Label3: TLabel;
    lblProfissional: TLabel;
    SpeedButton2: TSpeedButton;
    ListBoxItem3: TListBoxItem;
    Label4: TLabel;
    SpeedButton3: TSpeedButton;
    Layout1: TLayout;
    tabCliente: TTabItem;
    tabProfissional: TTabItem;
    tabServico: TTabItem;
    lbCliente: TListBox;
    SearchBox1: TSearchBox;
    lbProfissional: TListBox;
    SearchBox2: TSearchBox;
    lbServico: TListBox;
    SearchBox3: TSearchBox;
    lblValorTotal: TLabel;
    ActionList1: TActionList;
    changeCliente: TChangeTabAction;
    changeFaturamento: TChangeTabAction;
    changeProfissional: TChangeTabAction;
    changeServico: TChangeTabAction;
    SpeedButton4: TSpeedButton;
    dsMongoGenerico: TFDMongoDataSet;
    TabControl2: TTabControl;
    TabItem1: TTabItem;
    ChangeTabPagamento: TChangeTabAction;
    SpeedButton6: TSpeedButton;
    lbServicoFatura: TListBox;
    lbPagamento: TListBox;
    ListBoxHeader1: TListBoxHeader;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure lbClienteItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbProfissionalItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbServicoItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    //procedure BtnPagamento(Sender: TObject);
  private
    { Private declarations }
    FUtils:TUtilsView;
    FCodCliente: Integer;
    FCodProfissional: Integer;
    FValorTotal: Currency;
    procedure SetCodCliente(const Value: Integer);
    procedure SetCodProfissional(const Value: Integer);
    procedure addItemFaturado;
    procedure SetValorTotal(const Value: Currency);
    function getValorTotal: Currency;
  public
    { Public declarations }
    //para salvar o (id)codigo de cliente, prof,,. (função lbProfissional IntemCli
    property CodCliente:Integer read FCodCliente write SetCodCliente;
    property CodProfissional:Integer read FCodProfissional write SetCodProfissional;
    property ValorTotal: Currency read getValorTotal ;
  end;

var
  frmFaturamento: TfrmFaturamento;

implementation

{$R *.fmx}

uses ufrmPrincipal;

//para add os item escolhidos para fatura(parte do serviços)
procedure TfrmFaturamento.addItemFaturado;
var
  lbItem : TListBoxItem;
begin
   try //para tratar erros
       lbItem := TListBoxItem.Create(self);
       //listBoxItemServiço-> tipo de personalização de list box
       //StyleLookup-> para personalização do listBox novo criado(2 labels em cada canto)
       lbItem.StyleLookup := 'ListBoxItemServico';
      //OBS::tira de um list box e joga para o outro
      //itemDow -> e o list box item que foi seceliconado em questao
      lbItem.StylesData['descricao'] := lbServico.ItemDown.StylesData['descricao'];
      lbItem.StylesData['valor'] :=  lbServico.ItemDown.StylesData['valor'];
      lbItem.StylesData['key'] :=  lbServico.ItemDown.StylesData['key'];
      lbServicoFatura.AddObject(lbItem); //para ao listBox
      //dps que add , pego o obj tiro da lista servioc e add na lista de servicos faturados
      lblValorTotal.Text:= FormatCurr('RS #,##0.00',ValorTotal);//valortotal == getvalortotal
   except
       raise Exception.Create('nao foi possivel add o item');
   end;
  end;

procedure TfrmFaturamento.FormCreate(Sender: TObject);
begin
  //Seta a primeira tab
  TabControl1.TabIndex := 0;
  //e esconde as abas
  TabControl1.TabPosition := TabControl1.TabPosition.tpNone;
  //toda vez que o fomr for criado vamos limpar o list BOx
  lbServicoFatura.Items.Clear;
  end;

//para somar os componentes do list box
function TfrmFaturamento.getValorTotal: Currency;
var
I : Integer;
begin
  Result :=  0;
  //varre os listBox, da tabItem1 serviçoes que estao faturados
  for I := 0 to lbServicoFatura.Items.Count-1 do
  begin
  //listToCurr(vai pega o valor do servico que esta no listBox, trazendo o valor, para i somando)
      Result := Result + FUtils.ListToCurr(lbServicoFatura.ItemByIndex(I).StylesData['valor'].ToString);
  end;
end;

procedure TfrmFaturamento.lbClienteItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin

  //(nome do cliente) label_CLienterecebe := pega o intem do obj,  lista os item, pegando o numero que o item ta selecionado começando de 0,.1..2(posicao do selecionado) ex: carlos..
  lblCliente.Text :=   lbCliente.Items[lbCliente.ItemIndex];

  //(id do cliente)(captura o codigo do cliente)traz o obj que esta no intem que foi selecionado
  CodCliente := Integer(lbCliente.Items.Objects[lbCliente.ItemIndex]);


  changeFaturamento.ExecuteTarget(Self);


  end;

procedure TfrmFaturamento.lbProfissionalItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
//armazena nessas var e ja joga na tela
  //Pega o nome msm coisa que fez com cliente
  lblProfissional.Text:= lbProfissional.Items[lbProfissional.ItemIndex];

  //pega o id(codigo)
  CodProfissional := Integer(lbProfissional.Items.Objects[lbProfissional.ItemIndex]);

  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.lbServicoItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
        //antes de troca de tela add o valor na lista de produtos faturado
  addItemFaturado;
  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem1Click(Sender: TObject);
begin   //preencher a lista
  FUtils.fnc_carregarDataSet('SALAO','CLIENTES',dsMongoGenerico);
  FUtils.fnc_montarGrid(lbCliente, dsMongoGenerico, 'CODIGO','NOME' );
  changeCliente.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem2Click(Sender: TObject);
begin
    FUtils.fnc_carregarDataSet('SALAO','PROFISSIONAIS',dsMongoGenerico);
  FUtils.fnc_montarGrid(lbProfissional, dsMongoGenerico, 'CODIGO','NOME' );
  changeProfissional.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem3Click(Sender: TObject);
begin
  FUtils.fnc_carregarDataSet('SALAO','SERVICOS',dsMongoGenerico);
  FUtils.fnc_montarGrid(lbServico, dsMongoGenerico,'DESCRICAO','VALOR', 'CODIGO' );
  changeServico.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.SetCodCliente(const Value: Integer);
begin
  FCodCliente := Value;
end;

procedure TfrmFaturamento.SetCodProfissional(const Value: Integer);
begin
  FCodProfissional := Value;
end;

procedure TfrmFaturamento.SetValorTotal(const Value: Currency);
begin
  FValorTotal := Value;
end;

procedure TfrmFaturamento.SpeedButton4Click(Sender: TObject);
begin
  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.SpeedButton6Click(Sender: TObject);
begin
//preenche os pagamento
    FUtils.fnc_carregarDataSet('SALAO','PAGAMENTOS',dsMongoGenerico);
    FUtils.fnc_montarGrid(lbPagamento, dsMongoGenerico, 'CODIGO','Descricao' );
     ChangeTabPagamento.ExecuteTarget(Self);
end;




end.
