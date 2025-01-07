select
  {{ dbt_utils.star(ref('stg_ecomm__products')) }}
from {{ ref('stg_ecomm__products') }}