{{ config(
    materialized='table',
    full_refresh=true
) }}

WITH products_items AS (
    SELECT *
    FROM (
        VALUES
            (1, 'iPhone 14', 'Smartphones', 899.99),
            (2, 'Samsung Galaxy S23', 'Smartphones', 849.99),
            (3, 'MacBook Pro 14"', 'Laptops', 1999.00),
            (4, 'Dell XPS 13', 'Laptops', 1499.00),
            (5, 'AirPods Pro', 'Audio', 249.00),
            (6, 'Bose QC 45', 'Audio', 329.00),
            (7, 'Logitech MX Master 3', 'Accessories', 99.99),
            (8, 'Apple Magic Keyboard', 'Accessories', 129.99),
            (9, 'Sony Bravia 55"', 'Televisions', 1099.00),
            (10, 'Samsung QLED 65"', 'Televisions', 1299.00),
            (11, 'Kindle Paperwhite', 'E-Readers', 139.99),
            (12, 'Google Nest Hub', 'Smart Home', 99.99),
            (13, 'Instant Pot Duo', 'Kitchen', 89.99),
            (14, 'Ninja Air Fryer', 'Kitchen', 119.99),
            (15, 'Fitbit Charge 5', 'Wearables', 149.99),
            (16, 'Apple Watch Series 8', 'Wearables', 399.00),
            (17, 'Canon EOS M50', 'Cameras', 679.00),
            (18, 'GoPro HERO11', 'Cameras', 499.00),
            (19, 'Philips Hue Bulb', 'Smart Home', 49.99),
            (20, 'Razer Gaming Chair', 'Gaming', 349.00)
    ) AS t(product_id, product_name, category, price)
)

SELECT * FROM products_items