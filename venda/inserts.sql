insert into Cliente (nome, idade)
values ('Vinicius', 16),
       ('Caio', 16);

insert into Produto (nome, preco, categoria, descricao)
values ('red bull', 7.49, 'bebida gaseificada', 'energético red bull de 250ml (red bull te dá aaasaass)'),
       ('cheetos de queijo', 11.99, 'salgadinho de milho', 'salgadinho feito de milho sabor queijo');

-- para os produtos terem saldo salvo e não ficarem vazios
insert into Saldo (id_produto, Saldo_produto)
values (1, 15), (2, 30)

insert into feriados_fixos (mes, dia, descricao) values
(1,  1,  'Confraternização Universal'),
(4,  21, 'Tiradentes'),
(5,  1,  'Dia do Trabalho'),
(9,  7,  'Independência do Brasil'),
(10, 12, 'Nossa Senhora Aparecida'),
(11, 2,  'Finados'),
(11, 15, 'Proclamação da República'),
(12, 25, 'Natal')

insert into feriados_do_ano (dataFeriado, descricao) values
('2026-02-16', 'Carnaval'),
('2026-02-17', 'Carnaval'),
('2026-04-02', 'Quinta-feira Santa'),
('2026-04-03', 'Sexta-feira Santa'),
('2026-04-05', 'Páscoa'),
('2026-05-14', 'Ascensão de Cristo'),
('2026-06-04', 'Corpus Christi')