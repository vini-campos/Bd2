CREATE trigger Ao_inserir_venda
ON Venda
instead of insert
AS
BEGIN
	declare @id_venda int,
			@data_vencimento date

	insert into Venda (id_cliente, id_produto, data_venda, quantidade, valor_total, nmr_parcela)
	select i.id_cliente, i.id_produto, i.data_venda, i.quantidade, p.preco * i.quantidade, i.nmr_parcela
	from inserted i
	inner join produto p on p.id = i.id_produto;

	-- pega o id do ultimo indice feito com o insert into
	set @id_venda = SCOPE_IDENTITY();

	-- insere os valores nos campos com valor calculado
	INSERT INTO Parcelas (total_parcelas, valor_p_parcela, parcelas_pagas , data_parcela)
    select i.nmr_parcela, p.preco * i.quantidade / cast(i.nmr_parcela as decimal (10,2)), 1, GETDATE()
	from inserted i
	inner join produto p on p.id = i.id_produto;

	-- vencimento base (1 Mês)
	select @data_vencimento = DATEADD(month, 1, i.data_venda)
	from inserted i;

	while @data_vencimento in (select dataFeriado from feriados_do_ano)
		or DATENAME(WEEKDAY, @data_vencimento) in ('Saturday', 'Sunday')
	begin
		set @data_vencimento = DATEADD(day, 1, @data_vencimento);
	end

	-- o agora ao inves de dateadd(day, 7, getdate()), esta com a variavel do dia util ja calculado com o while
	insert into contas_receber(id_venda, nmr_parcela, data_vencimento, valor_parcela, data_pagamento)
	select	@id_venda,
			i.nmr_parcela,
			@data_vencimento, -- usa a variavel depois que o dia util foi definido
			p.preco * i.quantidade / cast(i.nmr_parcela as decimal (10,2)),
			GETDATE()
	from inserted i
	inner join produto p on p.id = i.id_produto;

	-- saida na tabela de movimentos
	insert into movimento (id_produto, quantidade, tipo)
	select i.id_produto, i.quantidade, 'S' -- sempre S porque e uma saida
	from inserted i;
END;


select * from Venda
select * from parcelas
select * from Saldo
select * from contas_receber
select * from movimento

insert into venda (id_cliente, id_produto, data_venda, quantidade, nmr_parcela)
values (1,2, getdate(), 5, 2)

create trigger Atualizar_saldo
on movimento
after insert
as
begin
	update Saldo
	set Saldo_produto = s.Saldo_produto + 
		case
			when i.tipo = 'E' then i.quantidade -- entrada, soma
			when i.tipo = 'S' then - i.quantidade -- saida, subtrai
		end
	from Saldo s
	inner join inserted i on s.id_produto = i.id_produto
end;

insert into movimento (id_produto, quantidade, tipo, data_movimento)
values (1, 15, 'E', getdate())

insert into Cliente (nome, idade)
values ('vinicius', 16), ('caio', 16);

insert into Produto (nome, preco, categoria, descricao)
values ('red bull', 7.49, 'bebida gaseificada', 'energético red bull de 250ml (red bull te dá aaasaass)')

insert into Produto (nome, preco, categoria, descricao)
values ('monster', 8.99, 'bebida gaseificada', 'energético red bull de 250ml (red bull te dá aaasaass)')

insert into Saldo (id_produto, Saldo_produto)
values (1, 15)

insert into Saldo (id_produto, Saldo_produto)
values (2, 10)

select * from feriados_do_ano
select * from feriados_fixos

INSERT INTO feriados_fixos (mes, dia, descricao) VALUES
(1,  1,  'Confraternização Universal'),
(4,  21, 'Tiradentes'),
(5,  1,  'Dia do Trabalho'),
(9,  7,  'Independência do Brasil'),
(10, 12, 'Nossa Senhora Aparecida'),
(11, 2,  'Finados'),
(11, 15, 'Proclamação da República'),
(12, 25, 'Natal')

INSERT INTO feriados_do_ano (dataFeriado, descricao) VALUES
-- Móveis 2026 (baseados na Páscoa em 05/04/2026)
('2026-02-16', 'Carnaval'),
('2026-02-17', 'Carnaval'),
('2026-04-02', 'Quinta-feira Santa'),
('2026-04-03', 'Sexta-feira Santa'),
('2026-04-05', 'Páscoa'),
('2026-05-14', 'Ascensão de Cristo'),
select * from feriados_do_ano
('2026-06-04', 'Corpus Christi')