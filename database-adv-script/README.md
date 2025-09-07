# Airbnb Advanced Database Project

This project is part of the **ALX Airbnb Database Module**.  
It focuses on advanced SQL techniques such as joins, subqueries, aggregations, window functions, indexing, and optimization for performance in large-scale relational databases.


## 📌 Project Overview
We work with a simulated **Airbnb database** containing:

Through progressively complex tasks, this project builds skills in:


## 🛠️ Requirements


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
- FULL OUTER JOIN → Retrieve all users and all bookings (even if unmatched).  
---

### **1. Practice Subqueries**  
File: `subqueries.sql`
- Find users who have made **more than 3 bookings** (correlated subquery).  
---

### **2. Apply Aggregations and Window Functions**  
File: `aggregations_and_window_functions.sql`
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