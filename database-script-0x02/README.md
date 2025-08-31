# Airbnb Database Seed Data

This directory contains SQL scripts to populate the database with sample data.

## Files
- `seed.sql`: SQL INSERT statements for Users, Properties, Bookings, Payments, Reviews, and Messages.

## Usage
Run after creating the schema:

```bash
mysql -u username -p < seed.sql
