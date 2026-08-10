-- E-commerce CLV & Inventory Analytics
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    signup_date DATE,
    region VARCHAR(30),
    acquisition_channel VARCHAR(40)
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(50),
    unit_cost DECIMAL(12,2),
    unit_price DECIMAL(12,2),
    reorder_point INT,
    lead_time_days INT
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE,
    product_id VARCHAR(20),
    quantity INT,
    discount_pct DECIMAL(5,2),
    payment_method VARCHAR(30),
    gross_sales DECIMAL(14,2),
    discount_amount DECIMAL(14,2),
    net_sales DECIMAL(14,2),
    cost DECIMAL(14,2),
    gross_profit DECIMAL(14,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE inventory_monthly (
    month DATE,
    product_id VARCHAR(20),
    opening_stock INT,
    units_sold INT,
    closing_stock INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
