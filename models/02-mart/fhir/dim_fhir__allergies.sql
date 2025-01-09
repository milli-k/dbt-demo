select
  {{ dbt_utils.star(ref('stg_fhir__allergies')) }}
from {{ ref('stg_fhir__allergies') }}