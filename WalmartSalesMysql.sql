SELECT * FROM salesdatawalmart.sales;
select * from sales;
describe sales;
-- Feature Engineering: This will help use generate some new columns from existing ones.

-- 1. Add a new column named time of day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.
Alter table sales
add column time_of_day varchar (20);

update sales
SET time_of_day =(
 case
  when 'time' BETWEEN '00:00:00' and '12:00:00' then 'morning'
  when 'time' BETWEEN '12:00:01' and '16:00:00' then 'afternoon'
  else 'evening'
  end);

-- 2. Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.
Alter table sales
add column day_name varchar (20);

update sales
SET day_name = DAYNAME(date);

-- 3. Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.
Alter table sales
add column month_name varchar (20);

update sales
SET month_name = MONTHNAME(date);

-- --------------------Business Questions To Answer---------------------------------------------------
-------------------------- Generic Question ------------------------------------------------------------------
-- 1. How many unique cities does the data have?
select distinct(city) from sales;

-- 2. In which city is each branch?
select distinct(branch) from sales;
-- ------------------------Product --------------------------------------------------------------------
-- 1. How many unique product lines does the data have?
select distinct(product_line) from sales;

-- 2. What is the most common payment method?
select payment_method,count(*) from sales
group by payment_method
order by count(*) desc;

-- 3. What is the most selling product line?
select product_line,count(product_line) from sales
group by product_line
order by count(product_line) desc;

-- 4. What is the total revenue by month?
select month_name,sum(total) from sales
group by month_name;

-- 5. What month had the largest COGS?
select month_name,sum(cogs) from sales
group by month_name
order by sum(cogs);

-- 6. What product line had the largest revenue?
select product_line,sum(total) from sales
group by product_line
order by sum(total) desc limit 1;

-- 7. What is the city with the largest revenue?
select city ,sum(total) as revenue from sales
group by city
order by revenue desc limit 1;

-- 8. What product line had the largest VAT?
select product_line , sum(VAT) from sales
group by product_line 
order by sum(VAT) desc limit 1;
-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

-- 10. Which branch sold more products than average product sold?
select product_line , sum(quantity) from sales
group by product_line
having sum(quantity)>(select avg(quantity) from sales);

-- 11. What is the most common product line by gender?
select gender,product_line,count(product_line) from sales
group by gender,product_line
order by count(product_line) desc limit 1;

-- 12. What is the average rating of each product line?
select product_line, avg(rating) from sales
group by product_line 
order by avg(rating);

-- -------------------------------------Sales-----------------------------------------------------------------------
-- 1. Number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sales
from sales 
group by time_of_day
order by total_sales Desc;

-- 2. Which of the customer types brings the most revenue?
select customer_type,sum(total) as total_rev from sales
group by customer_type
order by total_rev;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,sum(total) as total_rev from sales
group by city
order by total_rev desc;

-- 4. Which customer type pays the most in VAT?
select customer_type,sum(VAT) VAT from sales
group by customer_type
order by VAT desc;
-- --------------------------------Customer--------------------------------------------------------------------------
-- 1. How many unique customer types does the data have?
select distinct customer_type from sales;

-- 2. How many unique payment methods does the data have?
select distinct payment_method from sales;

-- 3. What is the most common customer type?
select customer_type,count(*) as most from sales
group by customer_type
order by most desc;

-- 4. Which customer type buys the most?
select customer_type,count(*) as most from sales
group by customer_type
order by most desc;

-- 5. What is the gender of most of the customers?
select gender,count(*) as most from sales
group by gender
order by most desc;

-- 6. What is the gender distribution per branch?
select gender,branch,count(*) as most from sales
group by gender,branch
order by branch ;

-- 7. Which  of the day do customers give most ratings?
select day_name,avg(rating) as rat from sales
group by day_name
order by rat desc;

-- 8. Which time of the day do customers give most ratings per branch?
select day_name,branch,avg(rating) as rat from sales
group by day_name,branch
order by branch desc;

-- 9. Which day fo the week has the best avg ratings?
select day_name,avg(rating) as rat from sales
group by day_name
order by rat desc limit 1;

-- 10. Which month has the best average ratings per branch?
select month_name ,avg(rating) as rat from sales
group by month_name
order by rat desc limit 1;