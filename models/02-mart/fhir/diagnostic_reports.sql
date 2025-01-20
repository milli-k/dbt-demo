select
  {{ dbt_utils.star(ref('stg_fhir__diagnostic_reports')) }}
from {{ ref('int_fhir__diagnostic_reports') }}