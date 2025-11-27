-- =====================================================
-- PROJECT: E-Commerce Database Simulation
-- SUBMITTED BY: Heena Mehta                                                                             
-- =====================================================

-- =====================================================
-- STEP 1: DATABASE & TABLE DESIGN
-- =====================================================


-- =====================================================
-- USERS TABLE
-- Stores basic customer details
-- =====================================================


CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20),
  date_of_birth DATE,
  gender ENUM('male','female','non-binary','other') DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- CATEGORIES TABLE
-- Stores product categories and subcategories (self-referencing)
-- =====================================================


CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(150) NOT NULL UNIQUE,
  parent_category_id INT DEFAULT NULL,
  FOREIGN KEY (parent_category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);


-- =====================================================
-- PRODUCTS TABLE
-- Contains details of all products listed in the store
-- =====================================================


CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
  category_id INT DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);


-- =====================================================
-- ORDERS TABLE
-- Stores customer order details
-- =====================================================


CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM('pending','paid','shipped','delivered','cancelled','refunded') NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);


-- =====================================================
-- ORDER_ITEMS TABLE
-- Line items for each order (product, qty, price)
-- =====================================================


CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  price_at_purchase DECIMAL(10,2) NOT NULL CHECK (price_at_purchase >= 0),
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);

-- =====================================================
-- PAYMENTS TABLE
-- Records payments linked to orders
-- =====================================================
CREATE TABLE payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  amount DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
  payment_method ENUM('card','upi','netbanking','wallet','cod') NOT NULL,
  status ENUM('pending','completed','failed','refunded') NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);


-- =====================================================
-- REVIEWS TABLE
-- User reviews and ratings on products
-- =====================================================


CREATE TABLE reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT DEFAULT NULL,
  product_id INT DEFAULT NULL,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);


-- =====================================================
-- SHIPPING TABLE
-- Stores shipping information for each order
-- =====================================================


CREATE TABLE shipping (
  shipping_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  shipping_address TEXT NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL,
  pincode VARCHAR(20),
  shipped_date DATETIME DEFAULT NULL,
  delivered_date DATETIME DEFAULT NULL,
  shipping_status ENUM('preparing','shipped','in_transit','delivered','returned','cancelled') NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- =====================================================
-- STEP 2: POPULATE DATA
-- =====================================================

-- USERS
INSERT INTO users (name, email, phone, date_of_birth, gender, created_at) VALUES
('Asha Rao','asha@example.com','+91-9000011111','1990-04-15','female', NOW() - INTERVAL 10 DAY),
('Ravi Sharma','ravi.s@example.com','+91-9000022222','1985-08-20','male', NOW() - INTERVAL 45 DAY),
('Priya Singh','priya.s@example.com','+91-9000033333','1993-12-02','female', NOW() - INTERVAL 5 DAY),
('Mohit Verma','mohit.v@example.com','+91-9000044444','1998-06-11','male', NOW() - INTERVAL 70 DAY),
('Sneha Patel','sneha.p@example.com','+91-9000055555','1992-11-23','female', NOW() - INTERVAL 2 DAY),
('Arjun Iyer','arjun.i@example.com','+91-9000066666','1989-01-30','male', NOW() - INTERVAL 400 DAY),
('Tara Mehta','tara.m@example.com','+91-9000077777','1995-09-09','female', NOW() - INTERVAL 20 DAY),
('Karan Gupta','karan.g@example.com','+91-9000088888','1991-03-05','male', NOW() - INTERVAL 200 DAY),
('Neha Joshi','neha.j@example.com','+91-9000099999','1996-07-17','female', NOW() - INTERVAL 15 DAY),
('Vikram Sinha','vikram.s@example.com','+91-9000010000','1987-02-27','male', NOW() - INTERVAL 300 DAY);


-- CATEGORIES
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES
(1,'Electronics', NULL),
(2,'Mobiles', 1),
(3,'Laptops', 1),
(4,'Home Appliances', NULL),
(5,'Kitchen Appliances', 4),
(6,'Fashion', NULL),
(7,'Men Clothing', 6),
(8,'Women Clothing', 6),
(9,'Sports & Outdoors', NULL),
(10,'Fitness', 9),
(11,'Books', NULL),
(12,'Fiction', 11),
(13,'Non-Fiction', 11),
(14,'Beauty', NULL),
(15,'Skincare', 14);

-- PRODUCTS

INSERT INTO products (name, description, price, stock_quantity, category_id, created_at) VALUES
('SuperPhone X1','Flagship smartphone with 6.5\" OLED',49999.00, 50, 2, NOW() - INTERVAL 40 DAY),
('BudgetPhone A2','Affordable phone with good battery',8999.00, 120, 2, NOW() - INTERVAL 10 DAY),
('UltraBook Pro 14','Lightweight laptop, 16GB RAM',119999.00, 12, 3, NOW() - INTERVAL 80 DAY),
('Kitchen Mixer 500W','Multifunction mixer',5499.00, 30, 5, NOW() - INTERVAL 100 DAY),
('AirCooler 20L','Room air cooler',6999.00, 25, 4, NOW() - INTERVAL 70 DAY),
('Men T-Shirt Classic','Cotton T-shirt',799.00, 200, 7, NOW() - INTERVAL 5 DAY),
('Women Kurta Floral','Rayon kurta',1299.00, 80, 8, NOW() - INTERVAL 1 DAY),
('Yoga Mat Premium','Non-slip yoga mat',999.00, 150, 10, NOW() - INTERVAL 200 DAY),
('Dumbbell Set 10kg','Pair adjustable dumbbells',3499.00, 40, 10, NOW() - INTERVAL 15 DAY),
('Mystery Novel \"The Lost Path\"','Bestselling fiction',499.00, 300, 12, NOW() - INTERVAL 60 DAY),
('Self-Help \"Grow Everyday\"','Popular non-fiction',399.00, 250, 13, NOW() - INTERVAL 120 DAY),
('Face Serum','Vitamin C serum 30ml',899.00, 90, 15, NOW() - INTERVAL 2 DAY),
('Blender 700W','High-speed blender',6999.00, 18, 5, NOW() - INTERVAL 30 DAY),
('Gaming Mouse','Ergonomic RGB mouse',2499.00, 60, 1, NOW() - INTERVAL 22 DAY),
('Wireless Earbuds','Noise cancelling earbuds',4999.00, 70, 1, NOW() - INTERVAL 7 DAY),
('Laptop Stand','Adjustable laptop stand',1299.00, 300, 3, NOW() - INTERVAL 300 DAY),
('Chef Knife 8\"','Stainless steel chef knife',1499.00, 120, 5, NOW() - INTERVAL 40 DAY),
('Women Jeans Slim','Denim jeans',2199.00, 60, 8, NOW() - INTERVAL 25 DAY),
('Men Running Shoes','Lightweight running shoes',3499.00, 55, 6, NOW() - INTERVAL 3 DAY),
('USB-C Cable 1m','Fast charging cable',299.00, 500, 1, NOW() - INTERVAL 10 DAY),
('Smart Watch S','Fitness watch with heart-rate',8999.00, 35, 1, NOW() - INTERVAL 50 DAY),
('Air Fryer 4L','Oil-less fryer',8999.00, 20, 5, NOW() - INTERVAL 90 DAY),
('Sunscreen SPF50','Broad spectrum sunscreen',599.00, 150, 15, NOW() - INTERVAL 12 DAY),
('Notebook - Ruled','200 page ruled notebook',149.00, 1000, 11, NOW() - INTERVAL 365 DAY),
('Gaming Keyboard','Mechanical keyboard',4499.00, 40, 1, NOW() - INTERVAL 8 DAY),
('Wireless Charger','15W fast wireless charger',1999.00, 80, 1, NOW() - INTERVAL 18 DAY),
('Protein Powder 1kg','Whey protein supplement',2499.00, 75, 9, NOW() - INTERVAL 120 DAY),
('Makeup Kit Basic','Starter makeup kit',1299.00, 90, 14, NOW() - INTERVAL 15 DAY),
('Electric Kettle','1.7L stainless kettle',1999.00, 60, 5, NOW() - INTERVAL 45 DAY),
('Hardcover Cookbook','Chef recipes',699.00, 70, 11, NOW() - INTERVAL 10 DAY);

-- ORDERS

INSERT INTO orders (order_id, user_id, order_date, status, total_amount) VALUES
(1, 1, NOW() - INTERVAL 9 DAY, 'paid', 51998.00),
(2, 3, NOW() - INTERVAL 4 DAY, 'pending', 8999.00),
(3, 5, NOW() - INTERVAL 1 DAY, 'paid', 129999.00),
(4, 2, NOW() - INTERVAL 40 DAY, 'delivered', 1998.00),
(5, 7, NOW() - INTERVAL 18 DAY, 'refunded', 4398.00),
(6, 1, NOW() - INTERVAL 3 DAY, 'paid', 1598.00),
(7, 9, NOW() - INTERVAL 12 DAY, 'paid', 2499.00),
(8, 1, NOW() - INTERVAL 2 DAY, 'paid', 8999.00);

-- ORDER_ITEMS
INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 49999.00),
(1, 25, 1, 1999.00),
(2, 2, 1, 8999.00),
(3, 3, 1, 119999.00),
(3, 16, 1, 1299.00),
(4, 24, 2, 999.00),
(5, 15, 1, 4999.00),
(5, 20, 1, 299.00),
(6, 6, 2, 799.00),
(7, 9, 1, 3499.00),


-- PAYMENTS

INSERT INTO payments (order_id, payment_date, amount, payment_method, status) VALUES
(1, NOW() - INTERVAL 9 DAY, 51998.00, 'card', 'completed'),
(2, NOW() - INTERVAL 4 DAY, 0.00, 'upi', 'pending'),
(3, NOW() - INTERVAL 1 DAY, 129999.00, 'card', 'completed'),
(4, NOW() - INTERVAL 40 DAY, 1998.00, 'netbanking', 'completed'),
(5, NOW() - INTERVAL 18 DAY, 4398.00, 'wallet', 'refunded'),
(6, NOW() - INTERVAL 3 DAY, 1598.00, 'card', 'completed'),
(7, NOW() - INTERVAL 12 DAY, 2499.00, 'cod', 'completed'),
(8, NOW() - INTERVAL 2 DAY, 8999.00, 'upi', 'completed');

-- SHIPPING
INSERT INTO shipping (order_id, shipping_address, city, state, pincode, shipped_date, delivered_date, shipping_status) VALUES
(1, '12 Green Street, MG Road', 'Mumbai', 'Maharashtra', '400001', NOW() - INTERVAL 8 DAY, NOW() - INTERVAL 6 DAY, 'delivered'),
(2, '55 Lakeview Dr', 'Bengaluru', 'Karnataka','560001', NULL, NULL, 'preparing'),
(3, '8 Palm Avenue', 'Pune', 'Maharashtra','411001', NOW() - INTERVAL 12 HOUR, NULL, 'shipped'),
(4, '90 Beach Road', 'Chennai', 'Tamil Nadu', '600001', NOW() - INTERVAL 39 DAY, NOW() - INTERVAL 37 DAY, 'delivered'),
(5, '34 River Lane','Ahmedabad','Gujarat','380001', NOW() - INTERVAL 17 DAY, NOW() - INTERVAL 12 DAY, 'returned'),
(6, '12 Green Street, MG Road','Mumbai','Maharashtra','400001', NOW() - INTERVAL 2 DAY, NOW() - INTERVAL 1 DAY, 'delivered'),
(7, '12 Green Street, MG Road','Mumbai','Maharashtra','400001', NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 8 DAY, 'delivered'),
(8, '88 Parkside', 'Delhi','Delhi','110001', NOW() - INTERVAL 1 DAY, NULL, 'shipped');

-- REVIEWS

INSERT INTO reviews (user_id, product_id, rating, comment, review_date) VALUES
(1,1,5,'Amazing pForeign Keyshone, great camera!', NOW() - INTERVAL 7 DAY),
(3,2,4,'Good value for money', NOW() - INTERVAL 3 DAY),
(5,3,5,'Super fast laptop', NOW() - INTERVAL 1 DAY),
(2,24,3,'Comfortable but keys are loud', NOW() - INTERVAL 30 DAY),
(9,9,4,'Good quality dumbbells', NOW() - INTERVAL 11 DAY),
(7,11,5,'Very inspiring!', NOW() - INTERVAL 20 DAY),
(4,15,4,'Earbuds have great noise cancellation', NOW() - INTERVAL 5 DAY),
(1,25,5,'Wireless charger works well', NOW() - INTERVAL 7 DAY),
(6,6,4,'Nice t-shirt', NOW() - INTERVAL 3 DAY),
(3,12,2,'Story was slow', NOW() - INTERVAL 60 DAY);




-- =====================================================
-- STEP 3: SQL QUERY CHALLENGES WITH INTERPRETATION
-- =====================================================

-- 1️⃣ BASIC RETRIEVAL & FILTERING

-- List all users who signed up in the last 30 days

SELECT *
 FROM users
  WHERE created_at >= 
  NOW() - INTERVAL 30 DAY;

-- Find products with price > 1000 and in stock

SELECT product_id, 
name, price, stock_quantity
 FROM products 
 WHERE price > 1000
  AND stock_quantity > 0;

-- Sort orders by total_amount descending

SELECT * 
FROM orders 
ORDER BY total_amount DESC;



-- 2️⃣ AGGREGATION & GROUPING


-- Total sales per category

SELECT c.category_name, SUM(oi.quantity * oi.price_at_purchase) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- Average rating per product

SELECT p.name, AVG(r.rating) AS avg_rating
FROM reviews r
JOIN products p ON r.product_id = p.product_id
GROUP BY p.name;

-- Number of orders per user

SELECT u.name, COUNT(o.order_id) AS num_orders
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.name;


-- 3️⃣ JOINS


-- INNER JOIN users and orders

SELECT u.name, o.order_id, o.total_amount, o.status
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id;


-- LEFT JOIN products and reviews (to find products with no reviews)

SELECT p.product_id, p.name, r.review_id
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- SELF JOIN categories 

SELECT c1.category_name AS parent, c2.category_name AS child
FROM categories c1
JOIN categories c2 ON c1.category_id = c2.parent_category_id;



-- 4️⃣ SUBQUERIES


-- Find products priced higher than average of their category

SELECT name, price
FROM products p
WHERE price > (SELECT AVG(price) FROM products WHERE category_id = p.category_id);

-- List users with more than 1 order
SELECT u.name
FROM users u
WHERE u.user_id IN (
  SELECT user_id FROM orders GROUP BY user_id HAVING COUNT(*) > 1);


-- 5️⃣ CTE & VIEWS


-- CTE for monthly sales

WITH monthly_sales AS (
  SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS total
  FROM orders
  GROUP BY month)
SELECT * FROM monthly_sales;

-- View for top-selling products

CREATE OR REPLACE VIEW top_selling_products AS
SELECT p.name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC;


-- 6️⃣ FUNCTIONS


-- •	Use string functions to clean user emails.

SELECT name, SUBSTRING_INDEX(email,'@',-1) AS email_domain
FROM users;

-- •	Date functions to find orders shipped late

SELECT o.order_id, s.shipping_status, s.delivered_date
FROM orders o
JOIN shipping s ON o.order_id = s.order_id
WHERE s.delivered_date > s.shipped_date + INTERVAL 5 DAY;


-- Arithmetic: calculate 10% discount preview

SELECT name, price, price * 0.9 AS discounted_price
FROM products;


-- SECTION 7: CONSTRAINTS & TABLE DESIGN
-- =====================================================
-- This section explains the database integrity rules and normalization design choices.


-- =====================================================
-- 1. PRIMARY KEYS
-- =====================================================
-- Each table has a single column PRIMARY KEY to ensure entity integrity:
--   users.user_id
--   categories.category_id
--   products.product_id
--   orders.order_id
--   order_items.order_item_id
--   payments.payment_id
--   reviews.review_id
--   shipping.shipping_id
-- These ensure every row is uniquely identifiable and prevent duplicate records.

-- =====================================================
-- 2. FOREIGN KEYS
-- =====================================================
-- Relationships are maintained using FOREIGN KEY constraints:
--   orders.user_id            → users.user_id
--   order_items.order_id       → orders.order_id
--   order_items.product_id     → products.product_id
--   payments.order_id          → orders.order_id
--   reviews.user_id            → users.user_id
--   reviews.product_id         → products.product_id
--   shipping.order_id          → orders.order_id
--   categories.parent_category_id → categories.category_id
--
-- Referential actions used:
--   ON DELETE CASCADE  → removes dependent records when a parent record is deleted (e.g., orders → order_items)
--   ON DELETE SET NULL  → preserves history while removing references (e.g., reviews.user_id)
-- These maintain referential integrity across all relationships.

-- =====================================================
-- 3. UNIQUE CONSTRAINTS
-- =====================================================
-- To ensure uniqueness where required:
--   users.email UNIQUE                → prevents duplicate email registration
--   categories.category_name UNIQUE   → ensures distinct category names
--   payments.order_id UNIQUE          → one payment per order

-- =====================================================
-- 4. NOT NULL CONSTRAINTS
-- =====================================================
-- Applied to essential attributes:
--   products.name, products.price, products.stock_quantity
--   users.name, users.email
--   orders.user_id, orders.status, orders.total_amount
--   payments.amount, payments.payment_method, payments.status
-- These prevent incomplete or ambiguous records from being inserted.

-- =====================================================
-- 5. CHECK CONSTRAINTS
-- =====================================================
-- Used for data validation to maintain domain integrity:
--   products.price >= 0
--   products.stock_quantity >= 0
--   order_items.quantity > 0
--   reviews.rating BETWEEN 1 AND 5
--   gender IN ('male','female','non-binary','other') OR NULL
-- These prevent invalid or illogical data (e.g., negative price or invalid gender).
-- =====================================================
-- NORMALIZATION COMMENTS
-- =====================================================
-- 1NF: Each field holds atomic values (no repeating groups)
-- 2NF: Non-key attributes depend entirely on primary key (e.g., in orders, total_amount depends only on order_id)
-- 3NF: No transitive dependencies (e.g., user details are separated from orders)
-- BCNF: Every determinant is a candidate key (achieved except denormalized field total_quantity_sold)

-- Denormalization Explanation:
-- total_quantity_sold in products table stores derived info (sum of quantities sold)
-- This avoids repeated aggregation for performance optimization.

-- 7️⃣ PERFORMANCE & INDEXES

-- Example indexes for optimization

CREATE INDEX idx_orders_user_id ON orders(user_id);

CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- 8️⃣ TRANSACTION EXAMPLE (ORDER PLACEMENT)

-- Demonstrates ACID properties

START TRANSACTION;
  INSERT INTO orders (user_id, status, total_amount) VALUES (1,'pending',1999.00);
  SET @oid = LAST_INSERT_ID();
  INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES (@oid,2,1,1999.00);
  UPDATE products SET stock_quantity = stock_quantity - 1 WHERE product_id = 2;
  INSERT INTO payments (order_id, amount, payment_method, status) VALUES (@oid,1999.00,'upi','completed');
COMMIT;

-- =====================================================
-- END OF FILE
-- =====================================================
