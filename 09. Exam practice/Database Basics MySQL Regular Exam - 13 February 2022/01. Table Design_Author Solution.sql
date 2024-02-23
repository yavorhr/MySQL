    CREATE SCHEMA `online_store`;
Use `online_store`;

CREATE TABLE `customers`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `phone` VARCHAR(30) NOT NULL UNIQUE,
    `address` VARCHAR(60) NOT NULL,
    `discount_card` BIT NOT NULL DEFAULT 0
);

CREATE TABLE `orders`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `order_datetime` DATETIME NOT NULL,
    `customer_id` INT NOT NULL,
    CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`)
    REFERENCES `customers` (`id`)
);

CREATE TABLE `reviews`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `content` TEXT,
    `rating` DECIMAL(10, 2) NOT NULL,
    `picture_url` VARCHAR(80)    NOT NULL,
    `published_at` DATETIME NOT NULL
);

CREATE TABLE `brands`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `categories`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `products`(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40)    NOT NULL,
    `price` DECIMAL(19, 2) NOT NULL,
    `quantity_in_stock` INT,
    `description` TEXT,
    `brand_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    `review_id` INT,
    CONSTRAINT `fk_products_brands` FOREIGN KEY (`brand_id`)
        REFERENCES `brands` (`id`),
    CONSTRAINT `fk_products_reviews` FOREIGN KEY (`review_id`)
        REFERENCES `reviews` (`id`),
    CONSTRAINT `fk_products_categories` FOREIGN KEY (`category_id`)
        references `categories` (`id`)
);

CREATE TABLE `orders_products`(
     `order_id` INT,
     `product_id` INT,
     KEY `pk_orders_products`(`order_id`,`product_id`),
     CONSTRAINT `fk_orders_product_orders` FOREIGN KEY(`order_id`)
         REFERENCES `orders`(`id`),
     CONSTRAINT `fk_orders_products_products` FOREIGN KEY(`product_id`)
         REFERENCES `products`(`id`)
);



#     02.	Insert
# You will have to insert records of data into the reviews table, based on the products table.
# For products with id equal or greater than 5, insert data in the reviews table with the following values:
# •	content – set it to the first 15 characters from the description of the product.
# •	picture_url – set it to the product's name but reversed.
# •	published_at – set it to 10-10-2010.
# •	rating – set it to the price of the product divided by 8.

INSERT INTO reviews (content, picture_url, published_at, rating)
SELECT LEFT(p.description, 15), reverse(p.name), DATE('2010/10/10'), p.price / 8
FROM products p
WHERE p.id >= 5;

# 03.	Update
# Reduce all products quantity by 5 for products with quantity greater than 60 and less than 70 (inclusive).

UPDATE products p
SET p.quantity_in_stock = p.quantity_in_stock - 5
WHERE p.quantity_in_stock BETWEEN 60 AND 70;

# 04.	Data Deletion
# REMOVE all customers, who didn't order anything.

DELETE c FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.customer_id IS NULL;

-- Section 3 --

# 5.	Categories
# Extract from the online_store system database, info about the name of categories.
# Order the results by category_name in descending order;
# Required Column: category_name

SELECT * from categories c
ORDER BY c.name desc;

# 6: Querying - Quantity
-- Write a query that returns: product_id, brand_id, name, quantity
-- from table products. Filter products which price is higher than
-- 1000 and their quantity is lower thant 30.

SELECT p.id, p.brand_id, p.name, p.quantity_in_stock
FROM products p
WHERE p.price > 1000 AND p.quantity_in_stock < 30
ORDER BY p.quantity_in_stock, p.id;

# 7: Review  
-- Write a query that returns: content, picture_url, published_at, rating
-- for all reviews which content starts with ‘My’ and the characters of the content are more than 61 symbols.
-- Sort by rating in ascending order.

SELECT * FROM reviews r
WHERE (SELECT r.content LIKE 'My%') AND LENGTH(r.content) > 61
ORDER BY r.rating DESC ;

# 8.	First customers
# There are many customers in our shop system, but we need to find only those who are clients from the beginning of the online store creation.
# Extract from the database, the full name of employee, the address, and the date of order. The year must be lower or equal to 2018.

SELECT CONCAT(c.first_name, ' ', c.last_name) as 'full_name', c.address, o.order_datetime
FROM customers c JOIN orders o ON c.id = o.customer_id
WHERE YEAR(o.order_datetime) <= 2018
ORDER BY full_name DESC ;

# 9. Best categories
-- Extract from the database, the top 5 categories.
-- ORDER the results descending by items count, then by total_quantity in ascending.
-- Required Columns: 'items_count' (number of items in this category), category_name, 'total_quantity' (sum of all items in this category)

SELECT COUNT(c.id) as 'items_count', c.name, sum(p.quantity_in_stock) as 'total_quantity'
FROM products p
         JOIN categories c on c.id = p.category_id
GROUP BY c.id
ORDER BY `items_count` desc, total_quantity ASC
LIMIT 5;

#10. Extract total count of items ordered

DELIMITER $$
CREATE FUNCTION udf_customer_products_count(name VARCHAR(30))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE products_count INT;
    SET products_count := (
        SELECT COUNT(c.id) FROM customers c
        JOIN orders o on c.id = o.customer_id
        JOIN orders_products op on o.id = op.order_id
        WHERE c.first_name = name);
    RETURN products_count;
end $$
DELIMITER ;

SELECT c.first_name, c.last_name, udf_customer_products_count('Shirley') as `total_products` FROM customers c
WHERE c.first_name = 'Shirley';

#11. Reduce price
# Reduce the price by 30% of all items which have reviews with rating less than 4 and are from the given category.

DELIMITER $$
CREATE PROCEDURE `udp_reduce_price`(`category_name` VARCHAR(50))
BEGIN
    UPDATE products p
        join reviews r on r.id = p.review_id
        JOIN categories c on c.id = p.category_id
    SET p.price = price * 0.70
    WHERE c.name = category_name
      AND r.rating < 4;
END $$
DELIMITER ;

CALL udp_reduce_price('Phones and tablets');


