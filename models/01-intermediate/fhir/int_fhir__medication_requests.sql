select
    timestampadd(year, extract(year, current_date()) - 2017, authored_on) as authored_on,
    {{ dbt_utils.star(ref("stg_fhir__medication_requests"), except=["authored_on"]) }}
from {{ ref('stg_fhir__medication_requests') }}

