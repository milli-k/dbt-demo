WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset
)

SELECT
    "id",
    "account_id",
    "user_id",
    "session_duration_seconds",
    "session_duration_minutes",
    "product_id",
    "pages_visited",
    "events_count",
    "unique_pages",
    "bounce_rate",
    "exit_page",
    "entry_page",
    "device_type",
    "browser",
    "os",
    "country",
    "region",
    "city",
    "ip_address",
    "user_agent",
    "referrer",
    "utm_source",
    "utm_medium",
    "utm_campaign",
    "account_segment",
    "product_tier",
    "user_count",
    "user_role",
    "session_quality_score",
    "errors_encountered",
    "conversion_events",
    
    -- Shift the Date field
    DATEADD(month, p.year_offset * 12, "session_date") AS "session_date",
    
    -- Shift the Timestamps
    DATEADD(month, p.year_offset * 12, "session_start_time") AS "session_start_time",
    DATEADD(month, p.year_offset * 12, "session_end_time") AS "session_end_time"

FROM {{ ref('stg_saas__sessions') }}
CROSS JOIN params p
-- Filter so sessions that haven't "happened yet" in our 2026 timeline are hidden
WHERE DATEADD(month, p.year_offset * 12, "session_start_time") < CURRENT_TIMESTAMP()
ORDER BY "session_date" DESC