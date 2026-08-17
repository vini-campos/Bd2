create view exibir_disponivel as
select * from filmes where filmes.status = 'disponivel';

select * from exibir_disponivel