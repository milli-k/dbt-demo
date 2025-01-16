select
  {{ dbt_utils.star(ref('stg_fhir__encounters')) }}
from {{ ref('stg_fhir__encounters') }}