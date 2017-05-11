unit uFrmCadastroPagamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmCadastroPadrao, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MongoDBDataSet, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.Edit, FMX.SearchBox, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation,
  mongo.FMX.Edit;

type
  TfrmCadastroPagamento = class(TfrmCadastroPadrao)
    ListBoxItem2: TListBoxItem;
    Label3: TLabel;
    EditMongo1: TMongoEdit;
    ListBoxItem3: TListBoxItem;
    Label2: TLabel;
    MongoEdit1: TMongoEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure fnc_montarGrid; override;
  end;

var
  frmCadastroPagamento: TfrmCadastroPagamento;

implementation

{$R *.fmx}

//monta o conteudo no listBox
procedure TfrmCadastroPagamento.fnc_montarGrid;
begin
 FUtils.fnc_montarGrid(ListBox1,dsMongo,'CODIGO','Descricao');
  inherited;


end;

//informa o nome do banco e tabela
procedure TfrmCadastroPagamento.FormCreate(Sender: TObject);
begin
  Self.Banco := 'SALAO';
  Self.Collection:= 'PAGAMENTO';
  inherited;

end;

end.
