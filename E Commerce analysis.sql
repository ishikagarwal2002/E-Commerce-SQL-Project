--Imported data from csv files and saved under table names- customers and baskets

-- Check what tables exist
SELECT name FROM sqlite_master WHERE type='table';

-- Count rows in each table
SELECT 'customers' as Table_Name, COUNT(*) as Total_Rows FROM customers
UNION ALL
SELECT 'baskets', COUNT(*) FROM baskets;

-- Preview data
SELECT * FROM customers LIMIT 5;
SELECT * FROM baskets LIMIT 5;

-- Check for missing data
SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) as missing_customer_ids,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) as missing_product_ids
FROM baskets;

-- Add proper date column
ALTER TABLE baskets ADD COLUMN purchase_date TEXT;

-- Convert DD-MM-YYYY to YYYY-MM-DD
UPDATE baskets 
SET purchase_date = SUBSTR(basket_date, 7, 4) || '-' || 
                   SUBSTR(basket_date, 4, 2) || '-' || 
                   SUBSTR(basket_date, 1, 2);

-- Verify date conversion
SELECT basket_date, purchase_date FROM baskets LIMIT 10;


--Q1. How many customers do you have?

SELECT COUNT(*) as total_customers FROM customers;

--Q2. What's the most popular product?

SELECT 
    product_id,
    SUM(basket_count) as total_sold
FROM baskets
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 1;

--Q3. What are your top 5 products?

SELECT 
    product_id,
    SUM(basket_count) as total_sold
FROM baskets
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 5;

-- Q4. Which day had the most sales?

SELECT 
    basket_date,
    SUM(basket_count) as items_sold
FROM baskets
GROUP BY basket_date
ORDER BY items_sold DESC
LIMIT 1;

--Q5. How many customers never bought anything?

SELECT COUNT(*) as inactive_customers
FROM customers c
LEFT JOIN baskets b ON c.customer_id = b.customer_id
WHERE b.customer_id IS NULL;

--Q6. Which age group has the most customers?

SELECT 
    CASE 
        WHEN customer_age <= 25 THEN '18-25'
        WHEN customer_age <= 35 THEN '26-35'
        WHEN customer_age <= 50 THEN '36-50'
        WHEN customer_age <= 65 THEN '51-65'
        ELSE '65+'
    END as age_group,
    COUNT(*) as customer_count
FROM customers
WHERE customer_age < 100
GROUP BY age_group
ORDER BY customer_count DESC;

--Q7. How many transactions per day on average?

SELECT 
    ROUND(AVG(daily_transactions), 1) as avg_transactions_per_day
FROM (
    SELECT basket_date, COUNT(*) as daily_transactions
    FROM baskets
    GROUP BY basket_date
);

--Q8. What is the most common basket size?

SELECT 
    basket_count,
    COUNT(*) as frequency
FROM baskets
GROUP BY basket_count
ORDER BY frequency DESC
LIMIT 5;

--Q9. What's the longest tenure customer?

SELECT 
    customer_id,
    tenure,
    customer_age,
    sex
FROM customers
ORDER BY tenure DESC
LIMIT 5;

--Q10. What's the average age of your customers?

SELECT AVG(customer_age) as average_age FROM customers 
WHERE customer_age < 100; 