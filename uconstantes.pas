unit UConstantes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  //Banco de dados local
  BANCO='ControleConsignado.db';
  LIB='sqlite3.dll';

  //Cargos
  ADMINISTRADOR = 'ADMINISTRADOR';  
  DIRETOR       = 'DIRETOR';
  GERENTE       = 'GERENTE';
  USUARIO       = 'USUARIO';

  //Situação
  EM_DIGITACAO = 'EM DIGITAÇÃO';
  PENDENTE = 'PENDENTE';
  EFETIVADA = 'EFETIVADA';

  //Mensagens de Erro
  ERRO_CONEXAO_BANCO        = 'Não foi possível conectar ao banco';
  ERRO_QTDE_RET_MAIOR_Q_ENV = 'Quantidade retornada não pode ser maior que a quantidade enviada';
  ERRO_CAMPO_FATURA_NULO    = 'Informe o valor no campo FATURA';                                
  ERRO_CAMPO_CLIENTE_NULO   = 'Informe o valor no campo CLIENTE';
  ERRO_CAMPO_DATA_NULO   = 'Informe o valor no campo DATA EMISSÃO';
  ERRO_PRODUTO_N_ENCONTRADO = 'Produto não encontrado';           
  ERRO_CLIENTE_N_ENCONTRADO = 'Cliente não encontrado';
  ERRO_JA_EFETIVADA_GRID    = 'Já efetivada, não é possível realizar alteração';
  ERRO_EM_DIGITACAO_GRID    = 'Não há nenhum item pra ser alterado. ' + #13 +
      'Você tem que usar o botão Adicionar Produtos (+) no canto superior';
  ERRO_NAO_DADOS            = 'Não há dados';

implementation

end.
