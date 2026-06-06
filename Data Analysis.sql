-- ===================================================
	-- First normalize the big table into small tables
-- ====================================================


-- =========================
-- CUSTOMERS
-- =========================

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);

-- =========================
-- LOCATIONS
-- =========================

CREATE TABLE locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50)
);

-- =========================
-- SHIPPING MODES
-- =========================

CREATE TABLE ship_modes (
    ship_mode_id INT PRIMARY KEY AUTO_INCREMENT,
    ship_mode VARCHAR(50)
);

-- =========================
-- CATEGORIES
-- =========================

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);

-- =========================
-- SUBCATEGORIES
-- =========================

CREATE TABLE subcategories (
    subcategory_id INT PRIMARY KEY AUTO_INCREMENT,
    subcategory_name VARCHAR(100),
    category_id INT,

    FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

-- =========================
-- PRODUCTS
-- =========================

CREATE TABLE products (
    product_id VARCHAR(30) PRIMARY KEY,
    product_name TEXT,
    subcategory_id INT,

    FOREIGN KEY (subcategory_id)
        REFERENCES subcategories(subcategory_id)
);

-- =========================
-- ORDERS
-- =========================

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    ship_date DATE,

    customer_id VARCHAR(20),
    ship_mode_id INT,
    location_id INT,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (ship_mode_id)
        REFERENCES ship_modes(ship_mode_id),

    FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
);

-- alter table order to add column shipping days

alter table orders add column shipping_days varchar(30);

-- =========================
-- ORDER ITEMS
-- =========================

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,

    order_id VARCHAR(50),
    product_id VARCHAR(30),

    quantity INT,
    sales DECIMAL(10,2),
    discount DECIMAL(10,2),
    profit DECIMAL(10,2),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- =====================================
	-- Insert data into small tables
-- =====================================

-- insert data into customers table

INSERT INTO customers (customer_id, customer_name, segment)
SELECT
    customer_id,
    MAX(customer_name),
    MAX(segment)
FROM super_store
GROUP BY customer_id;

-- insert data into locations table

insert into locations (city,state,postal_code,region)
SELECT DISTINCT
    city, state, postal_code, region
FROM
    super_store;
    
-- insert data into ship_mode table

select * from ship_modes;

insert into ship_modes(ship_mode)

SELECT DISTINCT
    ship_mode
FROM
    super_store;
    
select * from ship_modes;

-- insert data into categories table

insert into categories(category_name)

SELECT DISTINCT
    category
FROM
    super_store;
    
select * from categories;

-- insert data into subcategory table

INSERT INTO subcategories (subcategory_name, category_id)
SELECT DISTINCT
    s.sub_category, c.category_id
FROM
    super_store s
        JOIN
    categories c ON s.category = c.category_name;

-- insert data into products table 

INSERT INTO products (product_id, product_name, subcategory_id)

SELECT
    s.product_id,
    MAX(s.product_name) AS product_name,
    MAX(sc.subcategory_id) AS subcategory_id

FROM super_store s

JOIN subcategories sc
    ON s.sub_category = sc.subcategory_name

GROUP BY s.product_id;

-- insert data into orders table

INSERT INTO orders (
    order_id,
    order_date,
    ship_date,
    shipping_days,
    customer_id,
    ship_mode_id,
    location_id
)

SELECT
    s.order_id,
    MAX(s.order_date),
    MAX(s.ship_date),
    MAX(s.shiping_days),
    MAX(s.customer_id),
    MAX(sm.ship_mode_id),
    MAX(l.location_id)

FROM super_store s

JOIN ship_modes sm
    ON s.ship_mode = sm.ship_mode

JOIN locations l
    ON s.city = l.city
   AND s.state = l.state
   AND s.postal_code = l.postal_code
   AND s.region = l.region

GROUP BY s.order_id;

-- insert data into order_items

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    sales,
    discount,
    profit
)
SELECT
    s.order_id,
    s.product_id,
    SUM(s.quantity) AS quantity,
    SUM(CAST(s.sales AS DECIMAL(12,2))) AS sales,
    AVG(CAST(s.discount AS DECIMAL(10,4))) AS discount,
    SUM(CAST(s.profit AS DECIMAL(12,2))) AS profit
FROM super_store s
WHERE s.order_id IS NOT NULL
  AND s.product_id IS NOT NULL
GROUP BY
    s.order_id,
    s.product_id;

-- ===================================
	-- Now solve the business problems
-- ===================================

-- 1. Business Overview

-- What are the total sales, total profit, and profit margin of the business?
	
SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    (SUM(profit) * 100.0 / NULLIF(SUM(sales), 0)) AS profit_margin
FROM
    order_items;

-- How many orders are profitable vs loss-making?

SELECT 
    COUNT(order_id) AS loss_making_orders
FROM
    order_items
WHERE
    profit > 0;

SELECT 
    COUNT(order_id) AS loss_making_orders
FROM
    order_items
WHERE
    profit < 0;
    
-- profit_able orders

SELECT 
    COUNT(order_id) AS profit_able_orders
FROM
    order_items
WHERE
    profit > 0;

SELECT 
    COUNT(order_id) AS profit_able_orders
FROM
    order_items
WHERE
    profit > 0;
    


-- 2. Product Performance

-- Which products generate the highest sales?

select * from 

( select  product_id,sum(sales) as total_sales, dense_rank() over(order by sum(sales) desc ) as rnk

from order_items group by product_id) as t

where rnk = 1;

-- Which products generate the highest profit?

select * from 

( select  product_id,sum(profit) as total_profit, dense_rank() over(order by sum(profit) desc ) as rnk

from order_items group by product_id) as t

where rnk = 1;

-- Which products are causing losses?

SELECT 
    product_id, SUM(profit) AS total_profit
FROM
    order_items
GROUP BY product_id
HAVING SUM(profit) < 0;

-- Which products have high sales but low profit?

SELECT 
    p.product_name,
    SUM(oi.sales) AS total_sales,
    SUM(oi.profit) AS total_profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(oi.sales) > (
        SELECT AVG(product_sales)
        FROM (
            SELECT SUM(sales) AS product_sales
            FROM order_items
            GROUP BY product_id
        ) AS sales_data
    )
AND SUM(oi.profit) < (
        SELECT AVG(product_profit)
        FROM (
            SELECT SUM(profit) AS product_profit
            FROM order_items
            GROUP BY product_id
        ) AS profit_data
    )
ORDER BY total_sales DESC;

-- Category Analysis

-- Which categories and sub-categories are most profitable?

	SELECT 
    c.category_id,
    c.category_name,
    SUM(oi.profit) AS total_profit
FROM
    categories c
        LEFT JOIN
    subcategories sc ON c.category_id = sc.category_id
        LEFT JOIN
    products p ON sc.subcategory_id = p.subcategory_id
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY category_id , category_name
ORDER BY total_profit DESC limit 1;

-- Top subcateogy by profit

SELECT 
    sc.subcategory_id,
    sc.subcategory_name,
    SUM(oi.profit) AS total_profit
FROM
    subcategories sc
        LEFT JOIN
    products p ON sc.subcategory_id = p.subcategory_id
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY sc.subcategory_id , sc.subcategory_name
ORDER BY total_profit DESC limit 1;


-- Which categories or sub-categories are underperforming?

SELECT 
    sc.subcategory_id,
    sc.subcategory_name,
    SUM(oi.sales) AS total_sales,
    SUM(oi.profit) AS total_profit
FROM
    subcategories sc
        LEFT JOIN
    products p ON sc.subcategory_id = p.subcategory_id
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY sc.subcategory_id , sc.subcategory_name;

-- 4. Discount Analysis

-- What is the relationship between discount and profit?

SELECT 
    discount_category,
    SUM(sales) AS total_sale,
    SUM(profit) AS total_profit
FROM
    (SELECT 
        sales,
            profit,
            discount,
            CASE
                WHEN discount >= 0.50 THEN 'very high'
                WHEN discount >= 0.30 THEN 'high discount'
                WHEN discount >= 0.10 THEN 'medium discount'
                ELSE 'low'
            END AS discount_category
    FROM
        order_items) AS t
GROUP BY discount_category;

-- Which discount ranges lead to negative profit?

SELECT 
    discount_category,
    SUM(sales) AS total_sale,
    SUM(profit) AS total_profit
FROM
    (SELECT 
        sales,
            profit,
            discount,
            CASE
                WHEN discount >= 0.50 THEN 'very high'
                WHEN discount >= 0.30 THEN 'high discount'
                WHEN discount >= 0.10 THEN 'medium discount'
                ELSE 'low'
            END AS discount_category
    FROM
        order_items) AS t
GROUP BY discount_category having total_profit < 0;

-- Which products receive high discounts but remain unprofitable?

SELECT 
    product_id,
    AVG(discount) AS avg_discount,
    SUM(profit) AS total_profit
FROM order_items
GROUP BY product_id
HAVING AVG(discount) > 0.30
   AND SUM(profit) < 0;


-- 5. Regional Analysis

-- Which regions generate the highest and lowest profit?

-- highest profit

SELECT *
FROM (
    SELECT
        l.region,
        SUM(oi.profit) AS total_profit,
        DENSE_RANK() OVER (
            ORDER BY SUM(oi.profit) DESC
        ) AS rnk
    FROM locations l
    LEFT JOIN orders o
        ON l.location_id = o.location_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY l.region
) AS t
WHERE rnk = 1;

-- lowest profit

SELECT *
FROM (
    SELECT
        l.region,
        SUM(oi.profit) AS total_profit,
        DENSE_RANK() OVER (
            ORDER BY SUM(oi.profit)
        ) AS rnk
    FROM locations l
    LEFT JOIN orders o
        ON l.location_id = o.location_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY l.region
) AS t
WHERE rnk = 1;


-- Which regions have strong sales but weak profitability?
SELECT 
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM (
    SELECT 
        l.region,
        oi.sales,
        oi.profit
    FROM locations l
    JOIN orders o 
        ON l.location_id = o.location_id
    JOIN order_items oi 
        ON o.order_id = oi.order_id
) t
GROUP BY region
HAVING SUM(sales) > (
        SELECT AVG(region_sales)
        FROM (
            SELECT 
                l.region,
                SUM(oi.sales) AS region_sales
            FROM locations l
            JOIN orders o 
                ON l.location_id = o.location_id
            JOIN order_items oi 
                ON o.order_id = oi.order_id
            GROUP BY l.region
        ) x
    )
AND SUM(profit) < (
        SELECT AVG(region_profit)
        FROM (
            SELECT 
                l.region,
                SUM(oi.profit) AS region_profit
            FROM locations l
            JOIN orders o 
                ON l.location_id = o.location_id
            JOIN order_items oi 
                ON o.order_id = oi.order_id
            GROUP BY l.region
        ) y
    );

-- 6. Customer Segment Analysis

-- Which customer segments are the most profitable?

SELECT *
FROM (
    SELECT
        c.segment,
        SUM(oi.profit) AS total_profit,
        DENSE_RANK() OVER (
            ORDER BY SUM(oi.profit) DESC
        ) AS rnk
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.segment
) AS t
WHERE rnk = 1;


-- Which customer segments receive the highest discounts?

SELECT *
FROM (
    SELECT
        c.segment,
        AVG(oi.discount) AS avg_discount,
        DENSE_RANK() OVER (
            ORDER BY AVG(oi.discount) DESC
        ) AS rnk
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.segment
) AS t
WHERE rnk = 1;

-- 7. Shipping Analysis

-- How does shipping mode affect profit margins?

SELECT 
    s.ship_mode,
    SUM(oi.sales) AS total_sales,
    SUM(oi.profit) AS total_profit,
    (SUM(profit) * 100.0 / NULLIF(SUM(sales), 0)) AS profit_margin
FROM
    ship_modes s
        LEFT JOIN
    orders o ON s.ship_mode_id = o.ship_mode_id
        LEFT JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY s.ship_mode
ORDER BY profit_margin DESC;

-- 8. Order-Level Analysis

-- Which orders generate the highest losses?

SELECT 
    order_id,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM
    order_items
GROUP BY order_id
HAVING total_profit < 0
ORDER BY total_profit;
	

