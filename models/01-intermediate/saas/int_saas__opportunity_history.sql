WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset 
)

SELECT
  -- Identifiers
  "id",
  "opportunity_id",
  "account_id",
  "name",
  "stage_name",
  "amount",
  "arr",
  "acv",
  "tcv",
  "contract_term_months",
  "probability",

  -- When this snapshot was captured (Shifted to 2026)
  DATEADD(month, p.year_offset * 12, "created_date") AS "created_date",

  -- When the stage actually changed (Shifted)
  DATEADD(month, p.year_offset * 12, "last_stage_change_date") AS "last_stage_change_date",

  -- Close Date Logic: Cap at current date if the shifted date is in the future
  IFF(
    DATEADD(month, p.year_offset * 12, "close_date") > p.as_of_date,
    p.as_of_date,
    DATEADD(month, p.year_offset * 12, "close_date")
  ) AS "close_date",

  -- Lifecycle milestones
  DATEADD(month, p.year_offset * 12, "first_demo_date")  AS "first_demo_date",
  DATEADD(month, p.year_offset * 12, "trial_start_date") AS "trial_start_date",

  "type",
  "is_won",
  "forecast_category",
  "next_steps",
  "lead_source",
  "owner_id",
  "sales_engineer_id",
  "contact_id",
  "competitor",
  "loss_reason",
  "win_reason",
  "risk_score",
  "risk_flags"

FROM {{ ref('stg_saas__opportunity_history') }}
CROSS JOIN params p
WHERE 
  -- Snapshot must have been created by today in our 2026 timeline
  DATEADD(month, p.year_offset * 12, "created_date") <= p.as_of_date 
  AND (
    -- AND the stage change must have logically happened by today
    "last_stage_change_date" IS NULL 
    OR DATEADD(month, p.year_offset * 12, "last_stage_change_date") <= p.as_of_date
  )
ORDER BY "created_date" DESC, "id" ASC