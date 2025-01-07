select
  {{ dbt_utils.star(source('ecomm', 'inventory_items')) }}
from {{ source('ecomm', 'inventory_items') }}