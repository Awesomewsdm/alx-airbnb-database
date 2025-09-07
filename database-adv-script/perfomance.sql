-- Initial complex query to retrieve all bookings with user, property, and payment details
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
