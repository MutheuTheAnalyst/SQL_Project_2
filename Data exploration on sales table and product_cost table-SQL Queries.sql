#launch database to be used
use portfolioproject;

#Create 'product_cost' table and 'Sales_1' table
CREATE TABLE product_cost (product_id INT PRIMARY KEY,cost_price FLOAT);
CREATE TABLE sales_1 (customer_id INT PRIMARY KEY,product_id INT,sell_price FLOAT,Quantity INT,state VARCHAR(20));
describe product_cost;
describe sales_1;

#create 'before insert trigger' for product_cost table
delimiter //
create trigger cost_price_confirmation
before insert on product_cost
for each row
begin 
if new.cost_price < 20 then set new.cost_price =20
end if;
end
delimiter ;

#Insert records into the 'product_cost' and 'sales' tables.
insert into product_cost values
(121, 50.66),(122,61.78),(123,42.92),(124,33.51),(125,68.43),(126,74.02),(127,58.67);
insert into sales_1 values
(8133,121,65.99,3,'California'),(8134,127,69.83,1,'Florida'),
(8135,124,45.62,4,'California'),(8136,121,65.99,2,'California'),
(8137,125,73.23,1,'Texas'),(8138,125,73.23,5,'Florida'),
(8139,123,51.66,2,'California'),(8140,122,63.33,4,'California'),
(8141,121,65.99,3,'Texas'),(8142,124,45.62,1,'Texas'),
(8143,122,63.33,2,'Florida'),(8144,127,69.83,4,'Florida'),
(8145,124,45.62,6,'California');

#Display records from the 'product_cost' and 'sales_1' tables
select * from sales_1;
select * from product_cost;

#Data Exploration
#Label records from both the product_cost table and sale table by row.
select row_number() over (order by product_id) as row_num,product_id,cost_price from product_cost; 
select row_number() over (order by customer_id) as row_num,customer_id,product_id,sell_price,quantity,state from sales_1;

#Number of products on sale
select count(distinct(product_id)) from product_cost;

#Profit margin of each product
select p.product_id,avg(round((s.sell_price-p.cost_price),2)) as profit_margin
from product_cost as p inner join sales_1 as s
on p.product_id=s.product_id
group by product_id
order by profit_margin desc;

#Total number of sales,total revenue and total profit obtained from each product 
select p.product_id,p.cost_price,s.sell_price,sum(s.Quantity) as quantity_sold,round(((sum(s.quantity))*s.sell_price),2) as total_revenue,
round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) as profit 
from product_cost as p inner join sales_1 as s
on p.product_id=s.product_id
group by p.product_id,s.sell_price
order by profit desc;

#Product(s) that did not get any sale
select p.product_id,sum(s.Quantity) as quantity from product_cost as p
left join sales_1 as s
on p.product_id=s.product_id
where Quantity is null
group by product_id;

#average selling price for the products
select round((avg(sell_price)),2 ) as average_sell_price
from sales_1;

#products with price above the average selling price(61.48)
select product_id,round((avg(sell_price)),2) as price
from sales_1
group by product_id
having price > 61.48 ;

#products selling below the average selling price(61.48)
select product_id,round((avg(sell_price)),2) as price
from sales_1
group by product_id
having price < 61.48 ;

#Rank states by their profit and diplay the total number of products sold,total number of customers,total revenue and total profits per state
select s.state,sum(s.Quantity)  as total_products_sold,count(s.customer_id) as no_of_customers,
round((sum(s.quantity*s.sell_price)),2) as total_revenue,
round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) as profit,
(rank () over (order by round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) desc)) as state_rank
from sales_1 as s inner join product_cost as p 
where s.product_id=p.product_id
group by s.state;

#Number of sales per product and in each state
select state,product_id,sum(quantity) as total_sales_per_product
from sales_1
group by state,product_id
order by state,total_sales_per_product desc;

#Products sold in California alongside profits obtained from  each product
select p.product_id,count(p.product_id) as number_sold,round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) as profit 
from product_cost as p inner join sales_1 as s
on p.product_id=s.product_id
where s.product_id in (select s.product_id from sales_1 where state = 'california')
group by p.product_id
order by profit desc;

#Update the purchase quantity of customer_id '8133' and commit to the updated changes
start transaction;
update sales_1
set quantity =5
where customer_id =8133;
commit;
 
 #confirm that the record(customer_id=8133)has been permanently updated 
select * from sales_1;

#create 'product_info' procedure that displays total number of sales,total revenue and total profit obtained from each product 
delimiter //
create procedure product_info ()
begin 
select p.product_id,p.cost_price,s.sell_price,sum(s.Quantity) as quantity_sold,round(((sum(s.quantity))*s.sell_price),2) as total_revenue,
round((sum((s.sell_price-p.cost_price)*(s.Quantity))),2) as profit 
from product_cost as p inner join sales_1 as s
on p.product_id=s.product_id
group by p.product_id,s.sell_price
order by profit desc;
END //
delimiter ;

#use the 'product_info' procedure
call product_info();

#create procedure 'sell_price_updates' to update sell_price
delimiter //
create procedure sell_price_updates (in new_product_id int,in new_sell_price int)
begin 
update sales_1
set product_id= new_product_id
where sell_price=new_sell_price;
end //
delimiter ;

#update sell price of record that has 127 as the product_id
call sell_price_updates(127,74.06);

#Create view to display total number of sales per product
delimiter //
create view total_no_of_product_sales as 
select product_id,sum(quantity) as total_quantity_sold
from sales_1
group by product_id
order by total_quantity_sold desc;

#display records from 'total_no_of_product_sales' view
select * from total_no_of_product_sales;

#display records of products whose quantity sold exceeds the average.
select product_id,total_quantity_sold from total_no_of_product_sales
 where total_quantity_sold > (select avg(total_quantity_sold) from total_no_of_product_sales;

#Display the rank,dense_rank and ntile bucket positions for the products in the view
 select *, rank() over (order by total_quantity_sold desc) as ranks,dense_rank() over (order by total_quantity_sold desc) as density_ranks, ntile(3) over (order by total_quantity_sold desc) as buckets from total_no_of_product_sales;
 
 ##End of data exploration.
 
 
 















