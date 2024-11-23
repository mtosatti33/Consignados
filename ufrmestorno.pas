unit ufrmEstorno;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, StdCtrls,
  MaskEdit, DateTimePicker, ZDataset, UConstantes, udm;

type

  { TfrmEstorno }

  TfrmEstorno = class(TForm)
    Action1: TAction;
    actions: TActionList;
    btnFechar: TButton;
    dtpData: TDateTimePicker;
    edtClienteNome: TEdit;
    edtEstorno: TEdit;
    edtFatura: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    qryFaturaEstorno: TZQuery;
    procedure Action1Execute(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure edtEstornoKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmEstorno: TfrmEstorno;

implementation

{$R *.lfm}

{ TfrmEstorno }

procedure TfrmEstorno.Action1Execute(Sender: TObject);
begin
  Close;
end;

procedure TfrmEstorno.btnFecharClick(Sender: TObject);
begin
  qryFaturaEstorno.ParamByName('ESTORNO').AsString:=edtEstorno.Text;
  qryFaturaEstorno.ParamByName('DT_ESTORNO').AsDate:=dtpData.Date;
  qryFaturaEstorno.ParamByName('fatura').AsString:=edtFatura.Text;
  qryFaturaEstorno.ExecSQL;
  ShowMessage('Salvo');
  Close;
end;

procedure TfrmEstorno.edtEstornoKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
     SelectNext(sender as TWinControl,true,true);
end;

procedure TfrmEstorno.FormShow(Sender: TObject);
begin
  dtpData.Date:=now;
end;

end.

