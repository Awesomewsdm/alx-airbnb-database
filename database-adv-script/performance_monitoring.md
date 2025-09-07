# Performance Monitoring & Refinement

## Objective
Continuously monitor frequently used queries, analyze execution plans, and refine schema or queries.

## Tools / Commands
- PostgreSQL:
  - `EXPLAIN` — shows planner plan.
  - `EXPLAIN ANALYZE` — runs the query and shows actual timings.
  - `ANALYZE table_name;` — updates statistics.
  - `VACUUM (VERBOSE, ANALYZE)` — maintain table health.
  - `pg_stat_statements` extension — track slow queries over time.
  - `SHOW work_mem;` and tune per-query memory settings for sorts/hashes.

## Monitoring workflow
1. Identify heavy queries:
   - Use `pg_stat_statements` to list top-by-total-time queries.
2. For each heavy query:
   - Run `EXPLAIN ANALYZE` and paste the output.
   - Look for Seq Scan, Hash Join vs Merge Join, Sort operations, and large memory spill messages.
3. Fix strategy:
   - Add appropriate index or composite index.
   - Re-write to reduce rows early (filter/join order or CTEs).
   - Use materialized view for expensive aggregations.
   - Consider partitioning for large tables (e.g., bookings).
4. Post-change:
   - Re-run `EXPLAIN ANALYZE` and compare.
   - Record before/after metrics (execution time, buffers read).

## Example commands
```sql
-- Identify slow queries (requires pg_stat_statements)
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;

-- Analyze a specific query
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT ...;

-- Update stats after data change
ANALYZE bookings;