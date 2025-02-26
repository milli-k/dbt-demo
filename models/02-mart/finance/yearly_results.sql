select
  {{ dbt_utils.star(ref('stg_finance__yearly_results')) }}
from {{ ref('stg_finance__yearly_results') }}