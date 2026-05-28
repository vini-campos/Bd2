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
	insert into Venda (id_cliente, id_produto, data_venda, quantidade, valor_total, nmr_parcela)
	select i.id_cliente, i.id_produto, i.data_venda, i.quantidade, p.preco * i.quantidade, i.nmr_parcela
	from inserted i
	inner join produto p on p.id = i.id_produto;

	-- insere os valores nos campos com valor calculado
	INSERT INTO Parcelas (total_parcelas, valor_p_parcela, parcelas_pagas , data_parcela, atrasos)
    select i.nmr_parcela, p.preco * i.quantidade / cast(i.nmr_parcela as decimal (10,2)), 1, GETDATE(), 0 
	from inserted i
	inner join produto p on p.id = i.id_produto;
END;