-- Create Database
CREATE DATABASE FraudAnalytics;
GO

USE FraudAnalytics;
GO

--------------------------------------------------
-- Customers Table
--------------------------------------------------
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name VARCHAR(100),
    country VARCHAR(50)
);

--------------------------------------------------
-- Accounts Table
--------------------------------------------------
CREATE TABLE accounts (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(50),
    balance DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

--------------------------------------------------
-- Transactions Table
--------------------------------------------------
CREATE TABLE transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    amount DECIMAL(12,2),
    transaction_type VARCHAR(50),
    status VARCHAR(20), -- 'normal' or 'fraud'
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

--------------------------------------------------
-- Insert Customers
--------------------------------------------------
INSERT INTO customers (customer_name, country)
VALUES
('Alice', 'USA'),
('Bob', 'UK'),
('Charlie', 'India'),
('Diana', 'Canada'),
('Ethan', 'Australia');

--------------------------------------------------
-- Insert Accounts
--------------------------------------------------
INSERT INTO accounts (customer_id, account_type, balance)
VALUES
(1, 'Checking', 5000),
(2, 'Savings', 10000),
(3, 'Checking', 3000),
(4, 'Savings', 15000),
(5, 'Checking', 2000);

--------------------------------------------------
-- Insert Transactions
--------------------------------------------------
INSERT INTO transactions (account_id, transaction_date, amount, transaction_type, status)
VALUES
(1, GETDATE()-10, 200, 'Online Payment', 'normal'),
(1, GETDATE()-9, 5000, 'Wire Transfer', 'fraud'),
(2, GETDATE()-8, 100, 'Online Payment', 'normal'),
(2, GETDATE()-7, 8000, 'Wire Transfer', 'fraud'),
(3, GETDATE()-6, 50, 'POS Purchase', 'normal'),
(3, GETDATE()-5, 2500, 'Wire Transfer', 'fraud'),
(4, GETDATE()-4, 120, 'Online Payment', 'normal'),
(4, GETDATE()-3, 10000, 'Wire Transfer', 'fraud'),
(5, GETDATE()-2, 75, 'POS Purchase', 'normal'),
(5, GETDATE()-1, 1800, 'Wire Transfer', 'fraud');
