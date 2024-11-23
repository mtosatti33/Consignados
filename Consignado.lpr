program Consignado;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, zcomponent, UMain, udm, ufrmFaturaProcurar, uFuncoes,
  uFrmProdutoProcurar, ufrmEstorno, UConstantes, ureportFaturaPendentes,
  uFrmLogin, ufrmprodutoadicionar, ufrmclienteprocurar,
  ureportFaturasNaoEstornadas, UFrmNotaVenda, UEstruturaDados, UFrmIntegerInput,
  UFrmStringInput, ufrmCadProdutos, ufrmCadClientes, UfrmUsuarios, 
ufrmusuarioEdit, UfrmUsuarioSenha, ufaturas, ufaturaitens, uprodutos, ucliente;
var
   UserName: string;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmMain, frmMain);

  UserName:= TfrmLogin.Execute;

  if UserName <> '' then
  begin
    frmMain.UserName:=UserName;
    Application.Run;
  end
  else
  begin
    Application.MessageBox('Usuario e senha não confere', 'Erro');
  end;
end.
