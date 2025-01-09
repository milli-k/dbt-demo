select
  {{ dbt_utils.star(ref('stg_fhir__diagnostic_reports')) }}
from {{ ref('stg_fhir__diagnostic_reports') }}