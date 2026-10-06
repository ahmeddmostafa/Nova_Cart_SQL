USE NovaCartDB;
GO

-- 1. Customers
INSERT INTO dbo.customers
	(full_name, email, phone, address, join_date)
    VALUES
    ('Ahmed Mostafa', 'ahmed@example.com','01000000001', 'Cairo', '2024-01-05'),
    ('Sara Ali', 'sara@example.com','01000000002', 'Giza', '2024-01-12'),
    ('Omar Hassan', 'omar@example.com','01000000003', 'Alexandria', '2024-02-03'),
    ('Mona Adel', 'mona@example.com','01000000004', 'Mansoura', '2024-02-18'),
    ('Youssef Samir', 'youssef@example.com','01000000005', 'Tanta', '2024-03-07'),
    ('Nour Khaled', 'nour@example.com','01000000006', 'Cairo', '2024-03-22'),
    ('Karim Said', 'karim@example.com','01000000007', 'Giza', '2024-04-10'),
    ('Hana Mostafa', 'hana@example.com','01000000008', 'Ismailia', '2024-04-25'),
    ('Ali Mahmoud', 'ali@example.com','01000000009', 'Zagazig', '2024-05-14'),
    ('Mariam Tarek', 'mariam@example.com','01000000010', 'Port Said', '2024-06-01');

-- 2. Products
INSERT INTO dbo.products
	(name, category, price, stock_quantity)
    VALUES
    ('Laptop', 'Electronics', 30000, 12),
    ('Wireless Mouse', 'Accessories', 650, 80),
    ('Smartphone', 'Electronics', 18000, 25),
    ('Headphones', 'Electronics', 2200, 40),
    ('Jacket', 'Fashion', 1600, 35),
    ('Blender', 'Home Appliances', 3200, 20),
    ('SQL Book', 'Books', 450, 60),
    ('Backpack', 'Accessories', 900, 45),
    ('Coffee Maker', 'Home Appliances', 6500, 15),
    ('Desk Lamp', 'Home Appliances', 750, 30);

-- 3. Orders
INSERT INTO dbo.orders
	(customer_id, order_date, status)
    VALUES
    (1, '2025-01-05', 'Delivered'), -- Order 1
    (1, '2025-02-10', 'Delivered'), -- Order 2
    (2, '2025-01-12', 'Delivered'), -- Order 3
    (3, '2025-02-15', 'Delivered'), -- Order 4
    (4, '2025-03-03', 'Delivered'), -- Order 5
    (5, '2025-03-12', 'Delivered'), -- Order 6
    (6, '2025-04-02', 'Delivered'), -- Order 7
    (7, '2025-04-18', 'Delivered'), -- Order 8
    (8, '2025-05-05', 'Delivered'), -- Order 9
    (9, '2025-06-01', 'Pending'),   -- Order 10
    (9, '2025-06-03', 'Shipped'),   -- Order 11
    (3, '2025-05-20', 'Cancelled'); -- Order 12

-- 4. OrderDetails
-- unit_price stores the historical purchase price.
INSERT INTO dbo.OrderDetails
	(order_id, product_id, quantity, unit_price)
    VALUES
    (1, 1, 1, 28000),
    (1, 2, 2, 600),
    (2, 3, 1, 17000),
    (2, 7, 2, 400),
    (3, 4, 1, 2000),
    (4, 5, 2, 1500),
    (5, 6, 1, 3000),
    (6, 7, 3, 400),
    (7, 8, 1, 850),
    (8, 9, 1, 6000),
    (9, 1, 1, 29000),
    (10, 3, 1, 18000),
    (11, 2, 1, 650),
    (12, 4, 1, 2100);

-- 5. Payments
-- Insert one payment per order.
-- Calculate amount using quantity * historical unit_price.
INSERT INTO dbo.payments
	(order_id, payment_date, amount, method)
		SELECT o.order_id,
		DATEADD (DAY, CASE WHEN o.order_id IN (3, 6, 7) THEN 3 ELSE 0 END, o.order_date),
        SUM(od.quantity * od.unit_price),
        CASE
            WHEN o.order_id IN (3, 6, 7) THEN 'Cash on Delivery (COD)'
            WHEN o.order_id IN (2, 5, 8, 11) THEN 'PayPal'
            ELSE 'Credit Card'
        END
    FROM dbo.orders AS o
    INNER JOIN dbo.OrderDetails AS od
        ON od.order_id = o.order_id
    GROUP BY
        o.order_id,
        o.order_date;

-- 6. Reviews
-- Each reviewer purchased the product in a Delivered order.
INSERT INTO dbo.reviews
	(customer_id, product_id, rating, comment, review_date)
    VALUES
    (1, 1, 5, 'Excellent performance.', '2025-01-15'),
    (1, 2, 4, 'Comfortable to use.', '2025-01-15'),
    (1, 3, 4, 'Good battery life.', '2025-02-20'),
    (2, 4, 2, 'Sound quality could be better.', '2025-01-22'),
    (3, 5, 3, 'Average material quality.', '2025-02-25'),
    (4, 6, 5, 'Works very well.', '2025-03-13'),
    (5, 7, 5, 'Clear SQL examples.', '2025-03-22'),
    (6, 8, 1, 'The zipper broke quickly.', '2025-04-12'),
    (7, 9, 4, 'Good coffee quality.', '2025-04-28'),
    (8, 1, 5, NULL, '2025-05-15');
