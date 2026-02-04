# Bug Reports - P5 Database SQL Testing

## Document Information

**Project:** P5 - Database SQL Testing  
**Author:** Artur Dmytriyev, QA Software Engineer 
**Date:** February 2026  
**Total Bugs Found:** 1  
**Status:** Documented in Jira (Project: P5SQL)

## Bug Summary

**Total Bugs:** 1

**BUG-001:**
- Summary: Films exist without inventory copies
- Severity: Medium (sample database context)
- Priority: Medium
- Status: Open
- Test Case: TC-009

## BUG-001: Films Exist Without Inventory Copies

### Basic Information

**Bug ID:** BUG-001  
**Type:** Data Consistency Issue / Business Rule Violation  
**Severity:** Medium (in sample database context; would be High in production)  
**Priority:** Medium  
**Status:** Open  
**Found By:** Artur Dmytriyev  
**Date Found:** February 2026  
**Test Case:** TC-009 - Film-Inventory relationship validation  
**Jira Ticket:** P5SQL project

### Summary

Database contains 42 films in the film catalog that have zero inventory copies, making them unrentable. These films appear in the film table but have no corresponding entries in the inventory table.

While this may be expected behavior for the sakila sample database (discontinued or historical films), it violates the assumed business rule that all catalog films must be rentable or explicitly marked as unavailable. This represents a business rule violation rather than a data corruption issue.

### Environment

**Database:** MySQL 8.0.45  
**Database Name:** sakila  
**Tables Affected:** film, inventory  
**Tool Used:** MySQL Workbench 8.0.40

### Steps to Reproduce

1. Connect to sakila database in MySQL Workbench
2. Execute the following SQL query:
```sql
SELECT f.film_id, f.title, COUNT(i.inventory_id) as total_copies
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(i.inventory_id) = 0
ORDER BY f.title;
```

3. Observe query results showing films with 0 inventory copies

### Expected Result

One of the following should be true:

1. All films in the film table should have at least 1 inventory copy in the inventory table
2. Films without inventory should have an is_available or active flag set to FALSE
3. Films without inventory should not appear in customer-facing catalog queries

**Business Rule Assumption:** Catalog should only display rentable films, or clearly mark unavailable items.

### Actual Result

Query returns 42 films with total_copies = 0, meaning these films exist in the catalog but have no physical inventory records at any store.

**Validation Note:** This assumes customer-facing queries are based on the film table without filtering by inventory availability. If catalog queries already filter by inventory existence, the impact is reduced to data housekeeping rather than user-facing issue.

**Sample Films Affected:**

- ALICE FANTASIA (film_id: 14)
- APOLLO TEEN (film_id: 33)
- ARGONAUTS TOWN (film_id: 36)
- ARK RIDGEMONT (film_id: 38)
- ARSENIC INDEPENDENCE (film_id: 41)
- BOONDOCK BALLROOM (film_id: 87)
- BUTCH PANTHER (film_id: 108)
- CATCH AMISTAD (film_id: 128)
- CHINATOWN GLADIATOR (film_id: 144)
- CHOCOLATE DUCK (film_id: 148)
- ...and 32 more films

**Total Films Affected:** 42 out of 1000 (4.2% of catalog)

### Impact Analysis

**Business Impact:**

Customers searching the catalog may find these films but never see them available for rental. This creates confusion and poor user experience. Potential revenue loss for 4.2% of catalog if these films should have inventory. Also indicates possible incomplete data migration or business rule gap in catalog management.

**Technical Impact:**

Data consistency concern between film and inventory tables. Possible business logic gap in catalog display versus rental availability. May indicate missing records from data migration or incomplete inventory setup. Does not represent database corruption or constraint violation - referential integrity is maintained.

**User Impact:** Medium

Severity is Medium assuming sample database context where this may be intentional for demonstration purposes. In production environment, this would be High severity due to direct revenue and UX impact.

**Store-Specific Consideration:** This analysis shows global inventory counts across all stores. Individual store availability was not tested. A film may have inventory at Store 1 but not Store 2, which would require store-specific filtering in production queries.

### Root Cause Analysis

**Possible Causes:**

1. **Incomplete Data Migration:** Inventory records were not created for all films during database setup
2. **Business Rule:** Films intentionally kept in catalog as "discontinued" or "out of stock" items for historical reference
3. **Missing Inventory:** Physical DVD copies were lost, damaged, or never purchased for these titles
4. **Data Entry Error:** Films added to catalog but inventory creation step skipped

**Most Likely Cause:**

This appears to be expected behavior for the sakila sample database, where some films exist as catalog entries without physical inventory to demonstrate various data scenarios. However, this behavior violates the assumed business rule that all catalog films must be rentable or explicitly marked as unavailable, making it valid to report as a data consistency issue.

### Recommendations

**Immediate Actions:**

1. Add an is_available or active boolean field in the film table to distinguish rentable versus discontinued films
2. Update customer-facing catalog queries to filter by inventory availability:
```sql
-- Recommended catalog query
SELECT DISTINCT f.film_id, f.title
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = ?;
```

**Short-term Actions:**

3. If these films should be rentable, add inventory entries for them
4. Confirm with product owner if films without inventory should remain in catalog
5. Document business rules for catalog versus inventory relationship

**Long-term Actions:**

6. Create a database view that shows only rentable films with current availability
7. Implement availability indicators in UI for films with zero current inventory
8. Add business rule validation during film creation to require minimum inventory

### Evidence

**Screenshot:** TC-009_films_without_inventory_BUG.jpg

**Query Results Preview:**
```
film_id: 14  | title: ALICE FANTASIA        | total_copies: 0
film_id: 33  | title: APOLLO TEEN           | total_copies: 0
film_id: 36  | title: ARGONAUTS TOWN        | total_copies: 0
film_id: 38  | title: ARK RIDGEMONT         | total_copies: 0
...
(42 rows total)
```

### Workaround

**Current Workaround (Basic):**

Filter out films with 0 inventory in application-level queries:
```sql
SELECT f.film_id, f.title, COUNT(i.inventory_id) as available_copies
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(i.inventory_id) > 0;
```

**Important Limitation:** This workaround only ensures existence of inventory records, not actual rental availability. It does not consider:
- Currently rented copies (active rentals)
- Store-specific inventory distribution
- Reserved or damaged inventory

Production systems would need more sophisticated availability logic combining inventory existence, rental status, and store location.

### Additional Notes

- This issue is consistent across the entire sakila database
- All 42 films have valid data in other columns (title, description, rating, etc.)
- The films span multiple categories and ratings
- No pattern identified in which films lack inventory (appears random)
- This may be intentional sample data behavior to demonstrate various test scenarios
- Foreign key relationships are intact - no referential integrity violations

### Related Test Cases

- **TC-009:** Film-Inventory relationship (where bug was discovered)
- **TC-006:** Actor-Film relationship (validated these films exist in catalog)
- **TC-002:** Total films count (confirms 1000 films in database, 42 unrentable)
- **TC-010:** Store-Manager relationship (validated store data structure)

### Follow-up Actions

- Clarify with stakeholder if this is expected behavior for sample database
- Document business rule for films without inventory in production scenarios
- Update catalog queries to handle zero-inventory films appropriately
- Consider implementing availability flag for production use
- Retest after fix implementation or business rule clarification

## Overall Bug Statistics

**Total Bugs Found:** 1

**By Severity:**
- Critical: 0
- High: 0
- Medium: 1
- Low: 0

**By Type:**
- Data Consistency / Business Rule: 1
- Functional: 0
- Performance: 0

**By Status:**
- Open: 1
- Fixed: 0

## Testing Notes

**Bug Discovery Method:** Systematic relationship testing using LEFT JOIN queries to identify films without corresponding inventory records.

**Test Coverage:** 20 test cases executed across 6 testing blocks. Bug found during Block 2 (JOINs & Relationships) testing, which specifically targets data consistency and referential completeness.

**Quality Assessment:** Bug discovery rate of 5% indicates generally good data quality with one notable business rule consistency concern. The issue represents a gap between catalog management and inventory tracking rather than database corruption.

**Document prepared by:** Artur Dmytriyev, QA Software Engineer
**Last Updated:** February 2026  
**Jira Project:** P5SQL  
**Status:** Final - Bug documented and tracked
