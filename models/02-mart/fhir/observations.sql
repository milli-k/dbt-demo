select {{ dbt_utils.star(ref("stg_fhir__observations")) }}
from {{ ref("int_fhir__observations") }}
