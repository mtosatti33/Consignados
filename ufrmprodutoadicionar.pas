unit ufrmprodutoadicionar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ActnList, ZDataset, uFrmProdutoProcurar, udm, UConstantes, ufrmCadProdutos;

type

  { TfrmProdutoAdicionar }

  TfrmProdutoAdicionar = class(TForm)
    actSair: TAction;
    actProcurar: TAction;
    actions: TActionList;
    btnSalvar: TButton;
    btnFechar: TButton;
    edtClienteNome: TEdit;
    edtFatura: TEdit;
    edtProdutoCod: TEdit;
    edtProdutoNome: TEdit;
    edtQtdeEnviada: TEdit;
    edtQtdeRetornada: TEdit;
    edtValorCobrado: TEdit;
    edtValorTotal: TEdit;
    edtValorRetornado: TEdit;
    edtValorUnitario: TEdit;
    edtQtdeCobrada: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btnProdutoProcurar: TSpeedButton;
    Label8: TLabel;
    Label9: TLabel;
    procedure actProcurarExecute(Sender: TObject);
    procedure actSairExecute(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtProdutoCodChange(Sender: TObject);
    procedure edtProdutoCodKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure edtProdutoCodKeyPress(Sender: TObject; var Key: char);
    procedure edtQtdeEnviadaExit(Sender: TObject);
    procedure edtQtdeEnviadaKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure edtQtdeRetornadaExit(Sender: TObject);
    procedure edtQtdeRetornadaKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure edtValorTotalExit(Sender: TObject);
    procedure edtValorTotalKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnProdutoProcurarClick(Sender: TObject);
  private
    procedure ProdutoNomeProcurar;
  public
    situacao: string;
    usuario: integer;
  end;

var
  frmProdutoAdicionar: TfrmProdutoAdicionar;

implementation

{$R *.lfm}

{ TfrmProdutoAdicionar }

procedure TfrmProdutoAdicionar.btnSalvarClick(Sender: TObject);
begin
  if situacao = EM_DIGITACAO then                        //Quando inserir um pedido novo
  begin
    if edtProdutoCod.Text = '' then
    begin
      MessageDlg('For Favor insira um produto', mtWarning, [mbOK], 1);
      edtProdutoCod.SetFocus;
      exit;
    end;

    with dm.qryFaturaItensAdd do
    begin
      ParamByName('fatura').AsString := edtFatura.Text;
      ParamByName('produto').AsString := edtProdutoCod.Text;
      ParamByName('qtde_enviada').AsString := edtQtdeEnviada.Text;
      ParamByName('qtde_retornada').AsString := edtQtdeRetornada.Text;
      ParamByName('valor_unit').AsString := edtValorUnitario.Text;
      ExecSQL;
    end;

    edtProdutoCod.SetFocus;
    edtProdutoCod.Clear;
    edtProdutoNome.Clear;
    edtQtdeEnviada.Clear;
    edtValorUnitario.Clear;
    edtValorTotal.Clear;
  end;

  if situacao = PENDENTE then                           //Quando ele já existir
  begin
    if StrToFloat(edtQtdeRetornada.Text) > StrToFloat(edtQtdeEnviada.Text) then
    begin
      ShowMessage(ERRO_QTDE_RET_MAIOR_Q_ENV);
      exit;
    end;

    with dm.qryFaturaItensUpdate do
    begin
      ParamByName('fatura').AsString := edtFatura.Text;
      ParamByName('produto').AsString := edtProdutoCod.Text;
      ParamByName('qtde_enviada').AsString := edtQtdeEnviada.Text;
      ParamByName('qtde_retornada').AsString := edtQtdeRetornada.Text;
      ParamByName('valor_unit').AsString := edtValorUnitario.Text;
      ExecSQL;
    end;
    actSair.Execute;
  end;

  with dm.qryFaturasLogUpdate do
  begin
    if situacao = EM_DIGITACAO then
       ParamByName('TIPO').AsString := 'INSERINDO PRODUTOS'
    else
        ParamByName('TIPO').AsString := 'ALTERANDO PRODUTOS';

    ParamByName('SITUACAO').AsString := situacao;
    ParamByName('USUARIO').AsInteger := usuario;
    ExecSQL;
  end;
end;

procedure TfrmProdutoAdicionar.edtProdutoCodChange(Sender: TObject);
begin
  if situacao = PENDENTE then
    ProdutoNomeProcurar;
end;

procedure TfrmProdutoAdicionar.edtProdutoCodKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if key = 13 then
  begin
    if edtProdutoCod.Text = '' then
    begin
      ShowMessage('Código Obrigatório');
      exit;
    end;
    if situacao = EM_DIGITACAO then
      ProdutoNomeProcurar;
  end;
end;

procedure TfrmProdutoAdicionar.btnFecharClick(Sender: TObject);
begin
  with dm do
  begin
    qryFaturaItens.Close;
    qryFaturaItens.ParamByName('FATURA').AsString := edtFatura.Text;
    qryFaturaItens.Open;

    if qryFaturaItens.RecordCount = 0 then
    begin
      ShowMessage('Há itens para salvar');
      exit;
    end;
  end;
  actSair.Execute;
end;

procedure TfrmProdutoAdicionar.actSairExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmProdutoAdicionar.actProcurarExecute(Sender: TObject);
begin
  if edtProdutoCod.Focused then
    btnProdutoProcurarClick(nil);
end;

procedure TfrmProdutoAdicionar.edtProdutoCodKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

procedure TfrmProdutoAdicionar.edtQtdeEnviadaExit(Sender: TObject);
begin
  edtQtdeEnviada.Text := StringReplace(edtQtdeEnviada.Text, ',', '.', []);
end;

procedure TfrmProdutoAdicionar.edtQtdeEnviadaKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if key = 13 then
  begin
    if edtQtdeEnviada.Text = '' then
    begin
      ShowMessage('Quantidade Obrigatória');
      exit;
    end;
  end;
end;

procedure TfrmProdutoAdicionar.edtQtdeRetornadaExit(Sender: TObject);
var
  vlr_ret: double;
begin
  if situacao = PENDENTE then
  begin
    vlr_ret := StrToFloat(edtQtdeRetornada.Text) * StrToFloat(edtValorUnitario.Text);
    edtValorRetornado.Text := FormatFloat('####.#0',vlr_ret);
    edtQtdeCobrada.Text := FormatFloat('####.#0',StrToFloat(edtQtdeEnviada.Text) - StrToFloat(edtQtdeRetornada.Text));
    edtValorCobrado.Text := FormatFloat('####.#0',StrToFloat(edtValorTotal.Text) - StrToFloat(edtValorRetornado.Text));
  end
  else
    edtValorRetornado.Text := '0';

end;

procedure TfrmProdutoAdicionar.edtQtdeRetornadaKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if key = 13 then
  begin
    if StrToFloat(edtQtdeRetornada.Text) > StrToFloat(edtQtdeEnviada.Text) then
    begin
      ShowMessage(ERRO_QTDE_RET_MAIOR_Q_ENV);
      exit;
    end;
  end;
end;

procedure TfrmProdutoAdicionar.edtValorTotalExit(Sender: TObject);
var
  vlr_unit: double;
begin
  try
    edtValorTotal.Text := StringReplace(edtValorTotal.Text, ',', '.', []);
    vlr_unit := StrToFloat(edtValorTotal.Text) / StrToFloat(edtQtdeEnviada.Text);
    edtValorUnitario.Text := FloatToStr(vlr_unit);
  except
    on EDivByZero do
      edtValorUnitario.Text := '0';
  end;
end;

procedure TfrmProdutoAdicionar.edtValorTotalKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if key = 13 then
  begin
    if edtValorTotal.Text = '' then
    begin
      ShowMessage('Valor Obrigatório');
      exit;
    end;
  end;
end;

procedure TfrmProdutoAdicionar.FormShow(Sender: TObject);
begin
  if situacao = EM_DIGITACAO then
  begin
    edtProdutoCod.SetFocus;
    edtProdutoCod.Enabled := True;
    edtProdutoNome.Enabled := True;
    edtQtdeEnviada.Enabled := True;
    edtValorUnitario.Enabled := True;
    edtValorTotal.Enabled := True;
    edtValorRetornado.Enabled := False;
    edtQtdeRetornada.Enabled := False;
  end;
  if situacao = PENDENTE then
  begin
    with dm do
    begin
      qryFaturaItem.Close;
      qryFaturaItem.ParamByName('fatura').AsString := edtFatura.Text;
      qryFaturaItem.ParamByName('produto').AsString := edtProdutoCod.Text;
      qryFaturaItem.Open;
    end;

    edtQtdeRetornada.SetFocus;
    edtProdutoCod.Enabled := False;
    edtProdutoNome.Enabled := False;
    edtQtdeEnviada.Enabled := False;
    edtValorUnitario.Enabled := False;
    edtValorTotal.Enabled := False;
    edtValorRetornado.Enabled := False;

    edtQtdeEnviada.Text := DM.qryFaturaItem['qtde_enviada'];
    edtQtdeRetornada.Text := DM.qryFaturaItem['qtde_retornada'];
    edtValorUnitario.Text := DM.qryFaturaItem['valor_unit'];
    edtValorTotal.Text := DM.qryFaturaItem['valor_produto'];
    edtValorRetornado.Text := FormatFloat('####.#0',DM.qryFaturaItem['valor_retornado']);
    edtQtdeCobrada.Text := FormatFloat('####.#0',StrToFloat(edtQtdeEnviada.Text) - StrToFloat(edtQtdeRetornada.Text));
    edtValorCobrado.Text := FormatFloat('####.#0',StrToFloat(edtValorTotal.Text) - StrToFloat(edtValorRetornado.Text));
  end;
end;

procedure TfrmProdutoAdicionar.btnProdutoProcurarClick(Sender: TObject);
begin
  frmProdutoProcurar := TfrmProdutoProcurar.Create(Application);
  try
    frmProdutoProcurar.ShowModal;
    edtProdutoCod.Text := frmProdutoProcurar.CodigoRetorno;
    edtProdutoCod.SetFocus;
    ProdutoNomeProcurar;
  finally
    frmProdutoProcurar.Free;
  end;
end;

procedure TfrmProdutoAdicionar.ProdutoNomeProcurar;
begin
  with dm do
  begin
    qryProduto.Close;
    qryProduto.ParamByName('CODIGO').AsString := edtProdutoCod.Text;
    qryProduto.Open;

    try
      edtProdutoNome.Text := qryProduto['PRODUTO'];
    except
      if MessageDlg('Produto não encontrado. Deseja cadastrar esse produto?',mtInformation,[mbyes,mbNo],0) = mrYes then
      begin
        if frmCadProdutos = nil then frmCadProdutos:= TfrmCadProdutos.Create(Application);
        begin
          try
            frmCadProdutos.edtCod.Text:=edtProdutoCod.Text;
            frmCadProdutos.ShowModal;
          finally
            FreeAndNil(frmCadProdutos);
          end;
        end;
      end;
    end;
  end;
end;

end.
