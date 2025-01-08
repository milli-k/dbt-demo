with
    raw as (
        select variant_col:entry[1]."resource"::variant as resource_raw
        from {{ source("fhir", "raw_fhir") }}
        where lower(variant_col:entry[1].resource."resourceType"::varchar) = 'organization'
    )
select
    resource_raw:"id"::varchar as id,
    resource_raw:"name"::varchar as name,
    resource_raw:"type"[0]."text"::varchar as type,
    resource_raw:"meta"."profile"[0]::varchar as profile,
    uniform(100000,50000000,random()) as revenue,
    resource_raw
from raw
group by all