{{ config(
    materialized='table',
    full_refresh=true
) }}

WITH final_report AS (
    SELECT 
        o.order_id AS order_id, 
        c.client_id AS user_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        DATE(o.sale_date) AS sale_date,
        p.product_name AS product_name,
        p.category AS product_category,
        p.price AS product_price
    FROM data.orders o
    JOIN data.clients c ON c.client_id = o.client_id
    JOIN data.products p ON p.product_id = o.product_id
)

SELECT *
FROM final_report
ORDER BY order_id ASC