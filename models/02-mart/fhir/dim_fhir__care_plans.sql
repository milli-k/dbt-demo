select
  {{ dbt_utils.star(ref('stg_fhir__care_plans')) }}
from {{ ref('stg_fhir__care_plans') }}