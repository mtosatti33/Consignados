unit ufaturaitens;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Dialogs, DB, ZDataset;

type

  { TFaturaItem }

  TFaturaItem = class
  private
    FFatura: integer;
    FPercentual: double;
    FProduto: integer;
    FProdutoNome: string;
    FQtdeEnviada: double;
    FQtdeRetornada: double;
    FQtdeCobrada: double;
    FVlrCobrado: double;
    FVlrUnit: double;
    FVlrEnviado: double;
    FVlrRetornado: double;
  public
    function Inserir: boolean;
    function Alterar(id, produto: integer): boolean;
    function Selecionar(id, produto: integer): boolean;
    function Excluir(id, produto: integer): boolean;
  published
    property Fatura: integer read FFatura write FFatura;
    property Produto: integer read FProduto write FProduto;
    property ProdutoNome: string read FProdutoNome write FProdutoNome;
    property QtdeEnviada: double read FQtdeEnviada write FQtdeEnviada;
    property QtdeRetornada: double read FQtdeRetornada write FQtdeRetornada;  
    property QtdeCobrada: double read FQtdeCobrada write FQtdeCobrada;
    property VlrUnit: double read FVlrUnit write FVlrUnit;
    property VlrEnviado: double read FVlrEnviado write FVlrEnviado;
    property VlrRetornado: double read FVlrRetornado write FVlrRetornado;  
    property VlrCobrado: double read FVlrCobrado write FVlrCobrado;
    property Percentual: double read FPercentual write FPercentual;
  end;

implementation

uses
  udm;
{ TFaturaItem }

function TFaturaItem.Inserir: boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'insert or replace into FATURA_ITENS('+
                  '  fatura, '+
                  '  produto, '+
                  '  qtde_enviada, '+
                  '  qtde_retornada,'+
                  '  valor_unit)'+
                  '  values('+
                  '  :fatura, '+
                  '  :produto, '+
                  '  :qtde_enviada, '+
                  '  :qtde_retornada,'+
                  '  :valor_unit)';

  qry.ParamByName('fatura').AsInteger := FFatura;
  qry.ParamByName('produto').AsInteger := FProduto;
  qry.ParamByName('qtde_enviada').AsFloat := FQtdeEnviada;
  qry.ParamByName('qtde_retornada').AsFloat := FQtdeRetornada;
  qry.ParamByName('valor_unit').AsFloat := VlrUnit;

  try
    qry.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ShowMessage('Houve um erro ao inserir: ' + E.ClassName + sLineBreak + E.Message);
      Result := False;
    end;
  end;

  if Assigned(qry) then FreeAndNil(qry);
end;

function TFaturaItem.Alterar(id, produto: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'UPDATE FATURA_ITENS'+
                  ' set  qtde_enviada=:qtde_enviada, '+
                  '  qtde_retornada=:qtde_retornada,'+
                  '  valor_unit=:valor_unit'+
                  '  where fatura=:fatura '+
                  ' and produto=:produto ';


  qry.ParamByName('fatura').AsInteger := id;
  qry.ParamByName('produto').AsInteger := produto;
  qry.ParamByName('qtde_enviada').AsFloat := FQtdeEnviada;
  qry.ParamByName('qtde_retornada').AsFloat := FQtdeRetornada;
  qry.ParamByName('valor_unit').AsFloat := VlrUnit;

  try
    qry.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ShowMessage('Houve um erro ao inserir: ' + E.ClassName + sLineBreak + E.Message);
      Result := False;
    end;
  end;

  if Assigned(qry) then FreeAndNil(qry);
end;

function TFaturaItem.Selecionar(id, produto: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'SELECT * FROM VW_FATURA a ' +
                  'where a.FATURA=:FATURA '+
                  'and a.PRODUTO=:PRODUTO';

  qry.ParamByName('fatura').AsInteger := id;  
  qry.ParamByName('produto').AsInteger := produto;
  qry.Open;

  if qry.RecordCount <> 0 then
  begin
    FFatura := qry.FieldByName('fatura').AsInteger;
    FProduto := qry.FieldByName('produto').AsInteger;
    FProdutoNome := qry.FieldByName('produto_nome').AsString;
    FQtdeRetornada := qry.FieldByName('qtde_retornada').AsFloat;
    FQtdeEnviada := qry.FieldByName('qtde_enviada').AsFloat;
    FVlrUnit := qry.FieldByName('valor_unit').AsFloat;
    FVlrEnviado := qry.FieldByName('valor_produto').AsFloat;
    FVlrRetornado := qry.FieldByName('valor_retornado').AsFloat;
    FQtdeCobrada := qry.FieldByName('qtde_cobrada').AsFloat;      
    FVlrCobrado := qry.FieldByName('valor_cobrado').AsFloat;
    FPercentual := qry.FieldByName('pct').AsFloat;
    Result := True;
  end
  else
    Result := False;


  if Assigned(qry) then FreeAndNil(qry);
end;

function TFaturaItem.Excluir(id, produto: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'delete from fatura_itens '+
                  'where fatura=:fatura '+
                  'and produto=:produto';

  qry.ParamByName('fatura').AsInteger := id;   
  qry.ParamByName('produto').AsInteger := produto;

  try
    qry.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ShowMessage('Houve um erro ao excluir: ' + E.ClassName + sLineBreak + E.Message);
      Result := False;
    end;
  end;

  if Assigned(qry) then FreeAndNil(qry);
end;

end.
