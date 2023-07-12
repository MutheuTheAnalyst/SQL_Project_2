# SQL_Project_2
## Introduction
- In this project, **two related datasets** i.e product_cost dataset and sales_1 dataset **are presented**.
  
- My **aim** is to **analyze** the datasets on **MYSQL database management system** using the **SQL language** and **draw insights** that will **guide** a figurative **sales and marketing department** on which products and demographic to focus more on so as **to minimize cost and maximize revenue and profits**.

## Purpose of the Project
**1)**. Identify which products have more sales and generate more profit compared to their counterparts.This is so as to ensure that these particular products are always in stock and thus guaranteeing a consistent flow of revenue.

**2)**. Compare quantity of sales per product in each state in addittion to the number of customers and revenue generated per state.This is so as to take note of the states that are favourable to each product and marketing accordingly,in order to increase sales in each state.

## Datasets Overview
- To analyze the datasets on MYSQL DBMS, I **launched an already existing database** i.e 'portfolioproject' using the **Query**: use portfolioproject;

- I then proceeded to **create two tables** on the database namely; **product_cost table** and **sales_1 table**.

- Correspondingly,the queries used to create the tables are: **Query 1**: create table product_cost (product_id int primary key,cost_price float); **Query 2**: create table sales_1 (customer_id int primary key,product_id int,sell_price float,quantity int,state varchar(20));

- To **confirm that the tables were created successfully**,I correspondingly used the queries: **Query 1**: describe product_cost; **Query 2**: describe sales_1;

- As per the **guidelines of a figurative finance department** in the same company,the **cost of any product should be 20 kshs and above**.Thus,I set out to **create a trigger for the cost_product table** to ensure that all products meet the set guidelines.

- **'Before insert trigger' Query**: delimiter // create trigger cost_price_confirmation before insert on product_cost for each row begin if new.cost_price < 20 then set new.cost_price = 20 end if; end delimiter ;

- I proceeded to **insert records into product_cost table**. **Query**: insert into product_cost values(....);.Then **inserted records into the sales_1 table**. **Query**: insert into sales_1 values(.....);.Refer to the attached files for the records input in both tables.

- To **display the records inserted into the tables**,I used the queries: **Query 1**: select * from sales_1; **Query 2**: select * from product_cost;

## Datasets Exploration
**1)**. **Label records** from both the 'product_cost table' and 'sales_1 table' **by row**.

  - This makes it **easier to reference a given record** in the tables.

  - *Query 1* : select row_number() over (order by product_id) as row_num,product_id,cost_price from product_cost; 
         
  - *Query 2* : select row_number() over (order by customer_id) as row_num,customer_id,product_id,sell_price,quantity,state from sales_1;

**2)**. Determine the **number of products on sale**.

 - From the query,I deduced that **7 products are on sale**.

 - *Query* : select count(distinct(product_id)) from product_cost;

  **3)**. Determine the **profit margin** to be obtained  **from** the **sale of each product**.
  
- From the query,I determined that **'product_id 121'** has the **highest profit margin of 'kshs 15.13'** while **'product_id 122' has the least profit margin of 'kshs 1.55'**.Thus, to obtain the same amount of profit from 'product_id 122' as in 'product_id 121',more sales of 'product_id 122' have to be made compared to 'product_id 121'.

- *Query* : select p.product_id,avg(round((s.sell_price-p.cost_price),2)) as profit_margin from product_cost as p inner join sales_1 as s
             on p.product_id=s.product_id group by product_id order by profit_margin desc;

 **4)**. Calculate the **total number of sales**,**total revenue** and **total profit** obtained **from the sale of each product**.

- From this query,I had a **clear overview of the general sales details** and was able to **pin-point best performing products overrall** in addittion to **products that aren't as beneficial to the company**.

 - From this analysis,it's clear to see that *product_id 121* was the *best performing product overrall* while *product_id 122* was the *least performer overrall* among products that received sales.
   
 - *Query* : select p.product_id,p.cost_price,s.sell_price,sum(s.Quantity) as quantity_sold,round(((sum(s.quantity))*s.sell_price),2) as total_revenue,
            round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) as profit from product_cost as p inner join sales_1 as s
            on p.product_id=s.product_id group by p.product_id,s.sell_price order by profit desc;

**5)**. Ascertain **if there exists any product(s) that did not get any sale**.

- From this query,I deduced that **only** one product i.e **'product_id 126' did not get any sale**.
  
- Look into the reason as to way 'product_id 126' did not get any sale.Could it be because of it's pricing compared to market value,could it be because of its appearrance etc.    
       
 - *Query* : select p.product_id,sum(s.Quantity) as quantity from product_cost as p left join sales_1 as s
           on p.product_id=s.product_id where quantity is null group by product_id;

**6)**. Find the **average selling price of the products**.

- The **average sell price is kshs 61.48**.This gives an estimate of the range of product prices thus guiding the customers on what prices to expect.

- *Query* : select round((avg(sell_price)),2 ) as average_sell_price from sales_1;

**7)**. Determine **products that are above and below the average selling price**.

- This gives insight to the sales and marketing department on which products to market to which demographic in regards to income earned and product price.

-  #product_id's with price above the average selling price(61.48).These product_id's are: 121,127,125,122.

- *Query 1* : select product_id,round((avg(sell_price)),2) as price from sales_1 group by product_id having price > 61.48 ;
            
-  #product_id's selling below the average selling price(61.48).These product_id's are 124,123.

-  *Query 2* : select product_id,round((avg(sell_price)),2) as price from sales_1 group by product_id having price < 61.48 ;

  **8)**. **Rank states by their profit** and **diplay the total number of products sold,total number of customers,total revenue and total profits per state**.

  - This provides insight on which state(s) favours which product(s).

  - The state of **California ranked first**, while **Florida came second** and **Texas bottommed the list**.This ranking is both in accordance to the number of products sold and in the profit obtained from the states.
  
  - *Query* : select s.state,sum(s.Quantity)  as total_products_sold,count(s.customer_id) as no_of_customers,round((sum(s.quantity*s.sell_price)),2) as total_revenue,
             round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) as profit,(rank () over (order by round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) desc)) as 
             state_rank from sales_1 as s inner join product_cost as p  where s.product_id=p.product_id group by s.state;

  **9)**. Determine the **number of sales per product and in each state**.

  - This query displays the products sold in each state and the quantity of the products sold.This deduces the best performing products in each state hence giving great leads to the sales and marketing department.

   - In the **state of California,the 'product_id 124' ranked first**,while in **Florida the 'product_id 127' topped the list** and in **Texas the 'product_id 121' topped 
     the list**. 
    
   - *Query* : select state,product_id,sum(quantity) as total_sales_per_product from sales_1 group by state,product_id order by state,total_sales_per_product desc;

  **10)**. **Update the purchase quantity of customer_id '8133'** and **commit to the updated changes**.

  - There was a slight error in in-puting the purchase quantity of 'customer_id 8133' thus I set out to rectify the entry.
  
  - *Query* : start transaction; update sales_1 set quantity =5 where customer_id =8133; commit;

  **11)** Confirm that the **record(customer_id=8133) has been permanently updated**. 
    
 - *Query* : select * from sales_1;

 **12)**. **Create 'product_info' procedure** that **displays total number of sales,total revenue and total profit obtained from each product**.
 
 - This procedure makes it fast and efficcient to access general information about product sales.
      
- *Query* : delimiter // create procedure product_info () begin select p.product_id,p.cost_price,s.sell_price,sum(s.Quantity) as 
quantity_sold,round(((sum(s.quantity))*s.sell_price),2) as total_revenue, round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) as profit 
from product_cost as p inner join sales_1 as s on p.product_id=s.product_id group by p.product_id,s.sell_price order by profit desc;
END // delimiter ;

**13)**. To **confirm that the 'product_info' procedure has been successfully created**,I used the query below.

- *Query* : call product_info();

**14)**. I set to **create** another **procedure namely 'sell_price_updates'** to **enable quick and efficcient updating of sell prices when need be**. 

- *Query* : delimiter // create procedure sell_price_updates (in new_product_id int,in new_sell_price int) begin update sales_1 set product_id= new_product_id
           where sell_price=new_sell_price; end // delimiter ;

**15)**. **Test out the 'sell_price_updates' procedure**  by updating the sell price of the record that has 127 as the product_id.
      
- *Query* : call sell_price_updates(127,74.06);

**16)** **Create view,namely 'total_no_of_product_sales',** to display the overrall total number of sales per product.

- This view is useful in easily visualizing and retrieving information on the total number of sales from each product.

 - *Query* : delimiter // create view total_no_of_product_sales as select product_id,sum(quantity) as total_quantity_sold from sales_1
            group by product_id group by total_quantity_sold desc;
   
**17)** Confirm that the **'total_no_of_product_sales' view has been successfully created**  by displaying all the records in the view.

- *Query* : select * from total_no_of_product_sales;

**18)** **Display the rank,dense_rank and ntile bucket positions** for the products in the view in relation to their quantity sold.

- This gives an **easier way to identify top performers** in accordance to quantity sold. 

- *Query* : select *, rank() over (order by total_quantity_sold desc) as ranks,
           dense_rank() over (order by total_quantity_sold desc) as density_ranks,
           ntile(3) over (order by total_quantity_sold desc) as buckets from total_no_of_product_sales;

  ## End of Data Exploration.

  


