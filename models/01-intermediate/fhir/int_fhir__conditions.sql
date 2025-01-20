select
  timestampadd(year, extract(year, current_date()) - 2017, asserted_date) as asserted_date,
  timestampadd(year, extract(year, current_date()) - 2017, onset_ts) as onset_ts,
  timestampadd(year, extract(year, current_date()) - 2017, abatement_ts) as abatement_ts,
  {{ dbt_utils.star(ref('stg_fhir__conditions'), except=["asserted_date", "onset_ts", "abatement_ts"]) }}
from {{ ref('stg_fhir__conditions') }}