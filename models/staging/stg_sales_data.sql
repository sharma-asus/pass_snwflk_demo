{{ config(
    materialized='table',
    schema='analytics'
) }}

SELECT
    id,
    product_name,
    category,
    quantity_sold,
    sale_date,
    revenue
FROM {{ source('analytics', 'sales_data') }}
