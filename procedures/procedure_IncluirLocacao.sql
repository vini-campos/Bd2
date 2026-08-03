--executar antes de rodar a procedure

alter table locacoes
add Data_devolucao datetime;

alter table locacoes
add status varchar(10);

alter table locacoes
drop column data_retirada;

alter table locacoes
drop column data_devolucao;

alter table locacoes
add data_retirada datetime;

alter table locacoes
add data_devolucao datetime;

alter table locacoes
add data_devolucao_prevista datetime;

create procedure IncluirLocacao
    @ID_Cliente int,
    @ID_Filme int
as
begin
    IF ( SELECT status FROM filmes WHERE cod_filme = @ID_Filme) != 'alugado'
    begin
        update locacoes
        set data_retirada = getdate()
        where cod_cliente = @ID_Cliente and cod_filme = @ID_Filme and data_retirada is null;

        update locacoes
        set data_devolucao_prevista = dateadd(day, 7, getdate())
        where cod_cliente = @ID_Cliente and cod_filme = @ID_Filme and data_devolucao_prevista is null;

        update locacoes
        set data_devolucao = null
        where @ID_Cliente = cod_cliente and @ID_Filme = cod_filme;

        -- Atualiza status 
        update filmes
        set status = 'alugado', vezes_alugado = vezes_alugado + 1
        where cod_filme = @ID_Filme;
    end
end

drop procedure IncluirLocacao

exec IncluirLocacao @ID_Cliente = 3, @ID_Filme = 3;
