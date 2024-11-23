unit ufaturas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Dialogs, DB, ZDataset;

type

  { TFatura }

  TFatura = class
  private
    FCliente: integer;
    FClienteNome: string;
    FDtEmissao: TDate;
    FDtEstorno: TDate;
    FEstorno: integer;
    FFatura: integer;
    FNotaVenda: integer;
    FPercentual: double;
    FSituacao: string;
    FVlrCobrado: double;
    FVlrFatura: double;
    FVlrRetornado: double;
  public
    function Inserir: boolean;
    function Alterar(id: integer): boolean;
    function Selecionar(id: integer): boolean;
    function Excluir(id: integer): boolean;
  published
    property Fatura: integer read FFatura write FFatura;
    property Estorno: integer read FEstorno write FEstorno;
    property DtEmissao: TDate read FDtEmissao write FDtEmissao;
    property Cliente: integer read FCliente write FCliente;   
    property ClienteNome: string read FClienteNome write FClienteNome;
    property VlrFatura: double read FVlrFatura write FVlrFatura;
    property VlrRetornado: double read FVlrRetornado write FVlrRetornado;
    property VlrCobrado: double read FVlrCobrado write FVlrCobrado;
    property Situacao: string read FSituacao write FSituacao;
    property DtEstorno: TDate read FDtEstorno write FDtEstorno;
    property NotaVenda: integer read FNotaVenda write FNotaVenda;
    property Percentual: double read FPercentual write FPercentual;
  end;

implementation

uses
  udm;

{ TFatura }

function TFatura.Inserir: boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'insert into faturas(' + '  fatura,' +
    '  nota_venda,' + '  estorno,' +
    '  dt_emissao,' + '  dt_estorno,' +
    '  cliente,' + '  valor_fatura,' +
    '  valor_retornado,' + '  situacao)' +
    ' values(' + '  :fatura,' +
    '  :nota_venda,' + '  :estorno,' +
    '  :dt_emissao,' + '  :dt_estorno,' +
    '  :cliente,' + '  :valor_fatura,' +
    '  :valor_retornado,' + '  :situacao)';

  qry.ParamByName('fatura').AsInteger := FFatura;
  qry.ParamByName('nota_venda').AsInteger := FNotaVenda;
  qry.ParamByName('estorno').AsInteger := FEstorno;
  qry.ParamByName('dt_emissao').AsDate := FDtEmissao;
  qry.ParamByName('dt_estorno').AsDate := FDtEstorno;
  qry.ParamByName('cliente').AsInteger := FCliente;
  qry.ParamByName('valor_fatura').AsFloat := FVlrFatura;
  qry.ParamByName('valor_retornado').AsFloat := FVlrRetornado;
  qry.ParamByName('situacao').AsString := FSituacao;

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

function TFatura.Alterar(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'update faturas set' + '  nota_venda=:nota_venda,' +
    '  estorno=:estorno,' + '  dt_emissao=:dt_emissao,' +
    '  dt_estorno=:dt_estorno,' + '  cliente=:cliente,' +
    '  valor_fatura=:valor_fatura,' +
    '  valor_retornado=:valor_retornado,' +
    '  situacao=:situacao' + '  where fatura=:fatura';

  qry.ParamByName('fatura').AsInteger := id;
  qry.ParamByName('nota_venda').AsInteger := FNotaVenda;
  qry.ParamByName('estorno').AsInteger := FEstorno;
  qry.ParamByName('dt_emissao').AsDate := FDtEmissao;
  qry.ParamByName('dt_estorno').AsDate := FDtEstorno;
  qry.ParamByName('cliente').AsInteger := FCliente;
  qry.ParamByName('valor_fatura').AsFloat := FVlrFatura;
  qry.ParamByName('valor_retornado').AsFloat := FVlrRetornado;
  qry.ParamByName('situacao').AsString := FSituacao;

  try
    qry.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ShowMessage('Houve um erro ao alterar: ' + E.ClassName + sLineBreak + E.Message);
      Result := False;
    end;
  end;

  if Assigned(qry) then FreeAndNil(qry);
end;

function TFatura.Selecionar(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'SELECT * FROM VW_FATURAS a ' +
    'where a.FATURA=:FATURA';

  qry.ParamByName('fatura').AsInteger := id;
  qry.Open;

  if qry.RecordCount <> 0 then
  begin
    FEstorno := qry.FieldByName('estorno').AsInteger;
    FDtEmissao := qry.FieldByName('dt_emissao').AsDateTime;
    FDtEstorno := qry.FieldByName('dt_estorno').AsDateTime;
    FNotaVenda := qry.FieldByName('nota_venda').AsInteger;
    FCliente := qry.FieldByName('cliente').AsInteger;     
    FClienteNome := qry.FieldByName('cliente_nome').AsString;
    FVlrFatura := qry.FieldByName('valor_fatura').AsFloat;
    FVlrRetornado := qry.FieldByName('valor_retornado').AsFloat;
    FVlrCobrado := qry.FieldByName('valor_cobrado').AsFloat;
    FPercentual := qry.FieldByName('pct').AsFloat;
    Result := True;
  end
  else    
    Result := False;

  if Assigned(qry) then FreeAndNil(qry);
end;

function TFatura.Excluir(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'delete from faturas where fatura=:fatura';

  qry.ParamByName('fatura').AsInteger := id;

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
