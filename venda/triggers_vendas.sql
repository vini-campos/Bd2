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