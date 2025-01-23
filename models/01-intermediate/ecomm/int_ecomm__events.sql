select
    id,
    sequence_number,
    session_id,
    timestampadd(year, extract(year, current_date()) - 2022, created_at) as created_at,
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
from {{ ref('stg_ecomm__events') }}
where
    1 = 1
    and timestampadd(year, extract(year, current_date()) - 2022, created_at)
    < current_timestamp()