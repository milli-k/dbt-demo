select
  {{ dbt_utils.star(ref('stg_fhir__immunizations')) }}
from {{ ref('int_fhir__immunizations') }}