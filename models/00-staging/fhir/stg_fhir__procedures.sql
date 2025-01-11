with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'procedure'
)
select
    replace(resource_raw:"subject"."reference"::varchar,'urn:uuid:','') as patient_id,
    replace(resource_raw:"reasonReference"."reference"::varchar,'urn:uuid:','') as condition_id,
    replace(resource_raw:"context"."reference"::varchar,'urn:uuid:','') as encounter_id,
    resource_raw:"status"::varchar as status,
    resource_raw:"code"."coding"[0]."code"::varchar as code,
    resource_raw:"code"."coding"[0]."display"::varchar as name,
    resource_raw:"performedDateTime"::timestamp as performed_ts,
    resource_raw:"reasonReference"."display"::varchar as reason_reference,
    resource_raw:"bodySite"[0]."coding"[0]."code"::varchar as body_site,
    resource_raw
from raw
