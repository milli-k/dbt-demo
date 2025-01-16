select
  {{ dbt_utils.star(ref('int_fhir__care_plans')) }}
from {{ ref('int_fhir__care_plans') }}