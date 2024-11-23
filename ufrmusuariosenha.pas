unit UfrmUsuarioSenha;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList;

type

  { TfrmUsuarioSenha }

  TfrmUsuarioSenha = class(TForm)
    actFechar: TAction;
    actions: TActionList;
    btnAtualizar: TButton;
    btnFechar: TButton;
    edtSenhaAtual: TEdit;
    edtNovaSenha: TEdit;
    edtConfirmacao: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure actFecharExecute(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure edtSenhaAtualKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frmUsuarioSenha: TfrmUsuarioSenha;

implementation

{$R *.lfm}

{ TfrmUsuarioSenha }

procedure TfrmUsuarioSenha.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmUsuarioSenha.btnAtualizarClick(Sender: TObject);
begin
  if edtNovaSenha.Text <> edtConfirmacao.Text then
  begin
    ShowMessage('Senha não confere');
    Exit;
  end;

end;

procedure TfrmUsuarioSenha.edtSenhaAtualKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

end.

