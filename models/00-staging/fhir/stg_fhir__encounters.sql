with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'encounter'
)
select
    resource_raw:"id"::varchar as id,
    replace(resource_raw:"subject"."reference"::varchar,'urn:uuid:', '') as patient_id,
    resource_raw:"class"."code"::varchar as class,
    resource_raw:"type"[0]."text"::varchar as type,
    resource_raw:"period"."start"::timestamp as start_ts,
    resource_raw:"period"."end"::timestamp as end_ts,
    replace(resource_raw:"serviceProvider"."reference"::varchar,'urn:uuid:', '') as service_provider_id,
    resource_raw:"reason"."coding"[0]:"code"::varchar as reason_code,
    resource_raw:"reason"."coding"[0]:"display"::varchar as reason,
    resource_raw
from raw