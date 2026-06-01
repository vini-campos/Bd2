create trigger Ao_inserir_venda
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
    select i.nmr_parcela, p.preco * i.quantidade / cast(i.nmr_parcela as decimal (10,2)), 1, GETDATE() -- cast foi usado para não cortar a vírgula do numero decimal
	from inserted i
	inner join produto p on p.id = i.id_produto;

	-- vencimento base (1 Mês)
	select @data_vencimento = DATEADD(month, 1, i.data_venda)
	from inserted i;

	while @data_vencimento in (select dataFeriado from feriados_do_ano)
		or DATENAME(WEEKDAY, @data_vencimento) in ('Sábado', 'Domingo')--so funciona para dias em portugues (linguagem do sqlserver da escola)
		or @data_vencimento in (select data_feriado from feriados_fixos)
	begin
		set @data_vencimento = DATEADD(day, 1, @data_vencimento);
	end

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

create trigger Atualizar_saldo
on movimento
after insert
as
begin
	declare 
		@e_s int

	select @e_s = case
		when i.tipo = 'E' then i.quantidade -- entrada, soma
		when i.tipo = 'S' then - i.quantidade-- saida, subtrai
	end
	from inserted i

	update Saldo
	set Saldo_produto = s.Saldo_produto + @e_s
	from Saldo s
	inner join inserted i on s.id_produto = i.id_produto
end;