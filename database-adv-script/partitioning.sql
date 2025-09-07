-- partitioning.sql
-- Partition the bookings table by RANGE on start_date (PostgreSQL example)
-- NOTE: run on a maintenance window. Back up data first.

-- 1. Create a new partitioned table (if bookings is currently a regular table).
-- If bookings already exists, you'd need to migrate data:
-- Steps overview:
--  - Create partitioned table bookings_part (same schema but declared PARTITION BY).
--  - Create partitions and copy data.
--  - Drop old table and rename.

-- Example assumes starting from scratch:

-- Create partitioned parent table
CREATE TABLE bookings_part (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    property_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMP DEFAULT now(),
    -- add other columns as in original table
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES properties(id)
) PARTITION BY RANGE (start_date);

-- Create yearly partitions (example)
CREATE TABLE bookings_2022 PARTITION OF bookings_part
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE bookings_2023 PARTITION OF bookings_part
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE bookings_2024 PARTITION OF bookings_part
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Optionally create a default partition for older/newer rows
CREATE TABLE bookings_others PARTITION OF bookings_part DEFAULT;

-- Add indexes on partitions (global indexes are not available on all versions)
CREATE INDEX idx_bookings_part_user_id_2024 ON bookings_2024 (user_id);
CREATE INDEX idx_bookings_part_start_date_2024 ON bookings_2024 (start_date);
-- Repeat for other partitions as needed or create templates via script.

-- Migration from old bookings to bookings_part (if original exists):
-- INSERT INTO bookings_part (id, user_id, property_id, start_date, end_date, created_at)
-- SELECT id, user_id, property_id, start_date, end_date, created_at FROM bookings;

-- After verification you may: drop old bookings and rename bookings_part to bookings.

-- 2. Testing queries on partitioned table
-- Run EXPLAIN ANALYZE on queries that filter by start_date. Partition pruning should limit scan to relevant partitions:
EXPLAIN ANALYZE
SELECT COUNT(*) FROM bookings_part
WHERE start_date BETWEEN '2024-01-01' AND '2024-01-31';

-- Partition maintenance:
-- - Create new partition for future ranges periodically.
-- - Consider partitioning by month if bookings are extremely high-volume.
