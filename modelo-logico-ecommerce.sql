-- Criacao do banco de dados para o cenário de E-commerce
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Criacao da tabela Cliente (Dividindo entre Pessoa Física e Jurídica)
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Minit CHAR(3),
    Lname VARCHAR(50),
    CPF CHAR(11) UNIQUE,
    CNPJ CHAR(14) UNIQUE,
    Address VARCHAR(255) NOT NULL,
    CHECK ((CPF IS NOT NULL AND CNPJ IS NULL) OR (CNPJ IS NOT NULL AND CPF IS NULL))
);

-- Criacao da tabela Produto
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(255) NOT NULL,
    classification_kids BOOL DEFAULT FALSE,
    category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') NOT NULL,
    avaliação FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- Criacao da tabela Estoque
CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255) NOT NULL,
    quantity INT DEFAULT 0
);

-- Criacao da tabela Fornecedor
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) UNIQUE NOT NULL,
    contact CHAR(11) NOT NULL
);

-- Criacao da tabela Vendedor
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(14) UNIQUE,
    CPF CHAR(11) UNIQUE,
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CHECK ((CPF IS NOT NULL AND CNPJ IS NULL) OR (CNPJ IS NOT NULL AND CPF IS NULL))
);

-- Criacao da tabela Pagamentos (Relacionamento M:N Cliente-Pagamento)
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    typePayment ENUM('Boleto','Cartão','Dois cartões') NOT NULL,
    limitAvailable FLOAT NOT NULL,
    FOREIGN KEY (idClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Criacao da tabela Pedidos
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT NOT NULL,
    orderStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idOrderClient) REFERENCES clients(idClient) ON UPDATE CASCADE
);

-- Criacao da tabela Entrega (com código de rastreio)
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    trackingCode VARCHAR(50) UNIQUE NOT NULL,
    status ENUM('Em transporte', 'Entregue', 'Pendente') DEFAULT 'Pendente',
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder) ON DELETE CASCADE
);

-- Relacionamento M:N entre Produto e Vendedor
CREATE TABLE productSeller (
    idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

-- Relacionamento M:N entre Produto e Pedido
CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

-- Relacionamento M:N entre Produto e Estoque
CREATE TABLE storageLocation (
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);

-- Relacionamento M:N entre Produto e Fornecedor
CREATE TABLE productSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

-- Queries para análise de dados

-- Quantos pedidos foram feitos por cada cliente?
SELECT idOrderClient, COUNT(idOrder) AS total_pedidos
FROM orders
GROUP BY idOrderClient;

-- Algum vendedor também é fornecedor?
SELECT s.SocialName AS NomeVendedor, sup.SocialName AS NomeFornecedor
FROM seller s
INNER JOIN supplier sup ON s.CNPJ = sup.CNPJ OR s.CPF = sup.CNPJ;

-- Relação de produtos, fornecedores e estoques
SELECT p.Pname, sup.SocialName AS Fornecedor, ps.quantity AS Quantidade
FROM product p
JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
JOIN supplier sup ON ps.idPsSupplier = sup.idSupplier;

-- Relação de nomes dos fornecedores e nomes dos produtos fornecidos
SELECT DISTINCT sup.SocialName, p.Pname
FROM supplier sup
JOIN productSupplier ps ON sup.idSupplier = ps.idPsSupplier
JOIN product p ON ps.idPsProduct = p.idProduct;

-- Relação de clientes e suas formas de pagamento
SELECT c.Fname, c.Lname, p.typePayment, p.limitAvailable
FROM clients c
JOIN payments p ON c.idClient = p.idClient;

-- Relação de pedidos e status de entrega
SELECT o.idOrder, d.trackingCode, d.status
FROM orders o
LEFT JOIN delivery d ON o.idOrder = d.idOrder;
