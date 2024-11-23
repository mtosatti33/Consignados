unit ufrmclienteprocurar;
//TODO: aprimorar a pesquisa usando quando o grid é focado e o usuário digita os caracteres

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ActnList, udm, DB, UConstantes, UFrmIntegerInput, UFrmStringInput;

type

  { TFrmClienteProcurar }

  TFrmClienteProcurar = class(TForm)
    Action1: TAction;
    actions: TActionList;
    btnFechar: TButton;
    dsDados: TDataSource;
    grid: TDBGrid;
    procedure Action1Execute(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure gridKeyPress(Sender: TObject; var Key: char);
  private
    Nome: string;
    Codigo: string;
    procedure ProcurarPorNome;
    procedure ProcurarPorCodigo;

  public
    CodigoRetorno: string;
  end;

var
  FrmClienteProcurar: TFrmClienteProcurar;

implementation

{$R *.lfm}

{ TFrmClienteProcurar }

procedure TFrmClienteProcurar.Action1Execute(Sender: TObject);
begin
  gridDblClick(nil);
end;

procedure TFrmClienteProcurar.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmClienteProcurar.FormShow(Sender: TObject);
begin
  CodigoRetorno:= '';
  ProcurarPorNome;
end;

procedure TFrmClienteProcurar.gridDblClick(Sender: TObject);
begin
  try
    CodigoRetorno := dsDados.DataSet['CODIGO'];
    Close;

  except
    ShowMessage('Selecione uma linha na tabela');
  end;
end;

procedure TFrmClienteProcurar.gridKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = 13 then
    gridDblClick(nil);
end;

procedure TFrmClienteProcurar.gridKeyPress(Sender: TObject; var Key: char);
begin
  if key in ['a'..'z'] then                                  //Caracteres
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
    ProcurarPorNome;
  end;


  if key in ['0'..'9'] then                                  //Números
  begin
    if frmIntegerInput = nil then
      frmIntegerInput := TfrmIntegerInput.Create(Application);

    frmIntegerInput.edtCampo.Text := key;
    try
      frmIntegerInput.ShowModal;

    finally
      Codigo := frmIntegerInput.Campo;
      frmIntegerInput.Free;
      frmIntegerInput := nil;
    end;
    ProcurarPorCodigo;
  end;
end;

procedure TFrmClienteProcurar.ProcurarPorNome;
begin
  with dm do
  begin
    dsDados.DataSet := qryClientes;

    qryClientes.Close;
    qryClientes.ParamByName('cliente').AsString := '%' + Nome + '%';
    qryClientes.Open;

    if qryClientes.RecordCount = 0 then
      ShowMessage(ERRO_NAO_DADOS);
  end;
end;

procedure TFrmClienteProcurar.ProcurarPorCodigo;
begin
  with dm do
  begin
    dsDados.DataSet := qryCliente;

    qryCliente.Close;
    qryCliente.ParamByName('codigo').AsString := Codigo;
    qryCliente.Open;

    if qryCliente.RecordCount = 0 then
      ShowMessage(ERRO_NAO_DADOS);
  end;
end;

end.
