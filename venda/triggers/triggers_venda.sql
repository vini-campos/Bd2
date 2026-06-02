CREATE TRIGGER Ao_inserir_venda
ON Venda
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @id_venda INT,
			@data_vencimento DATE

	INSERT INTO Venda (id_cliente, id_produto, data_venda, quantidade, valor_total, nmr_parcela)
	SELECT i.id_cliente, i.id_produto, i.data_venda, i.quantidade, p.preco * i.quantidade, i.nmr_parcela
	FROM inserted i
	INNER JOIN produto p ON p.id = i.id_produto;

	-- pega o id do ultimo indice feito com o insert into
	SET @id_venda = SCOPE_IDENTITY();

	-- insere os valores nos campos com valor calculado
	INSERT INTO Parcelas (id_venda, total_parcelas, valor_p_parcela, parcelas_pagas, data_parcela)
	SELECT @id_venda, i.nmr_parcela, p.preco * i.quantidade / CAST(i.nmr_parcela AS DECIMAL(10,2)), 1, GETDATE() -- cast foi usado para não cortar a vírgula do numero decimal
	FROM inserted i
	INNER JOIN produto p ON p.id = i.id_produto;

	-- vencimento base (1 Mês)
	SELECT @data_vencimento = DATEADD(MONTH, 1, i.data_venda)
	FROM inserted i;

	WHILE @data_vencimento IN (SELECT dataFeriado FROM feriados_do_ano)
		OR DATENAME(WEEKDAY, @data_vencimento) IN ('Sábado', 'Domingo') --so funciona para dias em portugues (linguagem do sqlserver da escola)
		OR @data_vencimento IN (SELECT data_feriado FROM feriados_fixos)
	BEGIN
		SET @data_vencimento = DATEADD(DAY, 1, @data_vencimento);
	END

	INSERT INTO contas_receber(id_venda, nmr_parcela, data_vencimento, valor_parcela, data_pagamento)
	SELECT	@id_venda,
			i.nmr_parcela,
			@data_vencimento, -- usa a variavel depois que o dia util foi definido
			p.preco * i.quantidade / CAST(i.nmr_parcela AS DECIMAL(10,2)),
			GETDATE()
	FROM inserted i
	INNER JOIN produto p ON p.id = i.id_produto;

	-- saida na tabela de movimentos
	INSERT INTO movimento (id_produto, quantidade, tipo, data_movimento)
	SELECT i.id_produto, i.quantidade, 'S', GETDATE() -- sempre S porque e uma saida
	FROM inserted i;
END;

CREATE TRIGGER Atualizar_saldo
ON movimento
AFTER INSERT
AS
BEGIN
	DECLARE
		@e_s INT

	SELECT @e_s = CASE
		WHEN i.tipo = 'E' THEN i.quantidade -- entrada, soma
		WHEN i.tipo = 'S' THEN - i.quantidade -- saida, subtrai
	END
	FROM inserted i

	-- verifica se o saldo do produto e maior do que a quantidade que foi feita a venda do mesmo produto
	IF EXISTS(
		SELECT * FROM Saldo s
		INNER JOIN inserted i on s.id_produto = i.id_produto
		WHERE i.tipo = 'S' AND s.Saldo_produto + @e_s < 0
	)
	BEGIN
		RAISERROR('Saldo insuficiente para realizar a saída.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
	END

	UPDATE Saldo
	SET Saldo_produto = s.Saldo_produto + @e_s
	FROM Saldo s
	INNER JOIN inserted i ON s.id_produto = i.id_produto
END;