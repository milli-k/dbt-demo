select
  {{ dbt_utils.star(ref('stg_fhir__medication_requests')) }}
from {{ ref('int_fhir__medication_requests') }}