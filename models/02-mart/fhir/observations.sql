select
  {{ dbt_utils.star(ref('stg_fhir__observations')) }}
from {{ ref('stg_fhir__observations') }}