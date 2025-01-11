select
  {{ dbt_utils.star(ref('int_ecomm__users')) }}
from {{ ref('int_ecomm__users') }}