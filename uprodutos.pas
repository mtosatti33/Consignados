unit uprodutos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Dialogs, DB, ZDataset;

type

  { TProduto }

  TProduto = class
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
{ TProduto }

function TProduto.Inserir: boolean;    
var
  qry: TZQuery;
begin   
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'insert into PRODUTOS(codigo,produto) values(:codigo,:produto)';

  qry.ParamByName('codigo').AsInteger := FID;
  qry.ParamByName('produto').AsString := FNome;


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

function TProduto.Alterar(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'update PRODUTOS set produto=:PRODUTO where codigo=:codigo';

  qry.ParamByName('codigo').AsInteger := id;
  qry.ParamByName('produto').AsString := FNome;


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

function TProduto.Selecionar(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'SELECT * FROM produtos ' +
    'where codigo=:codigo';

  qry.ParamByName('codigo').AsInteger := id;
  qry.Open;

  if qry.RecordCount <> 0 then
  begin
    FID := qry.FieldByName('codigo').AsInteger;
    FNome := qry.FieldByName('produto').AsString;
    Result := True;
  end
  else
    Result := False;

  if Assigned(qry) then FreeAndNil(qry);
end;

function TProduto.Excluir(id: integer): boolean;
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);

  qry.Connection := dm.conn;

  qry.sql.Text := 'delete from produtos where codigo=:codigo';

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

