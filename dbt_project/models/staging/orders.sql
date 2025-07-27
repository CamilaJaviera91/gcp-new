{{ config(
    materialized='table',
    full_refresh=true
) }}

WITH numbered_items AS (
  SELECT
    ROW_NUMBER() OVER () AS order_item_id,
    CEIL(ROW_NUMBER() OVER () / 10.0) AS order_id,
    CAST(FLOOR(random() * 1000 + 1) AS INT) AS client_id,
    CAST(FLOOR(random() * 20 + 1) AS INT) AS product_id,
    CURRENT_DATE - ((random() * 365)::INT) AS sale_date

  FROM
    generate_series(1, 5000)
)

SELECT * FROM numbered_items