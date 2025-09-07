-- Indexes for User table
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_created_at ON Users(created_at);
CREATE INDEX idx_users_status ON Users(status);

-- Indexes for Property table
CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_property_price ON Property(price);
CREATE INDEX idx_property_status ON Property(status);
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Indexes for Booking table
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_end_date ON Booking(end_date);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Indexes for Payment table
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);
CREATE INDEX idx_payment_status ON Payment(status);
CREATE INDEX idx_payment_created_at ON Payment(created_at);

-- Composite indexes for common query patterns
CREATE INDEX idx_booking_dates_status ON Booking(start_date, end_date, status);
CREATE INDEX idx_property_location_price ON Property(location, price);
CREATE INDEX idx_users_email_status ON Users(email, status);