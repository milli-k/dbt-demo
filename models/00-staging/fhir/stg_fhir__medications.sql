with raw as (
    select 
        variant_col:"entry"[0]:"resource".id::varchar as patient_id,
        v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'medication'
)
select
    patient_id,
    resource_raw:"code"."coding"[0]."code"::varchar as code,
    resource_raw:"code"."coding"[0]."display"::varchar as name,
    resource_raw
from raw