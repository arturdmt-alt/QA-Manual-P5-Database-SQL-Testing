# P5 - Database SQL Testing Project

## Project Overview

This project demonstrates comprehensive Manual Database Testing skills using MySQL and the sakila sample database. The testing focuses on data validation, SQL queries, relationships, constraints, stored procedures, and complex queries to ensure database integrity and functionality.

**Project Type:** QA Manual Testing - Database/SQL  
**Database:** MySQL 8.0.45 (sakila sample database)  
**Test Cases:** 20 executed  
**Pass Rate:** 95% (19 PASS, 1 FAIL)  
**Bugs Found:** 1 (Medium severity)  
**Duration:** 4-5 days  
**Testing Tool:** MySQL Workbench

## Objectives

- Validate database schema integrity and data consistency
- Test complex SQL queries including JOINs, subqueries, and aggregations
- Verify database constraints (Foreign Keys, NOT NULL, UNIQUE, CHECK)
- Test stored procedures and their output
- Identify data integrity issues through systematic testing
- Document findings using industry-standard practices (Jira, detailed test reports)

## Technology Stack

**Database:** MySQL 8.0.45  
**Database Tool:** MySQL Workbench 8.0.40  
**Test Database:** sakila (MySQL sample database with 16 tables, 16,044 records)  
**Bug Tracking:** Jira (Team-managed Kanban project)  
**Version Control:** Git/GitHub  
**Documentation:** Markdown

## Project Structure
```
P5-Database-SQL-Testing/
├── bugs/
│   └── Bug-Reports.md                # Detailed bug documentation
├── documentation/
│   ├── Database-Schema-Overview.md   # Sakila database structure
│   ├── Test-Strategy.md              # Testing approach and scope
│   └── jira-screenshots/             # Jira project evidence
├── test-cases/
│   ├── Database-Test-Cases.md        # 20 test cases with results
│   └── SQL-Test-Queries.sql          # All SQL queries used in testing
├── test-results/
│   ├── screenshots/                  # Visual evidence (20 screenshots)
│   └── Test-Execution-Summary.md     # Executive summary and metrics
├── .gitignore
└── README.md
```

## Test Coverage

### Testing Blocks (20 Test Cases)

**Block 1: Basic Data Validation (5 TCs)**
- Actor table data retrieval
- Film count validation
- Date format verification
- Payment amount validation
- Email format validation

**Block 2: JOINs & Relationships (5 TCs)**
- Actor-Film many-to-many relationship
- Customer-Rental aggregation
- Payment-Rental orphan check
- Film-Inventory relationship (BUG FOUND)
- Store-Manager relationship

**Block 3: Constraints & Integrity (4 TCs)**
- Foreign Key constraint testing
- NOT NULL constraint verification
- UNIQUE constraint validation
- CHECK constraint testing

**Block 4: Aggregate Functions (3 TCs)**
- COUNT() with GROUP BY
- SUM() and AVG() calculations
- MIN() and MAX() range analysis

**Block 5: Stored Procedures (2 TCs)**
- film_in_stock procedure
- film_not_in_stock procedure

**Block 6: Advanced Queries (1 TC)**
- Complex subquery with filtering

## Key Results

### Test Execution Metrics

**Total Test Cases:** 20  
**Passed:** 19  
**Failed:** 1  
**Pass Rate:** 95%  
**Bugs Found:** 1  
**Bug Severity:** Medium  
**Test Execution Time:** 2-3 hours

### Bug Summary

**BUG-001: Films exist without inventory copies**

**Severity:** Medium  
**Priority:** Medium  
**Impact:** 42 films appear in catalog but cannot be rented  
**Root Cause:** Missing inventory records for films  
**Test Case:** TC-009 - Film-Inventory relationship  
**Status:** Documented in Jira (P5SQL project)

**Recommendation:** Add inventory copies, implement availability flag, or confirm expected behavior for discontinued films.

## Database Information

**Sakila Database Schema:**

**Tables:** 16 (actor, film, customer, rental, payment, inventory, store, etc.)  
**Total Records:** 16,044 rentals  
**Categories:** 16 film categories  
**Films:** 1,000 films  
**Customers:** 599 customers  
**Relationships:** Multiple one-to-many and many-to-many relationships

## How to Replicate This Testing

### Prerequisites

1. Install MySQL 8.0+ (https://dev.mysql.com/downloads/mysql/)
2. Install MySQL Workbench 8.0+ (https://dev.mysql.com/downloads/workbench/)
3. Download sakila database (https://dev.mysql.com/doc/index-other.html)

### Setup Steps

**1. Install MySQL and MySQL Workbench**

Follow installation wizard for your OS and set root password during installation.

**2. Import sakila database**

In MySQL Workbench:
- File → Open SQL Script → select sakila-schema.sql
- Execute (⚡ button)
- File → Open SQL Script → select sakila-data.sql
- Execute (⚡ button)

**3. Verify installation**
```sql
USE sakila;
SELECT COUNT(*) FROM rental;  -- Should return 16,044
SELECT COUNT(*) FROM film;    -- Should return 1,000
```

**4. Run test queries**

- Open test-cases/SQL-Test-Queries.sql
- Execute queries one by one
- Compare results with test-cases/Database-Test-Cases.md

## Documentation

**Test Strategy** - Testing approach, scope, and methodology  
**Test Cases** - All 20 test cases with steps and results  
**Bug Reports** - Detailed bug documentation  
**Test Execution Summary** - Results and metrics  
**SQL Queries** - All queries used in testing  
**Database Schema** - Sakila structure overview

## Skills Demonstrated

- Manual database testing and validation
- SQL query writing (SELECT, JOIN, aggregate functions, subqueries)
- Database constraint testing (FK, NOT NULL, UNIQUE, CHECK)
- Stored procedure testing
- Data integrity analysis
- Bug identification and documentation
- Test case design and execution
- Professional documentation (Markdown, Jira)
- Version control (Git/GitHub)
- MySQL Workbench proficiency

## Portfolio Context

This is Project 5 in my QA Manual Testing portfolio, focused on database testing skills. It demonstrates systematic testing approach, SQL proficiency, and ability to identify data integrity issues.

**Portfolio Projects:**
- P1: ParaBank (Web application testing)
- P2: Sauce Demo (E-commerce testing)
- P3: OpenCart (Full e-commerce platform)
- P4: API Testing (Postman collections)
- P5: Database SQL Testing (Current project)

## Author

**Artur Dmytriyev**  
QA Software Engineer | Vancouver, BC, Canada

**GitHub:** https://github.com/arturdmt-alt  
**LinkedIn:** https://www.linkedin.com/in/arturdmytriyev  


## License

This project is for portfolio demonstration purposes.

**Last Updated:** February 2026