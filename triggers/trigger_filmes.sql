CREATE TRIGGER devolver_filme
ON filmes
AFTER UPDATE
AS
BEGIN
	DECLARE 
	@status varchar(10),
	@id_filme int

	SELECT @id_filme = cod_filme, @status = status FROM inserted

	UPDATE locacoes SET status = @status WHERE cod_filme = @id_filme

	SELECT * FROM locacoes
	SELECT * FROM filmes

END
DROP TRIGGER devolver_filme

UPDATE dbo.filmes
SET status = 'alugado' WHERE cod_filme = 1

--arrumar essa merda 
