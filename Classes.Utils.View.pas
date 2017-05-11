unit Classes.Utils.View;

interface
uses
  FireDAC.Phys.MongoDBWrapper, uDmDados, FireDAC.Phys.MongoDBDataSet,
  FMX.ListBox;


type
   TUtilsView = class
     public
        procedure fnc_carregarDataSet(Banco, Collection:string; var dsMongo: TFDMongoDataSet);
        procedure fnc_montarGrid(var lv: TListBox; dsMongo: TFDMongoDataSet; key, Value:String);overload;
        //metodo de montar grid sobrecarregado(sbrecarga de metodos)(overruide
        //pode sobrecarrega ele passando parametros diferentes
        procedure fnc_montarGrid(var lv: TListBox; dsMongo: TFDMongoDataSet;Descricao, Value, key:String);overload;
         // pega o valor na lista e transforma ele para current(REAL)
         function ListToCurr(Value: string): Currency;

   end;

implementation

uses
  System.SysUtils;

// classe generica que vai funcionar para tds os forms para preencher um data set, preenchendo os paremetros em qualquer liugar
procedure TUtilsView.fnc_carregarDataSet(Banco, Collection:string; var dsMongo: TFDMongoDataSet);
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

//preencher o grid,preencher os listBox de forma generica
//dataSet(e o dsmongo->dataSet com os dados), listBox(oq vai ser preenchido), chave(value->vai ser salvo nele como obj pra poder recuperar isso para poder usar em outro lugar como uma chave primaria)  e o value(e oq vai ser exibido no grid)
procedure TUtilsView.fnc_montarGrid(var lv: TListBox; dsMongo: TFDMongoDataSet; key, value :String);
begin
  inherited;
  with dsMongo do
  begin
    First;
    lv.Items.Clear;
    while not Eof do
    begin
      lv.Items.AddObject(FieldByName(value).AsString, TObject(FieldByName(key).AsInteger));
      Next;
    end;
  end;
  inherited;
end;




//metodo sobrecarregado
//possui o msm nome mais parametros diferentes por isso e possivel sobrecarrefa esse metodo
procedure TUtilsView.fnc_montarGrid(var lv: TListBox; dsMongo: TFDMongoDataSet;
  Descricao, Value, key: String);
var lbIntem: TListBoxItem;
  begin
  //percorrer o client data set
  dsMongo.First; //posiciona na primeira posicao
  lv.Items.Clear; // limpa o list box
  while not dsMongo.Eof do //percorre
  begin

    //escreve no list box, de acordo com a personalizacao criada nele(aula 28;;11:24
    //criando um novo list box item, ele vai ser...
    lbIntem := TListBoxItem.Create(nil);
    //...
    //list  box criado com o tipo definido e os valores criados nele
    lbIntem.StyleLookup:= 'ListBoxItemServico';
    //da acesso a descricao valor, e chave...  := pega a descricao ...
    lbIntem.StylesData['descricao'] := dsMongo.FieldByName(Descricao).AsString;
    lbIntem.StylesData['valor'] := FormatCurr('R$ #,##0.00', dsMongo.FieldByName(value).AsCurrency);
    lbIntem.StylesData['chave'] := dsMongo.FieldByName(Key).AsString;
    lv.AddObject(lbIntem);
      dsMongo.Next; //avanca o pont do cursor
  end;
  end;










//tranforma o numero para real
function TUtilsView.ListToCurr(Value: string): Currency;
  var
    I: Byte;
    Aux: String;
    begin
      Aux := '';
      //pega apenas um posicao da string, verifca se a posicao 1 da string esta entre 0 e 9,(logo se for numero)
      for I := 1 to Length(Value) do
        if (value[I] in ['0'..'9']) then
          Aux := Aux+ Value[I];

      Result := strToCurr(Aux)/100;
    end;

end.
