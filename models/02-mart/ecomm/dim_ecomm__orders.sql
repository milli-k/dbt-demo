select
    order_items.id,
    order_items.order_id,
    order_items.user_id,
    order_items.inventory_item_id,
    order_items.sale_price,
    order_items.status,
    order_items.created_at,
    order_items.returned_at,
    order_items.shipped_at,
    order_items.delivered_at as delivered_at,
    order_items.returned_at is not null as is_returned,
    order_items.delivered_at is not null as is_delivered,
    order_items.shipped_at is not null as is_shipped,
    order_items.sale_price - inventory_items.cost as margin,
    datediff(month, users.created_at, order_items.created_at) as months_since_signup,
    datediff('days', order_items.created_at, order_items.shipped_at) as time_to_ship,
    upper(order_items.status) as upper_case_status
from {{ ref("int_ecomm__order_items") }} as order_items
left join
    {{ ref("int_ecomm__inventory_items") }} as inventory_items
    on order_items.inventory_item_id = inventory_items.id
left join {{ ref("int_ecomm__users") }} as users on order_items.user_id = users.id
