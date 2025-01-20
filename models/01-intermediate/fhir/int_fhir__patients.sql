select
    timestampadd(year, extract(year, current_date()) - 2017, birth_date) as birth_date,
    timestampadd(year, extract(year, current_date()) - 2017, deceased_ts) as deceased_ts,
    {{ dbt_utils.star(ref("stg_fhir__patients"), except=["birth_date", "deceased_ts"]) }}
from {{ ref('stg_fhir__patients') }}