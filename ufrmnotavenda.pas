unit UFrmNotaVenda;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList,
  ZDataset;

type

  { TfrmNotaVenda }

  TfrmNotaVenda = class(TForm)
    Action1: TAction;
    actions: TActionList;
    btnFechar: TButton;
    edtClienteNome: TEdit;
    edtNotaVenda: TEdit;
    edtFatura: TEdit;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    qryNotaVenda: TZQuery;
    procedure Action1Execute(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure edtNotaVendaKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frmNotaVenda: TfrmNotaVenda;

implementation

{$R *.lfm}

{ TfrmNotaVenda }

procedure TfrmNotaVenda.btnFecharClick(Sender: TObject);
begin
  qryNotaVenda.ParamByName('NOTA_VENDA').AsString:=edtNotaVenda.Text;
  qryNotaVenda.ParamByName('fatura').AsString:=edtFatura.Text;
  qryNotaVenda.ExecSQL;
  ShowMessage('Salvo');
  Close;
end;

procedure TfrmNotaVenda.Action1Execute(Sender: TObject);
begin
  close;
end;

procedure TfrmNotaVenda.edtNotaVendaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
     SelectNext(sender as TWinControl,true,true);
end;

end.

