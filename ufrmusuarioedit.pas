unit ufrmusuarioEdit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList,
  udm;

type

  { TfrmUsuarioEditar }

  TfrmUsuarioEditar = class(TForm)
    actFechar: TAction;
    actLimpar: TAction;
    actions: TActionList;
    btnSalvar: TButton;
    btnFechar: TButton;
    cmbCargo: TComboBox;
    cmbSituacao: TComboBox;
    edtSenha: TEdit;
    edtNome: TEdit;
    edtCod: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure actFecharExecute(Sender: TObject);
    procedure actLimparExecute(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtCodExit(Sender: TObject);
    procedure edtCodKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmUsuarioEditar: TfrmUsuarioEditar;

implementation

{$R *.lfm}

{ TfrmUsuarioEditar }

procedure TfrmUsuarioEditar.FormShow(Sender: TObject);
begin
  if edtcod.Text = '0' then
    edtSenha.Text := '123456';

  if edtCod.Text <> '0' then
  begin
    with dm.qryUsuario do
    begin
      Close;
      ParamByName('codigo').AsString := edtCod.Text;
      Open;

      edtNome.Text := FieldByName('usuario').AsString;
      cmbCargo.Text := FieldByName('cargo').AsString;
      edtSenha.Text := FieldByName('senha').AsString;
      cmbSituacao.Text := FieldByName('situacao').AsString;
    end;
  end;
end;

procedure TfrmUsuarioEditar.edtCodKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

procedure TfrmUsuarioEditar.btnSalvarClick(Sender: TObject);
begin
  if edtCod.Text = '0' then
  begin
    ShowMessage('Adicionando usuário');
    with dm.qryUsuarioAdd do
    begin
      ParamByName('usuario').AsString := edtNome.Text;
      ParamByName('cargo').AsString := cmbCargo.Text;
      ParamByName('senha').AsString := edtSenha.Text;
      ParamByName('situacao').AsString := cmbSituacao.Text;
      ExecSQL;
    end;
  end
  else
  begin
    with dm.qryUsuarioUpdate do
    begin
      //ParamByName('usuario').AsString := edtNome.Text;
      ParamByName('cargo').AsString := cmbCargo.Text;
      ParamByName('senha').AsString := edtSenha.Text;
      ParamByName('situacao').AsString := cmbSituacao.Text;
      ParamByName('codigo').AsString := edtCod.Text;
      ExecSQL;
    end;
  end;
  actLimpar.Execute;
end;

procedure TfrmUsuarioEditar.edtCodExit(Sender: TObject);
begin
  if edtcod.Text = '' then
  begin
    ShowMessage('Registro Novo');
    edtcod.Text := '0';
  end;
end;

procedure TfrmUsuarioEditar.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmUsuarioEditar.actLimparExecute(Sender: TObject);
var
  i: byte;
begin
  for i := 0 to self.ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
      TEdit(Components[i]).Clear;
    if Components[i] is TComboBox then
      TComboBox(Components[i]).ItemIndex := -1;
  end;
end;

end.
