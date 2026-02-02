WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset
)

SELECT 
    -- We use double quotes to match the lowercase identifiers in the dbt staging model
    * REPLACE (
        DATEADD(month, p.year_offset * 12, "created_date") AS "created_date"
    )
FROM {{ ref('stg_saas__contacts') }}
CROSS JOIN params p
-- Filter based on the shifted 2026 date
WHERE DATEADD(month, p.year_offset * 12, "created_date") <= p.as_of_date
ORDER BY "created_date" DESC