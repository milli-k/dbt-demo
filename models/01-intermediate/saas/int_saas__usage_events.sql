WITH params AS (
  SELECT 
    CURRENT_TIMESTAMP() AS as_of_ts,
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset
)

SELECT
    "id"
    , "account_id"
    , "user_id"
    , "event_type"
    , "event_name"
    -- Shifting the date and timestamp forward to 2026
    , DATEADD(month, p.year_offset * 12, "event_date") AS "event_date"
    , DATEADD(month, p.year_offset * 12, "event_timestamp") AS "event_timestamp"
    , "session_id"
    , "sequence_number"
    , "product_id"
    , "page_url"
    , "user_agent"
    , "ip_address"
    , "country"
    , "region"
    , "city"
    , "device_type"
    , "browser"
    , "os"
    , "screen_resolution"
    , "referrer"
    , "utm_source"
    , "utm_medium"
    , "utm_campaign"
    , "account_segment"
    , "product_tier"
    , "user_count"
    , "user_role"
    , "feature_name"
    , "event_properties"
FROM {{ ref('stg_saas__usage_events') }}
CROSS JOIN params p
-- Filter so events "appear" in real-time as the clock ticks today in 2026
WHERE DATEADD(month, p.year_offset * 12, "event_timestamp") < p.as_of_ts
ORDER BY "event_date" DESC