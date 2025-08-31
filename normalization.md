# Database Normalization (Airbnb Schema)

## Step 1: First Normal Form (1NF)
- All attributes are atomic.
- No repeating groups.
- Example: In the `User` table, `first_name`, `last_name`, `email` are stored separately.

## Step 2: Second Normal Form (2NF)
- All non-key attributes fully depend on the primary key.
- No partial dependency on a part of a composite key.
- Example: In `Booking`, `start_date`, `end_date`, `status` depend entirely on `booking_id`.

## Step 3: Third Normal Form (3NF)
- No transitive dependencies (non-key attributes must not depend on another non-key attribute).
- Example: In `Property`, `location` depends only on `property_id`, not on `host_id`.

## Conclusion
The schema is already in **Third Normal Form (3NF)** and requires no structural adjustments.
