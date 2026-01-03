USE FraudAnalytics;
GO

--------------------------------------------------
-- 1. Total transactions
--------------------------------------------------
SELECT COUNT(transaction_id) AS total_transactions
FROM transactions;

--------------------------------------------------
-- 2. Total fraudulent transactions
--------------------------------------------------
SELECT COUNT(transaction_id) AS total_fraud
FROM transactions
WHERE status = 'fraud';

--------------------------------------------------
-- 3. Fraud percentage
--------------------------------------------------
SELECT 
    (CAST(SUM(CASE WHEN status='fraud' THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*))*100 AS fraud_percentage
FROM transactions;

--------------------------------------------------
-- 4. Total amount of fraud transactions
--------------------------------------------------
SELECT SUM(amount) AS total_fraud_amount
FROM transactions
WHERE status = 'fraud';

--------------------------------------------------
-- 5. Fraud transactions per account
--------------------------------------------------
SELECT a.account_id,
       COUNT(t.transaction_id) AS fraud_count
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.status='fraud'
GROUP BY a.account_id
ORDER BY fraud_count DESC;

--------------------------------------------------
-- 6. Fraud transactions per customer
--------------------------------------------------
SELECT c.customer_name,
       COUNT(t.transaction_id) AS fraud_count
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.status='fraud'
GROUP BY c.customer_name
ORDER BY fraud_count DESC;

--------------------------------------------------
-- 7. Top fraudulent transactions by amount
--------------------------------------------------
SELECT t.transaction_id,
       a.account_id,
       t.amount
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.status='fraud'
ORDER BY t.amount DESC;

--------------------------------------------------
-- 8. Fraud by transaction type
--------------------------------------------------
SELECT transaction_type,
       COUNT(transaction_id) AS fraud_count
FROM transactions
WHERE status='fraud'
GROUP BY transaction_type
ORDER BY fraud_count DESC;

--------------------------------------------------
-- 9. Daily fraud trend
--------------------------------------------------
SELECT transaction_date,
       COUNT(transaction_id) AS fraud_count
FROM transactions
WHERE status='fraud'
GROUP BY transaction_date
ORDER BY transaction_date;

--------------------------------------------------
-- 10. Accounts with multiple frauds
--------------------------------------------------
SELECT a.account_id,
       COUNT(t.transaction_id) AS fraud_count
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.status='fraud'
GROUP BY a.account_id
HAVING COUNT(t.transaction_id) > 1
ORDER BY fraud_count DESC;

--------------------------------------------------
-- 11. Customer-wise total transaction amount
--------------------------------------------------
SELECT c.customer_name,
       SUM(t.amount) AS total_amount
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_amount DESC;

--------------------------------------------------
-- 12. Customer-wise total fraud amount
--------------------------------------------------
SELECT c.customer_name,
       SUM(t.amount) AS total_fraud_amount
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.status='fraud'
GROUP BY c.customer_name
ORDER BY total_fraud_amount DESC;

--------------------------------------------------
-- 13. Fraud ratio per customer
--------------------------------------------------
SELECT c.customer_name,
       CAST(SUM(CASE WHEN t.status='fraud' THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*) AS fraud_ratio
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY fraud_ratio DESC;

--------------------------------------------------
-- 14. Transactions by account type
--------------------------------------------------
SELECT a.account_type,
       COUNT(t.transaction_id) AS total_transactions
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
GROUP BY a.account_type;

--------------------------------------------------
-- 15. Fraud by account type
--------------------------------------------------
SELECT a.account_type,
       COUNT(t.transaction_id) AS fraud_count
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.status='fraud'
GROUP BY a.account_type
ORDER BY fraud_count DESC;

--------------------------------------------------
-- 16. Highest fraud transaction per customer
--------------------------------------------------
WITH ranked_transactions AS (
    SELECT c.customer_name,
           t.transaction_id,
           t.amount,
           RANK() OVER(PARTITION BY c.customer_name ORDER BY t.amount DESC) AS rnk
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    JOIN customers c ON a.customer_id = c.customer_id
    WHERE t.status='fraud'
)
SELECT customer_name, transaction_id, amount
FROM ranked_transactions
WHERE rnk = 1;

--------------------------------------------------
-- 17. Top customers by total transaction amount
--------------------------------------------------
SELECT TOP 5 c.customer_name,
       SUM(t.amount) AS total_amount
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_amount DESC;

--------------------------------------------------
-- 18. Transactions above 1000 amount
--------------------------------------------------
SELECT transaction_id, account_id, amount, status
FROM transactions
WHERE amount > 1000
ORDER BY amount DESC;

--------------------------------------------------
-- 19. Fraud transactions above 5000
--------------------------------------------------
SELECT transaction_id, account_id, amount
FROM transactions
WHERE status='fraud' AND amount > 5000
ORDER BY amount DESC;

--------------------------------------------------
-- 20. Fraud percentage per account
--------------------------------------------------
SELECT a.account_id,
       CAST(SUM(CASE WHEN t.status='fraud' THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*)*100 AS fraud_percentage
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
GROUP BY a.account_id
ORDER BY fraud_percentage DESC;
