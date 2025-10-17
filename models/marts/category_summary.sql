{{ config(
    materialized='view',
    schema='analytics'
) }}

SELECT
    category,
    COUNT(*) AS total_sales,
    SUM(quantity_sold) AS total_quantity,
    SUM(revenue) AS total_revenue
FROM {{ ref('stg_sales_data') }}
GROUP BY category