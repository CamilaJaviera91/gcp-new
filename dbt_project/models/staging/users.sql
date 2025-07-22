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
roles AS (
    SELECT *
    FROM unnest(ARRAY[
        'Data Analyst', 'Data Engineer', 'BI Analyst', 'Software Developer', 'Project Manager',
        'Marketing Specialist', 'QA Engineer', 'Support Engineer', 'HR Specialist', 'Finance Analyst'
    ]) WITH ORDINALITY AS t(role, id)
),
countries AS (
    SELECT *
    FROM unnest(ARRAY[
        'Chile', 'Argentina', 'Colombia', 'México', 'Perú', 'Uruguay', 'Paraguay', 'Ecuador', 'Bolivia', 'Venezuela'
    ]) WITH ORDINALITY AS t(country, id)
),
base AS (
    SELECT 
        generate_series(1, 1000) AS user_id,
        (random() * interval '3 years') AS random_date,
        floor(random() * 20 + 1)::int AS fn_id,
        floor(random() * 20 + 1)::int AS ln_id,
        floor(random() * 10 + 1)::int AS role_id,
        floor(random() * 10 + 1)::int AS country_id,
        CASE 
            WHEN random() > 0.5 THEN 'active'
            ELSE 'inactive'
        END AS status
),
user_data AS (
    SELECT
        b.user_id,
        fn.first_name,
        ln.last_name,
        CASE 
            WHEN fn.first_name IN ('Camila', 'Fernanda', 'Isidora', 'Valentina', 'María', 'Daniela', 'Antonia', 'Josefa', 'Florencia', 'Catalina')
            THEN 'F'
            ELSE 'M'
        END AS gender,
        r.role,
        c.country,
        CONCAT(lower(regexp_replace(fn.first_name, '[^a-zA-Z]', '', 'g')), '_',
               lower(regexp_replace(ln.last_name, '[^a-zA-Z]', '', 'g')), '_', b.user_id) AS username,
        lower(
            regexp_replace(CONCAT(fn.first_name, '.', ln.last_name, b.user_id, '@example.com'), '[^a-zA-Z0-9.@]', '', 'g')
        ) AS email,
        CONCAT('+56 9 ', LPAD((floor(random() * 100000000)::int)::text, 8, '0')) AS phone_number,
        now() - b.random_date AS created_at,
        b.status,
        CASE
            WHEN b.status = 'active' THEN NULL
            ELSE b.random_date + now()
        END AS terminated_at
    FROM base b
    LEFT JOIN first_names fn ON b.fn_id = fn.id
    LEFT JOIN last_names ln ON b.ln_id = ln.id
    LEFT JOIN roles r ON b.role_id = r.id
    LEFT JOIN countries c ON b.country_id = c.id
)

SELECT * FROM user_data