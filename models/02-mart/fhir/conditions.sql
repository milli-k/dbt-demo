select
  {{ dbt_utils.star(ref('stg_fhir__conditions')) }}
from {{ ref('stg_fhir__conditions') }}