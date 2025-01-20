select
  {{ dbt_utils.star(ref('int_fhir__procedures')) }}
from {{ ref('int_fhir__procedures') }}