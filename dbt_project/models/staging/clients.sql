{{ config(
    materialized='table',
    full_refresh=true
) }}

WITH first_names AS (
    SELECT *
    FROM unnest(ARRAY[
        'Camila', 'Carlos', 'Fernanda', 'Luis', 'Isidora', 'Pedro', 'Valentina', 'Jorge', 'María', 'Sebastián',
        'Daniela', 'Andrés', 'Antonia', 'Matías', 'Josefa', 'Ignacio', 'Florencia', 'Diego', 'Catalina', 'Benjamín'
    ]) WITH ORDINALITY AS t(first_name, id)
),
last_names AS (
    SELECT *
    FROM unnest(ARRAY[
        'Muñoz', 'Navarro', 'Pérez', 'González', 'Rodríguez', 'López', 'Díaz', 'Sánchez', 'Romero', 'Castro',
        'Vargas', 'Silva', 'Torres', 'Rojas', 'Flores', 'Morales', 'Ortega', 'Herrera', 'Reyes', 'Fuentes'
    ]) WITH ORDINALITY AS t(last_name, id)
),
city AS (
    SELECT *
    FROM unnest(ARRAY[
        'Curicó', 'Talca', 'Linares', 'San Fernando', 'Santiago', 'Viña del Mar', 'Puerto Montt', 'Rancagua', 'Valparaiso', 'Parral'
    ]) WITH ORDINALITY AS t(country, id)
),
base AS (
    SELECT 
        generate_series(1, 1000) AS client_id,
        (random() * interval '3 years') AS random_date,
        floor(random() * 20 + 1)::int AS fn_id,
        floor(random() * 20 + 1)::int AS ln_id,
        floor(random() * 10 + 1)::int AS city_id,
        CASE 
            WHEN random() > 0.5 THEN 'active'
            ELSE 'inactive'
        END AS status
),
user_data AS (
    SELECT
        b.client_id,
        fn.first_name,
        ln.last_name,
        CASE 
            WHEN fn.first_name IN ('Camila', 'Fernanda', 'Isidora', 'Valentina', 'María', 'Daniela', 'Antonia', 'Josefa', 'Florencia', 'Catalina')
            THEN 'F'
            ELSE 'M'
        END AS gender,
        c.country,
        CONCAT(lower(regexp_replace(fn.first_name, '[^a-zA-Z]', '', 'g')), '_',
               lower(regexp_replace(ln.last_name, '[^a-zA-Z]', '', 'g')), '_', b.client_id) AS username,
        lower(
            regexp_replace(CONCAT(fn.first_name, '.', ln.last_name, b.client_id, '@example.com'), '[^a-zA-Z0-9.@]', '', 'g')
        ) AS email,
        CONCAT('+56 9 ', LPAD((floor(random() * 100000000)::int)::text, 8, '0')) AS phone_number,
        b.status
    FROM base b
    LEFT JOIN first_names fn ON b.fn_id = fn.id
    LEFT JOIN last_names ln ON b.ln_id = ln.id
    LEFT JOIN city c ON b.city_id = c.id
)

SELECT * FROM user_data