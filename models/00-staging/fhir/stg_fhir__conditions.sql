with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'condition'
)
select
    resource_raw:"id"::varchar as id,
    replace(resource_raw:"subject"."reference"::varchar,'urn:uuid:','') as patient_id,
    -- come back to this
    replace(resource_raw:"context":"reference"::varchar,'urn:uuid:','') as unknown_fk,
    resource_raw:"clinicalStatus"::varchar as clinical_status,
    resource_raw:"verificationStatus"::varchar as verification_status,
    resource_raw:"code"."coding"[0]."code"::varchar as code,
    resource_raw:"code"."coding"[0].text as name,
    resource_raw:"onsetDateTime"::timestamp as onset_ts,
    resource_raw:"abatementDateTime"::timestamp as abatement_ts,
    resource_raw:"recordedDate"::timestamp as recorded_ts,
    resource_raw
from raw
