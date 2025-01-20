select 
    timestampadd(year, extract(year, current_date()) - 2017, effective_ts) as effective_ts,
    timestampadd(year, extract(year, current_date()) - 2017, issued_ts) as issued_ts,
    {{ dbt_utils.star(ref("stg_fhir__observations"), except=["effective_ts", "issued_ts"]) }}
from {{ ref("stg_fhir__observations") }}
