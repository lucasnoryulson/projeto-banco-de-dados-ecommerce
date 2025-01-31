# 📦 Projeto de Banco de Dados para E-commerce

## 📌 Descrição do Projeto
Este projeto implementa a modelagem e criação do banco de dados para um **sistema de e-commerce**, abrangendo desde o cadastro de clientes até a gestão de pedidos, pagamentos e entregas. A modelagem foi baseada em um **modelo lógico refinado**, garantindo **relacionamentos bem estruturados** e regras de integridade.

O banco de dados foi projetado para permitir:
- Cadastro de **Clientes** (PJ e PF);
- Registro de **Produtos**, **Fornecedores** e **Vendedores**;
- Controle de **Pedidos** e **Pagamentos**;
- Gerenciamento de **Estoque**;
- Acompanhamento de **Entregas com código de rastreamento**.

---

## 🏗 Estrutura do Banco de Dados
O banco de dados segue uma modelagem relacional com as seguintes tabelas principais:

### **📌 Tabelas Principais**
- **`clients`**: Armazena informações sobre clientes (CPF ou CNPJ, endereço, etc.).
- **`orders`**: Contém informações sobre os pedidos feitos pelos clientes.
- **`product`**: Cadastro de produtos disponíveis para compra.
- **`supplier`**: Registra os fornecedores que abastecem o e-commerce.
- **`seller`**: Representa terceiros que vendem produtos dentro da plataforma.
- **`payments`**: Formas de pagamento cadastradas pelos clientes.
- **`delivery`**: Informações sobre envio e rastreamento de pedidos.
- **`productStorage`**: Gerencia o estoque de produtos.

### **📌 Relacionamentos Importantes**
- **Pedido e Produto** possuem um relacionamento **M:N**, registrado na tabela **`productOrder`**.
- **Produto e Fornecedor** também têm um relacionamento **M:N**, representado em **`productSupplier`**.
- **Pedido e Entrega** têm uma relação **1:1**, onde cada pedido tem uma única entrega associada.

---

## 🛠 Tecnologias Utilizadas
- **MySQL** como Sistema Gerenciador de Banco de Dados (SGBD);
- **SQL** para criação das tabelas e consultas;
- **Workbench** (ou DBeaver) para visualização do modelo.

---

## 🔍 Queries Implementadas
Além da estrutura do banco, foram desenvolvidas consultas para análise de dados:

1. **Número de pedidos por cliente**:
   ```sql
   SELECT idOrderClient, COUNT(idOrder) AS total_pedidos
   FROM orders
   GROUP BY idOrderClient;
   ```
2. **Vendedores que também são fornecedores**:
   ```sql
   SELECT s.SocialName AS NomeVendedor, sup.SocialName AS NomeFornecedor
   FROM seller s
   INNER JOIN supplier sup ON s.CNPJ = sup.CNPJ OR s.CPF = sup.CNPJ;
   ```
3. **Produtos fornecidos e seus fornecedores**:
   ```sql
   SELECT p.Pname, sup.SocialName AS Fornecedor, ps.quantity AS Quantidade
   FROM product p
   JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
   JOIN supplier sup ON ps.idPsSupplier = sup.idSupplier;
   ```
4. **Status das entregas e rastreamento**:
   ```sql
   SELECT o.idOrder, d.trackingCode, d.status
   FROM orders o
   LEFT JOIN delivery d ON o.idOrder = d.idOrder;
   ```

---

## 📂 Como Utilizar
1. **Criar o Banco de Dados**
   ```sql
   CREATE DATABASE ecommerce;
   USE ecommerce;
   ```
2. **Executar o Script SQL** (disponível neste repositório) para criação das tabelas.
3. **Popular o banco com dados de exemplo**.
4. **Executar as consultas para análise dos dados.**

---

## 📢 Contribuições
Se quiser contribuir com melhorias, faça um **fork** deste repositório, crie uma **branch** com as alterações e envie um **Pull Request**! 🚀

---

## 📜 Licença
Este projeto é de livre uso para aprendizado e pode ser modificado conforme necessário.

