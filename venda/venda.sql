CREATE DATABASE financeiro;
USE financeiro;

CREATE TABLE Cliente(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	idade INT NOT NULL
);

CREATE TABLE Produto(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nome VARCHAR(100) NOT NULL,
	preco DECIMAL(10,2) NOT NULL,
	categoria VARCHAR(50) NOT NULL,
	descricao VARCHAR(150) NOT NULL
);

CREATE TABLE Venda(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	id_cliente INT FOREIGN KEY REFERENCES Cliente(id) NOT NULL,
	id_produto INT FOREIGN KEY REFERENCES Produto(id) NOT NULL,
	data_venda DATE NOT NULL,
	quantidade INT NOT NULL,
	valor_total FLOAT, -- nao precisa do not null porque o trigger ja adiciona
	nmr_parcela INT NOT NULL
);

CREATE TABLE parcelas(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	total_parcelas INT,
	valor_p_parcela DECIMAL(10,2),
	parcelas_pagas INT NOT NULL,
	data_parcela DATE NOT NULL,
);

CREATE TABLE Saldo(
	id_produto INT FOREIGN KEY REFERENCES Produto(id) NOT NULL,
	Saldo_produto DECIMAL NOT NULL
);

CREATE TABLE contas_receber(
    id_venda INT NOT NULL,
    nmr_parcela INT NOT NULL,
    data_vencimento DATE,
    valor_parcela MONEY NOT NULL,
    data_pagamento DATE NOT NULL
);

CREATE TABLE movimento(
	id INT PRIMARY KEY IDENTITY(1,1),
	id_produto INT NOT NULL,
	quantidade INT NOT NULL,
	tipo CHAR(1) NOT NULL CHECK(tipo in ('E', 'S')), -- CHECK é o equivalente ao enum do mysql que vimos em pw
	data_movimento DATE -- nao precisa de not null
);

CREATE TABLE feriados_fixos(
	data_feriado DATE NOT NULL,
	descricao VARCHAR(100) NOT NULL
);

CREATE TABLE feriados_do_ano(
	dataFeriado DATE PRIMARY KEY NOT NULL,
	descricao VARCHAR(100) NOT NULL
);