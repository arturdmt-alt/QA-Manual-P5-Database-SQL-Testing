# Database Schema Overview - Sakila Database

## Document Information

**Project:** P5 - Database SQL Testing  
**Author:** Artur Dmytriyev, QA Software Engineer  
**Database:** MySQL 8.0.45 - sakila  
**Date:** February 2026  
**Status:** Final

## Introduction

This document provides an overview of the MySQL sakila sample database schema used for testing in this project. The sakila database is a standard MySQL sample database representing a DVD rental store business model.

**Database Name:** sakila  
**Database Type:** Relational (MySQL)  
**Purpose:** Sample database for learning and testing SQL operations  
**Version:** Official MySQL sakila sample database  
**Source:** https://dev.mysql.com/doc/sakila/en/

## Database Statistics

**Total Tables:** 16  
**Total Views:** 7  
**Stored Procedures:** 3  
**Triggers:** 6

**Key Data Volumes:**
- Films: 1,000
- Actors: 200
- Customers: 599
- Rentals: 16,044
- Payments: 16,049
- Inventory Items: 4,581
- Stores: 2
- Staff: 2

## Core Tables Overview

### 1. actor

**Purpose:** Stores information about actors

**Columns:**
- actor_id (PRIMARY KEY, AUTO_INCREMENT)
- first_name (VARCHAR)
- last_name (VARCHAR)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-many with film through film_actor table

**Records:** 200 actors

### 2. film

**Purpose:** Stores information about films available in the catalog

**Columns:**
- film_id (PRIMARY KEY, AUTO_INCREMENT)
- title (VARCHAR)
- description (TEXT)
- release_year (YEAR)
- language_id (FOREIGN KEY → language)
- original_language_id (FOREIGN KEY → language, nullable)
- rental_duration (TINYINT, default 3 days)
- rental_rate (DECIMAL, default 4.99)
- length (SMALLINT, film duration in minutes)
- replacement_cost (DECIMAL)
- rating (ENUM: G, PG, PG-13, R, NC-17)
- special_features (SET: Trailers, Commentaries, Deleted Scenes, Behind the Scenes)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-many with actor through film_actor
- Many-to-many with category through film_category
- One-to-many with inventory

**Records:** 1,000 films

### 3. film_actor (Junction Table)

**Purpose:** Links films to actors (many-to-many relationship)

**Columns:**
- actor_id (FOREIGN KEY → actor)
- film_id (FOREIGN KEY → film)
- last_update (TIMESTAMP)

**Primary Key:** Composite (actor_id, film_id)

### 4. category

**Purpose:** Stores film categories

**Columns:**
- category_id (PRIMARY KEY, AUTO_INCREMENT)
- name (VARCHAR)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-many with film through film_category

**Records:** 16 categories (Action, Animation, Children, Classics, Comedy, Documentary, Drama, Family, Foreign, Games, Horror, Music, New, Sci-Fi, Sports, Travel)

### 5. film_category (Junction Table)

**Purpose:** Links films to categories (many-to-many relationship)

**Columns:**
- film_id (FOREIGN KEY → film)
- category_id (FOREIGN KEY → category)
- last_update (TIMESTAMP)

**Primary Key:** Composite (film_id, category_id)

### 6. inventory

**Purpose:** Stores physical inventory copies of films at stores

**Columns:**
- inventory_id (PRIMARY KEY, AUTO_INCREMENT)
- film_id (FOREIGN KEY → film)
- store_id (FOREIGN KEY → store)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-one with film
- Many-to-one with store
- One-to-many with rental

**Records:** 4,581 inventory items

**Note:** Some films in the film table have zero inventory copies (identified in BUG-001)

### 7. store

**Purpose:** Stores information about physical store locations

**Columns:**
- store_id (PRIMARY KEY, AUTO_INCREMENT)
- manager_staff_id (FOREIGN KEY → staff)
- address_id (FOREIGN KEY → address)
- last_update (TIMESTAMP)

**Relationships:**
- One-to-one with staff (manager)
- One-to-many with customer
- One-to-many with inventory
- One-to-many with staff

**Records:** 2 stores

### 8. staff

**Purpose:** Stores information about store staff members

**Columns:**
- staff_id (PRIMARY KEY, AUTO_INCREMENT)
- first_name (VARCHAR)
- last_name (VARCHAR)
- address_id (FOREIGN KEY → address)
- picture (BLOB, staff photo)
- email (VARCHAR)
- store_id (FOREIGN KEY → store)
- active (BOOLEAN)
- username (VARCHAR)
- password (VARCHAR)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-one with store
- One-to-many with rental
- One-to-many with payment

**Records:** 2 staff members

### 9. customer

**Purpose:** Stores customer information

**Columns:**
- customer_id (PRIMARY KEY, AUTO_INCREMENT)
- store_id (FOREIGN KEY → store)
- first_name (VARCHAR)
- last_name (VARCHAR)
- email (VARCHAR, nullable, no UNIQUE constraint)
- address_id (FOREIGN KEY → address)
- active (BOOLEAN)
- create_date (DATETIME)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-one with store
- One-to-many with rental
- One-to-many with payment

**Records:** 599 customers

**Note:** Email field allows NULL and duplicates (no UNIQUE or NOT NULL constraints)

### 10. rental

**Purpose:** Stores rental transaction records

**Columns:**
- rental_id (PRIMARY KEY, AUTO_INCREMENT)
- rental_date (DATETIME, NOT NULL)
- inventory_id (FOREIGN KEY → inventory)
- customer_id (FOREIGN KEY → customer)
- return_date (DATETIME, nullable)
- staff_id (FOREIGN KEY → staff)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-one with inventory
- Many-to-one with customer
- Many-to-one with staff
- One-to-one with payment (typically)

**Records:** 16,044 rentals

**Note:** return_date can be NULL for unreturned items

### 11. payment

**Purpose:** Stores payment transaction records

**Columns:**
- payment_id (PRIMARY KEY, AUTO_INCREMENT)
- customer_id (FOREIGN KEY → customer)
- staff_id (FOREIGN KEY → staff)
- rental_id (FOREIGN KEY → rental, nullable)
- amount (DECIMAL, no CHECK constraint in sakila)
- payment_date (DATETIME)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-one with customer
- Many-to-one with staff
- One-to-one with rental (typically)

**Records:** 16,049 payments

**Note:** Amount field allows negative values (no CHECK constraint enforced)

### 12. address

**Purpose:** Stores address information for customers, staff, and stores

**Columns:**
- address_id (PRIMARY KEY, AUTO_INCREMENT)
- address (VARCHAR)
- address2 (VARCHAR, nullable)
- district (VARCHAR)
- city_id (FOREIGN KEY → city)
- postal_code (VARCHAR, nullable)
- phone (VARCHAR)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-one with city
- One-to-many with customer
- One-to-many with staff
- One-to-many with store

### 13. city

**Purpose:** Stores city information

**Columns:**
- city_id (PRIMARY KEY, AUTO_INCREMENT)
- city (VARCHAR)
- country_id (FOREIGN KEY → country)
- last_update (TIMESTAMP)

**Relationships:**
- Many-to-one with country
- One-to-many with address

### 14. country

**Purpose:** Stores country information

**Columns:**
- country_id (PRIMARY KEY, AUTO_INCREMENT)
- country (VARCHAR)
- last_update (TIMESTAMP)

**Relationships:**
- One-to-many with city

### 15. language

**Purpose:** Stores language information for films

**Columns:**
- language_id (PRIMARY KEY, AUTO_INCREMENT)
- name (CHAR)
- last_update (TIMESTAMP)

**Relationships:**
- One-to-many with film (language_id)
- One-to-many with film (original_language_id)

**Records:** 6 languages (English, Italian, Japanese, Mandarin, French, German)

## Database Relationships Summary

**One-to-Many Relationships:**
- store → customer
- store → inventory
- store → staff
- film → inventory
- customer → rental
- customer → payment
- inventory → rental
- staff → rental
- staff → payment
- rental → payment
- country → city
- city → address
- language → film

**Many-to-Many Relationships:**
- film ↔ actor (via film_actor)
- film ↔ category (via film_category)

**One-to-One Relationships:**
- store → staff (manager)

## Stored Procedures

### 1. film_in_stock

**Purpose:** Returns inventory IDs of available copies of a film at a specific store

**Parameters:**
- IN p_film_id (INT)
- IN p_store_id (INT)
- OUT p_film_count (INT)

**Tested in:** TC-018

### 2. film_not_in_stock

**Purpose:** Returns inventory IDs of rented copies of a film at a specific store

**Parameters:**
- IN p_film_id (INT)
- IN p_store_id (INT)
- OUT p_film_count (INT)

**Tested in:** TC-019

### 3. rewards_report

**Purpose:** Generates a report of customers eligible for rewards based on rental activity

**Not tested in this project**

## Database Constraints

### Foreign Key Constraints

The sakila database implements foreign key constraints on all relationship columns to maintain referential integrity:

- film_actor: actor_id → actor, film_id → film
- film_category: film_id → film, category_id → category
- inventory: film_id → film, store_id → store
- rental: inventory_id → inventory, customer_id → customer, staff_id → staff
- payment: customer_id → customer, staff_id → staff, rental_id → rental

**Testing Result:** All foreign key constraints are properly enforced (TC-011)

### Other Constraints

**NOT NULL Constraints:**  
Limited NOT NULL constraints in sakila. Most notable:
- rental.rental_date is NOT NULL
- Other fields allow NULL for flexibility in sample database

**UNIQUE Constraints:**  
Limited UNIQUE constraints in sakila. Email fields do not have UNIQUE constraints.

**CHECK Constraints:**  
No CHECK constraints enforced in sakila database. Amount fields allow negative values at database level.

**Note:** The absence of these constraints is intentional for the sample database but would typically be implemented in production systems.

## Views

The sakila database includes 7 views for common queries:

1. actor_info
2. customer_list
3. film_list
4. nicer_but_slower_film_list
5. sales_by_film_category
6. sales_by_store
7. staff_list

**Not tested in this project** - focus was on base tables and direct SQL queries

## Triggers

The sakila database includes 6 triggers for automatic timestamp updates:

- customer_create_date
- ins_film
- upd_film
- del_film
- payment_date
- rental_date

**Not tested in this project**

## Key Findings from Testing

### Data Integrity Issues

**BUG-001: Films Without Inventory**  
42 films exist in the film table with zero corresponding inventory records. This represents 4.2% of the catalog and creates a potential user experience issue.

### Schema Design Observations

**Flexible Constraints:**  
Sakila uses minimal constraints (NOT NULL, UNIQUE, CHECK) to provide flexibility as a learning/sample database. Production systems would typically enforce stricter constraints.

**Proper Foreign Keys:**  
All foreign key relationships are properly defined and enforced, maintaining referential integrity across the database.

**Timestamp Tracking:**  
All tables include last_update timestamp field for change tracking.

## Database Relationships

**Core Flow:**
- Countries contain Cities
- Cities contain Addresses
- Customers rent Inventory via Rentals
- Payments track Rental transactions
- Films connect to Actors and Categories (many-to-many)
- Stores manage Inventory and Staff

**Note:** See official sakila documentation for complete ER diagram.

## Additional Resources

**Official Documentation:**  
https://dev.mysql.com/doc/sakila/en/

**Download:**  
https://dev.mysql.com/doc/index-other.html

**Schema Scripts:**
- sakila-schema.sql (creates tables, views, procedures)
- sakila-data.sql (populates data)

**Document prepared by:** Artur Dmytriyev, QA Software Engineer  
**Date:** February 2026  
**Status:** Final - Schema documented based on testing observations
