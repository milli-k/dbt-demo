select
  {{ dbt_utils.star(ref('int_fhir__allergies')) }}
from {{ ref('int_fhir__allergies') }}