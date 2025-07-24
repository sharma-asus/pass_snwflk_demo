/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(
    materialized='table',
    schema=var('my_schema'),
    transient=false
) }}

with source_data as (

    select 1 as id, '{{ var("my_table") }}' as table_name, '{{ var("run_date") }}' as run_date
    union all
    select null as id, '{{ var("my_table") }}', '{{ var("run_date") }}'

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
