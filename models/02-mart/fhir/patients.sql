select
  {{ dbt_utils.star(ref('stg_fhir__patients')) }}
from {{ ref('int_fhir__patients') }}