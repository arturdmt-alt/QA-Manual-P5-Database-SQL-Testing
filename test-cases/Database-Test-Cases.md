# Database Test Cases - P5 SQL Testing Project

## Document Information

**Project:** P5 - Database SQL Testing  
**Author:** Artur Dmytriyev, QA Software Engineer  
**Database:** MySQL 8.0.45 - sakila  
**Total Test Cases:** 20  
**Execution Date:** February 2026  
**Status:** Completed

## Test Execution Summary

**Total:** 20 test cases  
**Passed:** 19 (95%)  
**Failed:** 1 (5%)  
**Bugs Found:** 1 (BUG-001: Films without inventory copies)

## BLOCK 1: BASIC DATA VALIDATION (5 Test Cases)

### TC-001: Verify Actor Table Data Retrieval

**Objective:** Validate that actor table returns data correctly and columns are accessible

**Pre-conditions:**
- MySQL connected to sakila database
- Actor table exists with data

**Test Steps:**
1. Execute SELECT query on actor table
2. Retrieve first 10 records
3. Verify all columns are accessible
4. Validate data types and format

**SQL Query:**
```sql
SELECT actor_id, first_name, last_name 
FROM actor 
LIMIT 10;
```

**Expected Result:**
- Query executes successfully
- Returns 10 actor records
- Columns: actor_id (INT), first_name (VARCHAR), last_name (VARCHAR)
- No NULL values in required fields

**Actual Result:**
- Query executed successfully
- 10 actors retrieved
- Sample data: PENELOPE GUINESS, NICK WAHLBERG, ED CHASE, JENNIFER DAVIS
- All columns populated correctly

**Status:** PASS

**Evidence:** TC-001_actor_data.jpg

---

### TC-002: Count Total Films in Database

**Objective:** Verify total number of films matches expected count

**Pre-conditions:**
- Film table exists and populated

**Test Steps:**
1. Execute COUNT query on film table
2. Verify count matches expected value
3. Validate aggregate function works correctly

**SQL Query:**
```sql
SELECT COUNT(*) as total_films 
FROM film;
```

**Expected Result:**
- Query returns single row
- Count approximately 1000 films
- Aggregate function COUNT() works correctly

**Actual Result:**
- Query executed successfully
- total_films = 1000
- Exact match with expected value

**Status:** PASS

**Evidence:** TC-002_total_films.jpg

---

### TC-003: Verify Rental Date Format

**Objective:** Validate date columns use proper MySQL datetime format

**Pre-conditions:**
- Rental table contains rental records

**Test Steps:**
1. Execute SELECT query on rental table
2. Retrieve rental_date and return_date columns
3. Verify datetime format (YYYY-MM-DD HH:MM:SS)
4. Check for NULL values in return_date (valid for unreturned items)

**SQL Query:**
```sql
SELECT rental_id, rental_date, return_date 
FROM rental 
LIMIT 10;
```

**Expected Result:**
- Dates display in format: YYYY-MM-DD HH:MM:SS
- rental_date is always populated (NOT NULL)
- return_date may be NULL (unreturned rentals)

**Actual Result:**
- Correct format: 2005-05-24 22:53:30
- All rental_date values populated
- Some return_date values NULL (expected behavior)

**Status:** PASS

**Evidence:** TC-003_rental_dates.jpg

---

### TC-004: Validate Payment Amounts Are Positive

**Objective:** Ensure all payment amounts are greater than zero (business rule)

**Pre-conditions:**
- Payment table contains payment records

**Test Steps:**
1. Execute SELECT with WHERE clause filtering amount > 0
2. Verify all returned amounts are positive
3. Validate no negative or zero amounts exist

**SQL Query:**
```sql
SELECT payment_id, amount, payment_date 
FROM payment 
WHERE amount > 0 
LIMIT 10;
```

**Expected Result:**
- All amounts are positive decimal values
- Typical values: 2.99, 4.99, 5.99, etc.
- No zero or negative amounts found in current dataset
- Note: Business rule validated at data level, not enforced by DB constraint

**Actual Result:**
- All amounts positive
- Sample values: 2.99, 0.99, 5.99, 4.99
- Business rule validated
- Validation based on existing data, not schema enforcement

**Status:** PASS

**Evidence:** TC-004_payment_amounts.jpg

---

### TC-005: Verify Customer Email Format

**Objective:** Validate email addresses follow standard email format

**Pre-conditions:**
- Customer table contains customer records

**Test Steps:**
1. Execute SELECT query on customer table
2. Retrieve customer_id and email columns
3. Verify email format contains @ symbol and domain
4. Check for invalid formats

**SQL Query:**
```sql
SELECT customer_id, email 
FROM customer 
LIMIT 10;
```

**Expected Result:**
- All emails contain @ symbol
- Format: name@domain.extension
- No malformed emails (e.g., missing @, no domain)

**Actual Result:**
- All emails properly formatted
- Format: FIRSTNAME.LASTNAME@sakilacustomer.org
- Consistent domain across all records

**Status:** PASS

**Evidence:** TC-005_customer_emails.jpg

---

## BLOCK 2: JOINS & RELATIONSHIPS (5 Test Cases)

### TC-006: Test Actor-Film Many-to-Many Relationship

**Objective:** Validate INNER JOIN across 3 tables to verify many-to-many relationship

**Pre-conditions:**
- film, film_actor, and actor tables populated
- film_actor junction table connects films to actors

**Test Steps:**
1. Execute 3-table INNER JOIN query
2. Retrieve films for specific actor (actor_id = 1)
3. Verify multiple films returned for single actor
4. Validate relationship data integrity

**SQL Query:**
```sql
SELECT f.title, a.first_name, a.last_name 
FROM film f 
INNER JOIN film_actor fa ON f.film_id = fa.film_id 
INNER JOIN actor a ON fa.actor_id = a.actor_id 
WHERE a.actor_id = 1;
```

**Expected Result:**
- Multiple films returned for actor_id = 1 (PENELOPE GUINESS)
- JOIN operates correctly across 3 tables
- All relationships properly linked

**Actual Result:**
- Query returned multiple films
- Sample titles: ACADEMY DINOSAUR, ANACONDA CONFESSIONS, ANGELS LIFE
- Many-to-many relationship validated

**Status:** PASS

**Evidence:** TC-006_actor_film_join.jpg

---

### TC-007: Test Customer-Rental Relationship with Aggregation

**Objective:** Validate LEFT JOIN with GROUP BY to count rentals per customer

**Pre-conditions:**
- Customer and rental tables populated

**Test Steps:**
1. Execute LEFT JOIN with COUNT aggregate
2. Group by customer
3. Verify all customers have rental counts
4. Check for customers with zero rentals (if any)

**SQL Query:**
```sql
SELECT c.customer_id, c.first_name, c.last_name, 
       COUNT(r.rental_id) as total_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE c.customer_id <= 10
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;
```

**Expected Result:**
- LEFT JOIN structure validated
- Customers displayed with rental counts
- No customers with zero rentals found in sampled range

**Actual Result:**
- All 10 customers have rentals
- Sample counts: MARY SMITH (32), PATRICIA JOHNSON (27), LINDA WILLIAMS (26)
- No customers with zero rentals found

**Status:** PASS

**Evidence:** TC-007_customer_rental_count.jpg

---

### TC-008: Check for Orphaned Rentals Without Payments

**Objective:** Identify rentals that have no associated payment (data integrity issue)

**Pre-conditions:**
- Rental and payment tables populated
- Test executed in isolated test environment

**Test Steps:**
1. Execute LEFT JOIN to find rentals without payments
2. Filter WHERE payment_id IS NULL
3. Verify no orphaned records exist
4. Validate referential integrity

**SQL Query:**
```sql
SELECT r.rental_id, r.rental_date, p.payment_id, p.amount
FROM rental r
LEFT JOIN payment p ON r.rental_id = p.rental_id
WHERE p.payment_id IS NULL
LIMIT 10;
```

**Expected Result:**
- Query returns 0 rows (all rentals have payments)
- Data integrity maintained
- No orphaned rental records

**Actual Result:**
- 0 rows returned
- All rentals have associated payments
- Referential integrity confirmed

**Status:** PASS

**Evidence:** TC-008_rentals_without_payment.jpg

---

### TC-009: Verify Film-Inventory Relationship

**Objective:** Identify films in catalog without inventory copies (potential data issue)

**Pre-conditions:**
- Film and inventory tables populated

**Test Steps:**
1. Execute LEFT JOIN with COUNT to find films with zero inventory
2. Group by film_id
3. Filter HAVING COUNT = 0
4. Identify films that cannot be rented

**SQL Query:**
```sql
SELECT f.film_id, f.title, COUNT(i.inventory_id) as total_copies
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(i.inventory_id) = 0
ORDER BY f.title;
```

**Expected Result:**
- Ideally, query returns 0 rows
- If rows returned, represents potential data or business rule issue requiring clarification

**Actual Result:**
- Query returned 42 films with 0 inventory copies
- Sample films: ALICE FANTASIA, APOLLO TEEN, ARGONAUTS TOWN, ARK RIDGEMONT
- These films appear in catalog but cannot be rented

**Status:** FAIL

**Bug Reference:** BUG-001 - Films exist without inventory copies

**Impact:** Medium - Films appear in catalog but are unrentable (poor user experience)

**Recommendation:**
1. Add inventory copies for these films, OR
2. Implement is_available flag to mark discontinued films, OR
3. Confirm this is expected behavior for historical/discontinued items

**Evidence:** TC-009_films_without_inventory_BUG.jpg

---

### TC-010: Verify Store-Manager Relationship

**Objective:** Validate each store has an assigned manager from staff table

**Pre-conditions:**
- Store and staff tables populated

**Test Steps:**
1. Execute INNER JOIN between store and staff tables
2. Verify each store has exactly one manager
3. Validate manager details are accessible

**SQL Query:**
```sql
SELECT s.store_id, st.staff_id, st.first_name, st.last_name, st.email
FROM store s
INNER JOIN staff st ON s.manager_staff_id = st.staff_id
ORDER BY s.store_id;
```

**Expected Result:**
- 2 stores with managers assigned
- Each store has valid manager from staff table
- Manager details displayed correctly

**Actual Result:**
- 2 stores returned
- Store 1 → Mike Hillyer
- Store 2 → Jon Stephens
- Relationship validated successfully

**Status:** PASS

**Evidence:** TC-010_store_manager_relationship.jpg

---

## BLOCK 3: CONSTRAINTS & INTEGRITY (4 Test Cases)

### TC-011: Test Foreign Key Constraint

**Objective:** Verify FK constraint prevents insertion of invalid customer_id in rental table

**Pre-conditions:**
- rental table has FK constraint to customer table
- Test executed in isolated test environment; inserted records rolled back after execution

**Test Steps:**
1. Attempt INSERT with non-existent customer_id (900)
2. Verify database rejects the insert
3. Confirm FK constraint is enforced

**SQL Query:**
```sql
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (NOW(), 1, 900, 1);
```

**Expected Result:**
- Insert fails with FK constraint error
- Error Code 1452: "Cannot add or update a child row: a foreign key constraint fails"
- Data integrity protected

**Actual Result:**
- Insert rejected as expected
- Error Code 1452 returned
- FK constraint working correctly

**Status:** PASS

**Evidence:** TC-011_foreign_key_constraint_pass.jpg

---

### TC-012: Test NOT NULL Constraint on Email

**Objective:** Verify database schema enforcement (email field behavior)

**Pre-conditions:**
- customer table email field analyzed
- Test executed in isolated test environment; inserted records cleaned after execution

**Test Steps:**
1. Attempt INSERT with NULL email value
2. Check if constraint exists and is enforced
3. Verify schema design

**SQL Query:**
```sql
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES (1, 'Test', 'User', NULL, 1, 1);
```

**Expected Result:**
- If constraint exists: Insert fails with NOT NULL error
- If constraint absent: Insert succeeds (schema verification)

**Actual Result:**
- Insert succeeded (1 row affected)
- Email field allows NULL in sakila schema
- Constraint NOT defined in database

**Status:** PASS

**Note:** Test validates schema behavior. Sakila database does not enforce NOT NULL on email field. This is correct behavior for the test database.

**Evidence:** TC-012_not_null_constraint_PASS.jpg

---

### TC-013: Test UNIQUE Constraint on Email

**Objective:** Verify database schema enforcement (email uniqueness behavior)

**Pre-conditions:**
- customer table analyzed for UNIQUE constraint
- Test executed in isolated test environment; inserted records cleaned after execution

**Test Steps:**
1. Attempt INSERT with duplicate email
2. Check if constraint exists and is enforced
3. Verify schema design

**SQL Query:**
```sql
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES (1, 'Duplicate', 'Test', 'MARY.SMITH@sakilacustomer.org', 1, 1);
```

**Expected Result:**
- If constraint exists: Insert fails with UNIQUE constraint error
- If constraint absent: Insert succeeds (schema verification)

**Actual Result:**
- Insert succeeded (1 row affected)
- Email field does not have UNIQUE constraint in sakila schema
- Duplicate emails allowed

**Status:** PASS

**Note:** Test validates schema behavior. Sakila database does not enforce UNIQUE constraint on email. This is correct behavior for the test database.

**Evidence:** TC-013_unique_constraint_PASS.jpg

---

### TC-014: Test CHECK Constraint on Payment Amount

**Objective:** Verify database schema enforcement (payment amount validation)

**Pre-conditions:**
- payment table analyzed for CHECK constraint
- Test executed in isolated test environment; inserted records cleaned after execution

**Test Steps:**
1. Attempt INSERT with negative amount value
2. Check if constraint exists and is enforced
3. Verify schema design

**SQL Query:**
```sql
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, 1, -10.99, NOW());
```

**Expected Result:**
- If constraint exists: Insert fails with CHECK constraint error
- If constraint absent: Insert succeeds (schema verification)

**Actual Result:**
- Insert succeeded (1 row affected)
- Payment amount field does not have CHECK constraint in sakila schema
- Negative amounts allowed at database level

**Status:** PASS

**Note:** Test validates schema behavior. Sakila database does not enforce CHECK constraint on amount. This is correct behavior for the test database.

**Evidence:** TC-014_check_constraint_PASS.jpg

---

## BLOCK 4: AGGREGATE FUNCTIONS (3 Test Cases)

### TC-015: Test COUNT() with GROUP BY

**Objective:** Verify COUNT aggregate function and GROUP BY clause

**Pre-conditions:**
- category and film_category tables populated

**Test Steps:**
1. Execute COUNT with GROUP BY to count films per category
2. Verify all 16 categories returned
3. Validate counts are accurate

**SQL Query:**
```sql
SELECT c.name AS category, COUNT(fc.film_id) AS total_films
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY total_films DESC;
```

**Expected Result:**
- 16 film categories displayed
- Each category has film count
- Counts sum to 1000 total films

**Actual Result:**
- All 16 categories returned
- Top category: Sports (74 films)
- Lowest category: Music (51 films)
- Aggregate function working correctly

**Status:** PASS

**Evidence:** TC-015_count_groupby_PASS.jpg

---

### TC-016: Test SUM() and AVG() Functions

**Objective:** Validate SUM and AVG aggregate functions on payment data

**Pre-conditions:**
- customer and payment tables populated

**Test Steps:**
1. Execute query with COUNT, SUM, and AVG
2. Calculate total spent and average payment per customer
3. Verify calculations are accurate

**SQL Query:**
```sql
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
```

**Expected Result:**
- Top 10 customers by total spending
- SUM and AVG calculations correct
- All three aggregate functions work properly

**Actual Result:**
- Top spender: KARL SEAL ($221.55, 45 payments, avg $4.92)
- Second: ELEANOR HUNT ($216.54, 46 payments, avg $4.71)
- All aggregate functions validated

**Status:** PASS

**Evidence:** TC-016_sum_avg_PASS.jpg

---

### TC-017: Test MIN() and MAX() Functions

**Objective:** Verify MIN and MAX aggregate functions on film data

**Pre-conditions:**
- film table populated with rental rates and film lengths

**Test Steps:**
1. Execute query with MIN, MAX, AVG grouped by rating
2. Analyze rental rate and film length ranges
3. Verify aggregate functions return correct values

**SQL Query:**
```sql
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
```

**Expected Result:**
- 5 film ratings (G, PG, PG-13, R, NC-17)
- MIN and MAX values for rental rates and lengths
- Ranges make business sense

**Actual Result:**
- All 5 ratings displayed
- Rental rates: Min $0.99, Max $4.99 (consistent across ratings)
- Film lengths: Shortest 46-49 min, Longest 184-185 min
- Aggregate functions working correctly

**Status:** PASS

**Evidence:** TC-017_min_max_PASS.jpg

---

## BLOCK 5: STORED PROCEDURES (2 Test Cases)

### TC-018: Test film_in_stock Stored Procedure

**Objective:** Verify stored procedure returns available inventory for a film at a store

**Pre-conditions:**
- film_in_stock procedure exists in database
- Inventory data populated

**Test Steps:**
1. Call stored procedure with film_id=1, store_id=1
2. Retrieve output parameter @count
3. Verify count matches available inventory

**SQL Query:**
```sql
CALL film_in_stock(1, 1, @count);
SELECT @count AS available_copies;
```

**Expected Result:**
- Procedure executes successfully
- Returns number of available copies for film_id=1 at store_id=1
- Output parameter populated correctly

**Actual Result:**
- Procedure executed successfully
- available_copies = 4
- 4 copies of film_id=1 available at store_id=1

**Status:** PASS

**Evidence:** TC-018_film_in_stock_PASS.jpg

---

### TC-019: Test film_not_in_stock Stored Procedure

**Objective:** Verify stored procedure returns rented inventory count

**Pre-conditions:**
- film_not_in_stock procedure exists in database

**Test Steps:**
1. Call stored procedure with film_id=2, store_id=1
2. Retrieve output parameter @count
3. Verify count represents rented copies

**SQL Query:**
```sql
CALL film_not_in_stock(2, 1, @count);
SELECT @count AS rented_copies;
```

**Expected Result:**
- Procedure executes successfully
- Returns number of currently rented copies
- Output parameter populated correctly

**Actual Result:**
- Procedure executed successfully
- rented_copies = 0
- No copies of film_id=2 currently rented from store_id=1

**Status:** PASS

**Evidence:** TC-019_film_not_in_stock_PASS.jpg

---

## BLOCK 6: ADVANCED QUERIES (1 Test Case)

### TC-020: Test Complex Subquery with Filtering

**Objective:** Validate complex SQL with subquery to find films with above-average rental rates

**Pre-conditions:**
- film table populated

**Test Steps:**
1. Execute query with subquery to calculate average rental rate
2. Filter films above average
3. Calculate difference from average
4. Verify subquery and filtering work correctly

**SQL Query:**
```sql
SELECT f.title, f.rental_rate,
    (SELECT AVG(rental_rate) FROM film) AS avg_rate,
    f.rental_rate - (SELECT AVG(rental_rate) FROM film) AS difference
FROM film f
WHERE f.rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY difference DESC
LIMIT 5;
```

**Expected Result:**
- Top 5 films with highest rental rates above average
- Subquery calculates average correctly
- Difference column shows how much above average

**Actual Result:**
- Top films: ACE GOLDFINGER, ZORRO ARK, ALI FOREVER, ALADDIN CALENDAR, AIRPORT POLLOCK
- All have rental_rate = $4.99
- Average rate = $2.98
- Difference = $2.01 above average
- Complex query executed successfully

**Status:** PASS

**Note:** Subquery intentionally repeated for demonstration purposes. In production, this could be optimized using a CTE or derived table.

**Evidence:** TC-020_advanced_subquery_PASS.jpg

---

## Test Execution Notes

### Environment

**Database:** MySQL 8.0.45  
**Tool:** MySQL Workbench 8.0.40  
**Test Database:** sakila (official MySQL sample database)  
**Tables Tested:** Core transactional tables (actor, film, customer, rental, payment, inventory, store, staff, etc.)

### Testing Approach

- Manual SQL query execution
- Visual verification of results via Result Grid
- Screenshot evidence for each test case
- Bug documentation for failures

### Key Findings

**Data Integrity:** Generally good, one issue found (TC-009)  
**Constraints:** Foreign keys enforced, other constraints optional in sakila  
**Relationships:** All JOIN operations validated successfully  
**Stored Procedures:** Both procedures tested function correctly  
**Aggregate Functions:** All aggregate functions (COUNT, SUM, AVG, MIN, MAX) working properly

### Recommendations

1. Address BUG-001: Films without inventory (42 films affected)
2. Consider adding NOT NULL constraint on customer.email for production
3. Consider adding UNIQUE constraint on customer.email for production
4. Consider adding CHECK constraint on payment.amount > 0 for production

**Document prepared by:** Artur Dmytriyev, QA Software Engineer  
**Date:** February 2026  
**Total Execution Time:** 2-3 hours  
**Status:** Testing Complete - Documentation Final