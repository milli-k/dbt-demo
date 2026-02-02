WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    -- Dynamic offset: moves 2025 data to 2026
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset 
)

SELECT
  -- Identifiers (using double quotes for Snowflake case-sensitivity)
  "id",
  "account_id",
  
  -- Account Attributes
  "type",
  "status",
  "industry",
  "annual_revenue",
  "number_of_employees",
  "segment",
  "owner_id",
  "csm_id",

  -- THE SHIFTED TIMELINE
  -- 1. When this specific snapshot record was created
  DATEADD(month, p.year_offset * 12, "created_date") AS "created_date",

  -- 2. When the account was last modified at the time of this record
  DATEADD(month, p.year_offset * 12, "last_modified_date") AS "last_modified_date",

  -- 3. Churn Date logic: Use IFF for cleaner Snowflake syntax
  -- If shifted churn is in the future, the account hasn't churned yet (NULL)
  IFF(
    DATEADD(month, p.year_offset * 12, "churn_date") > p.as_of_date,
    NULL,
    DATEADD(month, p.year_offset * 12, "churn_date")
  ) AS "churn_date",

  "churn_reason"

FROM {{ ref("stg_saas__account_history") }}
CROSS JOIN params p
WHERE 
  -- Snapshot must have been created by today in our 2026 timeline
  DATEADD(month, p.year_offset * 12, "created_date") <= p.as_of_date 
  AND (
    -- AND the modification must have logically happened by today
    "last_modified_date" IS NULL 
    OR DATEADD(month, p.year_offset * 12, "last_modified_date") <= p.as_of_date
  )
ORDER BY "id" ASC, "created_date" DESC