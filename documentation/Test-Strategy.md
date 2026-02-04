# Test Strategy - Database SQL Testing Project

## Document Information

**Project:** P5 - Database SQL Testing  
**Author:** Artur Dmytriyev, QA Software Engineer  
**Date:** February 2026  
**Version:** 1.0  
**Status:** Final

## 1. Introduction

### 1.1 Purpose

This document outlines the comprehensive testing strategy for manual database testing of the MySQL sakila sample database. The primary objective is to validate database integrity, data consistency, SQL functionality, and identify potential data quality issues through systematic manual testing.

### 1.2 Scope

**In Scope:**
- Data validation and integrity checks
- SQL query functionality (SELECT, JOIN, aggregates, subqueries)
- Database relationships and foreign key constraints
- Stored procedure testing
- Data format validation
- Business logic validation through data analysis

**Out of Scope:**
- Automated testing scripts
- Performance/load testing
- Security penetration testing
- Database optimization
- Schema design changes

## 2. Test Approach

### 2.1 Testing Methodology

Manual testing combining exploratory techniques with predefined structured test cases covering:

1. Basic Data Validation - Verify core data integrity and formats
2. Relationship Testing - Validate JOIN operations and foreign keys
3. Constraint Testing - Test database constraints (FK, NOT NULL, UNIQUE, CHECK where applicable)
4. Aggregate Functions - Verify SQL aggregate operations
5. Stored Procedures - Test pre-built database procedures
6. Advanced Queries - Complex SQL with subqueries and multiple JOINs

### 2.2 Bug Hunting Strategy

Rather than exhaustive testing, this project focuses on strategic bug hunting:
- Identify high-risk areas (relationships, data integrity)
- Use LEFT JOINs to find orphaned records
- Validate business logic through data analysis
- Document findings with visual evidence

## 3. Test Environment

### 3.1 Technology Stack

**Database:** MySQL 8.0.45 - Core database system  
**Tool:** MySQL Workbench 8.0.40 - Query execution and testing  
**Test Database:** sakila - Sample DVD rental database  
**Documentation:** Markdown - Test case documentation  
**Bug Tracking:** Jira (P5SQL project) - Defect management

### 3.2 Database Information

**Sakila Database:**

**Type:** Sample DVD rental store database  
**Tables:** Focus on core transactional tables (actor, film, customer, rental, payment, inventory, store, staff, etc.)  
**Records:** 16,044 rentals, 1,000 films, 599 customers  
**Relationships:** Multiple one-to-many and many-to-many relationships  
**Features:** Stored procedures, triggers, views

### 3.3 Test Data

Using production-like sample data from sakila database:
- Real-world relational complexity
- Multiple table relationships
- Sufficient data volume for meaningful testing
- Pre-configured constraints and stored procedures

## 4. Test Coverage

### 4.1 Test Blocks Overview

**Block 1: Basic Data Validation - 5 test cases - Risk Level: Low**  
**Block 2: JOINs & Relationships - 5 test cases - Risk Level: High**  
**Block 3: Constraints & Integrity - 4 test cases - Risk Level: Medium**  
**Block 4: Aggregate Functions - 3 test cases - Risk Level: Low**  
**Block 5: Stored Procedures - 2 test cases - Risk Level: Medium**  
**Block 6: Advanced Queries - 1 test case - Risk Level: Medium**

**Total: 20 test cases**

### 4.2 Detailed Test Coverage

**Block 1: Basic Data Validation (5 TCs)**

- TC-001: Actor table data retrieval
- TC-002: Film count validation
- TC-003: Date format verification
- TC-004: Payment amount validation
- TC-005: Email format validation

Focus: Ensure basic data integrity and proper formatting.

**Block 2: JOINs & Relationships (5 TCs)**

- TC-006: Actor-Film many-to-many relationship
- TC-007: Customer-Rental aggregation
- TC-008: Payment-Rental orphan check
- TC-009: Film-Inventory relationship
- TC-010: Store-Manager relationship

Focus: Validate foreign key relationships and identify orphaned records.

**Block 3: Constraints & Integrity (4 TCs)**

- TC-011: Foreign Key constraint testing
- TC-012: NOT NULL constraint verification
- TC-013: UNIQUE constraint validation
- TC-014: CHECK constraint testing

Focus: Verify database constraints enforcement and identify gaps between schema and business rules.

**Block 4: Aggregate Functions (3 TCs)**

- TC-015: COUNT() with GROUP BY
- TC-016: SUM() and AVG() calculations
- TC-017: MIN() and MAX() range analysis

Focus: Test SQL aggregate functions and grouping.

**Block 5: Stored Procedures (2 TCs)**

- TC-018: film_in_stock procedure
- TC-019: film_not_in_stock procedure

Focus: Validate pre-built stored procedure functionality.

**Block 6: Advanced Queries (1 TC)**

- TC-020: Complex subquery with filtering

Focus: Test advanced SQL capabilities and complex logic.

## 5. Entry and Exit Criteria

### 5.1 Entry Criteria

- MySQL 8.0+ installed and configured
- MySQL Workbench installed
- Sakila database imported successfully
- Test case documentation prepared
- Jira project created for defect tracking

### 5.2 Exit Criteria

- All 20 test cases executed
- Test results documented with screenshots
- Bugs identified and documented in Jira
- Test execution summary completed
- Final test report prepared

## 6. Defect Management

### 6.1 Defect Classification

**Severity Levels:**

- **Critical:** Data loss, database corruption, system crash
- **High:** Major functionality broken, no workaround
- **Medium:** Functionality impaired, workaround available
- **Low:** Minor issues, cosmetic problems

**Priority Levels:**

- **High:** Fix immediately
- **Medium:** Fix in current cycle
- **Low:** Fix when time permits

### 6.2 Defect Workflow

1. Discovery: Identify issue during test execution
2. Documentation: Screenshot + detailed description
3. Classification: Assign severity and priority
4. Logging: Create Jira ticket with evidence
5. Verification: Retest after fix (future)

### 6.3 Bug Reporting Template

Each defect includes:
- Summary: Clear, concise description
- Test Case ID: TC-XXX reference
- Environment: MySQL version, database details
- Steps to Reproduce: SQL query used
- Expected Result: What should happen
- Actual Result: What actually happened
- Evidence: Screenshot attachment
- Severity/Priority: Classification
- Recommendations: Suggested fixes

## 7. Test Execution Process

### 7.1 Execution Workflow

1. Open MySQL Workbench
2. Connect to sakila database
3. Execute test case SQL query
4. Review Result Grid
5. Compare with expected result
6. Take screenshot (PASS or FAIL)
7. Save screenshot with TC-XXX naming
8. Document result
9. If FAIL → Create defect report
10. Proceed to next test case

### 7.2 Screenshot Guidelines

- Capture: Full Result Grid with column headers
- Naming: TC-XXX_description_STATUS.jpg
- Content: Query visible, results clear
- Quality: High resolution, readable text
- Storage: test-results/screenshots/ directory

### 7.3 Documentation Standards

- All test cases documented in Database-Test-Cases.md
- SQL queries saved in SQL-Test-Queries.sql
- Bugs documented in Bug-Reports.md and Jira
- Final summary in Test-Execution-Summary.md

## 8. Risks and Mitigation

### 8.1 Identified Risks

**Risk: Data inconsistency in sakila**  
Impact: Medium | Probability: Low  
Mitigation: Use official MySQL sakila download

**Risk: Query syntax errors**  
Impact: Low | Probability: Medium  
Mitigation: Test queries incrementally

**Risk: Missing database constraints**  
Impact: High | Probability: Medium  
Mitigation: Identify missing constraints through testing and document recommendations for production environments

**Risk: Incomplete test coverage**  
Impact: Medium | Probability: Low  
Mitigation: Follow structured test plan

### 8.2 Assumptions

- Sakila database is properly installed and configured
- MySQL Workbench functions correctly
- Sample data represents realistic scenarios
- Database constraints may not fully enforce business rules in the sakila sample database

## 9. Deliverables

### 9.1 Test Artifacts

- Test Strategy document (this document)
- Test Cases documentation (Database-Test-Cases.md)
- SQL query repository (SQL-Test-Queries.sql)
- Test execution screenshots (20 total)
- Bug reports (Bug-Reports.md + Jira)
- Test execution summary (Test-Execution-Summary.md)
- Database schema overview (Database-Schema-Overview.md)
- Project README (README.md)

### 9.2 Final Report Contents

- Test execution metrics (pass/fail rates)
- Bug summary and severity breakdown
- Coverage analysis
- Recommendations
- Lessons learned

## 10. Success Criteria

### 10.1 Project Success Metrics

- Coverage: All 20 test cases executed
- Documentation: Complete test documentation
- Evidence: Screenshots for all test cases
- Defect Tracking: Bugs properly documented
- Quality: Professional portfolio-ready deliverables

### 10.2 Skills Demonstrated

- Manual database testing methodology
- SQL query proficiency (SELECT, JOIN, aggregates, subqueries)
- Data integrity validation
- Database constraint testing
- Stored procedure testing
- Bug identification and documentation
- Professional QA documentation
- Jira defect tracking

## 11. Test Execution Breakdown

**Test Execution:** 2-3 hours  
**Documentation:** 1-2 hours  
**Bug Investigation & Reporting:** ~60 minutes

## 12. References

- MySQL 8.0 Documentation: https://dev.mysql.com/doc/
- Sakila Database: https://dev.mysql.com/doc/sakila/en/
- SQL Best Practices: Industry standards for manual DB testing

**Document prepared by:** Artur Dmytriyev, QA Software Engineer  
**Last Updated:** February 2026  
**Status:** Final - All testing completed
