{{ config(
    materialized='incremental',
    unique_key='id',
    schema='analytics',
    tags=['staging', 'incremental'],
    incremental_strategy='merge'
) }}

select
    id,
    product_name,
    category,
    quantity_sold,
    sale_date,
    revenue,
    current_timestamp() as updated_at
from {{ source('analytics', 'sales_data') }}

-- {% if is_incremental() %}
-- where updated_at > (select max_updated_at from max_existing)
-- {% endif %}
