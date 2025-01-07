select
  {{ dbt_utils.star(ref('stg_ecomm__distribution_centers')) }}
from {{ ref('stg_ecomm__distribution_centers') }}