select * from pizzas;

create table Pizzas(
  	pizza_id int primary key,
	order_id int not null,
	pizza_name_id varchar(40),
	quantity int not null,
	order_date date not null,
	order_time time,
	unit_price numeric not null,
	total_price numeric not null,
	pizza_size Varchar(5),
	pizza_category Varchar(30),
	pizza_ingredients varchar(300),
	pizza_name varchar(50)
);

-- confirm you’re connected to the intended DB
SELECT current_database(), current_schema();

-- check if the table already has rows
SELECT COUNT(*) AS row_count, MIN(pizza_id), MAX(pizza_id) FROM public.pizzas;

-- specifically check for the conflicting key
SELECT * FROM public.pizzas WHERE pizza_id = 1;

-- sanity: list a few rows if any
SELECT pizza_id FROM public.pizzas ORDER BY pizza_id LIMIT 10;


drop table pizzas;

select * from Pizzas;

--1. Total Revenue:
select sum(total_price) as Revenue from Pizzas;

--2. Average Order Value
select sum(total_price)/count(distinct order_id) as Average_orders from Pizzas;

--3. Total Pizzas Sold
select sum(quantity) as Total_Pizzas_sold from Pizzas;

--4. Total Orders
select count(distinct order_id) as Total_orders from Pizzas;

--5. Average Pizzas Per 
SELECT
	cast(CAST(SUM(QUANTITY) AS DECIMAL(10, 2)) / CAST(COUNT(DISTINCT ORDER_ID) AS DECIMAL(10, 2)) as decimal(10,2)) AS AVERAGE_PIZZA_PER
FROM
	PIZZAS;

select * from Pizzas;

--B. Daily Trend for Total Orders
SELECT
	TO_CHAR(ORDER_DATE, 'DAY') AS ORDER_DAY,
	COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS
FROM
	PIZZAS
group by TO_CHAR(ORDER_DATE, 'DAY');
-- 9.Hourly Trend for Orders
SELECT
	EXTRACT(
		HOUR
		FROM
			ORDER_TIME
	) AS ORDER_HOUR,
	COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS
FROM
	PIZZAS group by EXTRACT(
		HOUR
		FROM
			ORDER_TIME
	) order by ORDER_HOUR;

--D. % of Sales by Pizza Category

SELECT
	PIZZA_CATEGORY,
	CAST(SUM(TOTAL_PRICE) AS DECIMAL(10, 2)) AS TOTAL_REVENUE,
	CAST(
		SUM(TOTAL_PRICE) * 100 / (
			SELECT
				SUM(TOTAL_PRICE)
			FROM
				PIZZAS
		) AS DECIMAL(10, 2)
	) AS PERCENTAGE
FROM
	PIZZAS
GROUP BY
	PIZZA_CATEGORY
ORDER BY
	PIZZA_CATEGORY;

--E. % of Sales by Pizza Size

SELECT
	pizza_size,
	CAST(SUM(TOTAL_PRICE) AS DECIMAL(10, 2)) AS TOTAL_REVENUE, cast(sum(total_price) * 100/ (select sum(total_price) from pizzas ) as decimal(10,2))
as percentage FROM
	PIZZAS group by Pizza_size order by pizza_size;

--F. Total Pizzas Sold by Pizza Category
SELECT
	PIZZA_CATEGORY,
	SUM(QUANTITY) AS TOTAL_QUANTITY
FROM
	PIZZAS
GROUP BY
	PIZZA_CATEGORY
ORDER BY
	SUM(QUANTITY) DESC;

--G. Top 5 Best Sellers by Total Pizzas Sold
SELECT
	PIZZA_NAME,
	SUM(QUANTITY) AS TOTAL_QUANTITY_SOLD
FROM
	PIZZAS
GROUP BY
	PIZZA_NAME
ORDER BY
	SUM(QUANTITY) desc limit 5;

--H. Bottom 5 Best Sellers by Total Pizzas Sold
SELECT
	PIZZA_NAME,
	SUM(QUANTITY) AS TOTAL_QUANTITY_SOLD
FROM
	PIZZAS
GROUP BY
	PIZZA_NAME
ORDER BY
	SUM(QUANTITY) asc limit 5;