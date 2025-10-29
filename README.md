# Data Warehouse and Analytics Project 🚀

Welcome to the Data Warehouse and Analytics Project repository! This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:
![Data Architecture](https://github.com/abdelrhmanashraf103/sql-data-warehouse-project/blob/master/sql-datawarehouse-project/docs/data_architecture.png)
- **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
- **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
- **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

## 📖 Project Overview

This project involves:

- **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
- **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
- **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
- **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

## 🎯 Skills Demonstrated

This repository is an excellent resource for professionals and students looking to showcase expertise in:

- SQL Development
- Data Architecture
- Data Engineering
- ETL Pipeline Development
- Data Modeling
- Data Analytics

## 🛠️ Tools & Technologies

Everything is for Free!

- **Datasets**: Access to the project dataset (csv files)
- **SQL Server Express**: Lightweight server for hosting your SQL database
- **SQL Server Management Studio (SSMS)**: GUI for managing and interacting with databases
- **Git Repository**: GitHub for version control and collaboration
- **DrawIO**: Design data architecture, models, flows, and diagrams
- **Notion**: Project Template and documentation

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

**Specifications**
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries
- **Scope**: Focus on the latest dataset only; historization of data is not required
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams

### BI: Analytics & Reporting (Data Analysis)

**Objective**
Develop SQL-based analytics to deliver detailed insights into:
- Customer Behavior
- Product Performance  
- Sales Trends

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

## 📂 Repository Structure

📂 data-warehouse-project/
│
├── 📁 datasets/                        # Raw datasets used for the project (ERP and CRM data)
│
├── 📁 docs/                            # Project documentation and architecture details
│   ├── 📄 etl.drawio                   # ETL techniques and methods diagram
│   ├── 📄 data_architecture.drawio     # Project architecture diagram  
│   ├── 📄 data_catalog.md              # Catalog of datasets, including field descriptions and metadata
│   ├── 📄 data_flow.drawio             # Data flow diagram
│   ├── 📄 data_models.drawio           # Data models (star schema) diagram
│   └── 📄 naming-conventions.md        # Consistent naming guidelines for tables, columns, and files
│
├── 📁 scripts/                         # SQL scripts for ETL and transformations
│   ├── 📁 bronze/                      # Scripts for extracting and loading raw data
│   ├── 📁 silver/                      # Scripts for cleaning and transforming data
│   └── 📁 gold/                        # Scripts for creating analytical models
│
├── 📁 tests/                           # Test scripts and quality files
│
├── 📄 README.md                        # Project overview and instructions
├── 📄 LICENSE                          # License information for the repository
├── 📄 .gitignore                       # Files and directories to be ignored by Git
└── 📄 requirements.txt                 # Dependencies and requirements for the project

## 👨‍💻 About Me

Hi there! I'm Abdelrahman Haroun.
Experienced Data Analyst with 2+ years at Samsung, specializing in transforming complex data into actionable insights. 
Passionate about leveraging analytics to drive business decisions and optimize performance across various domains.


## 📞 Stay Connected

Let's stay in touch! Feel free to connect with me on the following platforms:

<p align="left">
  <a href="https://www.linkedin.com/in/abdelrhman-haroun-455aa930a/">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
  <a href="https://abdelrhmanashraf103.github.io/MyPortfolio.github.io/">
    <img src="https://img.shields.io/badge/Portfolio-FF7139?style=for-the-badge&logo=firefox&logoColor=white" alt="Portfolio"/>
  </a>
  <a href="https://faint-pewter-80a.notion.site/Data-Warehouse-Project-299ce363138780299279e9ba193f5cdd">
    <img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white" alt="Notion Project"/>
  </a>
  <a href="https://github.com/abdelrhmanashraf103">
    <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"/>
  </a>
</p>
