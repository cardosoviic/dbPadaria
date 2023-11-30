show databases;

create database dbPadariaVictoria;

use dbPadariaVictoria;

create table fornecedores (
idFornecedor int primary key auto_increment,
nomeFornecedor varchar(50) not null,
cnpjFornecedor varchar(20) not null,
telefoneFornecedor varchar(20),
emailFornecedor varchar (50) not null unique,
cep varchar (10),
enderecoFornecedor varchar(100),
numeroEndereco varchar(10),
bairro varchar(40),
cidade varchar(40),
estado char(2)
);

insert into fornecedores (nomeFornecedor, cnpjFornecedor, telefoneFornecedor, emailFornecedor, cep, enderecoFornecedor, numeroEndereco, bairro, cidade, estado) values
("Lucas Silva", "71.965.605/0001-65", "(11) 94933-8216", "lucassilva356@outlook.com", "04763-140", "Praça Jorge Veiga", "357", "Socorro", "São Paulo", "SP" );

select * from fornecedores;

create table produtos (
idProduto int primary key auto_increment,
nomeProduto varchar(50) not null, 
descricaoProduto text, 
precoProduto decimal (10,2) not null, 
estoqueProduto int not null,
categoriaProduto enum ("Pães", "Bolos", "Confeitaria", "Salgados"), 
idFornecedor int not null,
foreign key (idFornecedor) references fornecedores (idFornecedor)
);

alter table produtos add column validadeProduto date;
alter table produtos add column pesoProduto decimal (10,2);
alter table produtos add column ingredientesProduto text;

alter table produtos modify column validadeProduto date after pesoProduto;
alter table produtos modify column pesoProduto decimal (10,2) after precoProduto;
alter table produtos modify column ingredientesProduto text after nomeProduto;

describe produtos;

insert into produtos (nomeProduto, descricaoProduto, precoProduto, estoqueProduto, categoriaProduto, ingredientesProduto,  pesoProduto, validadeProduto, idFornecedor) values 
("Pão De Queijo", "É um pão macio por dentro com boa crocância por fora, proporcionada também pelo queijo parmesão que é polvilhado em cada um deles.", 4.00, 2, "Pães", "polvilho doce, leite, ovos, óleo, tempero ou sal a gosto, queijo minas meia cura", "0.20", "2023-11-16", 1);

insert into produtos (nomeProduto, descricaoProduto, precoProduto, estoqueProduto, categoriaProduto, ingredientesProduto, pesoProduto, validadeProduto, idFornecedor) values 
("Coxinha", "Massa cremosa a base de batata, superfície dourada e crocante, com o empanamento aderente à massa, recheio de peito de frango desfiado, com fragmentos de salsinha e cebolinha.", 12.50, 3, "Salgados", "Massa: água, caldo de galinha, sal, farinha de trigo, margarina e colorífico.  
Recheio: peito de frango, cebola, salsa, pimenta, alho, sal, colorífico, azeite", "0.50", "2023-11-17", 1);

insert into produtos (nomeProduto, ingredientesProduto, precoProduto, pesoProduto, estoqueProduto, categoriaProduto, validadeProduto, idFornecedor) values 
("Beijinho", "leite condensado, coco ralado", 1.00, "0.20", 120, "Confeitaria", "2023-11-17", 1);

insert into produtos (nomeProduto, ingredientesProduto, precoProduto, pesoProduto, estoqueProduto, categoriaProduto, validadeProduto, idFornecedor) values 
("Bolo De Cenoura", "Cenoura", 44.90, "1.2", 10, "Bolos", "2023-11-30", 1);

select * from produtos;

select * from produtos where categoriaProduto = "Pães";

select * from produtos where precoProduto < 50.00 order by precoProduto asc;

create table clientes (
idCliente int primary key auto_increment,
nomeCliente varchar(50),
cpfCliente varchar(15) not null unique,
telefoneCliente varchar(20),
emailCliente varchar (50) unique,
cep varchar (10),
enderecoCliente varchar(100),
numeroEndereco varchar(10),
bairro varchar(40),
cidade varchar(40),
estado char(2)
);

describe clientes;

insert into clientes (nomeCliente, cpfCliente, telefoneCliente, emailCliente, cep, enderecoCliente, numeroEndereco, bairro, cidade, estado) values 
("Alice Nascimento", "218.467.330-73", "(11) 97096-4673", "alicxnascimento2@gmail.com", "04101-000", "Rua Vergueiro", "4667", "Vila Mariana", "São Paulo", "SP");

select * from clientes;

create table pedidos (
idPedido int primary key auto_increment,
dataPedido timestamp default current_timestamp,
statusPedido enum("Pendente", "Finalizado", "Cancelado") not null,
idCliente int not null,
foreign key (idCliente) references clientes (idCliente)
);

insert into pedidos (statusPedido, idCliente) values ("Finalizado", 1);

select * from pedidos;
select * from pedidos inner join clientes on pedidos.idCliente = clientes.idCliente;

create table itensPedidos (
iditensPedido int primary key auto_increment, 
idPedido int not null,
idProduto int not null,
foreign key (idPedido) references pedidos(idPedido),
foreign key (idProduto) references produtos(idProduto),
quantidade int not null
);

select idPedido from pedidos;

insert into itensPedidos (idPedido, idProduto, quantidade) values (1, 3, 4);
insert into itensPedidos (idPedido, idProduto, quantidade) values (1, 4, 1);

select * from itensPedidos;

select clientes.nomeCliente, pedidos.idPedido, pedidos.dataPedido, itensPedidos.quantidade, produtos.nomeProduto, produtos.precoProduto
from clientes inner join pedidos on clientes.idCliente = pedidos.idCliente inner join
itensPedidos on pedidos.idPedido = itensPedidos.idPedido inner join 
produtos on produtos.idProduto = itensPedidos.idProduto; 

select sum(produtos.precoProduto * itensPedidos.quantidade) as Total from produtos inner join itensPedidos on produtos.idProduto = itensPedidos.idProduto where idPedido = 1;

/*ATIVIDADE: POSSÍVEIS FILTROS PARA PADARIA*/ 

/*Filtrar produtos (por exemplo, produtos com validade maior que a data atual */

select * from produtos where validadeProduto > curdate();

/* Filtrar produtos que contenham um ingrediente específico */

select * from produtos where ingredientesProduto like '%glúten%';

/*ATIVIDADE: FILTRAR PÃES QUE NÃO SEJAM FEITOS À BASE DE FARINHA DE TRIGO, COM VALOR ATÉ 7.90 */
/* QUERO UM RESULTADO AO MENOS!*/

select * from produtos where categoriaProduto = "Pães" or ingredientesProduto like '%farinha de trigo%' and precoProduto < 7.90 order by precoProduto asc;

update itensPedidos inner join produtos on itensPedidos.idProduto = produtos.idProduto
set produtos.estoqueProduto = produtos.estoqueProduto - itensPedidos.quantidade 
where itensPedidos.quantidade > 0;

select nomeProduto, estoqueProduto from produtos;