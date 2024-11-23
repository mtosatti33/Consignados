CREATE VIEW IF NOT EXISTS VW_FATURAS
AS
select f.fatura, 
f.estorno, 
f.nota_venda, 
f.dt_emissao,
f.cliente,
c.cliente as cliente_nome,
f.valor_fatura,
f.valor_retornado,
f.situacao,
(SELECT count(*) from FATURA_ITENS it where it.FATURA=f.fatura) as QTDE_ITENS
from faturas f
join clientes c on c.codigo=f.cliente;

CREATE VIEW IF NOT EXISTS VW_FATURA_ITENS
AS
select it.fatura, it.produto,
p.produto as produto_nome, 
it.qtde_retornada,
it.qtde_enviada,
it.valor_unit,
cast(it.valor_unit*it.qtde_enviada as decimal(5,2)) as valor_produto,
cast(it.valor_unit*it.QTDE_RETORNADA as decimal(5,2)) as valor_retornado,
cast(it.qtde_enviada-it.qtde_retornada as decimal(5,2)) as saldo
from fatura_itens it
join produtos p on p.codigo=it.produto;