CREATE DATABASE financeiro;
USE financeiro;

CREATE TABLE Cliente(
	id int identity(1,1) primary key,
	nome VARCHAR(255) NOT NULL,
	idade INT NOT NULL
);

create table Produto(
	id int identity(1,1) primary key not null,
	nome varchar(100) not null,
	preco decimal(10,2) not null,
	categoria varchar(50) not null,
	descricao varchar(150)
);

create table Venda(
	id int identity(1,1) primary key not null,
	id_cliente int foreign key references Cliente(id),
	id_produto int foreign key references Produto(id),
	data_venda date not null,
	quantidade int not null,
	valor_total float, -- nao precisa do not null porque o trigger ja adiciona
	nmr_parcela int not null
);

CREATE TABLE parcelas(
	id int identity(1,1) primary key not null,
	total_parcelas int,
	valor_p_parcela decimal(10,2),
	parcelas_pagas int not null,
	data_parcela date not null,
);

create table Saldo(
	id_produto int foreign key references Produto(id) not null,
	Saldo_produto decimal not null
);

create table contas_receber(
    id_venda int not null,
    nmr_parcela int not null,
    data_vencimento date,
    valor_parcela money not null,
    data_pagamento date
);

create table movimento(
	id int primary key identity(1,1),
	id_produto int not null,
	quantidade int not null,
	tipo char(1) not null check(tipo in ('E', 'S')), -- check é o equivalente ao enum do mysql que vimos em pw
	data_movimento date default getdate()
);

create table feriados_fixos(
	mes int not null,
	dia int not null,
	descricao varchar(100) not null
);

create table feriados_do_ano(
	dataFeriado date primary key,
	--nova coluna abaixo
	dataProxAno date,
	descricao varchar(100) not null
);