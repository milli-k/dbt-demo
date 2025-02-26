select
  {{ dbt_utils.star(ref('stg_finance__quarterly_results')) }}
from {{ ref('stg_finance__quarterly_results') }}