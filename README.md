 

📦 Order Delivery Management System
Project Overview

This project is an Oracle SQL / PL/SQL Database Management System designed to manage orders and deliveries (Gestion des Livraisons des Commandes).

It implements a complete relational database including schema design, business logic packages, validation triggers, and stored procedures to handle daily operations in a small sales and logistics environment.

The system demonstrates a strong understanding of relational database design, SQL, and PL/SQL programming, using advanced database features such as tables, sequences, indexes, constraints, triggers, packages, procedures, functions, and cursors to enforce business rules and automate operations.

✨ Features
1️⃣ Core Functionalities
📦 Article Management

Add, update, search, and delete products.

Manage item categories, stock quantities, and pricing information.

Support both logical and physical deletion of items.

👥 Customer Management

Register and manage client information.

Validate customer data such as phone numbers and postal codes.

🛒 Order Management

Create customer orders.

Add order lines and validate product availability.

Track and update order status.

🚚 Delivery Management

Schedule deliveries and assign drivers.

Manage delivery status and dates.

Validate delivery constraints.

📜 Cancellation History

Store the history of canceled orders.

Track quantities, amounts, and timestamps.

🧠 Business Rules and Validation

The system enforces several business rules using constraints and triggers, including:

Order state transitions:
EC → PR → LI → SO, with cancellation states AN and AL.

Automatic stock validation and updates when adding order lines.

Delivery constraints:

Only orders with state PR (Ready) can be delivered.

A driver cannot exceed 15 deliveries per day per city.

Delivery updates must respect time restrictions.

Data validation:

Phone number format

Price consistency (selling price > purchase price)

Unique constraints for clients and products.

⚙️ Advanced Database Techniques

The project uses several advanced database concepts:

PL/SQL Packages for modular business logic.

Stored Procedures and Functions for core operations.

Cursors for processing query results.

Exception Handling for safe data management.

Indexes to improve query performance on:

Order dates

Customer IDs

Product references.

🛠️ Technology Stack

Database: Oracle (11g / 12c)

Language: SQL and PL/SQL

Tools: Oracle SQL Developer / SQL*Plus

🚀 Installation and Setup
1️⃣ Create Schema Objects

Execute the following scripts in your Oracle client:

CreationDesTables.sql

CreationDesSequences.sql

CreationDesIndexes.sql

2️⃣ Create Triggers

Run the following trigger scripts:

TrigArticles.sql

TrigClients.sql

TrigCommandes.sql

TrigligneCommandes.sql

TrigLivraisonCom.sql

TrigPersonnel.sql

3️⃣ Deploy PL/SQL Packages

Run both the package specification and package body for each module:

pkg_gestion_articles_spec.sql

pkg_gestion_articles_body.sql

pkg_gestion_commandes_spec.sql

pkg_gestion_commandes_body.sql

pkg_gestion_livraisons_spec.sql

pkg_gestion_livraisons_body.sql

4️⃣ Run Tests (Optional)

Execute test scripts to validate the packages:

pkg_gestion_articles_tests.sql

pkg_gestion_commandes_tests.sql

pkg_gestion_livraisons_tests.sql

📖 Usage

Use the PL/SQL packages to perform operations on the system.

Example:

BEGIN
  pkg_gestion_commandes.p_ajouter_commande(1001);
END;
/

