unit uFrmCadastroProfissionais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmCadastroPadrao, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MongoDBDataSet, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.Edit, FMX.SearchBox, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation,
  mongo.FMX.Edit, Classes.Utils.View;

type
  TfrmCadastroProfissionais = class(TfrmCadastroPadrao)
    ListBoxItem2: TListBoxItem;
    Label3: TLabel;
    EditMongo1: TMongoEdit;
    ListBoxItem3: TListBoxItem;
    Label2: TLabel;
    EditMongo2: TMongoEdit;
    ListBoxItem4: TListBoxItem;
    Label4: TLabel;
    EditMongo3: TMongoEdit;
    ListBoxItem5: TListBoxItem;
    Label5: TLabel;
    EditMongo4: TMongoEdit;
    ListBoxItem6: TListBoxItem;
    Label6: TLabel;
    MongoEdit1: TMongoEdit;
    ListBoxItem7: TListBoxItem;
    Label7: TLabel;
    MongoEdit2: TMongoEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure fnc_montarGrid; override;
  end;

var
  frmCadastroProfissionais: TfrmCadastroProfissionais;

implementation

{$R *.fmx}


//monta o conteudo nos listBox
procedure TfrmCadastroProfissionais.fnc_montarGrid;
begin
   FUtils.fnc_montarGrid(ListBox1,dsMongo,'CODIGO','NOME');
   inherited; //para caso tiver algo em herança elevai poder executar
end;

//informa o BD e a TAB
procedure TfrmCadastroProfissionais.FormCreate(Sender: TObject);
begin
  Self.Banco := 'SALAO';
  Self.Collection := 'PROFISSIONAIS';
  inherited;
end;

end.
