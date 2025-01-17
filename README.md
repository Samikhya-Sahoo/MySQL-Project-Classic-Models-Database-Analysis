# MySQL Project: Classic Models Database Analysis

## Project Objective
This project aims to analyze data from the Classic Models database using MySQL. The goal is to execute various SQL queries that extract meaningful insights and create structured tables for managing customer orders and employee information.

## Dataset Used
- **Classic Models Database**: This dataset includes tables related to customers, orders, products, and payments. The dataset can be found [here](https://github.com/Samikhya-Sahoo/MySQL-Project-Classic-Models-Database-Analysis/blob/main/classicmodels%20database.sql).

## Questions and Key Performance Indicators (KPIs)

1. **Employee Information**: 
   - Fetch the employee number, first name, and last name of employees working as Sales Reps who report to employee number 1102.

2. **Unique Product Lines**: 
   - Show unique product line values containing the word 'cars' at the end from the products table.

3. **Customer Segmentation**: 
   - Segment customers into three categories based on their country:
     - "North America" for customers from the USA or Canada.
     - "Europe" for customers from the UK, France, or Germany.
     - "Other" for all remaining countries.

4. **Top Ordered Products**: 
   - Identify the top 10 products (by productCode) with the highest total order quantity across all orders.

5. **Monthly Payments**: 
   - Count the total number of payments made per month, including only those months with a payment count exceeding 20. 

6. **Customer Orders by Country**: 
   - List the top 5 countries (by order count) that Classic Models ships to, using the Customers and Orders tables.

7. **Employee Hierarchy**: 
   - Show the names of employees and their respective managers using a self-join.

8. **Product Sales View**: 
   - Create a view named `product_category_sales` that provides insights into sales performance by product category, including total sales and number of orders.

9. **Yearly Payments by Country**: 
   - Create a stored procedure named `Get_country_payments` that takes year and country as inputs, providing the year-wise, country-wise total amount.

10. **Product Line Analysis**: 
    - Count the number of product lines for which the buy price value is greater than the average of the buy price value.

11. **Error Handling**: 
    - Create a procedure to accept values for the `Emp_EH` table, implementing error handling to display a message if any error occurs.

12. **Working Hours Trigger**: 
    - Create a trigger to ensure that any new value of working hours in the `Emp_BIT` table is inserted as a positive number.

## Process Overview
- **Data Retrieval**: Execute SQL queries to gather data from the Classic Models database.
- **Table Creation**: Design and implement new tables for managing customer orders and employee information.
- **Data Cleaning and Validation**: Ensure data integrity by handling errors and maintaining data consistency.
- **Modeling**: Create views and stored procedures to streamline data analysis and enhance reporting capabilities.

## SQL Queries File
The SQL queries utilized in this project are documented in the following file:[MySQL_Project.sql](https://github.com/Samikhya-Sahoo/MySQL-Project-Classic-Models-Database-Analysis/blob/main/MySQL_Project.sql).



## Conclusion
This project demonstrates the ability to extract valuable insights from a relational database using SQL queries. The analysis facilitates informed business decisions and promotes operational efficiency, making it a valuable asset for organizations seeking data-driven solutions.
