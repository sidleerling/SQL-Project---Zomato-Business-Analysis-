-- SQL Project 3 - Zomato Business Analysis 

create database zomato_db;
use zomato_db;

-- creating the customers table 
create table customers (
    customer_id int primary key,
    customer_name varchar(50), 
    reg_date date
);

select * from customers;

-- creating the restaurants table

create table restaurants (
    restaurant_id int primary key,
    restaurant_name varchar(75),
    city varchar(20),
    opening_hours varchar(55)
);

select * from restaurants;


-- creating the riders table 

create table riders (
    rider_id int primary key,
    rider_name varchar(55),
    sign_up date
);

select * from riders;

-- creating the orders table 

create table orders (
    order_id int primary key,
    customer_id int,
    restaurant_id int,
    order_item varchar(75),
    order_date date,
    order_time time,
    order_status varchar(55),
    total_amount float,
    foreign key (customer_id) references customers(customer_id),
    foreign key (restaurant_id) references restaurants(restaurant_id)
);

select * from orders;

-- creating the deliveries table

create table deliveries (
    delivery_id int primary key,
    order_id int,
    delivery_status varchar(35),
    delivery_time time,
    rider_id int,
    foreign key (order_id) references orders(order_id),
    foreign key (rider_id) references riders(rider_id)
);

-- Performing EDA

-- Q1. Check for null values in each table 

select * from customers
where customer_name is null 
or reg_date is null; -- There are no null values in the customers table 

select * from restaurants
where restaurant_name is null 
or city is null
or opening_hours is null; -- No null values in restaurants table

select * from riders
where rider_name is null
or sign_up is null; -- No null values in the riders table 

select * from orders
where customer_id is null
or restaurant_id is null
or order_item is null
or order_time is null
or order_status is null
or total_amount is null; -- No null values in the orders table

-- Business questions 

-- CRUD / Data Management

-- 2. Insert a new rider into the riders table

select * from riders;

insert into riders 
values (35,'Anuj Devdas','2025-02-15');

-- 3. Update restaurant contact information for a given restaurant_id (update opening hours)

select * from restaurants;

update restaurants
set opening_hours = '6:00 PM - 4:00 AM'
where restaurant_id = 3;

------------------------------------------------------------------------------------------------------

-- Customer Insights / Behavior

-- *4. List all customers who registered in the last 6 months

select * from customers 
where datediff(month,reg_date, '2024-09-01') <= 6; 

-- 5. Identify the top 5 most frequently ordered dishes by customer 'Arjun Mehta' in the last year

with order_rank as (
select c.customer_id, c.customer_name, o.order_item, count(o.order_item) as total_orders,
dense_rank () over (order by count(o.order_item) desc) as rank_no
from customers as c 
inner join orders as o
on c.customer_id = o.customer_id
where c.customer_id = 1 and o.order_date >= to_date('2024-09-01') - interval '1 year'
group by c.customer_id, c.customer_name, o.order_item)
select customer_name, order_item, total_orders 
from order_rank where rank_no <= 5;

-- We can see that 'Paneer Butter Masala' was ordered the most number of times (9 orders) by Arjun Mehta while 'Lamb Kebab' was ordered the least (5 orders) in the last year.

-- 6. List the customers who have spent more than 100K in total on food orders (include customer_name and customer_id)

select c.customer_id, c.customer_name, sum(o.total_amount) from customers as c 
inner join orders as o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name 
having sum(o.total_amount) > 100000
order by customer_id asc;

-- There were 14 customers that spent more than 100,000 in total on food orders. They could be our target customer.

-- 7. Find the customers have placed at least one order

-- I need customer_count count(order_id) > 1

select count(*) as no_of_customers 
from (select customer_id, count(order_id) from orders 
group by customer_id 
having count(order_id) > 1);

-- There are 23 customers who have placed at least one order

-- 8. Identify customers who have never placed an order

-- Need to find customers that are present in the customers table but not in the orders table

select c.customer_id, c.customer_name from customers as c 
left join orders as o
on c.customer_id = o.customer_id
where order_id is null;

-- There are 9 customers that have never placed an order 

------------------------------------------------------------------------------------------------------

--  Order & Sales Analysis

-- 9. Show the top 10 food items which generated the highest revenue in the last month

with expensive_order as (
select order_item, sum(total_amount) as order_amount,
dense_rank() over (order by sum(total_amount) desc) as cost_rank
from orders 
group by order_item)
select order_item, order_amount from expensive_order
where cost_rank <= 10;

-- This table shows that 'Chicken Biryani' was the most sold item in the last month with total revenue generated of 238,767 while 'Mutton Biryani' was the lowest generating a revenue of 140,667

-- 10. Average order amount for each city

select city, round(avg(o.total_amount),2) as avg_order_amount 
from orders as o
inner join restaurants as r
on o.restaurant_id = r.restaurant_id
group by city
order by avg(total_amount) desc;

-- Delhi has the highest average order amount of 329.79 per order while Chennai has the lowest amount of 318.12. However, there doesn't seem to be a substantial difference in the order amounts. It could be explained by the fact that all these are major metropolitan cities and people here have higher purchasing power than smaller cities. If we had data for smaller cities as well, then the result could have been much different
-- This is only a 3.6% difference so it might not warrant a city-specific campaign to increase orders

-- 11. Identify the time slots during which the most orders are placed (2-hour intervals)

select
    case
        when extract(hour from order_time) between 0 and 1 then '00:00 - 02:00'
        when extract(hour from order_time) between 2 and 3 then '02:00 - 04:00'
        when extract(hour from order_time) between 4 and 5 then '04:00 - 06:00'
        when extract(hour from order_time) between 6 and 7 then '06:00 - 08:00'
        when extract(hour from order_time) between 8 and 9 then '08:00 - 10:00'
        when extract(hour from order_time) between 10 and 11 then '10:00 - 12:00'
        when extract(hour from order_time) between 12 and 13 then '12:00 - 14:00'
        when extract(hour from order_time) between 14 and 15 then '14:00 - 16:00'
        when extract(hour from order_time) between 16 and 17 then '16:00 - 18:00'
        when extract(hour from order_time) between 18 and 19 then '18:00 - 20:00'
        when extract(hour from order_time) between 20 and 21 then '20:00 - 22:00'
        when extract(hour from order_time) between 22 and 23 then '22:00 - 00:00'
    end as time_slot,
    count(order_id) as order_count
from orders
group by time_slot
order by order_count desc;

-- We can see from the data that majority of orders were placed either in the afternoon during lunch time or in the evening, before midnight during dinner time.
-- Relatively low orders were placed during breakfast time which means that customers often use Zomato to order main meals but not much of snacks or breakfast.
-- Morning orders are low which could suggest low availability of restaurants during that time. A lot of the restaurants often open after 9:30 or 10:00 in the morning so it is expected that there won't be much orders placed.
-- Orders late into midnight is very low (12) which could be related to a vast majority of restaurants closing down before midnight.

-- 12. For each restaurant, find the highest-value order ever placed

-- I need restaurant, order_item, total_amount

with high_value_order as (
select r.restaurant_name, o.order_item, o.total_amount,
dense_rank () over (partition by r.restaurant_name order by o.total_amount desc) as order_rank
from restaurants as r 
inner join orders as o
on r.restaurant_id = o.restaurant_id)
select restaurant_name, order_item, total_amount 
from high_value_order
where order_rank = 1
order by total_amount desc;

-- The restaurants 'Masala Library', 'Paradise Biryani' and 'Perch Wine & Coffee Bar' had the highest order amounts of 750 while the restaurant Imli had the lowest order amount of 600.
-- Restaurants like Imli might be more inclined to serve budget friendly customers who chose value over premium quality while restaurants like Masala Library, Paradise Biryani, Perch Wine & Coffee Bar offer food to customers who are more willing to spend on expensive food items
-- 3 dishes having their highest order ever placed to 750 means that there is a order price cap at these restaurants.
-- If these restaurants consistenyl give high order amounts, Zomato could pitch them exclusive promotions (eg: premium dining campaigns)

-- 13. Top-selling dish at each restaurant in the last month (give how many times the dish was sold and the total revenue it generated)

with top_selling_dish as (
select r.restaurant_name, o.order_item,
count(o.order_id) as no_of_orders, sum(total_amount) as total_revenue_generated,
dense_rank () over (partition by r.restaurant_name
order by count(o.order_id) desc) as order_rank
from restaurants as r
inner join orders as o
on r.restaurant_id = o.restaurant_id
group by r.restaurant_name, order_item)
select restaurant_name, order_item, no_of_orders, total_revenue_generated from top_selling_dish
where order_rank = 1
order by no_of_orders desc, total_revenue_generated desc;

-- The dish Paneer Butter Masala at the Bombay Canteen was the top selling dish amongst all restaurants with total orders of 50 and the highest revenue generated at 15,875.
-- Within this table, there were a couple of dishes that were the same and they also had a high number of orders from that restaurant such as the 'Pasta Alfredo' from the Leopold Cafe, Bademiya and Yauatcha.
-- Something to note here is that the dish 'Masala Dosa' was the highest selling dish in Masala Library and Ziya however despite the former restaurant having higher order count (39) compared to the latter (37), the former generated almost 1000 less in revenue compared to the latter restaurant. This suggests that while order volume drives popularity, average selling price significantly affects the revenue outcomes
------------------------------------------------------------------------------------------------------

-- Revenue & Restaurant Analysis

-- 15. Rank restaurants by their total revenue from the last year, including name, total revenue, and rank within city
-- I need city, city listing different restaurants, total_revenue generated by each of the r

select r.city, r.restaurant_name, sum(o.total_amount) as total_revenue,
rank() over (partition by r.city order by sum(o.total_amount) desc) as rank_within_city
from restaurants r
inner join orders o 
on r.restaurant_id = o.restaurant_id
where o.order_date >= to_date('2024-02-01') - interval '1 year'
group by r.city, r.restaurant_name;

-- 16. Calculate and compare the order cancellation rate for each restaurant between current year and previous year

with cancel_rate_23 as (
select o.restaurant_id, r.restaurant_name, count(o.order_id) as total_orders,
count(case when d.delivery_id is null then o.restaurant_id end) as not_delivered
from orders as o 
left join deliveries as d
on o.order_id = d.order_id
inner join restaurants as r
on o.restaurant_id = r.restaurant_id
where extract(year from o.order_date) = 2023
group by o.restaurant_id, r.restaurant_name
),
last_year_data as (
select 
restaurant_id, 
total_orders, 
not_delivered, 
round(not_delivered::numeric / total_orders::numeric * 100, 2) as cancel_ratio
from cancel_rate_23
),
cancel_rate_24 as (
select o.restaurant_id, r.restaurant_name, count(o.order_id) as total_orders,
count(case when d.delivery_id is null then o.restaurant_id end) as not_delivered
from orders as o 
left join deliveries as d
on o.order_id = d.order_id
inner join restaurants as r
on o.restaurant_id = r.restaurant_id
where extract(year from o.order_date) = 2024
group by o.restaurant_id, r.restaurant_name
),
current_year_data AS (
select restaurant_id, total_orders, not_delivered, 
round(not_delivered::numeric / total_orders::numeric * 100, 2) as cancel_ratio
from cancel_rate_24
)
select current_year_data.restaurant_id as rest_id, 
current_year_data.cancel_ratio as current_year_ratio, 
last_year_data.cancel_ratio as last_year_ratio
from current_year_data
join last_year_data
on current_year_data.restaurant_id = last_year_data.restaurant_id;

-- 17. Identify restaurants generating above-average revenue (using a CTE)

with all_avg_revenue as (
select avg(total_amount) as avg_amount
from orders
),
avg_revenue_per_restaurant as (
select restaurant_id, avg(total_amount) as avg_per_restaurant
from orders
group by restaurant_id
)
select r.restaurant_id, r.restaurant_name,round(avr.avg_per_restaurant,2) as average_amount
from restaurants r 
join avg_revenue_per_restaurant avr    
on r.restaurant_id = avr.restaurant_id
join all_avg_revenue ar
on avr.avg_per_restaurant > ar.avg_amount
order by round(avr.avg_per_restaurant,2) desc;

-- We can see that "Nagarjuna" restaurant has generated the highest average revenue amongst all other restaurants with an amount of 351.41

-- 18. Segment customers into 'Gold' or 'Silver' categories based on their total spending compared to the average value (AOV). If the customers total spending exceeds the AOV, label them as 'Gold' otherwise label them as 'Silver'. Find out each segments total number of orders and the revenue they generated.

with total_spend as (
select c.customer_id, count(order_id) as order_count,
sum(o.total_amount) as total_amount_spent from customers as c
inner join orders as o
on c.customer_id = o.customer_id
group by c.customer_id),
average_spend as (
select avg(total_amount_spent) as avg_amount from total_spend)
select 
case 
when tsp.total_amount_spent > avs.avg_amount then 'Gold'
else 'Silver'
end as customer_segment,
sum(tsp.total_amount_spent) as total_revenue_generated, sum(tsp.order_count) as total_orders
from total_spend as tsp
inner join average_spend as avs
group by customer_segment;

-- Delivery & Rider Performance

-- 19. Calculate each rider's total_monthly earnings, assuming they earn 8% of the total order amount

select r.rider_id, r.rider_name, to_char(o.order_date,'mm-yy') as month,
sum(o.total_amount) as revenue,
round(sum(o.total_amount) * 0.08,2) as rider_earnings
from riders as r 
inner join deliveries as d
on r.rider_id = d.rider_id
inner join orders as o
on d.order_id = o.order_id
group by 1,2,3
order by 1,3 desc;

-- 20. Identify riders who delivered more than 100 orders in the month of November, 2023

with rider_deliveries as 
(select r.rider_id, r.rider_name, o.order_id, d.delivery_status, o.order_date 
from riders as r 
inner join deliveries as d
on r.rider_id = d.rider_id
inner join orders as o
on d.order_id = o.order_id
where d.delivery_status = 'Delivered')
select rider_id, rider_name, count(order_id) as order_count 
from rider_deliveries
where order_date >= to_date('2023-11-30') - interval '1 month'
group by rider_id, rider_name
having count(order_id) > 100;

-- Given that these 11 riders delivered more than 100 orders in the month of November, they could be rewarded with bonuses from the revenue generated for the month of Novemeber to appreciate their performances.

-- 21. Find then number of 5 star, 4 star, 3 star rating each rider has based on delivery time.     If orders are delivered less than 15 mins of order received time, rider gets 5 star rating, if they deliver between 15 to 20 mins, rider gets 4 star rating and if they deliver after 20 mins, rider gets 3 star rating.

with order_deliver_time as (
select o.order_id, o.order_time, d.delivery_time,
datediff(minute, dateadd(second, date_part(second, o.order_time)
+ date_part(minute, o.order_time)*60
+ date_part(hour, o.order_time)*3600,
current_date),
case
when d.delivery_time < o.order_time then dateadd(second,
date_part(second, d.delivery_time) + date_part(minute, d.delivery_time)*60
+ date_part(hour, d.delivery_time)*3600,
dateadd(day, 1, current_date))
else
dateadd(second, date_part(second, d.delivery_time) + date_part(minute, d.delivery_time)*60
+ date_part(hour, d.delivery_time)*3600, current_date) end) as delivery_process_time,
d.rider_id from orders o
inner join deliveries d
on o.order_id = d.order_id
where d.delivery_status = 'Delivered'
),
rider_performance as (
select rider_id, delivery_process_time,
case
when delivery_process_time < 15 then '5 Star'
when delivery_process_time between 15 and 25 then '4 Star'
when delivery_process_time between 26 and 40 then '3 Star'
when delivery_process_time between 41 and 60 then '2 Star'
else '1 Star'
end as rider_ratings
from order_deliver_time)
select rider_id, rider_ratings, count(*) as rider_rating_distribution
from rider_performance
group by rider_id, rider_ratings
order by rider_id asc, rider_rating_distribution desc;

-- 21. Evaluate rider efficiency by determining average delivery time and identifying those with the lowest and highest averages.

with order_deliver_time as (
select o.order_id, o.order_time, d.delivery_time, d.rider_id,
datediff(minute, dateadd(second, date_part(second, o.order_time) + date_part(minute, o.order_time)*60 
+ date_part(hour, o.order_time)*3600,
current_date),
case
when d.delivery_time < o.order_time then 
dateadd(second, date_part(second, d.delivery_time) + date_part(minute, d.delivery_time)*60 
+ date_part(hour, d.delivery_time)*3600, dateadd(day, 1, current_date))
else dateadd(second, date_part(second, d.delivery_time) + date_part(minute, d.delivery_time)*60 
+ date_part(hour, d.delivery_time)*3600, current_date)
end) as delivery_minutes
from orders o
inner join deliveries d
on o.order_id = d.order_id
where d.delivery_status = 'Delivered'
),
rider_efficiency as (
select rider_id, round(avg(delivery_minutes),2) as avg_delivery_time_in_mins,
min(delivery_minutes) as fastest_delivery_in_mins,
max(delivery_minutes) as slowest_delivery_in_mins
from order_deliver_time
group by rider_id
)
select * from rider_efficiency
order by avg_delivery_time_in_mins asc;  

----------------------------------------------------------------------------------------------------------------------------------
