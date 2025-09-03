create table OnlineRetail(
 InvoiceNo int not null,
 StockCode varchar(50) not null,
 Description varchar(50) ,
 Quantity int not null,
 InvoiceDate date,
 UnitPrice int,
 CustomerID int,
 Country varchar(50)
);

select * from OnlineRetail;

alter table OnlineRetail alter column unitprice TYPE numeric;

alter table OnlineRetail ALTER COLUMN invoiceno TYPE text;

WITH cohort AS (
    SELECT 
        customerid,
        MIN(DATE_TRUNC('month', invoicedate)) AS cohort_month
    FROM onlineretail
    WHERE customerid IS NOT NULL
    GROUP BY customerid
),
transactions AS (
    SELECT 
        customerid,
        DATE_TRUNC('month', invoicedate) AS order_month
    FROM onlineretail
    WHERE customerid IS NOT NULL
),
cohort_analysis AS (
    SELECT 
        c.cohort_month,
        t.order_month,
        COUNT(DISTINCT t.customerid) AS active_customers,
        (EXTRACT(YEAR FROM t.order_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM t.order_month) - EXTRACT(MONTH FROM c.cohort_month)) AS month_index
    FROM transactions t
    JOIN cohort c ON t.customerid = c.customerid
    GROUP BY c.cohort_month, t.order_month
)
SELECT 
    cohort_month,
    month_index,
    active_customers
FROM cohort_analysis
ORDER BY cohort_month, month_index;

WITH cohort AS (
    SELECT 
        customerid,
        MIN(DATE_TRUNC('month', invoicedate)) AS cohort_month
    FROM onlineretail
    WHERE customerid IS NOT NULL
    GROUP BY customerid
),
transactions AS (
    SELECT 
        customerid,
        DATE_TRUNC('month', invoicedate) AS order_month
    FROM onlineretail
    WHERE customerid IS NOT NULL
),
cohort_size AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT customerid) AS cohort_customers
    FROM cohort
    GROUP BY cohort_month
),
cohort_analysis AS (
    SELECT 
        c.cohort_month,
        t.order_month,
        COUNT(DISTINCT t.customerid) AS active_customers,
        (EXTRACT(YEAR FROM t.order_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM t.order_month) - EXTRACT(MONTH FROM c.cohort_month)) AS month_index
    FROM transactions t
    JOIN cohort c ON t.customerid = c.customerid
    GROUP BY c.cohort_month, t.order_month
)
SELECT 
    ca.cohort_month,
    ca.month_index,
    ca.active_customers,
    ROUND( (ca.active_customers::decimal / cs.cohort_customers) * 100 , 2) AS retention_rate
FROM cohort_analysis ca
JOIN cohort_size cs ON ca.cohort_month = cs.cohort_month
ORDER BY ca.cohort_month, ca.month_index;
