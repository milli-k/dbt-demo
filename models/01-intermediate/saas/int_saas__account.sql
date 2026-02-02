-- don't judge, used chatgpt

WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset 
),

base_accounts AS (
  SELECT 
    *,
    -- Shift created_date forward to 2026
    DATEADD(month, (SELECT year_offset * 12 FROM params), "created_date") AS "shifted_created_date"
  FROM {{ ref('stg_saas__account') }}
),

filtered_accounts AS (
  SELECT *
  FROM base_accounts
  CROSS JOIN params p
  WHERE "shifted_created_date" <= p.as_of_date
),

history_asof AS (
  SELECT *
  FROM (
    SELECT
      ah."account_id",
      ah."type",
      ah."industry",
      ah."annual_revenue",
      ah."number_of_employees",
      ah."segment",
      ah."owner_id",
      ah."csm_id", 
      ROW_NUMBER() OVER (
        PARTITION BY ah."account_id"
        ORDER BY COALESCE(ah."last_modified_date", ah."created_date") DESC,
                 ah."created_date" DESC
      ) AS rn
    FROM {{ ref('stg_saas__account_history') }} ah
    CROSS JOIN params p
    -- History snapshot must be "as of today" in the shifted timeline
    WHERE COALESCE(
        DATEADD(month, p.year_offset * 12, ah."last_modified_date"), 
        DATEADD(month, p.year_offset * 12, ah."created_date")
      ) <= p.as_of_date
  )
  WHERE rn = 1
)

SELECT
  a."id",
  a."name",
  COALESCE(h."type", a."type") AS "type",
  a."billing_street",
  a."billing_state",
  a."billing_city",
  a."billing_zip",
  a."billing_country",
  a."region",
  COALESCE(h."industry", a."industry") AS "industry",
  CAST(COALESCE(h."annual_revenue", a."annual_revenue") AS BIGINT) AS "annual_revenue",
  CAST(COALESCE(h."number_of_employees", a."number_of_employees") AS BIGINT) AS "number_of_employees",
  COALESCE(h."segment", a."segment") AS "segment",
  COALESCE(h."owner_id", a."owner_id") AS "owner_id",
  a."shifted_created_date" AS "created_date",
  
  /* BUSINESS RULE: CSMs only assigned to 'Customer' types */
  CASE 
    WHEN COALESCE(h."type", a."type") = 'Customer' THEN COALESCE(h."csm_id", a."csm_id")
    ELSE NULL 
  END AS "csm_id"

FROM filtered_accounts a
LEFT JOIN history_asof h
  ON h."account_id" = a."id"
ORDER BY "created_date" DESC