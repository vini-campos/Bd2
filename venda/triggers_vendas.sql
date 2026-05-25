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
create trigger Ao_inserir_venda on Venda
after insert
as
begin
	declare
	@nmr_parcela int,
	@valor_parcela decimal(10, 2),
	@valorTotal decimal (10, 2),
	@dataVencimento date
	
	select @nmr_parcela = nmr_parcela, @valorTotal = valor_total from inserted
	SET @valor_parcela = @valorTotal / CAST(@nmr_parcela AS DECIMAL(10,2));

	insert into Parcelas (total_parcelas, valor_p_parcela, parcelas_pagas, data_parcela, atrasos) values (@nmr_parcela, @valor_parcela, 0, GETDATE(), 0);


end