{{ config(alias='users') }}

with 

source as (

    select * from {{ source('ecomm', 'users') }}

),

renamed as (

    select
        id,
        first_name,
        last_name,
        email,
        age,
        city,
        state,
        country,
        zip,
        latitude,
        longitude,
        gender,
        created_at,
        traffic_source

    from source

)

select * from renamed