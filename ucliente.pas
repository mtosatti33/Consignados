unit ucliente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Dialogs, DB, ZDataset;

type

  { TCliente }

  TCliente = class
  private
    FID: integer;
    FNome: string;
  public
    function Inserir: boolean;
    function Alterar(id: integer): boolean;
    function Selecionar(id: integer): boolean;
    function Excluir(id: integer): boolean;
  published
    property ID: integer read FID write FID;
    property Nome: string read FNome write FNome;
  end;

implementation
uses
  udm;
{ TCliente }

function TCliente.Inserir: boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'insert into CLIENTES(codigo,cliente) values(:codigo,:cliente)';

  qry.ParamByName('codigo').AsInteger := FID;
  qry.ParamByName('cliente').AsString := FNome;


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

function TCliente.Alterar(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'update CLIENTES set cliente=:cliente where codigo=:codigo';

  qry.ParamByName('codigo').AsInteger := id;
  qry.ParamByName('cliente').AsString := FNome;


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

function TCliente.Selecionar(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'SELECT * FROM clientes ' +
    'where codigo=:codigo';

  qry.ParamByName('codigo').AsInteger := id;
  qry.Open;

  if qry.RecordCount <> 0 then
  begin
    FID := qry.FieldByName('codigo').AsInteger;
    FNome := qry.FieldByName('cliente').AsString;
    Result := True;
  end
  else
    Result := False;

  if Assigned(qry) then FreeAndNil(qry);
end;

function TCliente.Excluir(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'delete from clientes where codigo=:codigo';

  qry.ParamByName('codigo').AsInteger := id;

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

