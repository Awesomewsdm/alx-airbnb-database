
```sql
-- Users
INSERT INTO Users (user_id, first_name, last_name, email, password_hash, role)
VALUES 
(UUID(), 'Ama', 'Mensah', 'ama@example.com', 'hashed_pw1', 'guest'),
(UUID(), 'Kwame', 'Boateng', 'kwame@example.com', 'hashed_pw2', 'host'),
(UUID(), 'Akosua', 'Adjei', 'akosua@example.com', 'hashed_pw3', 'host');

-- Properties
INSERT INTO Properties (property_id, host_id, name, description, location, pricepernight)
VALUES
(UUID(), (SELECT user_id FROM Users WHERE email='kwame@example.com'), 'Beach House', 'A beautiful beachside property', 'Cape Coast', 200.00),
(UUID(), (SELECT user_id FROM Users WHERE email='akosua@example.com'), 'City Apartment', 'Modern apartment in Accra', 'Accra', 100.00);

-- Bookings
INSERT INTO Bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
(UUID(), (SELECT property_id FROM Properties WHERE name='Beach House'), (SELECT user_id FROM Users WHERE email='ama@example.com'), '2025-09-01', '2025-09-05', 800.00, 'confirmed');

-- Payments
INSERT INTO Payments (payment_id, booking_id, amount, payment_method)
VALUES
(UUID(), (SELECT booking_id FROM Bookings LIMIT 1), 800.00, 'credit_card');

-- Reviews
INSERT INTO Reviews (review_id, property_id, user_id, rating, comment)
VALUES
(UUID(), (SELECT property_id FROM Properties WHERE name='Beach House'), (SELECT user_id FROM Users WHERE email='ama@example.com'), 5, 'Amazing stay, will come again!');

-- Messages
INSERT INTO Messages (message_id, sender_id, recipient_id, message_body)
VALUES
(UUID(), (SELECT user_id FROM Users WHERE email='ama@example.com'), (SELECT user_id FROM Users WHERE email='kwame@example.com'), 'Hello, is the beach house available in October?');