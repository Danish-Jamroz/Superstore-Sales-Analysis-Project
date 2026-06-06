# Superstore Sales Analysis Using Python, MySQL, and Power BI

## Introduction

This project analyzes retail sales data from a Superstore dataset to understand the factors affecting sales, profit, and overall business performance.

The project follows a complete analytics workflow, starting with data cleaning in Python, followed by SQL analysis in MySQL, and ending with an interactive Power BI dashboard for business reporting.

The purpose of this analysis is to identify profitable products, evaluate discount strategies, compare regional performance, analyze customer segments, and uncover loss-making transactions.

---

## Business Objective

The main objective of this project is to use historical sales data to answer important business questions and provide recommendations that can help improve profitability.

Key areas of focus include:

* Product performance
* Discount impact
* Regional analysis
* Customer segment analysis
* Shipping performance
* Order-level profitability

---

## Dataset Information

Dataset: Sample Superstore Dataset

The dataset contains information about:

* Orders
* Customers
* Products
* Categories
* Sales
* Profit
* Quantity
* Discounts
* Regions
* Shipping Modes

This dataset is commonly used for business intelligence and sales analytics projects.

---

## Tools and Technologies

### Python

Used for:

* Data cleaning
* Data preprocessing
* Handling missing values
* Data transformation

Libraries:

* Pandas
* NumPy

### MySQL

Used for:

* Data storage
* SQL analysis
* Business reporting queries

### Power BI

Used for:

* Dashboard creation
* KPI tracking
* Data visualization
* Interactive reporting

---

## Project Workflow

### Step 1: Data Cleaning and Preparation

The raw dataset was first processed in Python to ensure data quality before analysis.

Tasks performed:

* Imported dataset using Pandas
* Checked data types
* Examined missing values
* Converted date columns into datetime format
* Removed duplicate records
* Standardized text fields
* Handled missing values
* Removed unnecessary columns
* Exported cleaned dataset

Output File:

cleaned_superstore.csv

---

### Step 2: Database Design and SQL Analysis

The cleaned dataset was loaded into MySQL for analysis.

The database was organized into fact and dimension tables to support analytical queries.

#### Dimension Tables

* Customers
* Products
* Locations
* Ship Modes

#### Fact Tables

* Orders
* Order Items

SQL techniques used:

* Joins
* Aggregate Functions
* Group By
* Having
* Case Statements
* Window Functions
* DENSE_RANK()

---

### Step 3: Business Analysis

The following business questions were explored.

#### Product Analysis

* Which categories generate the highest sales?
* Which categories generate the highest profit?
* Which sub-categories are most profitable?
* Which products perform poorly?

#### Discount Analysis

* How do discounts impact profit?
* Which discount levels create losses?

#### Regional Analysis

* Which regions generate the highest profit?
* Which regions contribute the lowest profit?

#### Customer Segment Analysis

* Which customer segment is most profitable?
* Which segment contributes the most sales?

#### Shipping Analysis

* Which shipping mode has the highest profit margin?
* Does shipping mode influence profitability?

#### Order-Level Analysis

* Which orders generated the highest losses?
* What factors contributed to those losses?

---

## Key Findings

### Product Performance

Technology was the most profitable category.

Copiers and Phones generated the highest profits among all sub-categories.

Tables and Bookcases showed weak profitability despite generating sales.

---

### Discount Impact

Profitability decreased as discount levels increased.

Many loss-making orders were associated with heavy discounting.

The analysis suggests that discount policies should be reviewed to protect margins.

---

### Regional Performance

The West region generated the highest profit.

Regional performance was generally balanced across the business.

---

### Customer Segment Performance

The Consumer segment contributed the highest sales and profit.

This segment represented the largest share of overall business value.

---

### Shipping Performance

First Class shipping achieved the highest profit margin.

Standard Class generated the largest order volume but lower margins.

---

### Loss-Making Orders

Several high-value orders resulted in significant losses.

The primary causes were large discounts and low profit margins.

---

## Power BI Dashboard

The final dashboard was created in Power BI to present the analysis in an interactive format.

### KPI Cards

* Total Sales
* Total Orders
* Total Profit
* Profit Margin

### Dashboard Visuals

* Monthly Sales Trend
* Sales by Category
* Profit by Region
* Discount vs Profit Analysis
* Top 10 Sub-Categories by Profit
* Shipping Mode Profit Margin

### Filters

* Year
* Region
* Category
* Customer Segment

---

## Business Recommendations

### 1. Review Discount Strategy

Reduce excessive discounting on products with low profit margins.

### 2. Monitor Loss-Making Orders

Introduce approval procedures for large orders generating negative profit.

### 3. Focus on High-Profit Products

Increase attention on Technology products, especially Copiers and Phones.

### 4. Improve Underperforming Categories

Review pricing and cost structures for Tables and Bookcases.

### 5. Replicate Successful Regional Practices

Analyze factors contributing to the success of the West region.

### 6. Continue Profitability Monitoring

Track profit performance at the order level rather than focusing only on sales volume.

---

## Project Deliverables

* Python Data Cleaning Notebook
* Cleaned Dataset
* MySQL Database Schema
* SQL Analysis Queries
* Power BI Dashboard (.pbix)
* Dashboard Screenshot
* Final Project Report

---

## Skills Demonstrated

### Data Cleaning

* Missing Value Handling
* Data Transformation
* Data Validation

### SQL Analysis

* Joins
* Aggregations
* Window Functions
* Business Query Development

### Data Visualization

* Dashboard Design
* KPI Development
* Interactive Reporting

### Business Analysis

* Profitability Analysis
* Sales Analysis
* Customer Analysis
* Business Recommendations

---

## Folder Structure

superstore-sales-analysis-python-mysql-powerbi/

├── data/
│ ├── raw_superstore.csv
│ └── cleaned_superstore.csv

├── notebooks/
│ └── data_cleaning.ipynb

├── sql/
│ ├── schema.sql
│ └── analysis_queries.sql

├── dashboard/
│ ├── superstore_dashboard.pbix
│ └── dashboard_screenshot.png

├── reports/
│ └── project_report.pdf

└── README.md

---

## Conclusion

This project demonstrates an end-to-end data analytics workflow using Python, MySQL, and Power BI. Through data cleaning, SQL analysis, and dashboard development, the project identifies key profit drivers, evaluates discount effectiveness, highlights regional performance trends, and provides actionable recommendations to support better business decisions.
