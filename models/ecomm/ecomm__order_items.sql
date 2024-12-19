{{ config(alias='order_items') }}

with 

source as (

    select * from {{ source('ecomm', 'order_items') }}

),

renamed as (

    select
        id,
        order_id,
        user_id,
        inventory_item_id,
        sale_price,
        status,
        created_at,
        returned_at,
        shipped_at,
        delivered_at

    from source

)

select * from renamed