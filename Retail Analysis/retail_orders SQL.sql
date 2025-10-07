SELECT * FROM df_orders;  -- works

-- find top 10 highest revenue generating products
SELECT
	PRODUCT_ID,
	SUM(TOTAL_SALES) AS SALES
FROM
	DF_ORDERS
GROUP BY
	PRODUCT_ID
ORDER BY
	SALES DESC
LIMIT
	10;

-- find top 5 highest selling product_ids in each region
WITH sales_rank AS (
    SELECT 
        region,
        product_id,
        SUM(total_sales) AS sales,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(total_sales) DESC) AS rn
    FROM df_orders
    GROUP BY region, product_id
)
SELECT region, product_id, sales
FROM sales_rank
WHERE rn <= 5
ORDER BY region, rn;

-- #find the month over month (mom) growth
SELECT
    years,
    months,
    sales,
    LAG(sales) OVER (PARTITION BY years ORDER BY months) AS prev_month_sales,
    ROUND(
        ((sales - LAG(sales) OVER (PARTITION BY years ORDER BY months)) 
        / NULLIF(LAG(sales) OVER (PARTITION BY years ORDER BY months), 0))::numeric, 
        2
    ) AS mom_growth_percent
FROM (
    SELECT
        EXTRACT(YEAR FROM order_date) AS years,
        EXTRACT(MONTH FROM order_date) AS months,
        SUM(total_sales) AS sales
    FROM df_orders
    GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
) t
ORDER BY years, months;

-- For each category which month had highest sales
with cte as (
SELECT
	CATEGORY,
	TO_CHAR(ORDER_DATE, 'yyyy-MM') as year_months,
	sum(total_sales) as Sales
FROM
	DF_ORDERS
GROUP BY
	CATEGORY,
	TO_CHAR(ORDER_DATE, 'yyyy-MM')
	)
	select * from (
	select row_number() over (partition by category order by Sales desc) as rn, * from cte
	) a where rn = 1;

-- Which sub category had highest growth by profit in 2023 compare  to 2022

with cte as (
select sub_category, extract(year from order_date) as order_year,
sum(total_sales) as Sales
from df_orders
group by sub_category, extract(year from order_date)
) , cte2 as (
select sub_category, 
sum(case when order_year = 2022 then Sales else 0 end) as Sales_2022,
sum(case when order_year = 2023 then Sales else 0 end) as Sales_2023
from cte group by sub_category
)
select *, (Sales_2023 - Sales_2022)*100/Sales_2022 from cte2
order by (Sales_2023 - Sales_2022)*100/Sales_2022 desc limit 1;