unit ufrmCadClientes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList,
  udm;

type

  { TfrmCadCli }

  TfrmCadCli = class(TForm)
    actFechar: TAction;
    actLimpar: TAction;
    actions: TActionList;
    btnAdicionar: TButton;
    btnFechar: TButton;
    edtCod: TEdit;
    edtNome: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure actFecharExecute(Sender: TObject);
    procedure actLimparExecute(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure edtNomeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtNomeKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frmCadCli: TfrmCadCli;

implementation

{$R *.lfm}

{ TfrmCadCli }

procedure TfrmCadCli.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadCli.actLimparExecute(Sender: TObject);
var
  i: byte;
begin
  for i := 0 to self.ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
      TEdit(Components[i]).Clear;
  end;
end;

procedure TfrmCadCli.btnAdicionarClick(Sender: TObject);
begin
  if edtNome.Text = '' then
  begin
    ShowMessage('Informe um valor no campo');
    edtNome.SetFocus;
    Exit;
  end;

  with dm.qryClienteAdd do
  begin
    ParamByName('codigo').AsString := edtCod.Text;
    ParamByName('cliente').AsString := edtNome.Text;
    ExecSQL;
  end;

  ShowMessage('Salvo');
  actLimpar.Execute;
  edtCod.SetFocus;
end;

procedure TfrmCadCli.edtNomeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = 13 then
  begin
    if edtNome.Text = '' then
    begin
      ShowMessage('Informe um valor no campo');
      edtNome.SetFocus;
      Exit;
    end;
  end;
end;

procedure TfrmCadCli.edtNomeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

end.
