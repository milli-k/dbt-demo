WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    -- Dynamic offset to move 2025 data to 2026
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset 
)

SELECT
  -- Use REPLACE to swap the original created_date with the shifted version
  * REPLACE (
      DATEADD(month, p.year_offset * 12, "created_date") AS "created_date"
  )
FROM {{ ref('stg_saas__opportunity_line_items') }}
CROSS JOIN params p
-- Filter: Line items only appear once their shifted creation date has passed
WHERE DATEADD(month, p.year_offset * 12, "created_date") <= p.as_of_date
ORDER BY "created_date" DESC