/*
============================================================
                    NovaCart SQL Lab
                  SQL Questions Worksheet
============================================================

Student Name : ______________________________
Section      : ______________________________
ID           : __________________________________

Platform: Microsoft SQL Server / SSMS

Instructions:
1. Complete the database design and implementation before solving
   these questions.
2. Do not modify the database structure just to make a question easier.
3. Write your SQL solution directly below each question.
4. Use meaningful aliases and readable formatting.
5. All queries must execute successfully on your completed NovaCartDB.
6. Use the separate Hints PDF only when you are genuinely stuck.
7. Do not hard-code results that should be calculated from the data.

Database:
    NovaCartDB

============================================================
*/

USE NovaCartDB;
GO


/*============================================================
                MISSION 1 — CUSTOMER & PRODUCT OVERVIEW
============================================================*/

-- M1-Q1
-- Display all customers.

-- Your query: 
SELECT * FROM customers;

------------------------------------------------------------

-- M1-Q2
-- Display the product name, category, and current price
-- for every product.

-- Your query:
SELECT name, category, price FROM products;


------------------------------------------------------------

-- M1-Q3
-- Display products whose current price is greater than 5000.

-- Your query:
SELECT product_id, name, price FROM products 
WHERE price > 5000;


------------------------------------------------------------

-- M1-Q4
-- Display all customers ordered by join date, newest first.

-- Your query:
SELECT * FROM customers 
ORDER BY join_date DESC, customer_id DESC;


------------------------------------------------------------

-- M1-Q5
-- Display the total number of customers.

-- Your query:
SELECT COUNT(*) AS total_customers FROM customers;


/*============================================================
             MISSION 2 — AGGREGATION & BUSINESS TOTALS
============================================================*/

-- M2-Q1
-- Calculate the average current product price.

-- Your query:
SELECT format(AVG(price),'0') AS avg_product_price FROM products;


------------------------------------------------------------

-- M2-Q2
-- Display the highest and lowest current product prices.

-- Your query:
SELECT 
	format(MAX(price), '0') AS highest_price,
	format(MIN(price), '0') AS lowest_price
FROM products;


------------------------------------------------------------

-- M2-Q3
-- Calculate the total available stock quantity.

-- Your query:
SELECT SUM(stock_quantity) AS total_stock_quantity 
FROM products;


------------------------------------------------------------

-- M2-Q4
-- Calculate the total amount recorded in Payments.

-- Your query:
SELECT format(SUM(amount), '0') AS total_payment_amount 
FROM payments;


------------------------------------------------------------

-- M2-Q5
-- Display the number of orders for each order status.

-- Your query:
SELECT status, COUNT(*) AS numbers_of_orders 
FROM orders
GROUP BY status
ORDER BY numbers_of_orders DESC, status;

------------------------------------------------------------

-- M2-Q6
-- Display the total payment amount for each payment method.

-- Your query:
SELECT method, format(SUM(amount), '0') AS total_payment_amount
FROM payments
GROUP BY method
ORDER BY total_payment_amount DESC, method;

/*============================================================
               MISSION 3 — ORDER & SALES ANALYSIS
============================================================*/

-- M3-Q1
-- Calculate the total sales amount for each order.
-- Use quantity multiplied by the historical unit price.

-- Your query:
SELECT
    order_id,
    format(SUM(quantity * unit_price), '0') AS order_total 
FROM OrderDetails
GROUP BY order_id
ORDER BY order_id;


------------------------------------------------------------

-- M3-Q2
-- Display only orders whose total sales exceed 5000.

-- Your query:
SELECT
    order_id,
    format(SUM(quantity * unit_price), '0') AS order_total 
FROM OrderDetails
GROUP BY order_id
HAVING SUM(quantity * unit_price) > 5000
ORDER BY order_total DESC, order_id;



------------------------------------------------------------

-- M3-Q3
-- Display each order together with:
-- customer name, order date, and order status.

-- Your query:
SELECT 
	o.order_id,
	c.full_name,
	o.order_date,
	o.status
FROM orders AS o
JOIN customers AS c
	ON c.customer_id = o.customer_id
ORDER BY o.order_id;


------------------------------------------------------------

-- M3-Q4
-- Display each order with:
-- product name, purchased quantity, and historical unit price.

-- Your query:
SELECT
    o.order_id,
    p.name,
    od.quantity,
    od.unit_price,
    od.quantity * od.unit_price AS line_total
FROM orders AS o
JOIN OrderDetails AS od
    ON od.order_id = o.order_id
JOIN products AS p
    ON p.product_id = od.product_id
ORDER BY o.order_id, p.product_id;


------------------------------------------------------------

-- M3-Q5
-- Display the total amount spent by each customer.

-- Your query:
SELECT 
	c.customer_id,
	c.full_name,
	COALESCE(SUM(pay.amount),0) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o 
	ON o.customer_id = c.customer_id
LEFT JOIN payments AS pay 
	ON pay.order_id = o.order_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC, c.customer_id;

/*============================================================
              MISSION 4 — REVIEWS & RELATIONSHIPS
============================================================*/

-- M4-Q1
-- Display the number of reviews received by each product,
-- including products with no reviews.

-- Your query:
SELECT 
	p.product_id,
	p.name,
	COUNT(r.review_id) AS reviews_count
FROM products AS p
LEFT JOIN reviews AS r
	ON r.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY reviews_count DESC, p.product_id;



------------------------------------------------------------

-- M4-Q2
-- Display all reviews together with:
-- customer name and product name.

-- Your query:
SELECT 
    r.review_id,
    c.full_name,
    p.name,
    r.rating,
    r.comment,
    r.review_date
FROM reviews AS r
JOIN customers AS c 
	ON c.customer_id = r.customer_id 
JOIN products AS p 
	ON p.product_id = r.product_id
ORDER BY r.review_id;



------------------------------------------------------------

-- M4-Q3
-- Display customers who have placed at least one order.

-- Your query:
SELECT
	c.customer_id,
	c.full_name
FROM customers AS c
WHERE EXISTS(
	SELECT 1 FROM orders AS o
	WHERE o.customer_id = c.customer_id
);


------------------------------------------------------------

-- M4-Q4
-- Display products that have never been ordered.

-- Your query:
SELECT 
	p.product_id,
	p.name
FROM products AS p
WHERE NOT EXISTS(
	SELECT 1 FROM OrderDetails AS od
	WHERE od.product_id = p.product_id
);


------------------------------------------------------------

-- M4-Q5
-- Display products that have never received a review.

-- Your query:
SELECT
	p.product_id,
	p.name
FROM products AS p
WHERE NOT EXISTS(
	SELECT 1 FROM reviews AS r
	WHERE r.product_id = p.product_id
);


------------------------------------------------------------

-- M4-Q6
-- Display all customers and their number of orders,
-- including customers who have never placed an order.

-- Your query:
SELECT 
	c.customer_id,
	c.full_name,
    COUNT(o.order_id) AS order_count
FROM customers AS c 
LEFT JOIN orders AS o 
	ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY order_count DESC, c.customer_id;


/*============================================================
                       MISSION 5 — SUBQUERIES
============================================================*/

-- M5-Q1
-- Display customers who placed more orders than the average
-- number of orders among customers who placed at least one order.

-- Your query:
-- M5-Q1                                             (using AI)  msh fahem elso2al kolo yt3ml ezay 
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS order_count
FROM dbo.Customers AS c
JOIN dbo.Orders AS o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >
(
    SELECT AVG(CAST(x.order_count AS DECIMAL(12,2)))
    FROM
    (
        SELECT
            customer_id,
            COUNT(*) AS order_count
        FROM dbo.Orders
        GROUP BY customer_id
    ) AS x
)
ORDER BY order_count DESC, c.customer_id;


------------------------------------------------------------

-- M5-Q2
-- Display products whose current price is above the average
-- current product price.

-- Your query:
SELECT 
	product_id,
	name,
	price
FROM products
WHERE price > (
	SELECT AVG(price) FROM products
)
ORDER BY price DESC, product_id;


------------------------------------------------------------

-- M5-Q3
-- Display customers whose total spending is greater than
-- the average total spending among customers who have made
-- at least one payment.

-- Your query:
-- M5-Q3   
SELECT                                 -- (USING AI)  msh 3aref afham mn awl el (HAVING)
    c.customer_id,
    c.full_name,
    SUM(pay.amount) AS total_spent
FROM customers AS c
JOIN orders AS o
    ON o.customer_id = c.customer_id
JOIN dbo.payments AS pay
    ON pay.order_id = o.order_id
GROUP BY c.customer_id, c.full_name
HAVING SUM(pay.amount) >
(
    SELECT AVG(x.total_spent)
    FROM
    (
        SELECT
            o2.customer_id,
            SUM(pay2.amount) AS total_spent
        FROM dbo.Orders AS o2
        JOIN payments AS pay2
            ON pay2.order_id = o2.order_id
        GROUP BY o2.customer_id
    ) AS x
)
ORDER BY total_spent DESC, c.customer_id;


/*============================================================
                MISSION 6 — COMMON TABLE EXPRESSIONS
============================================================*/

-- M6-Q1
-- Using a CTE, calculate total revenue by month.

-- Your query:
-- M6-Q1: Monthly revenue from Payments.
WITH MonthlyRevenue AS(
    SELECT DATEFROMPARTS ( YEAR(payment_date), MONTH(payment_date), 1) AS revenue_month,
        SUM(amount) AS total_revenue
    FROM dbo.Payments
    GROUP BY DATEFROMPARTS (YEAR(payment_date), MONTH(payment_date), 1 )
)
SELECT revenue_month, total_revenue
FROM MonthlyRevenue
ORDER BY revenue_month;


-- M6-Q2: Customers spending more than 10000.
WITH CustomerSpending AS(
    SELECT
        c.customer_id,
        c.full_name,
        SUM(pay.amount) AS total_spent
    FROM dbo.Customers AS c
    JOIN dbo.Orders AS o
        ON o.customer_id = c.customer_id
    JOIN dbo.Payments AS pay
        ON pay.order_id = o.order_id
    GROUP BY c.customer_id, c.full_name
)
SELECT customer_id, full_name, total_spent
FROM CustomerSpending
WHERE total_spent > 10000
ORDER BY total_spent DESC, customer_id;


------------------------------------------------------------

-- M6-Q2
-- Using a CTE, calculate total spending by customer.
-- Return only customers whose total spending exceeds 10000.

-- Your query:



/*============================================================
                  MISSION 7 — WINDOW FUNCTIONS
============================================================*/

-- M7-Q1
-- Rank customers by total spending using RANK(),
-- with the highest spending ranked first.

-- Your query:
-- M7-Q1: Rank customers by spending.
;WITH CustomerSpending AS
(
    SELECT
        c.customer_id,
        c.full_name,
        COALESCE(SUM(pay.amount), 0) AS total_spent
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o
        ON o.customer_id = c.customer_id
    LEFT JOIN dbo.Payments AS pay
        ON pay.order_id = o.order_id
    GROUP BY c.customer_id, c.full_name
)
SELECT
    customer_id,
    full_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM CustomerSpending
ORDER BY spending_rank, customer_id;


-- M7-Q2: Rank products by quantity.
;WITH ProductQuantities AS
(
    SELECT
        p.product_id,
        p.product_name,
        COALESCE(SUM(od.quantity), 0) AS total_quantity_sold
    FROM dbo.Products AS p
    LEFT JOIN dbo.OrderDetails AS od
        ON od.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    total_quantity_sold,
    DENSE_RANK() OVER
    (
        ORDER BY total_quantity_sold DESC
    ) AS quantity_rank
FROM ProductQuantities
ORDER BY quantity_rank, product_id;


-- M7-Q3: Previous payment amount.
SELECT
    payment_id,
    order_id,
    payment_date,
    amount,
    LAG(amount) OVER
    (
        ORDER BY payment_date, payment_id
    ) AS previous_payment_amount
FROM dbo.Payments
ORDER BY payment_date, payment_id;


-- M7-Q4: Running payment total.
WITH CustomerSpending AS (
    SELECT
        c.customer_id,
        c.full_name,
        COALESCE(SUM(pay.amount), 0) AS total_spent
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o
        ON o.customer_id = c.customer_id
    LEFT JOIN dbo.Payments AS pay
        ON pay.order_id = o.order_id
    GROUP BY c.customer_id, c.full_name
)
SELECT
    customer_id,
    full_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM CustomerSpending
ORDER BY spending_rank, customer_id;


------------------------------------------------------------

-- M7-Q2
-- Rank products by total quantity sold using DENSE_RANK(),
-- with the highest quantity ranked first.

-- Your query:
WITH ProductQuantities AS (
    SELECT
        p.product_id,
        p.name,
        COALESCE(SUM(od.quantity), 0) AS total_quantity_sold
    FROM products AS p
    LEFT JOIN OrderDetails AS od
        ON od.product_id = p.product_id
    GROUP BY p.product_id, p.name
)
SELECT
    product_id,
    name,
    total_quantity_sold,
    DENSE_RANK() OVER
    (
        ORDER BY total_quantity_sold DESC
    ) AS quantity_rank
FROM ProductQuantities
ORDER BY quantity_rank, product_id;



------------------------------------------------------------

-- M7-Q3
-- Display each payment together with the previous payment amount
-- using LAG().
-- Order the sequence by payment date and payment ID.

-- Your query:
SELECT
    payment_id,
    order_id,
    payment_date,
    amount,
    LAG(amount) OVER
    (
        ORDER BY payment_date, payment_id
    ) AS previous_payment_amount
FROM dbo.Payments
ORDER BY payment_date, payment_id;


------------------------------------------------------------

-- M7-Q4
-- Display a running total of payment amounts.
-- Order the sequence by payment date and payment ID.

-- Your query:
SELECT
    payment_id,
    order_id,
    payment_date,
    amount,
    SUM(amount) OVER
    (
        ORDER BY payment_date, payment_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM dbo.Payments
ORDER BY payment_date, payment_id;


/*============================================================
                         MISSION 8 — VIEWS
============================================================*/

-- M8-Q1
-- Create a view named vw_revenue_by_month
-- that displays monthly revenue.

-- Your query:
CREATE VIEW dbo.vw_revenue_by_month
AS
SELECT
    DATEFROMPARTS
    (
        YEAR(payment_date),
        MONTH(payment_date),
        1
    ) AS revenue_month,

    SUM(amount) AS total_revenue
FROM payments
GROUP BY
    DATEFROMPARTS
    (
        YEAR(payment_date),
        MONTH(payment_date),
        1
    );
GO


------------------------------------------------------------

-- M8-Q2
-- Create a view named vw_best_selling_products
-- that displays:
--   Product Name
--   Total Quantity Sold
--   Total Revenue

-- Your query:
CREATE VIEW dbo.vw_best_selling_products
AS
SELECT
    p.product_id,
    p.name,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.quantity * od.unit_price) AS total_revenue
FROM products AS p
JOIN OrderDetails AS od
    ON od.product_id = p.product_id
GROUP BY p.product_id, p.name;
GO


------------------------------------------------------------

-- M8-Q3
-- Create a view named vw_customer_summary
-- that displays:
--   Customer Name
--   Number of Orders
--   Total Amount Spent

-- Your query:
CREATE VIEW dbo.vw_customer_summary
AS
SELECT
    c.customer_id,
    c.full_name,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    COALESCE(SUM(pay.amount), 0) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customer_id = c.customer_id
LEFT JOIN payments AS pay
    ON pay.order_id = o.order_id
GROUP BY c.customer_id, c.full_name;
GO


/*============================================================
                           END
============================================================*/
