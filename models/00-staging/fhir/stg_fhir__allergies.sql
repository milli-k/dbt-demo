with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'allergyintolerance'
)
select
    replace(resource_raw:"patient"."reference"::varchar,'urn:uuid:','') as patient_id,
    resource_raw:"code"."coding"[0]."code"::varchar as code,
    resource_raw:"category"[0]::varchar as category,
    resource_raw:"code"."coding"[0]."display"::varchar as description,
    resource_raw:"type"::varchar as type,
    resource_raw:"criticality"::varchar as criticality,
    resource_raw:"onsetDateTime"::timestamp as onset_ts,
    resource_raw:"clinicalStatus"."coding"[0]."code"::varchar as clinical_status,
    resource_raw
from raw