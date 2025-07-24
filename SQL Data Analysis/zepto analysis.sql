drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC (8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
)

--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR 
mrp IS NULL
OR 
discountPercent IS NULL
OR 
discountedSellingPrice IS NULL
OR 
weightInGms IS NULL
OR 
availableQuantity IS NULL
OR 
outOfStock IS NULL
OR 
quantity IS NULL;

--different categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--products names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with prize = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto 
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0

SELECT mrp,discountedSellingPrice FROM zepto

--Q1. Find the top 10 best-value products based on the discounted percentage
SELECT DISTINCT name, mrp, discountPercent 
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2. What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC; 

--Q3. Calculate estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) as total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 and discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--Q5. Identify the top 5 categories offering the highest avereage discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;