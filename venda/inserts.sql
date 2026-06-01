insert into Cliente (nome, idade)
values ('Vinicius', 16),
       ('Caio', 16);

insert into Produto (nome, preco, categoria, descricao)
values ('red bull', 7.49, 'bebida gaseificada', 'energético red bull de 250ml (red bull te dá aaasaass)'),
       ('cheetos de queijo', 11.99, 'salgadinho de milho', 'salgadinho feito de milho sabor queijo');

-- para os produtos terem saldo salvo e não ficarem vazios
insert into Saldo (id_produto, Saldo_produto)
values (1, 15), (2, 30)

INSERT INTO feriados_fixos (data_feriado, descricao) VALUES
('2026-01-01', 'Confraternização Universal'),
('2026-04-21', 'Tiradentes'),
('2026-05-01', 'Dia do Trabalho'),
('2026-09-07', 'Independência do Brasil'),
('2026-10-12', 'Nossa Senhora Aparecida'),
('2026-11-02', 'Finados'),
('2026-11-15', 'Proclamação da República'),
('2026-12-25', 'Natal');

insert into feriados_do_ano (dataFeriado, descricao) values
('2026-02-16', 'Carnaval'),
('2026-02-17', 'Carnaval'),
('2026-04-02', 'Quinta-feira Santa'),
('2026-04-03', 'Sexta-feira Santa'),
('2026-04-05', 'Páscoa'),
('2026-05-14', 'Ascensão de Cristo'),
('2026-06-04', 'Corpus Christi')

insert into venda (id_cliente, id_produto, data_venda, quantidade, nmr_parcela)
values (1, 2, GETDATE(), 5, 2) --valor de teste '2026-05-06'

insert into movimento (id_produto, quantidade, tipo, data_movimento)
values (2, 10, 'E', getdate())