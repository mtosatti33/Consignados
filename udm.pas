unit udm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, SQLite3Conn, ZConnection,
  ZDataset, ZSqlUpdate, Dialogs;

type

  { Tdm }

  Tdm = class(TDataModule)
    conn: TZConnection;
    qryClienteAdd: TZQuery;
    qryClientes: TZQuery;
    qryFaturaAdd: TZQuery;
    qryFaturaUpdate: TZQuery;
    qryFaturaItem: TZQuery;
    qryFaturaItens: TZQuery;
    qryFaturaItensAdd: TZQuery;
    qryFaturaItensUpdate: TZQuery;
    qryFaturas: TZQuery;
    qryFatura: TZQuery;
    qryFaturasTodas: TZQuery;
    qryFaturasPendentes: TZQuery;
    qryFaturasSemEstorno: TZQuery;
    qryProduto: TZQuery;
    qryCliente: TZQuery;
    qryProdutoAdd: TZQuery;
    qryFaturasLogUpdate: TZQuery;
    qryProdutos: TZQuery;
    qryUsuarioAdd: TZQuery;
    qryUsuario: TZQuery;
    qryUsuariosLogin: TZQuery;
    qryUsuarioUpdate: TZQuery;
    qryUsuarios: TZQuery;
    qryUsuarioLogin: TZQuery;
  private

  public

  end;

var
  dm: Tdm;

implementation

{$R *.lfm}

end.

