select
  {{ dbt_utils.star(source('ecomm', 'order_items')) }}
from {{ source('ecomm', 'order_items') }}