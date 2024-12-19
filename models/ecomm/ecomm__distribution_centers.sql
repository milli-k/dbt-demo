{{ config(alias='distribution_centers') }}

with 

source as (

    select * from {{ source('ecomm', 'distribution_centers') }}

),

renamed as (

    select
        id,
        name,
        latitude,
        longitude

    from source

)

select * from renamed