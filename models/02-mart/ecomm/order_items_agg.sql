{{
    config(
        alias='order_items_agg'
    )
}}
select
    order_id as order_id,
    user_id as user_id,
    coalesce(sum(sale_price), 0) as total_sale_price,
    count(*) as count
from {{ ref('order_items') }} as order_items
where status not in ('Returned', 'Cancelled') or status is null
group by 1, 2
order by 4 desc nulls last
limit 1000
