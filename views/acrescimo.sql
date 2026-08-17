CREATE FUNCTION aplica_acrescimo (@num int)
RETURNS @tbl table(nmr_acrescido int) -- cria tabela virtual p retornar dps
AS
BEGIN
    insert into @tbl values( @num * 1.1); -- insere nessa bglh de tabela virtual    
    RETURN ;
END;

select * from  aplica_acrescimo(10);