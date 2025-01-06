select
    id,
    first_name,
    last_name,
    email,
    case
        when users.age < 17
        then users.age + 1 + mod(users.id, 89)
        when users.age < 34
        then users.age + mod(users.id, 5)
        when users.age < 77
        then users.age - mod(users.id, 18)
        else users.age - mod(users.id, 12)
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
where
    timestampadd(year, extract(year, current_date()) - 2022, created_at)
    < current_timestamp()
