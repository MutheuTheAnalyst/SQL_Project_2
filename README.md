# SQL_Project_2
## Introduction
- In this project, **two related datasets** i.e product_cost dataset and sales_1 dataset **are presented**.
  
- My **aim** is to **analyze** the datasets on **MYSQL database management system** using the **SQL language** and **draw insights** that will **guide** a figurative **sales and marketing department** on which products and demographic to focus more on so as **to minimuze cost and maximize revenue and profits**.

## Purpose of the project
**1)**. Identify which products have more sales and generate more profit compared to their counterparts.This is so as to ensure that these particular products are always in stock and thus guaranteeing a consistent flow of revenue.

**2)**. Compare quantity of sales per product,number of customers and revenue generated per state.This is so as to take note of the states that are favourable to each product and marketing accordingly in order to increase sales in each state.

## Datasets overview
- To analyze the datasets on MYSQL DBMS, I **launched an already existing database** i.e 'portfolioproject' using the **query**; use portfolioproject;

- I then proceeded to **create two tables** on the database namely; **product_cost table** and **sales_1 table**.

- Correspondingly,the queries are: **Query 1**: create table product_cost (product_id int primary key,cost_price float); **Query 2**: create table sales_1 (customer_id int primary key,product_id int,sell_price float,quantity int,state varchar(20));

- To **confirm that the tables were created successfully**,I used the queries: **Query 1**: describe product_cost; **Query 2**: describe sales_1;

- As per the **guidelines of the figurative finance department**,the **cost of any product should 20 kshs and above**.Thus,I set out to **create a trigger for the cost_product table** to ensure that all products meet the set guidelines.

- **'Before insert trigger' query**; delimiter // create trigger cost_price_confirmation before insert on product_cost for each row begin if new.cost_price < 20 then set new.cost_price = 20 end if; end delimiter ;

- I proceeded to **insert records into product_cost table**.**Query**;insert into product_cost values(....);.Then **inserted records into the sales_1 table**.**Query**;insert into sales_1 values(.....);.Refer to attached files for the records input in both tables.



