unit UfrmUsuarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ActnList, udm, ufrmusuarioEdit;

type

  { TfrmUsuarios }

  TfrmUsuarios = class(TForm)
    actFechar: TAction;
    actions: TActionList;
    btnAdicionar: TButton;
    btnEditar: TButton;
    btnFechar: TButton;
    dsDados: TDataSource;
    DBGrid1: TDBGrid;
    procedure actFecharExecute(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure FormUsuarioEditar(id: string);
    procedure AtualizaDados;
  public

  end;

var
  frmUsuarios: TfrmUsuarios;

implementation

{$R *.lfm}

{ TfrmUsuarios }

procedure TfrmUsuarios.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmUsuarios.btnAdicionarClick(Sender: TObject);
begin

  FormUsuarioEditar('0');
end;

procedure TfrmUsuarios.btnEditarClick(Sender: TObject);
begin

  FormUsuarioEditar(dsDados.DataSet.FieldByName('CODIGO').AsString);
end;

procedure TfrmUsuarios.FormShow(Sender: TObject);
begin
  AtualizaDados;
end;

procedure TfrmUsuarios.FormUsuarioEditar(id: string);
begin
  if frmUsuarioEditar = nil then
    frmUsuarioEditar := TfrmUsuarioEditar.Create(Application);

  frmUsuarioEditar.edtCod.Text := id;
  try
    frmUsuarioEditar.ShowModal;
  finally
    FreeAndNil(frmUsuarioEditar);

    AtualizaDados;
  end;
end;

procedure TfrmUsuarios.AtualizaDados;
begin
  dsDados.DataSet.Close;
  dsDados.DataSet.Open;
end;

end.
