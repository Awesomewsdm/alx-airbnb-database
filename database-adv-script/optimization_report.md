# Optimization Report

## Objective
Refactor a complex query that joined bookings, users, properties and payments to reduce execution time and resource usage.

## Baseline query
- File: `perfomance.sql` (initial query)
- Characteristics:
  - Multiple LEFT JOINs including payments.
  - WHERE included `pay.status = 'completed'`, which can cause unexpected behavior when used with LEFT JOIN.
  - Returned many columns, risking higher I/O and network transfer.

## Findings (after EXPLAIN ANALYZE)
- The query performed sequential scans on `payments` and `bookings`.
- There were duplicates for bookings when payments had multiple rows per booking.
- Planner estimated rows poorly (estimates vs actual mismatch), indicating stale statistics.

## Actions taken
1. Created indexes:
   - `bookings(start_date)`
   - `payments(booking_id, status)`
   - `bookings(property_id)` and `bookings(user_id)` if missing.
2. Refactored query:
   - Pre-filter payments with a CTE `completed_payments` to reduce rows.
   - Used `JOIN` semantics consistent with data expectations (only bookings with completed payments).
   - Selected only necessary columns.
3. Ran `ANALYZE` on affected tables.

## Results (how to record them)
- Paste EXPLAIN ANALYZE before and after.
- Key improvements to expect:
  - Reduced total runtime (ms).
  - Index scan used instead of seq scan on payments and bookings.
  - Fewer rows processed overall.

## Recommendations
- Add partial indexes for common date ranges (e.g. recent 30 days) to speed recent queries.
- Maintain statistics: schedule `VACUUM ANALYZE` (Postgres).
- Consider materialized views for highly expensive aggregated reports (refresh periodically).
