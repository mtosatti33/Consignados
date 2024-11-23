unit ufrmCadProdutos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList,
  udm;

type

  { TfrmCadProdutos }

  TfrmCadProdutos = class(TForm)
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
    procedure edtCodKeyPress(Sender: TObject; var Key: char);
    procedure edtNomeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private

  public

  end;

var
  frmCadProdutos: TfrmCadProdutos;

implementation

{$R *.lfm}

{ TfrmCadProdutos }

procedure TfrmCadProdutos.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadProdutos.actLimparExecute(Sender: TObject);
var
  i: byte;
begin
  for i := 0 to self.ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
      TEdit(Components[i]).Clear;
  end;
end;

procedure TfrmCadProdutos.btnAdicionarClick(Sender: TObject);
begin          
  if edtNome.Text = '' then
  begin
    ShowMessage('Informe um valor no campo');
    edtNome.SetFocus;
    Exit;
  end;

  with dm.qryProdutoAdd do
  begin
    ParamByName('codigo').AsString := edtCod.Text;
    ParamByName('produto').AsString := edtNome.Text;
    ExecSQL;
  end;

  ShowMessage('Salvo');
  actLimpar.Execute;
  edtCod.SetFocus;
end;

procedure TfrmCadProdutos.edtCodKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

procedure TfrmCadProdutos.edtNomeKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = 13 then
  begin
      if edtNome.Text = '' then
      begin
          showmessage('Informe um valor no campo');
          edtNome.SetFocus;
          Exit;
      end;
  end;
end;

end.
