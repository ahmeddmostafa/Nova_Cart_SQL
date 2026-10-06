USE NovaCartDB;
GO

CREATE TABLE customers(
	customer_id INT IDENTITY(1,1) CONSTRAINT PK_customers PRIMARY KEY,
	full_name NVARCHAR(100) NOT NULL,
	email NVARCHAR(254) CONSTRAINT UQ_Customers_Email UNIQUE,
	phone NVARCHAR(25) NOT NULL,
    address NVARCHAR(250) NOT NULL,
    join_date DATE NOT NULL
);

CREATE TABLE products (
	product_id INT IDENTITY(1,1) CONSTRAINT PK_Products PRIMARY KEY,
    name NVARCHAR(150) NOT NULL,
    category NVARCHAR(50) NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    stock_quantity INT NOT NULL,

    CONSTRAINT CK_Products_Price CHECK (price > 0),
    CONSTRAINT CK_Products_Stock CHECK (stock_quantity >= 0)
);

CREATE TABLE orders(
	order_id INT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status NVARCHAR(15) NOT NULL,

    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id)
        REFERENCES dbo.Customers(customer_id),
    CONSTRAINT CK_Orders_Status CHECK
        (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE OrderDetails(
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_OrderDetails PRIMARY KEY (order_id, product_id),

    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT CK_OrderDetails_Quantity CHECK (quantity > 0),
    CONSTRAINT CK_OrderDetails_Price CHECK (unit_price > 0)
);

CREATE TABLE payments(
    payment_id INT IDENTITY(1,1) CONSTRAINT PK_Payments PRIMARY KEY,
    order_id INT NOT NULL CONSTRAINT UQ_payments_order UNIQUE,
    payment_date DATE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    method NVARCHAR(30) NOT NULL,
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT CK_Payments_Amount CHECK (amount >= 0),
    CONSTRAINT CK_Payments_Method CHECK
        (method IN ('Credit Card', 'PayPal', 'Cash on Delivery (COD)'))
);

CREATE TABLE reviews(
    review_id INT IDENTITY(1,1) CONSTRAINT PK_reviews PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating TINYINT NOT NULL,
    comment NVARCHAR(1000) NULL,
    review_date DATE NOT NULL,
    CONSTRAINT FK_Reviews_Customers FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    CONSTRAINT FK_Reviews_Products FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CONSTRAINT CK_Reviews_Rating CHECK (rating BETWEEN 1 AND 5)
);
