unit UFrmStringInput;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmStringInput }

  TfrmStringInput = class(TForm)
    btnOK: TButton;
    edtCampo: TEdit;
    Label1: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure edtCampoKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    FCampo: string;
  public
    property Campo: string read FCampo write FCampo;
  end;

var
  frmStringInput: TfrmStringInput;

implementation

{$R *.lfm}

{ TfrmStringInput }

procedure TfrmStringInput.FormShow(Sender: TObject);
begin
  edtCampo.SelStart := Length(edtCampo.Text);
end;

procedure TfrmStringInput.btnOKClick(Sender: TObject);
begin
  FCampo := edtCampo.Text;
  Close;
end;

procedure TfrmStringInput.edtCampoKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

end.
