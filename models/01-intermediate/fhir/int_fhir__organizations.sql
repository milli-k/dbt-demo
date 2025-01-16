select
  {{ dbt_utils.star(ref('stg_fhir__organizations')) }}
from {{ ref('stg_fhir__organizations') }}