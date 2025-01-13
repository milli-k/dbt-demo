select
    {{
        dbt_utils.star(
            ref("stg_fhir__procedures"),
            except=[performed_ts, performed_start_ts, performed_end_ts],
        )
    }},
    case when performed_ts is not null then true else false end as is_quick_procedure,
    coalesce(performed_ts, performed_start_ts) as performed_start_ts,
    coalesce(performed_ts, performed_end_ts) as performed_end_ts
from {{ ref("stg_fhir__procedures") }}
