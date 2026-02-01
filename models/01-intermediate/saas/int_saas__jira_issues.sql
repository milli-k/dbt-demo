WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset
)

SELECT 
    * REPLACE (
        -- 1. Shift Created Date (Original Logic)
        DATEADD(month, p.year_offset * 12, "created_date") AS "created_date",

        -- 2. Logic: If shifted Updated Date is in the future, cap it at TODAY
        IFF(
            DATEADD(month, p.year_offset * 12, "updated_date") > p.as_of_date,
            p.as_of_date,
            DATEADD(month, p.year_offset * 12, "updated_date")
        ) AS "updated_date",

        -- 3. Logic: If shifted Resolved Date is in the future, it's not resolved yet (NULL)
        IFF(
            DATEADD(month, p.year_offset * 12, "resolved_date") > p.as_of_date,
            NULL,
            DATEADD(month, p.year_offset * 12, "resolved_date")
        ) AS "resolved_date"
    )
FROM {{ ref('stg_saas__jira_issues') }}
CROSS JOIN params p
-- Only show issues that have been 'created' in our 2026 timeline
WHERE DATEADD(month, p.year_offset * 12, "created_date") <= p.as_of_date
ORDER BY "created_date" DESC