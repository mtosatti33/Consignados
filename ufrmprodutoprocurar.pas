unit uFrmProdutoProcurar;
//TODO: aprimorar a pesquisa usando quando o grid é focado e o usuário digita os caracteres

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  DBGrids, ActnList, udm, DB, UConstantes, UFrmStringInput, UFrmIntegerInput;

type

  { TfrmProdutoProcurar }

  TfrmProdutoProcurar = class(TForm)
    Action1: TAction;
    actions: TActionList;
    btnFechar: TButton;
    dsDados: TDataSource;
    grid: TDBGrid;
    procedure Action1Execute(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
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
  frmProdutoProcurar: TfrmProdutoProcurar;

implementation

{$R *.lfm}

{ TfrmProdutoProcurar }

procedure TfrmProdutoProcurar.gridDblClick(Sender: TObject);
begin
  try
    CodigoRetorno := dsDados.DataSet['CODIGO'];
    Close;
  except
    ShowMessage('Selecione uma linha na tabela');
  end;
end;

procedure TfrmProdutoProcurar.gridKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = 13 then
    gridDblClick(nil);
end;

procedure TfrmProdutoProcurar.gridKeyPress(Sender: TObject; var Key: char);
begin
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

procedure TfrmProdutoProcurar.ProcurarPorNome;
begin
  with dm do
  begin
    dsDados.DataSet := qryProdutos;

    qryProdutos.Close;
    qryProdutos.ParamByName('produto').AsString := '%' + Nome + '%';
    qryProdutos.Open;

    if qryProdutos.RecordCount = 0 then
      ShowMessage(ERRO_NAO_DADOS);
  end;
end;

procedure TfrmProdutoProcurar.ProcurarPorCodigo;
begin
  with dm do
  begin
    dsDados.DataSet := qryProduto;

    qryProduto.Close;
    qryProduto.ParamByName('codigo').AsString := Codigo;
    qryProduto.Open;

    if qryProduto.RecordCount = 0 then
      ShowMessage(ERRO_NAO_DADOS);
  end;
end;

procedure TfrmProdutoProcurar.Action1Execute(Sender: TObject);
begin
  gridDblClick(nil);
end;

procedure TfrmProdutoProcurar.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.
