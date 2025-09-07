sql
sql
---
# Partition Performance Report

## Goal
Partition the `bookings` table by `start_date` to improve date-range query performance.

## Steps Performed

1. Implemented RANGE partitioning on `start_date` (see `partitioning.sql`).
2. Created yearly partitions for 2022, 2023, 2024, and a default partition for others.
3. Migrated data into the partitioned table (if applicable).
4. Created indexes on hot partitions (e.g., latest year).

## How to Test and Measure

### Baseline

```sql
EXPLAIN ANALYZE SELECT COUNT(*) FROM bookings WHERE start_date BETWEEN '2024-01-01' AND '2024-01-31';
```

Capture baseline output.

### After Partitioning (on `bookings_part`)

```sql
EXPLAIN ANALYZE SELECT COUNT(*) FROM bookings_part WHERE start_date BETWEEN '2024-01-01' AND '2024-01-31';
```

#### Compare:
- Whether planner pruned partitions (look for "Partition Prune" or only scanning single partition)
- Execution time reduction
- I/O reduction

## Expected Improvements

- Partition pruning should scan only the matching partition(s) instead of the whole table
- Significant reduction in query time for date-bound queries
- Better local index usage (indexes per partition)

## Caveats

- No global indexes in some Postgres versions — need to create indexes per partition
- Partitioning improves reads for partitioned key queries, but may not help queries that don’t filter by `start_date`
- Added complexity for inserts (new partitions), constraints, maintenance

## Suggestions

- Automate partition creation (cron job or scheduled task) for new date ranges
- Monitor partitions for skew and re-balance if one partition becomes too large

---

# 7) `performance_monitoring.md`

## Performance Monitoring & Refinement

### Objective
Continuously monitor frequently used queries, analyze execution plans, and refine schema or queries.

### Tools / Commands

- **PostgreSQL:**
  - `EXPLAIN` — shows planner plan
  - `EXPLAIN ANALYZE` — runs the query and shows actual timings
  - `ANALYZE table_name;` — updates statistics
  - `VACUUM (VERBOSE, ANALYZE)` — maintain table health
  - `pg_stat_statements` extension — track slow queries over time
  - `SHOW work_mem;` and tune per-query memory settings for sorts/hashes

### Monitoring Workflow

1. Identify heavy queries:
   - Use `pg_stat_statements` to list top-by-total-time queries
2. For each heavy query:
   - Run `EXPLAIN ANALYZE` and paste the output
   - Look for Seq Scan, Hash Join vs Merge Join, Sort operations, and large memory spill messages
3. Fix strategy:
   - Add appropriate index or composite index
   - Re-write to reduce rows early (filter/join order or CTEs)
   - Use materialized view for expensive aggregations
   - Consider partitioning for large tables (e.g., bookings)
4. Post-change:
   - Re-run `EXPLAIN ANALYZE` and compare
   - Record before/after metrics (execution time, buffers read)

### Example Commands

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
```

### What to Record in Reports

- Query text
- EXPLAIN ANALYZE before
- Change made (index/partition/rewrite)
- EXPLAIN ANALYZE after
- Percent improvement in runtime
- Any negative effects (write slowdown, disk usage)

### Ongoing Maintenance

- Schedule regular VACUUM / ANALYZE
- Monitor growth of indexes and remove unused indexes
- Keep stats up-to-date to help planner make better decisions

