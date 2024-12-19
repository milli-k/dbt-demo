{{ config(alias='inventory_items') }}

select
  {{ dbt_utils.star(source('ecomm', 'inventory_items')) }}
from {{ source('ecomm', 'inventory_items') }}