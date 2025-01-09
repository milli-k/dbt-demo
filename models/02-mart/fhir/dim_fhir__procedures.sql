select
  {{ dbt_utils.star(ref('stg_fhir__procedures')) }}
from {{ ref('stg_fhir__procedures') }}