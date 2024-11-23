unit UFrmIntegerInput;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmIntegerInput }

  TfrmIntegerInput = class(TForm)
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
  frmIntegerInput: TfrmIntegerInput;

implementation

{$R *.lfm}

{ TfrmIntegerInput }

procedure TfrmIntegerInput.edtCampoKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

procedure TfrmIntegerInput.FormShow(Sender: TObject);
begin
  edtCampo.SelStart:= Length(edtCampo.Text);
end;

procedure TfrmIntegerInput.btnOKClick(Sender: TObject);
begin
  FCampo:= edtCampo.Text;
  close;
end;

end.
