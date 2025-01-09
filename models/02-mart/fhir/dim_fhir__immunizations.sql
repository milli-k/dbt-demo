select
  {{ dbt_utils.star(ref('stg_fhir__immunizations')) }}
from {{ ref('stg_fhir__immunizations') }}