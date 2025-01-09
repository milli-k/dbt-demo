with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'diagnosticreport'
)
select
    resource_raw:"id"::varchar as id,
    replace(resource_raw:"subject"."reference"::varchar,'urn:uuid:','') as patient_id,
    resource_raw:"status"::varchar as status,
    resource_raw:"code"."coding"[0]."code"::varchar as code,
    resource_raw:"code"."coding"[0]."display"::varchar as name,
    resource_raw:"effectiveDateTime"::timestamp as effective_ts,
    resource_raw:"issued"::timestamp as issued_ts,
    resource_raw:"result"::variant as result,
    resource_raw
from raw