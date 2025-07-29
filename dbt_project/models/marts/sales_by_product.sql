{{ config(
    materialized='table',
    full_refresh=true
) }}

WITH sales_by_product AS (
    SELECT 
        p.product_id AS ProductID,
        p.product_name AS ProductName,
        EXTRACT(MONTH FROM o.sale_date) AS Month,
        EXTRACT(YEAR FROM o.sale_date) AS Year,
        SUM(p.price) AS Total
    FROM data.orders o
    JOIN data.products p ON p.product_id = o.product_id
    GROUP BY 
        p.product_id,
        p.product_name,
        EXTRACT(MONTH FROM o.sale_date),
        EXTRACT(YEAR FROM o.sale_date)
)

SELECT *
FROM sales_by_product
ORDER BY Year, Month ASC