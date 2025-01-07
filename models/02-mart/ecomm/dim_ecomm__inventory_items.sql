select
  {{ dbt_utils.star(ref('int_ecomm__inventory_items')) }}
from {{ ref('int_ecomm__inventory_items') }}