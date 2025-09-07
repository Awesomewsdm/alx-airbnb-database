# Airbnb Advanced Database Project

This project is part of the **ALX Airbnb Database Module**.  
It focuses on advanced SQL techniques such as joins, subqueries, aggregations, window functions, indexing, and optimization for performance in large-scale relational databases.

---

## 📌 Project Overview
We work with a simulated **Airbnb database** containing:
- `users` – information about Airbnb users
- `properties` – listings available for booking
- `bookings` – reservations made by users
- `reviews` – feedback provided by users on properties

Through progressively complex tasks, this project builds skills in:
- Writing complex **SQL queries** (joins, subqueries, window functions).
- Performing **data analysis** with aggregations.
- Practicing **optimization strategies** like indexing and partitioning.
- Using **performance monitoring tools** such as `EXPLAIN` and `ANALYZE`.

---

## 🛠️ Requirements
- Strong understanding of **SQL fundamentals** (SELECT, WHERE, GROUP BY).
- Knowledge of **keys and relationships** (primary keys, foreign keys).
- Familiarity with **EXPLAIN / ANALYZE** for query performance.
- Ability to use Git/GitHub for submission.

---

## 📂 Repository Structure

alx-airbnb-database/
└── database-adv-script/
├── joins_queries.sql
├── subqueries.sql
├── aggregations_and_window_functions.sql
└── README.md


---

## ✅ Tasks

### **0. Write Complex Queries with Joins**  
File: `joins_queries.sql`

- INNER JOIN → Retrieve all bookings and their respective users.  
- LEFT JOIN → Retrieve all properties and their reviews (including properties with no reviews).  
- FULL OUTER JOIN → Retrieve all users and all bookings (even if unmatched).  

---

### **1. Practice Subqueries**  
File: `subqueries.sql`

- Find all properties with an **average rating greater than 4.0** (subquery).  
- Find users who have made **more than 3 bookings** (correlated subquery).  

---

### **2. Apply Aggregations and Window Functions**  
File: `aggregations_and_window_functions.sql`

- Find the **total number of bookings per user** using COUNT + GROUP BY.  
- Rank properties based on the **total number of bookings** using RANK().  

---

## 🚀 How to Run the Queries
1. Load the Airbnb schema into your SQL environment (MySQL/PostgreSQL).  
2. Open each `.sql` file in your SQL client or run from CLI:
   ```bash
   mysql -u username -p < joins_queries.sql
   ```

or

   ```bash
psql -U username -d airbnb_db -f joins_queries.sql

```