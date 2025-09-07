---
# Index Performance Report

## Goal
Identify high-usage columns and add indexes to improve read/query performance. Measure performance before and after adding indexes.

## Candidate High-Usage Columns

- `bookings.user_id`, `bookings.property_id`, `bookings.start_date`
- `properties.owner_id`, `properties.location`
- `users.email`
- `reviews.property_id`, `reviews.user_id`

## Files

- `database_index.sql` — contains CREATE INDEX commands.

## How to Measure (PostgreSQL Examples)

1. **Gather baseline:** Run `EXPLAIN ANALYZE` on target queries before creating indexes.

   ```sql
   EXPLAIN ANALYZE
   SELECT b.id, b.start_date, u.id, u.name
   FROM bookings b
   JOIN users u ON b.user_id = u.id
   WHERE b.start_date BETWEEN '2024-01-01' AND '2024-01-31';
   ```

2. **Create indexes:** Run `database_index.sql`.

3. **Re-run EXPLAIN ANALYZE** on the same query:

   ```sql
   EXPLAIN ANALYZE
   SELECT b.id, b.start_date, u.id, u.name
   FROM bookings b
   JOIN users u ON b.user_id = u.id
   WHERE b.start_date BETWEEN '2024-01-01' AND '2024-01-31';
   ```

4. **Compare metrics (before → after):**
   - Total runtime (ms)
   - Planning time / Execution time
   - Whether sequential scan changed to index scan
   - Rows estimates vs actual rows (to detect stale stats)

### What to Record in This Report

- Query text
- EXPLAIN ANALYZE (before) — paste output
- Indexes added
- EXPLAIN ANALYZE (after) — paste output
- Observed improvements:
  - Reduced execution time (ms)
  - Changed scan type (Seq Scan → Index Scan)
  - Improved I/O or CPU

## Notes / Best Practices

- Run `ANALYZE` after creating indexes:
  ```sql
  ANALYZE bookings;
  ```
- Consider partial indexes for common filters to save space:
  ```sql
  CREATE INDEX ON bookings (property_id) WHERE start_date >= current_date - interval '30 days';
  ```
- Monitor insert/update cost: indexes speed reads but slow writes.

---

# 3) `perfomance.sql`

Initial complex query + refactored optimized query

## Initial (Naive) Complex Query

```sql
-- Retrieve booking, user, property and payment details
SELECT b.id AS booking_id,
       b.user_id,
       u.name AS user_name,
       u.email AS user_email,
       b.property_id,
       p.name AS property_name,
       p.location,
       pay.id AS payment_id,
       pay.amount,
       pay.status,
       b.start_date,
       b.end_date
FROM bookings b
LEFT JOIN users u ON b.user_id = u.id
LEFT JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON pay.booking_id = b.id
WHERE b.start_date BETWEEN '2024-01-01' AND '2024-01-31'
  AND pay.status = 'completed'
ORDER BY b.start_date DESC;
```

### Notes on Inefficiencies in Initial Query

1. `pay.status` filter on LEFT JOINed payments can turn LEFT JOIN into an effective inner join.
2. Selecting many columns may increase IO; select only needed columns.
3. If payments has multiple rows per booking, results will duplicate bookings.
4. Missing indexes may force sequential scans on bookings, payments.

## Refactored Query (Optimized)

**Strategy:**
- Filter payments first in a CTE to reduce rows.
- Use INNER JOIN where semantically valid (only completed payments required).
- Select only needed columns.
- Rely on indexes: `bookings(start_date)`, `bookings(property_id)`, `payments(booking_id, status)`

```sql
WITH completed_payments AS (
    SELECT DISTINCT ON (booking_id) booking_id, id AS payment_id, amount, status
    FROM payments
    WHERE status = 'completed'
    -- ORDER BY booking_id, created_at DESC  -- keep latest payment per booking if needed
)
SELECT b.id AS booking_id,
       b.start_date,
       b.end_date,
       u.id AS user_id,
       u.name AS user_name,
       p.id AS property_id,
       p.name AS property_name,
       cp.payment_id,
       cp.amount
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN completed_payments cp ON cp.booking_id = b.id
WHERE b.start_date >= '2024-01-01'
  AND b.start_date < '2024-02-01'
ORDER BY b.start_date DESC;
```

### Additional Optimizations to Try

1. Ensure indexes:
   - `bookings(start_date)`
   - `bookings(user_id)` / `bookings(property_id)`
   - `payments(booking_id, status)`
2. If selecting a paginated window, use keyset pagination instead of OFFSET.
3. Limit the number of rows returned when appropriate: add `LIMIT`.