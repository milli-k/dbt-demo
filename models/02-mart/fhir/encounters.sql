select
  {{ dbt_utils.star(ref('stg_fhir__encounters')) }}
from {{ ref('int_fhir__encounters') }}