CREATE DATABASE financeiro;
USE financeiro;

CREATE TABLE Cliente(
	id int identity(1,1) primary key,
	nome VARCHAR(255) NOT NULL,
	idade DATE NOT NULL
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
	valor_total float not null,
	nmr_parcela int not null unique,
);

CREATE TABLE parcelas(
	id int identity(1,1) primary key not null,
	total_parcelas int foreign key references Venda(nmr_parcela),
	parcelas_pagas int not null,
	data_parcela date not null,
	atrasos int,
);

create table Saldo(
	id_produto int foreign key references Produto(id) not null,
	Saldo_produto decimal not null
);

CREATE TRIGGER subtrair_venda
ON Venda
AFTER INSERT
AS
BEGIN
	UPDATE saldo
	SET Saldo_produto = Saldo_produto - inserted.quantidade
	FROM Saldo
	INNER JOIN inserted ON Saldo.id_produto = inserted.id_produto;
END;