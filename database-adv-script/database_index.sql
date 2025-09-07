-- Create index on users table (commonly used in JOINs and WHERE clauses)
CREATE INDEX idx_users_id ON users(id);

-- Create index on bookings table (user_id and property_id are frequently used in JOINs)
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Create index on properties table (frequently joined with bookings and filtered by location)
CREATE INDEX idx_properties_id ON properties(id);
CREATE INDEX idx_properties_location ON properties(location);

-- Measure query performance BEFORE and AFTER indexing using EXPLAIN ANALYZE

-- Example: Check performance of joining users and bookings
EXPLAIN ANALYZE
SELECT u.id, u.name, b.id, b.start_date, b.end_date
FROM users u
JOIN bookings b
    ON u.id = b.user_id;

-- Example: Check performance of joining bookings and properties
EXPLAIN ANALYZE
SELECT b.id, b.start_date, b.end_date, p.name, p.location
FROM bookings b
JOIN properties p
    ON b.property_id = p.id;

-- Example: Check performance of filtering properties by location
EXPLAIN ANALYZE
SELECT id, name, location
FROM properties
WHERE location = 'New York';
