select
  {{ dbt_utils.star(ref('stg_fhir__allergies')) }}
from {{ ref('int_fhir__allergies') }}