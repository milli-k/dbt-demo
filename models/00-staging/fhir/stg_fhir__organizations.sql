with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'organization'
)
select
    resource_raw:"id"::varchar as id,
    resource_raw:"name"::varchar as name,
    resource_raw:"type"[0]."text"::varchar as type,
    resource_raw:"meta"."profile"[0]::varchar as profile,
    uniform(100000, 50000000, random()) as revenue,
    resource_raw
from raw