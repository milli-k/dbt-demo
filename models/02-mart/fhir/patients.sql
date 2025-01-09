select
  {{ dbt_utils.star(ref('stg_fhir__patients')) }}
from {{ ref('stg_fhir__patients') }}