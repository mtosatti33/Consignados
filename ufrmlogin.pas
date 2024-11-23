unit uFrmLogin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MaskEdit,
  ExtCtrls, UMain, udm, UConfiguration, UConstantes;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    btnEntrar: TButton;
    cmbUsuarioLista: TComboBox;
    edtSenha: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnEntrarClick(Sender: TObject);
    procedure cmbUsuarioListaKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    UserName: string;
  public
    class function Execute: string;

  end;

var
  frmLogin: TfrmLogin; 
  iniStrings: TIniStrings;

implementation

{$R *.lfm}

{ TfrmLogin }

procedure TfrmLogin.FormShow(Sender: TObject);
var
  filePath: string;
begin
  filePath := ExtractFilePath(ParamStr(0));

  iniStrings := ReadIniFile;
  dm.conn.Connected := False;

  if iniStrings.habilitado then                    //caso o campo habilitado seja verdadeiro
  begin
    dm.conn.Database := iniStrings.database;
  end
  else                                             //caso contrário
  begin
    dm.conn.Database := filePath + BANCO;
  end;

  dm.conn.LibraryLocation := filePath + LIB;

  try
    dm.conn.Connected := True;
  except
    ShowMessage(ERRO_CONEXAO_BANCO);
    Application.Terminate;
  end;

  if cmbUsuarioLista.Items.Count <> 0 then cmbUsuarioLista.items.Clear;

  with dm.qryUsuariosLogin do
  begin
    Open;

    First;
    while not EOF do
    begin
      cmbUsuarioLista.Items.Add(FieldByName('USUARIO').AsString);
      Next;
    end;
  end;

end;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
begin
  //if edtSenha.Text = '' then
  //begin
  //  ShowMessage('Informe uma senha');
  //  exit;
  //end;
  //

  if cmbUsuarioLista.Text = '' then
  begin
    ShowMessage('Informe um usuário');
    exit;
  end;

  with dm.qryUsuarioLogin do
  begin
    Close;
    ParamByName('USUARIO').AsString := cmbUsuarioLista.Text;
    Open;

    //if edtSenha.Text = FieldByName('SENHA').AsString then
    //begin
      ModalResult := mrOk;
      UserName := cmbUsuarioLista.Text;
    //end
    //else
    //  ModalResult := mrCancel;
  end;

  MessageDlg('A senha está desabilitada até ser implementada a segurança delas', mtInformation,[mbOK],1);
end;

procedure TfrmLogin.cmbUsuarioListaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

class function TfrmLogin.Execute: string;
begin
  with TfrmLogin.Create(nil) do
    try
      if ShowModal = mrOk then
        Result := cmbUsuarioLista.Text
      else
        Result := '';
    finally
      Free;
    end;
end;

end.
