select
    id,
    first_name,
    last_name,
    email,
    case
        when age < 17
        then age + 1 + mod(id, 89)
        when age < 34
        then age + mod(id, 5)
        when age < 77
        then age - mod(id, 18)
        else age - mod(id, 12)
    end as age,
    city,
    state,
    country,
    zip,
    latitude,
    longitude,
    gender,
    timestampadd(year, extract(year, current_date()) - 2022, created_at) as created_at,
    traffic_source
from {{ ref("stg_ecomm__users") }}
where 1=1
    and timestampadd(year, extract(year, current_date()) - 2022, created_at)
    < current_date()