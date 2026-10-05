# WarrantyBox – Product Warranty & Service Claim Tracker

## 📌 Project Overview

**WarrantyBox** is a PostgreSQL-based **Product Warranty and Service Claim Tracking System** developed as a DBMS project.

The system manages products, customers, warranties, service centers, and warranty claims. It also uses **Primary Keys, Foreign Keys, SQL Queries, Subqueries, Aggregate Functions, Joins, PL/pgSQL Functions, and Triggers** to maintain data integrity and automate warranty validation.

The main purpose of the system is to make it easier to track product warranties and ensure that customers can only raise service claims while their warranty is valid.

---

## 🎯 Objectives

- Store and manage product information.
- Maintain customer details.
- Track warranty information for purchased products.
- Maintain service center details.
- Record and manage warranty claims.
- Identify warranties that are about to expire.
- Analyze the number of claims handled by each service center.
- Prevent claims from being created after warranty expiry.
- Demonstrate important PostgreSQL and DBMS concepts.

---

## 🗂️ Database Structure

The database consists of the following five main tables:

### 1. Product

Stores information about products available in the system.

| Column | Data Type | Description |
|---|---|---|
| ProductID | INTEGER | Primary key |
| ProductName | VARCHAR(100) | Name of the product |
| Category | VARCHAR(50) | Product category |
| Brand | VARCHAR(50) | Product brand |
| Price | NUMERIC(10,2) | Product price |

### 2. Customer

Stores customer information.

| Column | Data Type | Description |
|---|---|---|
| CustomerID | INTEGER | Primary key |
| CustomerName | VARCHAR(100) | Customer name |
| Email | VARCHAR(100) | Customer email |
| Phone | VARCHAR(15) | Customer phone number |
| Address | VARCHAR(200) | Customer address |

### 3. ServiceCenter

Stores information about authorized service centers.

| Column | Data Type | Description |
|---|---|---|
| ServiceCenterID | INTEGER | Primary key |
| CenterName | VARCHAR(100) | Service center name |
| Location | VARCHAR(100) | Service center location |
| ContactNo | VARCHAR(15) | Contact number |

### 4. Warranty

Stores warranty information associated with products and customers.

| Column | Data Type | Description |
|---|---|---|
| WarrantyID | INTEGER | Primary key |
| PurchaseID | INTEGER | Unique purchase identifier |
| ProductID | INTEGER | Foreign key referencing Product |
| CustomerID | INTEGER | Foreign key referencing Customer |
| PurchaseDate | DATE | Date of purchase |
| WarrantyPeriod | INTEGER | Warranty duration |
| ExpiryDate | DATE | Warranty expiry date |

### 5. Claim

Stores warranty service claims submitted by customers.

| Column | Data Type | Description |
|---|---|---|
| ClaimID | INTEGER | Primary key |
| ProductID | INTEGER | Foreign key referencing Product |
| CustomerID | INTEGER | Foreign key referencing Customer |
| WarrantyID | INTEGER | Foreign key referencing Warranty |
| ServiceCenterID | INTEGER | Foreign key referencing ServiceCenter |
| ClaimDate | DATE | Date of claim |
| Status | VARCHAR(20) | Current claim status |
| Description | VARCHAR(255) | Description of the issue |

---

## 🔗 Relationships

The database follows these relationships:

```text
Customer
   │
   ├─────────────── Warranty
   │                    │
   │                    │
   │                 Product
   │
   └─────────────── Claim
                        │
                        ├──────── Product
                        ├──────── Warranty
                        └──────── ServiceCenter
```

### Relationships implemented

- One customer can have multiple warranties.
- One product can have multiple warranties.
- One warranty can be associated with claims.
- One customer can raise multiple claims.
- One service center can handle multiple claims.
- A claim is associated with one product, customer, warranty and service center.

---

## ⚙️ DBMS Concepts Used

### Primary Key

Each table has a unique primary key to identify every record.

Examples:

```sql
ProductID
CustomerID
ServiceCenterID
WarrantyID
ClaimID
```

### Foreign Key

Foreign keys establish relationships between tables and maintain referential integrity.

For example:

```sql
FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
```

### JOIN

A `LEFT JOIN` is used to find the number of claims handled by each service center.

```sql
SELECT
    s.CenterName,
    COUNT(c.ClaimID) AS TotalClaims
FROM ServiceCenter s
LEFT JOIN Claim c
    ON s.ServiceCenterID = c.ServiceCenterID
GROUP BY s.ServiceCenterID, s.CenterName
ORDER BY TotalClaims DESC;
```

### Aggregate Function

`COUNT()` is used to calculate the number of claims.

```sql
COUNT(c.ClaimID)
```

### Subquery

A subquery is used to find customers who have an existing warranty.

```sql
SELECT CustomerName
FROM Customer
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Warranty
);
```

### Date Operations

The project uses PostgreSQL date functions to find warranties expiring within the next 30 days.

```sql
WHERE ExpiryDate BETWEEN CURRENT_DATE
AND CURRENT_DATE + INTERVAL '30 days';
```

---

## 🚨 Trigger & Warranty Validation

One of the main features of WarrantyBox is its **automatic warranty validation**.

A PL/pgSQL trigger function named:

```text
check_warranty_expiry()
```

checks the warranty expiry date whenever a new claim is inserted.

If the warranty has already expired, the claim is rejected.

Example:

```text
ERROR: Claim rejected: Warranty has expired
```

This prevents invalid warranty claims from being stored in the database.

### Trigger

The trigger is executed before inserting a claim:

```sql
CREATE TRIGGER check_warranty_before_claim
BEFORE INSERT ON Claim
FOR EACH ROW
EXECUTE FUNCTION check_warranty_expiry();
```

---

## 🧪 Example Queries

### Display all claims

```sql
SELECT *
FROM Claim
ORDER BY ClaimID;
```

### Find warranties expiring within 30 days

```sql
SELECT
    WarrantyID,
    ProductID,
    CustomerID,
    PurchaseDate,
    ExpiryDate
FROM Warranty
WHERE ExpiryDate BETWEEN CURRENT_DATE
AND CURRENT_DATE + INTERVAL '30 days';
```

### Count claims by service center

```sql
SELECT
    s.CenterName,
    COUNT(c.ClaimID) AS TotalClaims
FROM ServiceCenter s
LEFT JOIN Claim c
    ON s.ServiceCenterID = c.ServiceCenterID
GROUP BY s.ServiceCenterID, s.CenterName
ORDER BY TotalClaims DESC;
```

### Check a specific claim

```sql
SELECT *
FROM Claim
WHERE ClaimID = 503;
```

### Check whether a rejected claim exists

```sql
SELECT *
FROM Claim
WHERE ClaimID = 600;
```

If the trigger rejects the claim, this query returns **0 rows**.

---

## 📁 Project Structure

```text
WarrantyBox/
│
├── schema.sql
├── seed.sql
├── queries.sql
├── README.md
└── ERD/
    └── WarrantyBox_ERD.png
```

### File Description

| File | Purpose |
|---|---|
| `schema.sql` | Creates tables, constraints, functions and triggers |
| `seed.sql` | Inserts sample data into the database |
| `queries.sql` | Contains SQL queries used for analysis and testing |
| `README.md` | Project documentation |
| `ERD/` | Contains the Entity Relationship Diagram |

---

## ▶️ How to Run the Project

### Step 1 – Create the Database

Create a PostgreSQL database named:

```text
WarrantyBox
```

### Step 2 – Run Schema

Open `schema.sql` in **pgAdmin 4 Query Tool** and execute it.

This creates:

- Product
- Customer
- ServiceCenter
- Warranty
- Claim
- Warranty validation function
- Warranty validation trigger

### Step 3 – Insert Sample Data

Run:

```text
seed.sql
```

This inserts sample products, customers, service centers, warranties and valid claims.

### Step 4 – Run Queries

Open:

```text
queries.sql
```

and execute the required queries.

---

## 🧩 Tools & Technologies

- **Database:** PostgreSQL
- **Database Management Tool:** pgAdmin 4
- **Query Language:** SQL
- **Procedural Language:** PL/pgSQL
- **ER Diagram:** pgAdmin 4 ERD Tool / diagrams.net
- **Version Control:** Git & GitHub

---

## 📊 Expected Functionality

The system allows users to:

1. Manage products.
2. Manage customers.
3. Track product warranties.
4. Track warranty expiry dates.
5. Register service claims.
6. View claims by service center.
7. Find warranties approaching expiry.
8. Search customer warranty information.
9. Validate warranty eligibility automatically.
10. Prevent claims against expired warranties.

---

## 🔐 Data Integrity

The database maintains data integrity using:

- Primary Keys
- Foreign Keys
- Unique Constraints
- NOT NULL Constraints
- Referential Integrity
- PL/pgSQL Trigger Functions
- BEFORE INSERT Triggers

These constraints ensure that invalid or inconsistent records are not inserted into the database.

---

## 📌 Conclusion

**WarrantyBox** demonstrates how a relational database can be used to manage product warranties and service claims efficiently.

The project combines relational database design with SQL queries, joins, subqueries, aggregate functions, constraints, functions and triggers. The warranty validation trigger provides an automated mechanism to prevent customers from raising claims after their warranty has expired.

This project demonstrates the practical application of **DBMS concepts using PostgreSQL**.