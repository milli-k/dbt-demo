with raw as (
    select variant_col:entry[0] as json_column
    from {{ source('fhir', 'raw_fhir') }}
)
select
    
    json_column:"resource"."id"::varchar as id,
    json_column:"resource"."birthDate"::date as birth_date,
    json_column:"resource"."gender"::varchar as gender,
    json_column:"resource"."maritalStatus".text::varchar as marital_status,
    json_column:"resource"."multipleBirthBoolean"::boolean as multiple_birth,
    json_column:"resource"."address"[0].city::varchar as city,
    json_column:"resource"."address"[0].country::varchar as country,
    json_column:"resource"."address"[0].postalCode::varchar as postal_code,
    json_column:"resource"."address"[0].state::varchar as state,
    json_column:"resource"."address"[0].line[0]::varchar as address_line_1,
    json_column:"resource"."address"[0].line[1]::varchar as address_line_2,
    json_column:"resource"."telecom"[0].value::varchar as phone_number,
    json_column:"resource"."name"::variant as name,
    json_column:"resource"."communication"[0]:"language":coding[0] as communication,
    json_column:"resource"."extension"::variant as extension,
    json_column:"resource"."identifier"::variant as identifier,
    -- update later
    json_column:"resource".text::variant as text_info,
    json_column
from raw
