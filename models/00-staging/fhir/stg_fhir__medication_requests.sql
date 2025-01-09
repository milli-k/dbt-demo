with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'medicationrequest'
)
select
    resource_raw:"authoredOn"::date as authored_on,
    replace(resource_raw:"subject"."reference"::varchar,'urn:uuid:','') as patient_id,
    replace(resource_raw:"context"."reference"::varchar,'urn:uuid:','') as encounter_id,
    replace(resource_raw:"reasonReference"[0]:"reference"::varchar,'urn:uuid:','') as condition_id,
    resource_raw:"status"::varchar as status,
    try_to_boolean(resource_raw:"dosageInstruction"[0]."asNeededBoolean"::varchar) as dosage_instructions_as_needed,
    resource_raw,
from raw
