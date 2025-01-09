select
  {{ dbt_utils.star(ref('stg_fhir__medications')) }}
from {{ ref('stg_fhir__medications') }}