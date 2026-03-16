 # Order Delivery Management System

## Project Overview

This project is a complete Oracle SQL / PL/SQL Database Management System for managing orders and deliveries (Gestion des Livraisons des Commandes). It includes schema design, business logic packages, data validation triggers, and procedures for day-to-day operations in a small sales/logistics environment.

The system demonstrates a strong understanding of relational modeling, SQL, and PL/SQL programming, using techniques like tables, sequences, indexes, constraints, triggers, packages, procedures, functions, and cursors to enforce business rules and automate key tasks.

## Features

### 1. Core Functionalities
- **Article Management**: Add, modify, search, and logically/physically delete items with stock, category, and pricing details.
- **Customer Management**: Add and validate clients with phone/postal constraints.
- **Order Management**: Create orders, add order lines, enforce stock checks, and update order states.
- **Delivery Management**: Schedule deliveries, assign drivers, manage delivery status, and validate delivery constraints.
- **Cancellation History**: Store canceled order history with quantities, amounts, and timestamps.

### 2. Business Rules and Validation
- Triggers and constraints ensure data integrity and business logic enforcement:
  - Order states restricted transitions (EC, PR, LI, SO, AN, AL).
  - Stock checks on order lines and automatic stock updates.
  - Delivery rules: only "PR" orders can be delivered, max deliveries per driver per city per day, and time-based update restrictions.
  - Input validation for phone numbers, prices, postal codes, and unique constraints.

### 3. Advanced Database Techniques
- Uses Oracle PL/SQL packages with procedures/functions for modular business operations.
- Includes cursor-based operations and exception handling for safe data access.
- Uses indexes for query performance on fields like order date, customer ID, and product references.

## Technology Stack
- **Database**: Oracle (11g/12c)
- **Language**: SQL and PL/SQL

## Installation and Setup

### 1. Create schema objects
Execute the following files in order in your Oracle client (SQL*Plus, SQL Developer, etc.):
1. `CreationDesTables.sql`
2. `CreationDesSequences.sql`
3. `CreationDesIndexes.sql`

### 2. Create triggers
Run:
- `TrigArticles.sql`
- `TrigClients.sql`
- `TrigCommandes.sql`
- `TrigligneCommandes.sql`
- `TrigLivraisonCom.sql`
- `TrigPersonnel.sql`

### 3. Deploy PL/SQL packages
Run each package specification and body:
- `pkg_gestion_articles_spec.sql`, `pkg_gestion_articles_body.sql`
- `pkg_gestion_commandes_spec.sql`, `pkg_gestion_commandes_body.sql`
- `pkg_gestion_livraisons_spec.sql`, `pkg_gestion_livraisons_body.sql`

### 4. Run tests
Optionally run:
- `pkg_gestion_articles_tests.sql`
- `pkg_gestion_commandes_tests.sql`
- `pkg_gestion_livraisons_tests.sql`

## Usage

Use the package procedures and functions to manage operations. Example:
```sql
BEGIN
  pkg_gestion_commandes.p_ajouter_commande(1001);
END;
/
```

You can also query tables directly for reports and validation.

## Contribution
1. Fork this repository.
2. Add/improve SQL/PLSQL scripts and packages.
3. Add tests in the `pkg_*_tests.sql` files.
4. Open a pull request with clear change descriptions.





