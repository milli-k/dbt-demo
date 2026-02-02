WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    -- Dynamic offset to move 2025 data to 2026
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset
)

SELECT
  "id"
  , "first_name"
  , "last_name"
  , "email"
  , "role"
  , "region"
  , "segment"
  , "manager_id"
  , "se_id"
  , "quota_target"
  , "quota_2024"
  , "quota_2025"
  , "quota_2026"
  , "quota_attainment_pct"
  , "performance_tier"
  -- Shift the creation date forward to 2026
  , DATEADD(month, p.year_offset * 12, "created_date") AS "created_date"
  -- Shift the ramp end date forward to stay logically consistent
  , DATEADD(month, p.year_offset * 12, "ramp_end_date") AS "ramp_end_date"
FROM {{ ref('stg_saas__users') }}
CROSS JOIN params p
-- Only show users who have "been hired" by today in our new timeline
WHERE DATEADD(month, p.year_offset * 12, "created_date") <= p.as_of_date