create view mais_locados
as
select f.filme,s.cod_filme , s.Vezes_alugado from (
	select l.cod_filme, count(l.cod_filme) as Vezes_Alugado
	from locacoes as l 
	inner join filmes as f on l.cod_filme = f.cod_filme 
	group by l.cod_filme
) as s
inner join filmes as f on s.cod_filme = f.cod_filme

select * from mais_locados order by Vezes_Alugado desc