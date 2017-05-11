unit ufrmPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.Menus, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation,
  FMX.MultiView, FMX.StdCtrls, FMX.Objects, uFrmFaturamento, Data.DB;

type
  TfrmPrincipal = class(TForm)
  //definição dos botões, listBox entre outros
    ActionList1: TActionList;
    Action1: TAction;
    MultiView1: TMultiView;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    layoutPrincipal: TLayout;
    StyleBook1: TStyleBook;
    Layout2: TLayout;
    Image1: TImage;
    ListBoxItem4: TListBoxItem;
    layoutMensagem: TLayout;
    Timer1: TTimer;
    ListBoxItem5: TListBoxItem;
    Label1: TLabel;
    //funções para ações nos listbox entre outros
    procedure Action1Execute(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure ListBoxItem5Click(Sender: TObject);
   // procedure ListBoxItem6Click(Sender: TObject);
   // procedure layoutPrincipalClick(Sender: TObject);
  private
   { Private declarations }
      FFormAtual: TCommonCustomForm;//classe base da qual pode obter outros forms e janela
  public
    { Public declarations }
    procedure exibirMensagem(Layout : TLayout); //exibe mensagem de acordo com a ação
  published
   { published declarations }//pode fornecer informções em runtime
     //para excluir da memoria, quando o objeto nao e mais usado(para nao encher a memoria)
    //property ela vai recebe o form que esta estanciado no momento
    property FormAtual : TCommonCustomForm read FFormAtual write FFormAtual; //TCustomForm representa a classe base a partir da qual você obtém outras janelas, como caixas de diálogo e formulários
end;


var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}
//formularios que vao usar
uses uFrmCadastroServicos, uFrmCadastroClientes, uFrmCadastroProfissionais,uFrmCadastroPagamento;

//para Controle de ´Usuários, Menus, Perfil´.
procedure TfrmPrincipal.Action1Execute(Sender: TObject);
var
  Form : TfrmCadastroServico;
begin
  Form := TfrmCadastroServico.Create(Self);
  try
    Form.ShowModal; //chama o form(frmCadastroServico)
  finally
    Form.Free;
  end;
end;

//exibi as mensagem de erro, salvou! ... parametro, recebe laytout que vem do cadastro padrao
procedure TfrmPrincipal.exibirMensagem(Layout: TLayout);
begin
  Timer1.Enabled := true;//ativa o tempo
  frmPrincipal.layoutMensagem.Visible := true;//ativa o form mensagem
  frmPrincipal.layoutMensagem.RemoveObject(0); //remove do layout msg se tiver algum objt la
  frmPrincipal.layoutMensagem.AddObject(Layout); //e instancia o Tlayout q e passo como parametro
end;

//acoes para quando criar o form
procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  //coloca o layout como invisivel
  layoutMensagem.Visible := false;
end;

//para trocar de layout do form principal pelo form cliente
procedure TfrmPrincipal.ListBoxItem1Click(Sender: TObject);
var
  //estanciando o forme cadastro cliente
  FormCliente : TfrmClientes;
begin
   // para verificar se o ponteiro para o form cliente existe //verifica se o objeto nao existe, se nao existe cria ele
  if not Assigned(FormCliente) then
    FormCliente := TfrmClientes.Create(Self);
   //para limpar o obj do layout para caso ja estiver um la
    Self.layoutPrincipal.RemoveObject(0);
   // add esse layout passado pelo parametro a esse desse pag,,logo o layout princial, e inserido no layout1,(copia)
    //para com o clic, seja inserido o, layout da outra pag  nesta principal
  Self.layoutPrincipal.AddObject(FormCliente.Layout1);
end;

//para trocar de layout do form principal pelo form servico
procedure TfrmPrincipal.ListBoxItem2Click(Sender: TObject);
var
  //estanciando o forme cadastro produto
  FormServico : TfrmCadastroServico;
begin
  //verifica se o objeto nao existe, se nao existe cria ele
  if not Assigned(FormServico) then
    FormServico := TfrmCadastroServico.Create(Self);
    //remove oq esta lá,para limpar o obj do layout para caso ja estiver um la
   Self.layoutPrincipal.RemoveObject(0);
   //logo o layout princial, e inserido no layout1,(copia)
  //para com o clic, seja inserido o, layout da outra pag  nesta principal e adiona formServiço
  Self.layoutPrincipal.AddObject(FormServico.Layout1);
end;

//para trocar de layout do form principal pelo form faturamento
procedure TfrmPrincipal.ListBoxItem3Click(Sender: TObject);
var
  FormFaturamento : TfrmFaturamento;
begin
  if not Assigned(FormFaturamento) then
    FormFaturamento := TfrmFaturamento.Create(Self);

  Self.layoutPrincipal.RemoveObject(0);
  Self.layoutPrincipal.AddObject(FormFaturamento.Layout1);
end;

//para trocar de layout do form principal pelo form profissionais
procedure TfrmPrincipal.ListBoxItem5Click(Sender: TObject);
var
  formProfissionais : TfrmCadastroProfissionais;
begin

  if not Assigned(FormProfissionais) then
    FormProfissionais := TfrmCadastroProfissionais.Create(Self);

  Self.layoutPrincipal.RemoveObject(0);
  Self.layoutPrincipal.AddObject(FormProfissionais.Layout1);

end;

{ para trocar de layout do form principal pelo form pagamento
procedure TfrmPrincipal.ListBoxItem6Click(Sender: TObject);
var
  frmCadastroPagamento: TfrmCadastroPagamento;
begin

  if not Assigned(frmCadastroPagamento) then
    frmCadastroPagamento := TfrmCadastroPagamento.Create(Self);

  Self.layoutPrincipal.RemoveObject(0);
  Self.layoutPrincipal.AddObject(frmCadastroPagamento.Layout1);
end;
}
//para fechar o programa
procedure TfrmPrincipal.ListBoxItem4Click(Sender: TObject);
begin
  Close;
end;

//para que o timer da mensagem desative a exibição da mensagem
procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
  begin
  //if o o layout da mensagem por visivel ele vai desativa e vai trocar para falso
    if layoutMensagem.Visible then
      layoutMensagem.Visible := false;

    Timer1.Enabled := false;
  end;
end.
