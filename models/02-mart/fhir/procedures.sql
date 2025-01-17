select
  {{ dbt_utils.star(ref('stg_fhir__procedures')) }},
  case when performed_ts is not null then true else false end as is_quick_procedure
from {{ ref('int_fhir__procedures') }}