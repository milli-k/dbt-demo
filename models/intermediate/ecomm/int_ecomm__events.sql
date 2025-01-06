select
    id as id,
    sequence_number as sequence_number,
    session_id as session_id,
    timestampadd(year, extract(year, current_date()) - 2022, created_at) as created_at,
    ip_address as ip_address,
    city as city,
    state as state,
    country as country,
    zip as zip,
    latitude as latitude,
    longitude as longitude,
    os as os,
    browser as browser,
    traffic_source as traffic_source,
    user_id as user_id,
    uri as uri,
    event_type as event_type,
    ad_event_id as ad_event_id,
    referrer_code as referrer_code
from ecomm_source.public.events
where
    1 = 1
    and timestampadd(year, extract(year, current_date()) - 2022, created_at)
    < current_timestamp()