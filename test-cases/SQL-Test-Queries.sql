-- ============================================================================
-- SQL Test Queries - P5 Database SQL Testing Project
-- ============================================================================
-- Project: P5 - Database SQL Testing
-- Author: Artur Dmytriyev
-- Database: MySQL 8.0.45 - sakila
-- Date: February 2026
-- Description: All SQL queries used during testing execution
-- ============================================================================

-- ============================================================================
-- BLOCK 1: BASIC DATA VALIDATION (5 Test Cases)
-- ============================================================================

-- TC-001: Verify Actor Table Data Retrieval
-- Purpose: Validate basic SELECT query and data accessibility
SELECT actor_id, first_name, last_name 
FROM actor 
LIMIT 10;

-- TC-002: Count Total Films in Database
-- Purpose: Verify aggregate COUNT function
SELECT COUNT(*) as total_films 
FROM film;

-- TC-003: Verify Rental Date Format
-- Purpose: Validate datetime format and NULL handling
SELECT rental_id, rental_date, return_date 
FROM rental 
LIMIT 10;

-- TC-004: Validate Payment Amounts Are Positive
-- Purpose: Test WHERE clause and business rule validation
SELECT payment_id, amount, payment_date 
FROM payment 
WHERE amount > 0 
LIMIT 10;

-- TC-005: Verify Customer Email Format
-- Purpose: Validate data format consistency
SELECT customer_id, email 
FROM customer 
LIMIT 10;


-- ============================================================================
-- BLOCK 2: JOINS & RELATIONSHIPS (5 Test Cases)
-- ============================================================================

-- TC-006: Test Actor-Film Many-to-Many Relationship
-- Purpose: Validate 3-table INNER JOIN and many-to-many relationship
SELECT f.title, a.first_name, a.last_name 
FROM film f 
INNER JOIN film_actor fa ON f.film_id = fa.film_id 
INNER JOIN actor a ON fa.actor_id = a.actor_id 
WHERE a.actor_id = 1;

-- TC-007: Test Customer-Rental Relationship with Aggregation
-- Purpose: Validate LEFT JOIN with GROUP BY and COUNT aggregate
SELECT c.customer_id, c.first_name, c.last_name, 
       COUNT(r.rental_id) as total_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE c.customer_id <= 10
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;

-- TC-008: Check for Orphaned Rentals Without Payments
-- Purpose: Identify referential integrity issues
SELECT r.rental_id, r.rental_date, p.payment_id, p.amount
FROM rental r
LEFT JOIN payment p ON r.rental_id = p.rental_id
WHERE p.payment_id IS NULL
LIMIT 10;

-- TC-009: Verify Film-Inventory Relationship (BUG FOUND)
-- Purpose: Identify films without inventory copies
SELECT f.film_id, f.title, COUNT(i.inventory_id) as total_copies
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(i.inventory_id) = 0
ORDER BY f.title;

-- TC-010: Verify Store-Manager Relationship
-- Purpose: Validate one-to-one relationship between stores and managers
SELECT s.store_id, st.staff_id, st.first_name, st.last_name, st.email
FROM store s
INNER JOIN staff st ON s.manager_staff_id = st.staff_id
ORDER BY s.store_id;


-- ============================================================================
-- BLOCK 3: CONSTRAINTS & INTEGRITY (4 Test Cases)
-- ============================================================================

-- TC-011: Test Foreign Key Constraint
-- Purpose: Verify FK constraint prevents invalid insertions
-- Note: This will fail with Error 1452 (expected behavior)
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (NOW(), 1, 900, 1);

-- TC-012: Test NOT NULL Constraint on Email
-- Purpose: Verify schema enforcement for NOT NULL
-- Note: This succeeds in sakila (constraint not defined)
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES (1, 'Test', 'User', NULL, 1, 1);

-- TC-013: Test UNIQUE Constraint on Email
-- Purpose: Verify schema enforcement for UNIQUE constraint
-- Note: This succeeds in sakila (constraint not defined)
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES (1, 'Duplicate', 'Test', 'MARY.SMITH@sakilacustomer.org', 1, 1);

-- TC-014: Test CHECK Constraint on Payment Amount
-- Purpose: Verify schema enforcement for CHECK constraint
-- Note: This succeeds in sakila (constraint not defined)
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, 1, -10.99, NOW());


-- ============================================================================
-- BLOCK 4: AGGREGATE FUNCTIONS (3 Test Cases)
-- ============================================================================

-- TC-015: Test COUNT() with GROUP BY
-- Purpose: Verify COUNT and GROUP BY functionality
SELECT c.name AS category, COUNT(fc.film_id) AS total_films
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY total_films DESC;

-- TC-016: Test SUM() and AVG() Functions
-- Purpose: Validate multiple aggregate functions
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(p.payment_id) AS total_payments,
    SUM(p.amount) AS total_spent,
    AVG(p.amount) AS avg_payment
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- TC-017: Test MIN() and MAX() Functions
-- Purpose: Verify MIN, MAX, and AVG with multiple columns
SELECT 
    f.rating,
    COUNT(f.film_id) AS total_films,
    MIN(f.rental_rate) AS min_rental_rate,
    MAX(f.rental_rate) AS max_rental_rate,
    AVG(f.rental_rate) AS avg_rental_rate,
    MIN(f.length) AS shortest_film,
    MAX(f.length) AS longest_film
FROM film f
GROUP BY f.rating
ORDER BY f.rating;


-- ============================================================================
-- BLOCK 5: STORED PROCEDURES (2 Test Cases)
-- ============================================================================

-- TC-018: Test film_in_stock Stored Procedure
-- Purpose: Verify stored procedure execution and output parameters
CALL film_in_stock(1, 1, @count);
SELECT @count AS available_copies;

-- TC-019: Test film_not_in_stock Stored Procedure
-- Purpose: Verify stored procedure execution for rented inventory
CALL film_not_in_stock(2, 1, @count);
SELECT @count AS rented_copies;


-- ============================================================================
-- BLOCK 6: ADVANCED QUERIES (1 Test Case)
-- ============================================================================

-- TC-020: Test Complex Subquery with Filtering
-- Purpose: Validate subqueries, filtering, and calculated columns
SELECT f.title, f.rental_rate,
    (SELECT AVG(rental_rate) FROM film) AS avg_rate,
    f.rental_rate - (SELECT AVG(rental_rate) FROM film) AS difference
FROM film f
WHERE f.rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY difference DESC
LIMIT 5;


-- ============================================================================
-- ADDITIONAL UTILITY QUERIES
-- ============================================================================

-- Verify sakila database setup
USE sakila;

-- Check total rentals
SELECT COUNT(*) as total_rentals FROM rental;

-- Check total films
SELECT COUNT(*) as total_films FROM film;

-- Check total customers
SELECT COUNT(*) as total_customers FROM customer;

-- View all tables in sakila
SHOW TABLES;

-- Describe customer table structure (used for constraint verification)
DESCRIBE customer;

-- Describe payment table structure (used for constraint verification)
DESCRIBE payment;


-- ============================================================================
-- END OF SQL TEST QUERIES
-- ============================================================================
-- Total Queries: 20 test cases + 7 utility queries
-- Status: All queries tested and documented
-- Date: February 2026
-- ============================================================================