unit UMain;
//TODO: permitir gerar inconsistência de digitação de valores
//TODO: tratar valores nulos
//TODO: incluir valor de venda na tabela Fatura e gerar inconsistencia se der diferente da informada na fatura
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, odbcconn, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, Buttons, ActnList, Menus, MaskEdit, ComCtrls, DateTimePicker,
  ufrmFaturaProcurar, ufrmclienteprocurar, ufrmprodutoadicionar, udm,
  ufrmEstorno, UConstantes, ureport, ureportFaturaPendentes,
  ureportFaturasNaoEstornadas, UFrmNotaVenda, UEstruturaDados, ufrmCadClientes,
  ufrmCadProdutos, UfrmUsuarios, UfrmUsuarioSenha;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actSair: TAction;
    actProcurar: TAction;
    actions: TActionList;
    BtnAdd: TBitBtn;
    btnModificar: TButton;
    btnRetornoTotal: TButton;
    BtnSair: TButton;
    BtnEfetivar: TButton;
    BtnImprimir: TButton;
    dtpEmissao: TDateTimePicker;
    edtObs: TEdit;
    edtEstorno: TEdit;
    edtNotaVenda: TEdit;
    edtVlrCobrado: TEdit;
    edtPct: TEdit;
    grid: TDBGrid;
    dsDados: TDataSource;
    dsDados2: TDataSource;
    edtClienteCod: TEdit;
    edtFatura: TEdit;
    edtClienteNome: TEdit;
    edtSit: TEdit;
    edtVlrTotal: TEdit;
    edtVlrRet: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btnFaturaProcurar: TSpeedButton;
    btnClienteProcurar: TSpeedButton;
    Label8: TLabel;
    Label9: TLabel;
    mainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    mnuItemRelFatData: TMenuItem;
    mnuItemNotaVenda: TMenuItem;
    mnuItemAlterarSenha: TMenuItem;
    Separator1: TMenuItem;
    mnuItemUsuarios: TMenuItem;
    mnuItemUsuariosManut: TMenuItem;
    mnuItemProcEsp: TMenuItem;
    MenuItem3: TMenuItem;
    mnuItemAtualizarBanco: TMenuItem;
    mnuItemCad: TMenuItem;
    mnuItemCadProdutos: TMenuItem;
    mnuItemCadClientes: TMenuItem;
    mnuItemRelFatNaoEstorn: TMenuItem;
    mnuItemSair: TMenuItem;
    mnuItemEstFat: TMenuItem;
    mnuItemRel: TMenuItem;
    mnuItemRelFatPend: TMenuItem;
    StatusBar1: TStatusBar;
    procedure actSairExecute(Sender: TObject);
    procedure actProcurarExecute(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEfetivarClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure btnRetornoTotalClick(Sender: TObject);
    procedure btnModificarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure edtClienteCodChange(Sender: TObject);
    procedure edtClienteCodKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure edtFaturaKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtFaturaKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure btnFaturaProcurarClick(Sender: TObject);
    procedure btnClienteProcurarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure mnuItemAlterarSenhaClick(Sender: TObject);
    procedure mnuItemAtualizarBancoClick(Sender: TObject);
    procedure mnuItemCadClientesClick(Sender: TObject);
    procedure mnuItemCadProdutosClick(Sender: TObject);
    procedure mnuItemNotaVendaClick(Sender: TObject);
    procedure mnuItemRelFatDataClick(Sender: TObject);
    procedure mnuItemRelFatNaoEstornClick(Sender: TObject);
    procedure mnuItemSairClick(Sender: TObject);
    procedure mnuItemEstFatClick(Sender: TObject);
    procedure mnuItemRelFatPendClick(Sender: TObject);
    procedure mnuItemUsuariosManutClick(Sender: TObject);
  private
    procedure ProcurarDados;
    procedure RetornaDados;
    procedure GravarDados;
    procedure AtualizarDados;
    procedure AlterandoEstadoComponentes;
    procedure ReverPrivilegios;
    procedure FormFaturaProcurar;
    procedure FormClienteProcurar;
    procedure FormProdutoAdicionar;
    procedure AlteraSituacao(situacao: string);
    procedure ImprimirFatura;
    function CampoTemValor(control: TWinControl): boolean;
    function EAdministrador: boolean;
  public
    UserName: string;
  end;

var
  frmMain: TfrmMain;
  Usuario: TUsuario;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnFaturaProcurarClick(Sender: TObject);
begin
  FormFaturaProcurar;
end;

procedure TfrmMain.BtnAddClick(Sender: TObject);
begin
  if not CampoTemValor(edtFatura) then exit;

  GravarDados;

  FormProdutoAdicionar;

  AlteraSituacao(PENDENTE);

  AlterandoEstadoComponentes;
end;

procedure TfrmMain.BtnEfetivarClick(Sender: TObject);
begin
  if MessageDlg('Deseja mesmo efetivar essa fatura?', mtWarning, mbYesNo, 0) = mrYes then
  begin
    //if (Usuario.Role <> ADMINISTRADOR) and (Usuario.Role <> DIRETOR) then
    //begin
    //  MessageDlg('Você precisa ter privilégios superiores para efetivar essa fatura',mtError,[mbOK],1);
    //  exit;
    //end;

    AlteraSituacao(EFETIVADA);

    ImprimirFatura;
    RetornaDados;
  end;
end;

procedure TfrmMain.BtnImprimirClick(Sender: TObject);
begin
  ImprimirFatura;
end;

procedure TfrmMain.btnRetornoTotalClick(Sender: TObject);
begin
  //TODO: elaborar o retorno total da fatura
  if MessageDlg('Deseja mesmo fazer retorno total?', mtWarning, mbYesNo, 0) = mrNo then
     Exit;

  with dm do
  begin
    dsDados.DataSet.First;

    while not dsDados.DataSet.EOF do
    begin;
      qryFaturaItensUpdate.ParamByName('qtde_enviada').AsString:= dsDados.DataSet.FieldByName('qtde_enviada').AsString;
      qryFaturaItensUpdate.ParamByName('qtde_retornada').AsString:= dsDados.DataSet.FieldByName('qtde_enviada').AsString;
      qryFaturaItensUpdate.ParamByName('valor_unit').AsString:= dsDados.DataSet.FieldByName('valor_unit').AsString;
      qryFaturaItensUpdate.ParamByName('fatura').AsString:= dsDados.DataSet.FieldByName('fatura').AsString;
      qryFaturaItensUpdate.ParamByName('produto').AsString:= dsDados.DataSet.FieldByName('produto').AsString;
      qryFaturaItensUpdate.ExecSQL;

      dsDados.DataSet.Next;
    end;
  end;
  RetornaDados;
end;

procedure TfrmMain.btnModificarClick(Sender: TObject);
begin
  //TODO: elaborar a modificação da fatura
  ShowMessage('Em breve...');
end;

procedure TfrmMain.actSairExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.actProcurarExecute(Sender: TObject);
begin
  if edtFatura.Focused then
    FormFaturaProcurar;
  if edtClienteCod.Focused then
    FormClienteProcurar;
end;

procedure TfrmMain.BtnSairClick(Sender: TObject);
begin
  actSair.Execute;
end;

procedure TfrmMain.edtClienteCodChange(Sender: TObject);
begin
  if edtSit.Text = PENDENTE then
  begin
    dm.qryCliente.Close;
    dm.qryCliente.ParamByName('CODIGO').AsString := edtClienteCod.Text;
    dm.qryCliente.Open;

    edtClienteNome.Text := dm.qryCliente['CLIENTE'];
  end;
end;

procedure TfrmMain.edtClienteCodKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = 13 then
  begin
    if not CampoTemValor(edtClienteCod) then exit;
    dm.qryCliente.Close;
    dm.qryCliente.ParamByName('CODIGO').AsString := edtClienteCod.Text;
    dm.qryCliente.Open;

    try
      edtClienteNome.Text := dm.qryCliente['CLIENTE'];
    except
      if MessageDlg('Cliente não encontrado. Deseja cadastrar esse cliente?',
        mtInformation, [mbYes, mbNo], 0) = mrYes then
      begin
        if frmCadCli = nil then frmCadCli := TfrmCadCli.Create(Application);

        try
          frmCadCli.edtCod.Text := edtClienteCod.Text;
          frmCadCli.ShowModal;
        finally
          FreeAndNil(frmCadCli);
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.edtFaturaKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if KEY = 13 then
  begin
    if not CampoTemValor(edtFatura) then exit;

    try
      RetornaDados;
    except
      ShowMessage('Registro Novo');
      edtEstorno.Text := '0';
      edtNotaVenda.Text:='0';
      edtSit.Text := EM_DIGITACAO;
      dtpEmissao.Date := Now;
      AlterandoEstadoComponentes;
      SelectNext(Sender as TWinControl, True, True);
    end;
  end;
end;

procedure TfrmMain.edtFaturaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DecimalSeparator := '.';
end;

procedure TfrmMain.btnClienteProcurarClick(Sender: TObject);
begin
  FormClienteProcurar;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  with dm.qryUsuarioLogin do
  begin
    Close;
    ParamByName('USUARIO').AsString := UserName;
    Open;

    Usuario.UserID := FieldByName('CODIGO').AsInteger;
    Usuario.Username := FieldByName('USUARIO').AsString;
    Usuario.Role := FieldByName('CARGO').AsString;
    Usuario.Status := FieldByName('SITUACAO').AsString;
  end;
  //ShowMessage(IntToStr(usuario.UserID));
  StatusBar1.Panels[0].Text := 'Usuário: ' + Usuario.Username;

  mnuItemCad.Visible := True;
  mnuItemRel.Visible := True;
  mnuItemProcEsp.Visible := True;
  mnuItemAtualizarBanco.Visible := True;
  mnuItemUsuariosManut.Visible := True;
  btnModificar.Enabled := True;

  //ReverPrivilegios;
end;

procedure TfrmMain.gridDblClick(Sender: TObject);
begin
  if not CampoTemValor(edtFatura) then exit;

  if edtSit.Text = EFETIVADA then
  begin
    ShowMessage(ERRO_JA_EFETIVADA_GRID);
    exit;
  end;

  if edtSit.Text = EM_DIGITACAO then
  begin
    ShowMessage(ERRO_EM_DIGITACAO_GRID);
    exit;
  end;

  FormProdutoAdicionar;
end;

procedure TfrmMain.gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = 13 then
    gridDblClick(nil);
end;

procedure TfrmMain.mnuItemAlterarSenhaClick(Sender: TObject);
begin
  if frmUsuarioSenha = nil then
     frmUsuarioSenha := TfrmUsuarioSenha.Create(Application);

  try
    frmUsuarioSenha.ShowModal;
  finally
    FreeAndNil(frmUsuarioSenha);
  end;
end;

procedure TfrmMain.mnuItemAtualizarBancoClick(Sender: TObject);
begin
  ShowMessage('Em Breve');
end;

procedure TfrmMain.mnuItemCadClientesClick(Sender: TObject);
begin
  if frmCadCli = nil then frmCadCli := TfrmCadCli.Create(Application);

  try
    frmCadCli.ShowModal;
  finally
    FreeAndNil(frmCadCli);
  end;
end;

procedure TfrmMain.mnuItemCadProdutosClick(Sender: TObject);
begin
  if frmCadProdutos = nil then frmCadProdutos := TfrmCadProdutos.Create(Application);

  try
    frmCadProdutos.ShowModal;
  finally
    FreeAndNil(frmCadProdutos);
  end;
end;

procedure TfrmMain.mnuItemNotaVendaClick(Sender: TObject);
begin
  if not CampoTemValor(edtFatura) then exit;

  if edtNotaVenda.Text <> '0' then
  begin
    ShowMessage('Nota de Venda já informada');
    Exit;
  end;

  if edtSit.Text <> EFETIVADA then
  begin
    ShowMessage('Fatura não efetivada');
    exit;
  end;

  frmNotaVenda := TfrmNotaVenda.Create(Application);

  frmNotaVenda.edtFatura.Text := edtFatura.Text;
  frmNotaVenda.edtClienteNome.Text := edtClienteNome.Text;
  try
    frmNotaVenda.ShowModal;
  finally
    frmNotaVenda.Free;
  end;
  RetornaDados;
end;

procedure TfrmMain.mnuItemRelFatDataClick(Sender: TObject);
begin
  //TODO: implementar um relatório com parametro para filtrar por data
  ShowMessage('Em Breve');
end;

procedure TfrmMain.mnuItemRelFatNaoEstornClick(Sender: TObject);
begin
  with dm do
  begin                         
    qryFaturasSemEstorno.Close;
    qryFaturasSemEstorno.Open;

    if qryFaturasSemEstorno.RecordCount = 0 then
    begin
      ShowMessage('Não há dados');
      Exit;
    end;
  end;

  FrmReportFaturasNEstornadas := TFrmReportFaturasNEstornadas.Create(Application);
  try
    FrmReportFaturasNEstornadas.FrReport.Preview();

  finally
    FrmReportFaturasNEstornadas.Free;
  end;
end;

procedure TfrmMain.mnuItemSairClick(Sender: TObject);
begin
  actSair.Execute;
end;

procedure TfrmMain.mnuItemEstFatClick(Sender: TObject);
begin
  if not CampoTemValor(edtFatura) then exit;

  if edtEstorno.Text <> '0' then
  begin
    ShowMessage('Fatura Já estornada');
    Exit;
  end;

  if edtSit.Text <> EFETIVADA then
  begin
    ShowMessage('Fatura não efetivada');
    exit;
  end;

  frmEstorno := TfrmEstorno.Create(Application);

  frmEstorno.edtFatura.Text := edtFatura.Text;
  frmEstorno.edtClienteNome.Text := edtClienteNome.Text;
  try
    frmEstorno.ShowModal;
  finally
    frmEstorno.Free;
  end;
  RetornaDados;
end;

procedure TfrmMain.mnuItemRelFatPendClick(Sender: TObject);
begin
  with dm do
  begin
    qryFaturasPendentes.Close;
    qryFaturasPendentes.Open;

    if qryFaturasPendentes.RecordCount = 0 then
    begin
      ShowMessage('Não há dados');
      Exit;
    end;
  end;

  FrmReportFaturasPendentes := TFrmReportFaturasPendentes.Create(Application);
  try
    FrmReportFaturasPendentes.FrReport.Preview();

  finally
    FrmReportFaturasPendentes.Free;
  end;

end;

procedure TfrmMain.mnuItemUsuariosManutClick(Sender: TObject);
begin
  if frmUsuarios = nil then frmUsuarios := TfrmUsuarios.Create(Application);

  try
    frmUsuarios.ShowModal;
  finally
    FreeAndNil(frmUsuarios);
  end;
end;

//-----------------------------------------------------------------------------
//MÉTODOS PRIVADOS
procedure TfrmMain.ProcurarDados;
begin
  with dm do
  begin
    qryFatura.Close;
    qryFatura.ParamByName('fatura').AsString := edtFatura.Text;
    qryFatura.Open;

    qryFaturaItens.Close;
    qryFaturaItens.ParamByName('FATURA').AsString := edtFatura.Text;
    qryFaturaItens.Open;

  end;
end;

procedure TfrmMain.RetornaDados;
begin
  with dm do
  begin

    ProcurarDados;
    dtpEmissao.Date := qryFatura.FieldByName('dt_emissao').AsDateTime;
    edtEstorno.Text := qryFatura['ESTORNO'];
    edtNotaVenda.Text := qryFatura['NOTA_VENDA'];
    edtClienteCod.Text := qryFatura['cliente'];
    edtClienteNome.Text := qryFatura['cliente_nome'];
    edtVlrTotal.Text := FormatFloat('####.#0', qryFatura['valor_fatura']);
    edtVlrRet.Text := FormatFloat('####.#0', qryFatura['valor_retornado']);
    edtVlrCobrado.Text := FormatFloat('####.#0', qryFatura['VALOR_COBRADO']);  
    edtPct.Text := FormatFloat('####.#0', qryFatura['pct']);
    edtSit.Text := qryFatura['situacao'];
    edtObs.Text := qryFatura['obs'];

    AlterandoEstadoComponentes;
  end;
end;

procedure TfrmMain.GravarDados;
begin
  with dm.qryFaturaAdd do
  begin
    Close;
    ParamByName('FATURA').AsString := edtFatura.Text;
    ParamByName('ESTORNO').AsString := edtEstorno.Text;
    ParamByName('NOTA_VENDA').AsString := edtNotaVenda.Text;
    ParamByName('DT_EMISSAO').AsDate := dtpEmissao.Date;
    ParamByName('CLIENTE').AsString := edtClienteCod.Text;
    ParamByName('VALOR_FATURA').AsString := edtVlrTotal.Text;
    ParamByName('VALOR_RETORNADO').AsString := edtVlrRet.Text;
    ParamByName('SITUACAO').AsString := edtSit.Text;
    ParamByName('OBS').AsString := edtObs.Text;
    ExecSQL;
  end;

  with dm.qryFaturasLogUpdate do
  begin
    ParamByName('TIPO').AsString := 'INSERINDO FATURA';
    ParamByName('SITUACAO').AsString := edtSit.Text;
    ParamByName('USUARIO').AsInteger := Usuario.UserID;
    ExecSQL;
  end;
end;

procedure TfrmMain.AtualizarDados;
begin
  with dm.qryFaturaUpdate do
  begin
    Close;
    ParamByName('FATURA').AsString := edtFatura.Text;
    ParamByName('ESTORNO').AsString := edtEstorno.Text;
    ParamByName('NOTA_VENDA').AsString := edtNotaVenda.Text;
    ParamByName('DT_EMISSAO').AsDate := dtpEmissao.Date;
    ParamByName('CLIENTE').AsString := edtClienteCod.Text;
    ParamByName('VALOR_FATURA').AsString := edtVlrTotal.Text;
    ParamByName('VALOR_RETORNADO').AsString := edtVlrRet.Text;
    ParamByName('SITUACAO').AsString := edtSit.Text;           
    ParamByName('OBS').AsString := edtObs.Text;
    ExecSQL;
  end;

  with dm.qryFaturasLogUpdate do
  begin
    ParamByName('TIPO').AsString := 'ATUALIZANDO FATURA';
    ParamByName('SITUACAO').AsString := edtSit.Text;
    ParamByName('USUARIO').AsInteger := Usuario.UserID;
    ExecSQL;
  end;
end;

procedure TfrmMain.AlterandoEstadoComponentes;
begin

  if (edtSit.Text = EM_DIGITACAO) then    //Se a situação estiver em Digitação
  begin
    dtpEmissao.Enabled := True;
    edtClienteCod.Enabled := True;
    edtClienteNome.Enabled := True;
    edtSit.Enabled := True;
    btnClienteProcurar.Enabled := True;
    BtnAdd.Visible := True;
    BtnEfetivar.Enabled := False;
    BtnImprimir.Enabled := False;
    btnModificar.Enabled := false;  
    btnRetornoTotal.Enabled := false;
  end;

  if edtSit.Text = PENDENTE then          //Se a situação estiver Pendente
  begin
    dtpEmissao.Enabled := False;
    edtClienteCod.Enabled := False;
    edtClienteNome.Enabled := False;
    edtSit.Enabled := False;
    btnClienteProcurar.Enabled := False;
    BtnAdd.Visible := False;
    BtnEfetivar.Enabled := True;
    BtnImprimir.Enabled := True;   
    btnModificar.Enabled := True;
    btnRetornoTotal.Enabled := True;
  end;

  if edtSit.Text = EFETIVADA then         //Se a situação estiver Efetivada
  begin
    dtpEmissao.Enabled := False;
    edtClienteCod.Enabled := False;
    edtClienteNome.Enabled := False;
    edtSit.Enabled := False;
    btnClienteProcurar.Enabled := False;
    BtnAdd.Visible := False;
    BtnEfetivar.Enabled := False;
    BtnImprimir.Enabled := True;  
    btnModificar.Enabled := True;
    btnRetornoTotal.Enabled := False;
  end;
end;

procedure TfrmMain.ReverPrivilegios;
begin
  //TODO: implementar o acesso aos usuarios por cargo.
  {
  cargos:
  ------------------------------------------------------------------------------
  TODOS:         mudar a senha

  ADMINISTRADOR: acesso total

  DIRETOR:       acesso geral, exceto manutenção do banco de dados.

  GERENTE:       acesso limitado a relatórios.

  USUARIO:       acesso SOMENTE a movimentação e consulta.
  ------------------------------------------------------------------------------
  }
  if Usuario.Role = ADMINISTRADOR then
  begin
    mnuItemCad.Visible := True;
    mnuItemRel.Visible := True;
    mnuItemProcEsp.Visible := True;
    mnuItemAtualizarBanco.Visible := True;
    mnuItemUsuariosManut.Visible := True;
    btnModificar.Enabled := True;
  end;

  if Usuario.Role = DIRETOR then
  begin
    mnuItemCad.Visible := True;
    mnuItemRel.Visible := True;
  end;

  if Usuario.Role = GERENTE then
  begin
    mnuItemRel.Visible := True;
  end;
end;

procedure TfrmMain.FormFaturaProcurar;
begin
  Application.CreateForm(TfrmFaturaProcurar, frmFaturaProcurar);

  try
    frmFaturaProcurar.ShowModal;
    if frmFaturaProcurar.CodigoRetorno = '' then exit;

    edtFatura.Text := frmFaturaProcurar.CodigoRetorno;
    edtFatura.SetFocus;
  finally
    frmFaturaProcurar.Free;
  end;

  try
    RetornaDados;
  except
    exit;
  end;
end;

procedure TfrmMain.FormClienteProcurar;
begin
  FrmClienteProcurar := TFrmClienteProcurar.Create(Application);
  try
    FrmClienteProcurar.ShowModal;
    edtClienteCod.Text := FrmClienteProcurar.CodigoRetorno;
    edtClienteCod.SetFocus;
  finally
    FrmClienteProcurar.Free;
  end;
end;

procedure TfrmMain.FormProdutoAdicionar;
begin
  frmProdutoAdicionar := TfrmProdutoAdicionar.Create(Application);

  frmProdutoAdicionar.situacao := edtSit.Text;
  frmProdutoAdicionar.usuario := Usuario.UserID;

  frmProdutoAdicionar.edtClienteNome.Text := self.edtClienteNome.Text;
  frmProdutoAdicionar.edtFatura.Text := self.edtFatura.Text;

  if grid.Focused then
    frmProdutoAdicionar.edtProdutoCod.Text := dsDados.DataSet['PRODUTO'];

  try
    frmProdutoAdicionar.ShowModal;
  finally
    frmProdutoAdicionar.Free;
  end;
  RetornaDados;
end;

procedure TfrmMain.AlteraSituacao(situacao: string);
begin
  edtSit.Text := situacao;
  AtualizarDados;
end;

procedure TfrmMain.ImprimirFatura;
begin
  with dm do
  begin
    qryFatura.Close;
    qryFatura.ParamByName('FATURA').AsString := edtFatura.Text;
    qryFatura.Open;

    qryFaturaItens.Close;
    qryFaturaItens.ParamByName('FATURA').AsString := edtFatura.Text;
    qryFaturaItens.Open;
  end;

  frmReport := TfrmReport.Create(Application);
  try
    frmReport.FrReport.Preview();
  finally
    frmReport.Free;
  end;
end;

function TfrmMain.CampoTemValor(control: TWinControl): boolean;
var
  mensagem: string;
begin
  mensagem := '';
  Result := True;

  if control is TEdit then
    if (control as TEdit).Text = '' then
    begin
      if (control as TEdit) = edtFatura then
        mensagem := ERRO_CAMPO_FATURA_NULO;

      if (control as TEdit) = edtClienteCod then
        mensagem := ERRO_CAMPO_CLIENTE_NULO;

      ShowMessage(mensagem);
      control.SetFocus;
      Result := False;
      exit;
    end;
end;

function TfrmMain.EAdministrador: boolean;
begin
  Result := True;
  if Usuario.Role <> ADMINISTRADOR then
  begin
    ShowMessage('Funcionalidade somente para o Administrador');
    Result := False;
    Exit;
  end;
end;

end.
