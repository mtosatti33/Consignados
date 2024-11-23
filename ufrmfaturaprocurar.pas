unit ufrmFaturaProcurar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ActnList, udm, UConstantes, UFrmStringInput, UFrmIntegerInput;

type

  { TfrmFaturaProcurar }

  TfrmFaturaProcurar = class(TForm)
    Action1: TAction;
    actions: TActionList;
    btnFechar: TButton;
    btnMostrarTodos: TButton;
    dsDados: TDataSource;
    grid: TDBGrid;
    procedure Action1Execute(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnMostrarTodosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure gridKeyPress(Sender: TObject; var Key: char);
  private
    Nome: string;
    Codigo: string;
    procedure ProcurarPorNome;  
    procedure ProcurarPorNomeTodos;
  public
    CodigoRetorno: string;
  end;

var
  frmFaturaProcurar: TfrmFaturaProcurar;

implementation

{$R *.lfm}

{ TfrmFaturaProcurar }

procedure TfrmFaturaProcurar.FormShow(Sender: TObject);
begin
  CodigoRetorno:= '';
  ProcurarPorNome;
end;

procedure TfrmFaturaProcurar.Action1Execute(Sender: TObject);
begin
  Close;
end;

procedure TfrmFaturaProcurar.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFaturaProcurar.btnMostrarTodosClick(Sender: TObject);
begin
  Nome:='';
  ProcurarPorNomeTodos;
end;

procedure TfrmFaturaProcurar.gridDblClick(Sender: TObject);
begin
  try
    CodigoRetorno := dsDados.DataSet['fatura'];
    Close;
  except
    ShowMessage('Selecione uma linha na tabela');
  end;
end;

procedure TfrmFaturaProcurar.gridKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = 13 then
    gridDblClick(nil);
end;

procedure TfrmFaturaProcurar.gridKeyPress(Sender: TObject; var Key: char);
begin
  //showmessage(key);
  if key in ['a'..'z'] then                                  //Caracteres Alfanumericos
  begin
    if frmStringInput = nil then
      frmStringInput := TfrmStringInput.Create(Application);

    frmStringInput.edtCampo.Text := key;
    try
      frmStringInput.ShowModal;

    finally
      Nome := frmStringInput.Campo;
      frmStringInput.Free;
      frmStringInput := nil;
    end;

    if dsDados.DataSet = dm.qryFaturas then
       ProcurarPorNome;
    if dsDados.DataSet = dm.qryFaturasTodas then
       ProcurarPorNomeTodos;
  end;
end;

//-----------------------------------------------------------------------------
//MÉTODOS PRIVADOS
procedure TfrmFaturaProcurar.ProcurarPorNome;
begin
  with dm do
  begin
    dsDados.DataSet := qryFaturas;

    qryFaturas.Close;
    qryFaturas.ParamByName('cliente').AsString := '%' + Nome + '%';
    qryFaturas.Open;

    if qryFaturas.RecordCount = 0 then
       ShowMessage(ERRO_NAO_DADOS);
  end;
end;

procedure TfrmFaturaProcurar.ProcurarPorNomeTodos;
begin
  with dm do
  begin
    dsDados.DataSet := qryFaturasTodas;

    qryFaturasTodas.Close;
    qryFaturasTodas.ParamByName('cliente').AsString := '%' + Nome + '%';
    qryFaturasTodas.Open;

    if qryFaturasTodas.RecordCount = 0 then
       ShowMessage(ERRO_NAO_DADOS);
  end;
end;

end.
