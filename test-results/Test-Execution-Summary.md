# Test Execution Summary - P5 Database SQL Testing

## Executive Summary

This document summarizes the test execution results for the P5 Database SQL Testing project. Manual testing was performed on the MySQL sakila sample database using MySQL Workbench to validate data integrity, SQL query functionality, relationships, constraints, and stored procedures.

**Project:** P5 - Database SQL Testing  
**Author:** Artur Dmytriyev, QA Software Engineer  
**Database:** MySQL 8.0.45 - sakila  
**Test Duration:** 2-3 hours  
**Execution Date:** February 2026  
**Status:** Complete

## Test Results Overview

**Total Test Cases Executed:** 20  
**Passed:** 19  
**Failed:** 1  
**Pass Rate:** 95%  
**Bugs Found:** 1 (Medium severity)

## Test Execution by Block

### Block 1: Basic Data Validation

**Test Cases:** 5  
**Passed:** 5  
**Failed:** 0  
**Pass Rate:** 100%

All basic data validation tests passed successfully. Database tables return data correctly, counts are accurate, date formats are valid, payment amounts are positive, and email formats are consistent.

### Block 2: JOINs & Relationships

**Test Cases:** 5  
**Passed:** 4  
**Failed:** 1  
**Pass Rate:** 80%

Most relationship tests passed, validating many-to-many relationships, aggregations, and orphan record checks. One data integrity issue discovered: 42 films exist without inventory copies (BUG-001).

**Failed Test:**
- TC-009: Film-Inventory relationship - Films without inventory copies found

### Block 3: Constraints & Integrity

**Test Cases:** 4  
**Passed:** 4  
**Failed:** 0  
**Pass Rate:** 100%

All constraint tests passed. Foreign key constraints are properly enforced. NOT NULL, UNIQUE, and CHECK constraints were tested and validated as per sakila schema design (some constraints intentionally not enforced in sample database).

### Block 4: Aggregate Functions

**Test Cases:** 3  
**Passed:** 3  
**Failed:** 0  
**Pass Rate:** 100%

All aggregate function tests passed successfully. COUNT(), SUM(), AVG(), MIN(), and MAX() functions work correctly with GROUP BY clauses.

### Block 5: Stored Procedures

**Test Cases:** 2  
**Passed:** 2  
**Failed:** 0  
**Pass Rate:** 100%

Both stored procedures tested (film_in_stock and film_not_in_stock) execute successfully and return correct results.

### Block 6: Advanced Queries

**Test Cases:** 1  
**Passed:** 1  
**Failed:** 0  
**Pass Rate:** 100%

Complex subquery test passed. Advanced SQL with nested subqueries and filtering works correctly.

## Bug Summary

**Total Bugs Found:** 1

### BUG-001: Films Exist Without Inventory Copies

**Severity:** Medium  
**Priority:** Medium  
**Status:** Open  
**Test Case:** TC-009

**Description:**  
42 films exist in the film table with zero inventory copies in the inventory table. These films appear in the catalog but cannot be rented, creating a poor user experience.

**Impact:**  
Medium - 4.2% of catalog (42 out of 1000 films) affected. Customers can search for these films but will never find them available.

**Sample Films Affected:**  
ALICE FANTASIA, APOLLO TEEN, ARGONAUTS TOWN, ARK RIDGEMONT, ARSENIC INDEPENDENCE, and 37 more.

**Recommendation:**  
Add inventory copies for these films, implement an availability flag, or confirm this is expected behavior for discontinued films.

**Evidence:**  
TC-009_films_without_inventory_BUG.jpg

## Test Coverage Analysis

### Areas Fully Tested

**Data Validation:**  
- Basic data retrieval and format validation
- Date and time formats
- Email formats
- Numeric data validation

**SQL Operations:**  
- SELECT queries with WHERE clauses
- INNER JOIN operations
- LEFT JOIN operations
- GROUP BY with aggregate functions
- Subqueries and nested queries
- ORDER BY and LIMIT clauses

**Database Integrity:**  
- Foreign key constraints
- Referential integrity
- Data consistency across tables
- Orphaned record detection

**Stored Procedures:**  
- Procedure execution
- Input parameter handling
- Output parameter retrieval

### Test Effectiveness

**Data Integrity Testing:** Highly effective - discovered one legitimate data quality issue (42 films without inventory)

**Constraint Testing:** Effective - validated that foreign keys are enforced and confirmed schema design for other constraints

**Relationship Testing:** Effective - all JOIN operations validated, many-to-many relationships confirmed

**Stored Procedure Testing:** Effective - both procedures tested successfully

## Environment Details

**Database System:**  
MySQL 8.0.45

**Testing Tool:**  
MySQL Workbench 8.0.40

**Test Database:**  
sakila (official MySQL sample database)

**Database Statistics:**  
- Tables: Core transactional tables (actor, film, customer, rental, payment, inventory, store, staff, etc.)
- Total Rentals: 16,044
- Total Films: 1,000
- Total Customers: 599
- Categories: 16

**Operating System:**  
Windows (MySQL Workbench running on local machine)

## Test Execution Metrics

**Time Investment:**

Test Execution: 2-3 hours  
Bug Investigation: ~60 minutes  
Documentation: 1-2 hours  
Total Project Time: ~5-6 hours

**Test Case Distribution:**

Basic Validation: 25% (5 TCs)  
Relationships: 25% (5 TCs)  
Constraints: 20% (4 TCs)  
Aggregates: 15% (3 TCs)  
Stored Procedures: 10% (2 TCs)  
Advanced Queries: 5% (1 TC)

**Evidence Collected:**

Screenshots: 20 (one per test case)  
SQL Queries: 20 (documented in SQL-Test-Queries.sql)  
Bug Reports: 1 (documented in Jira)

## Quality Assessment

### Strengths

**Data Quality:** Overall data quality is good with 95% pass rate. Only one data integrity issue identified.

**Schema Design:** Foreign key constraints are properly implemented and enforced. Referential integrity is maintained across tables.

**Stored Procedures:** Both tested procedures function correctly and return expected results.

**SQL Functionality:** All tested SQL operations (SELECT, JOIN, aggregates, subqueries) work as expected.

### Areas for Improvement

**Inventory Management:** 42 films lack inventory copies. This should be addressed with either:
- Adding inventory records for these films
- Implementing an availability flag
- Removing unrentable films from customer-facing queries

**Constraint Coverage:** While sakila is a sample database, production systems should consider:
- NOT NULL constraint on customer.email
- UNIQUE constraint on customer.email
- CHECK constraint on payment.amount (must be positive)

## Recommendations

### Immediate Actions

1. **Address BUG-001:** Decide whether to add inventory, implement availability flags, or document as expected behavior
2. **Update Documentation:** Document that 42 films are intentionally kept without inventory (if this is the case)

### Short-term Improvements

3. **Query Optimization:** For customer-facing queries, filter out films with zero inventory
4. **Business Rules:** Clarify and document business rules for films without inventory

### Long-term Considerations

5. **Availability View:** Create database view that shows only rentable films
6. **Constraint Enhancement:** Consider adding constraints for production systems (NOT NULL, UNIQUE, CHECK)
7. **Automated Testing:** Consider automating repetitive data validation tests

## Lessons Learned

### Technical Lessons

**Schema Verification is Critical:**  
Initially identified 3 additional "bugs" related to constraints (TC-012, TC-013, TC-014), but schema verification revealed these were expected behavior for sakila database. Always verify schema design before declaring constraint bugs.

**LEFT JOIN for Data Integrity:**  
Using LEFT JOIN with NULL checks is highly effective for finding orphaned records and data integrity issues.

**Aggregate Functions with HAVING:**  
Combining COUNT() with HAVING clause effectively identifies records with zero relationships.

### Process Lessons

**Screenshot Everything:**  
Visual evidence for every test case is essential for documentation and portfolio demonstration.

**Query Documentation:**  
Maintaining a separate SQL file with all queries used makes testing reproducible and helps with documentation.

**Bug Investigation:**  
Take time to investigate apparent bugs thoroughly before reporting them as defects.

## Skills Demonstrated

This project successfully demonstrates:

- Manual database testing methodology
- SQL query proficiency (SELECT, JOIN, aggregates, subqueries)
- Data integrity validation techniques
- Database constraint testing
- Stored procedure testing
- Bug identification and documentation
- Professional QA documentation
- Jira defect tracking
- MySQL Workbench proficiency
- Systematic test approach

## Conclusion

The P5 Database SQL Testing project successfully executed 20 test cases with a 95% pass rate. One data integrity issue was identified and documented. The testing validated that the sakila database has generally good data quality, proper foreign key enforcement, and functional stored procedures.

The bug discovered (42 films without inventory) is a legitimate data quality concern that should be addressed either through adding inventory records or implementing an availability flag system.

All test artifacts have been documented including test cases, SQL queries, screenshots, and bug reports. The project demonstrates comprehensive manual database testing skills and professional QA documentation practices.

**Document prepared by:** Artur Dmytriyev, QA Software Engineer  
**Date:** February 2026  
**Status:** Final - Testing Complete
