# Fetch Rewards Data Analyst Exercise
__Author:__ Runqing Jia

__Last Modified:__ Jul 14, 2023

This repository is created for the analytical exercise of Data Analyst position at Fetch Rewards.

### First: Review Existing Unstructured Data and Diagram a New Structured Relational Data Model
__Diagram_Q1__ shows the ER Diagram generated from the JSON file to the relational database format

The approach I took involved a thorough review of the unstructured data in the JSON files and the creation of a new structured relational data model. Users and Brands were directly flattened in relational database format; Specifically, for table Receipts, I split it into two separate tables: Receipts and itemList, linking them with the id of Receipts with one-to-many relationships. Consequently, there are four tables after manipulation: Receipts (without itemList detail), itemList, Users, Brands.

Afterwards, I analyzed the information within the files to identify entities and their attributes, established relationships between the entities, and defined the tables with appropriate primary keys, foreign keys, and data types, eventually established a table relationship diagram around table Receipts:

- Receipts & Users: linked by id of Users
- itemList & Brands: linked by barcode
- Receipts & itemList: linked by id of Receipts


### Second: Write a query that directly answers a predetermined question from a business stakeholder
__Queries_Q2:__ The SQL queries for the second part

For this part, requests in Question 1 & 2, 3 & 4, 5 & 6 can be integrated into 3 queries, respectively, to reduce repetitive work. Please check my SQL code for detail.

The SQL Queries are in the syntax of __MySQL__.

### Third: Evaluate Data Quality Issues in the Data Provided
__Script_Q3:__ The Python Notebook script for data quality detection, with insights and suggestions

### Fourth: Communicate with Stakeholders
__Email_Q4:__ The Email draft based on the requirements in the fourth part
