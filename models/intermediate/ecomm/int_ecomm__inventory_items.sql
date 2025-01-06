select
    id,
    product_id,
    timestampadd(year, extract(year, current_date()) - 2022, created_at) as created_at,
    case
        when
            timestampadd(year, extract(year, current_date()) - 2022, sold_at)
            > current_timestamp()
        then null
        else timestampadd(year, extract(year, current_date()) - 2022, sold_at)
    end as sold_at,
    cost,
    product_category,
    product_name,
    product_brand,
    product_retail_price,
    product_department,
    product_sku,
    product_distribution_center_id
from {{ ref("inventory_items") }}
where
    1 = 1
    and timestampadd(year, extract(year, current_date()) - 2022, created_at)
    < current_date()