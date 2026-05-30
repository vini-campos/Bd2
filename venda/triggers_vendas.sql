CREATE TRIGGER subtrair_venda
ON Venda
AFTER INSERT
AS
BEGIN
	UPDATE saldo
	SET Saldo_produto = Saldo_produto - inserted.quantidade
	FROM Saldo
	INNER JOIN inserted ON Saldo.id_produto = inserted.id_produto;
END;

CREATE TRIGGER somar_venda
ON Venda
AFTER INSERT
AS
BEGIN
    UPDATE saldo
    SET Saldo_produto = Saldo_produto + inserted.quantidade
    FROM Saldo
    INNER JOIN inserted ON Saldo.id_produto = inserted.id_produto;
END;

--Trigger pra saber valor por parcela
CREATE trigger Ao_inserir_venda
ON Venda
instead of insert
AS
BEGIN
	declare @id_venda int

	insert into Venda (id_cliente, id_produto, data_venda, quantidade, valor_total, nmr_parcela)
	select i.id_cliente, i.id_produto, i.data_venda, i.quantidade, p.preco * i.quantidade, i.nmr_parcela
	from inserted i
	inner join produto p on p.id = i.id_produto;

	-- pega o id do ultimo indice feito com o insert into
	set @id_venda = SCOPE_IDENTITY();

	-- insere os valores nos campos com valor calculado
	INSERT INTO Parcelas (total_parcelas, valor_p_parcela, parcelas_pagas , data_parcela, atrasos)
    select i.nmr_parcela, p.preco * i.quantidade / cast(i.nmr_parcela as decimal (10,2)), 1, GETDATE(), 0 
	from inserted i
	inner join produto p on p.id = i.id_produto;

	-- insere na tabela contas_receber
	-- o DATEADD(day, 7, GETDATE()) está como vencimento em 7 dias, deixar no padrao de não ser final de semana e nem feriado
	-- a data de pagamento está como getdate(), trocar se necessario
	insert into contas_receber(id_venda, nmr_parcela, data_vencimento, valor_parcela, data_pagamento)
	select	@id_venda, i.nmr_parcela, DATEADD(day, 7, GETDATE()), p.preco * i.quantidade / cast(i.nmr_parcela as decimal (10,2)), GETDATE()
	from inserted i
	inner join produto p on p.id = i.id_produto;
END;