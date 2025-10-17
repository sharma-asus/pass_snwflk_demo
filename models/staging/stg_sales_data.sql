{{ config(
    materialized='incremental',
    unique_key='id',
    schema='analytics',
    tags=['staging', 'incremental'],
    incremental_strategy='merge'
) }}

-- Get the max updated_at from the existing table
{% if is_incremental() %}
with max_existing as (
    select max(updated_at) as max_updated_at
    from {{ this }}
)
{% endif %}

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
