create trigger devolver_filme
on filmes
after update
as
begin
	declare 
	@status varchar(10),
	@id_filme int

	SELECT @id_filme = cod_filme, @status = status FROM inserted

	update locacoes set status = @status where cod_filme = @id_filme

	select * from locacoes
	select * from filmes

end
drop trigger devolver_filme

update dbo.filmes
set status = 'alugado' where cod_filme = 1

--arrumar essa merda 