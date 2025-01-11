with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'careplan'
)
select
    replace(resource_raw:"subject"."reference"::varchar,'urn:uuid:','') as patient_id,
    replace(resource_raw:"context"."reference"::varchar,'urn:uuid:','') as service_provider_id,
    replace(resource_raw:"addresses"[0]:"reference"::varchar,'urn:uuid:','') as condition_id,
    resource_raw:"status"::varchar as status,
    resource_raw:"category"[0]:"coding"[0]:"display"::varchar as category,
    resource_raw:"period"."start"::timestamp as start_ts,
    resource_raw:"period"."end"::timestamp as end_ts,
    resource_raw:"activity"::variant as activity,
    resource_raw
from raw