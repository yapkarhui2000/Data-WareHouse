# 🏗️ Data Warehouse Project

## 📖 Project Overview

This project focuses on designing and implementing a modern **Data Warehouse** using **Microsoft SQL Server**. The warehouse consolidates data from multiple business systems into a centralized analytical platform, enabling efficient reporting, business intelligence, and data-driven decision-making.

---

## 🎯 Objective

Develop a modern data warehouse solution that:

* Consolidates sales data from multiple source systems.
* Improves data quality through cleansing and transformation.
* Provides a unified and analytics-friendly data model.
* Supports business reporting and strategic decision-making.

---

## 📋 Project Requirements

### 📂 Data Sources

The data warehouse integrates data from two operational systems:

| Source System | Format    |
| ------------- | --------- |
| ERP System    | CSV Files |
| CRM System    | CSV Files |

---

### 🧹 Data Quality Management

Before loading data into the warehouse, the following data quality processes are performed:

* Handling missing values
* Removing duplicate records
* Standardizing data formats
* Resolving inconsistent data entries
* Validating data integrity

---

### 🔄 Data Integration

Data from ERP and CRM systems is:

1. Extracted from source CSV files
2. Transformed and cleansed
3. Integrated into a unified data model
4. Loaded into SQL Server for analytical processing

---

### 📊 Scope

* Focus on the **latest available dataset**
* Historical data tracking (historization) is **not required**
* Designed primarily for analytical reporting and business insights

---

### 📚 Documentation

The project includes comprehensive documentation covering:

* Data architecture
* ETL process
* Data model design
* Business rules
* Data dictionary


## 🏛️ Data Architecture

This project follows the **Medallion Architecture** approach.

### Architecture Layers

#### 🥉 Bronze Layer

* Raw data ingestion from source systems
* Minimal transformations
* Preserves original source data

#### 🥈 Silver Layer

* Data cleansing and validation
* Standardization and enrichment
* Business rule implementation

#### 🥇 Gold Layer

* Business-ready dimensional models
* Optimized for reporting and analytics
* Supports dashboards and decision-making

---

## 🖼️ Architecture Diagram

<img width="1213" height="795" alt="Screenshot 2026-06-08 101853" src="https://github.com/user-attachments/assets/b15c0c18-7af9-4176-b18e-14750e23fa2b" />

---

## 🛠️ Technology Stack

* Microsoft SQL Server
* SQL
* CSV Data Sources
* ETL Processes
* Medallion Architecture

---

## 🚀 Expected Outcome

A scalable and maintainable data warehouse solution that provides:

* Single source of truth for sales data
* Improved data quality
* Faster analytical queries
* Better business reporting
* Enhanced decision-making capabilities
