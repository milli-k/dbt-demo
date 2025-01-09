with raw as (
    select v.resource_raw
    from {{ source("fhir", "raw_fhir") }},
    lateral flatten(input => variant_col:entry) as f,
    lateral (select f.value:resource::variant as resource_raw) as v
    where lower(v.resource_raw:"resourceType"::varchar) = 'patient'
)
select
    resource_raw:"id"::varchar as id,
    resource_raw:"name"[0]."family"::varchar as family_name,
    array_to_string(resource_raw:"name"[0]."given"::array, ' ') as given_names,
    resource_raw:"telecom"[0]."value"::varchar as phone_number,
    resource_raw:"birthDate"::date as birth_date,
    resource_raw:"deceasedDateTime"::timestamp as deceased_ts,
    resource_raw:"gender"::varchar as gender,
    resource_raw:"maritalStatus".text::varchar as marital_status,
    resource_raw:"multipleBirthBoolean"::boolean as multiple_birth,
    resource_raw:"address"[0]."city"::varchar as city,
    resource_raw:"address"[0]."country"::varchar as country,
    resource_raw:"address"[0]."postalCode"::varchar as postal_code,
    resource_raw:"address"[0]."state"::varchar as state,
    resource_raw:"address"[0]."line"[0]::varchar as address_line_1,
    resource_raw:"address"[0]."line"[1]::varchar as address_line_2,
    resource_raw:"address"[0]."extension"[0]."extension"[0]."valueDecimal"::varchar as latitude,
    resource_raw:"address"[0]."extension"[0]."extension"[1]."valueDecimal"::varchar as longitude,
    resource_raw:"extension"[0]."valueCodeableConcept"."coding"[0]."display"::varchar as race,
    resource_raw:"extension"[1]."valueCodeableConcept"."coding"[0]."display"::varchar as ethnicity,
    resource_raw:"extension"[4]."valueCode"::varchar as birth_sex,
    resource_raw:"extension"[2]."valueAddress"::object as birth_place,
    resource_raw:"extension"[3]."valueString"::varchar as mothers_maiden_name,
    try_to_boolean(resource_raw:"extension"[5]."valueBoolean"::varchar) as interpreter_required,
    resource_raw:"extension"[8]."valueString"::varchar as ssn,
    resource_raw
from raw
