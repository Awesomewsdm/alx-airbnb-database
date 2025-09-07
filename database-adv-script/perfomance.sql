-- perfomance.sql
-- Initial complex query (before optimization)
SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title AS property_title,
    p.location,
    p.price_per_night,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.status AS payment_status,
    pay.created_at AS payment_date
FROM Booking b
JOIN Users u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY b.created_at DESC
LIMIT 1000;


-- Analyze query performance using EXPLAIN
EXPLAIN
SELECT b.id AS booking_id,
       b.start_date,
       b.end_date,
       u.id AS user_id,
       u.name AS user_name,
       p.id AS property_id,
       p.name AS property_name,
       pay.id AS payment_id,
       pay.amount,
       pay.status
FROM bookings b
JOIN users u
    ON b.user_id = u.id
JOIN properties p
    ON b.property_id = p.id
JOIN payments pay
    ON b.id = pay.booking_id;
