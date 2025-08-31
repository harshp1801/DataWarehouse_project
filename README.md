# 📊 Olist E-commerce Data Warehouse (SQL Server)

---

This project builds a SQL Server–based Data Warehouse using the Brazilian Olist E-commerce dataset.
It follows the Medallion Architecture (Bronze → Silver → Gold) to ensure data quality, scalability, and analytics readiness.
The warehouse supports KPI dashboards and business insights for e-commerce operations.

---

# 📂 Repository Structure

```
olist-sql-dwh/
│── README.md                # Documentation for GitHub
│── Schema_Architecture      # Any ER diagrams, architecture images, notes
│   ├── Bronze_schema.jpg
│   ├── Silver_schema.jpg
│   └── star_schema.png
│── Bronze                 # Raw schema + stored procs
│   ├── Bronze_Layer_Creation_query.sql
│   ├── Bronze_Layer_Stored_Procedure.sql
│── Silver                 # Star schema + stored procs
│   ├── Silver_Layer_Creation_query.sql
│   ├── Silver_Layer_Stored_Procedure.sql
│── Gold                   # Aggregates, views, KPIs
│   └── Gold_Layer_Query.sql
│── Validation              # Analysis + dashboards
│   ├── Bronze_Layer_Validation.sql
│   └── Silver_Layer_Validation.sql
│── SQLQuery_to_create_database.sql   # Database and Schema setup scripts    
```

---

## 🚀 Project Highlights

* **Database**: SQL Server
* **Architecture**: Medallion (Bronze → Silver → Gold)
* **Modeling**: Star Schema (Fact + Dimension tables)
* **Data**: [Olist Brazilian E-commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
* **Analytics**: KPI queries and dashboards (Power BI / Tableau compatible)


---

## 🔑 Layers Explained

### 🥉 Bronze Layer

* Raw import of all 9 Olist CSVs into SQL Server
* Minimal changes (staging tables)
* Scripts:

  * `bronze_schema_creation.sql`
  * `stored_procedure_for_bronze.sql`

### 🥈 Silver Layer

* Cleansed and normalized the tables
* Fact tables: `fact_orders`, `fact_order_items`, `fact_payments`, `fact_reviews`
* Dimension tables: `dim_customers`, `dim_products`, `dim_sellers`, `dim_geolocation`, `dim_date`
* Scripts:

  * `silver_schema_creation.sql`
  * `stored_procedure_for_silver.sql`

### 🥇 Gold Layer **Star Schema**

* Dimension Tables
    - dim_customer
    - dim_product
    - dim_seller
    - dim_payment
    - dim_review
    - dim_order
    - dim_geolocation
* Fact Tables
    - fact_orders (order-level metrics)
    - fact_order_items (item-level metrics)
    - fact_payments (payment transactions)    
    - fact_reviews (review metrics)
* Script:

  * `Query_for_gold_layer.sql`


## 🛠️ How to Run

1. Create the database:

   ```sql
   -- Run from /setup
   SQLQuery_to_create_database.sql
   ```

2. Load Bronze Layer (raw tables):

   ```sql
   -- Run from /bronze
   bronze_schema_creation.sql
   stored_procedure_for_bronze.sql
   ```

3. Build Silver Layer (star schema):

   ```sql
   -- Run from /silver
   silver_schema_creation.sql
   stored_procedure_for_silver.sql
   ```

4. Generate Gold Layer (KPI views):

   ```sql
   -- Run from /gold
   Query_for_gold_layer.sql
   ```
