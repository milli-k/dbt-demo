{{ config(alias='events') }}

with 

source as (

    select * from {{ source('ecomm', 'events') }}

),

renamed as (

    select
        id,
        sequence_number,
        session_id,
        created_at,
        ip_address,
        city,
        state,
        country,
        zip,
        latitude,
        longitude,
        os,
        browser,
        traffic_source,
        user_id,
        uri,
        event_type,
        ad_event_id,
        referrer_code

    from source

)

select * from renamed