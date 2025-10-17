-- {{ config(
--     materialized='table',
--     schema='analytics'
-- ) }}

-- SELECT
--     id,
--     product_name,
--     category,
--     quantity_sold,
--     sale_date,
--     revenue
-- FROM {{ source('analytics', 'sales_data') }}

{{ config(
    materialized='incremental',
    unique_key='id',
    schema='analytics',
    tags=['staging', 'incremental'],
    incremental_strategy='merge'
) }}

SELECT
    id,
    product_name,
    category,
    quantity_sold,
    sale_date,
    revenue,
    CURRENT_TIMESTAMP() AS updated_at
FROM {{ source('analytics', 'sales_data') }}

{% if is_incremental() %}
WHERE sale_date > (SELECT MAX(sale_date) FROM {{ this }})
  OR updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
