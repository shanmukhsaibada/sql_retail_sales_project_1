-- sql retail sales analysis - p1
Create database sql_project_p2;

-- creating a table 
create table retail_sales
		(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,	
		customer_id	INT,
		gender VARCHAR(15),	
		age	INT,
		category VARCHAR(15),
		quantiy	INT,
		price_per_unit	FLOAT,
		cogs FLOAT,
		total_sale FLOAT
		);
		
--exploring the data 

select * 
from retail_sales
limit 10;

-- checking if the data is properly imported or not by checking the row count 

select 
   count(*)
from retail_sales;

-- checking the null values from the table 

select * 
from retail_sales
 Where 
      	transactions_id is null
   	  	or 
	  	sale_date is null
		or
		sale_time is null
		or
		sale_time is null
		or
		customer_id is null
		or 
		gender is null
		or 
		age is null 
		or 
		category is null 
		or 
		quantiy is null
		or 
		price_per_unit is null
		or 
		cogs is null
		or 
		total_sale is null ;

--deleting the null values 

delete from retail_sales 

 Where 
      	transactions_id is null
   	  	or 
	  	sale_date is null
		or
		sale_time is null
		or
		sale_time is null
		or
		customer_id is null
		or 
		gender is null
		or 
		age is null 
		or 
		category is null 
		or 
		quantiy is null
		or 
		price_per_unit is null
		or 
		cogs is null
		or 
		total_sale is null ;

-- Data Exploration 
-- How much sale we have ?

select count(*) 
as total_sale 
from retail_sales;

-- how many unqiue customers we have ?

select count(Distinct customer_id) 
as total_sale 
from retail_sales;

-- how many unquie cateogary we have ?

select count(Distinct category) 
as total_sale 
from retail_sales;

-- show unique catergory 

select Distinct category 
from retail_sales;

-- what is the total amount of sales 

select sum(total_sale) as total_amount 
from retail_sales;

-- Data analysis and Business key Problems 

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

 select *
 from retail_sales 
 where sale_date = '2022-11-05'

 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * 
FROM retail_sales 
WHERE category = 'Clothing' 
  AND quantiy >= 4 
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(total_sale)as net_sale,
 count(*)
 as total_sale
from retail_sales 
group by category:

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select ROUND(avg(age),2)as avg_age  -- round is nothing but showing two values in readble format
from retail_sales 
where category  = 'Beauty' ;



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * 
from retail_sales 
where total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,
       gender, 
	   count(transactions_id) as total_transactions 
	   from retail_sales 
	   group by gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
      year,
	  month,
	  avg_sale
from
(
	select 
   		extract (YEAR from sale_date) as year,
   		extract (MONTH from sale_date) as month,
   		avg(total_sale) AS avg_sale,
		rank() over(partition  by extract(YEAR from sale_date) order by avg(total_sale)) as rank
		from retail_sales group by 1, 2
		ORDER BY 1, 2
 ) as t1
 where rank = 1 ; -- sub queries
 
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id , 
sum(total_sale) as max_sale 
from retail_sales 
group by 1 
order by 2 desc
limit 5 

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct customer_id) as unq_customers ,
category 
from retail_sales
group by 2

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


with hourly_sale -- CTE common table expression
as
(

select *,
 		case
			WHEN EXTRACT(hour from sale_time) <= 12 THEN 'Morning'
			WHEN EXTRACT(hour from sale_time) between 12 and 17 THEN 'afternoon'
			ELSE 'evening'
				END AS SHIFT
		from
		retail_sales
)
select 
count(transactions_id) as total_transctions,
count(total_sale) as tot_Sale,
shift
from hourly_sale
group by shift;