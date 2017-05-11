{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit uFrmCadastroClientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmCadastroPadrao, System.Actions, FMX.ActnList, FMX.Controls.Presentation,
  FMX.Layouts, FMX.Edit, FMX.SearchBox, FMX.ListBox, FMX.TabControl,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MongoDBDataSet, mongo.FMX.Edit, Classes.Utils.View,
  uFrmCadastroProfissionais, uDmDados, FireDAC.Phys.MongoDBWrapper;

type
  TfrmClientes = class(TfrmCadastroPadrao)
    ListBoxItem2: TListBoxItem;
    Label3: TLabel;
    EditMongo1: TMongoEdit;
    ListBoxItem3: TListBoxItem;
    Label2: TLabel;
    EditMongo2: TMongoEdit;
    ListBoxItem4: TListBoxItem;
    Label4: TLabel;
    EditMongo3: TMongoEdit;
    ListBoxItem6: TListBoxItem;
    Label6: TLabel;
    MongoEdit1: TMongoEdit;
    ListBoxItem8: TListBoxItem;
    MongoEdit3: TMongoEdit;
    tabAddT: TTabItem;
    ListBox3: TListBox;
    ListBoxItem7: TListBoxItem;
    SearchBox2: TSearchBox;
    Button1: TButton;
    changeTabAddT: TChangeTabAction;
    dsAddT: TFDMongoDataSet;
    Button2: TButton;
    ListBoxItem5: TListBoxItem;
    MongoEdit2: TMongoEdit;
    tabTrat: TTabItem;
    ListBox4: TListBox;
    ListBoxItem9: TListBoxItem;
    changeTabTrat: TChangeTabAction;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure fnc_carregarDataSet(Banco, Collection:string; var dsMongo: TFDMongoDataSet);
    procedure fnc_montarGrid; override;
  end;

var
  frmClientes: TfrmClientes;

implementation

{$R *.fmx}


// classe generica que vai funcionar para tds os forms para preencher um data set, preenchendo os paremetros em qualquer liugar
procedure TfrmClientes.Button2Click(Sender: TObject);
begin
   fnc_carregarDataSet('SALAO','SERVICOS',dsAddT);
   FUtils.fnc_montarGrid(ListBox4, dsAddT, 'DESCRICAO','VALOR','CODIGO');
   changeTabTrat.ExecuteTarget(Self);
   //MongoEdit3. := frmCadastroProfissionais.ListBox1.ItemDown.StylesData['nome'];
end;

procedure TfrmClientes.EditButton1Click(Sender: TObject);
begin
   fnc_carregarDataSet('SALAO','PROFISSIONAIS',dsAddT);
   FUtils.fnc_montarGrid(ListBox3, dsAddT, 'Codigo', 'Nome');
   changeTabAddT.ExecuteTarget(Self);
   //MongoEdit3.StylesData['DESC'] := frmCadastroProfissionais.ListBox1.ItemDown.StylesData['nome'];

end;

procedure TfrmClientes.fnc_carregarDataSet(Banco, Collection:string; var dsMongo: TFDMongoDataSet);
var
  oCrs: IMongoCursor;
  begin
  //with e a msm coisa que fazer dm.oCrs...
   with dmDados do
  begin
  //na var oCrs(cursor) recebe todos os registros do BD na collection informada
    oCrs := FConMongo[Banco][Collection].Find();
    //fecha o data set, para que n aja nenhum erro
    dsMongo.Close;
     //atribui o cursor ao dataSet que pega os dados
    dsMongo.Cursor := oCrs;
    //abre o dataset novamente para uso, pois tds os dados que esta la no mongo agr esta no dataset
    dsMongo.Open;
  end;
end;

//--monta grid
//montou a procedure pois esta como meto abstrato na classe padrao e logo so chamar a utilsview e contsta ele implementado
procedure TfrmClientes.Button1Click(Sender: TObject);
begin
  fnc_carregarDataSet('SALAO','PROFISSIONAIS',dsAddT);
  FUtils.fnc_montarGrid(ListBox3, dsAddT, 'Codigo', 'Nome');
  changeTabAddT.ExecuteTarget(Self);
end;

procedure TfrmClientes.fnc_montarGrid;
begin
inherited;
  FUtils.fnc_montarGrid(ListBox1, dsMongo, 'Codigo', 'Nome');
end;

//informa o nome do banco e da tabela
procedure TfrmClientes.FormCreate(Sender: TObject);
begin
  Self.Banco := 'SALAO';
  Self.Collection := 'CLIENTES';
  inherited;
end;

end.
