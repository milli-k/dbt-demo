select
  {{ dbt_utils.star(ref('stg_fhir__medication_requests')) }}
from {{ ref('stg_fhir__medication_requests') }}