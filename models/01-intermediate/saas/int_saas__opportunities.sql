
WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset
),

base_opps AS (
  SELECT 
    o.*,
    DATEADD(month, p.year_offset * 12, o."created_date")            AS "shifted_created_date",
    DATEADD(month, p.year_offset * 12, o."close_date")              AS "shifted_close_date",
    DATEADD(month, p.year_offset * 12, o."last_stage_change_date")  AS "shifted_last_stage_change_date",
    DATEADD(month, p.year_offset * 12, o."first_demo_date")         AS "shifted_first_demo_date",
    DATEADD(month, p.year_offset * 12, o."trial_start_date")        AS "shifted_trial_start_date"
  FROM {{ ref('stg_saas__opportunities')}} o
  CROSS JOIN params p
  WHERE DATEADD(month, p.year_offset * 12, o."created_date") <= p.as_of_date
),

latest_hist AS (
  SELECT * FROM (
    SELECT
      oh."opportunity_id",
      oh."name", oh."stage_name", oh."amount", oh."probability", oh."type",
      oh."next_steps", oh."lead_source", oh."is_won", oh."forecast_category",
      oh."owner_id", oh."sales_engineer_id", oh."contact_id", oh."competitor", oh."loss_reason",
      DATEADD(month, p.year_offset * 12, oh."created_date")            AS "shifted_hist_created_date",
      DATEADD(month, p.year_offset * 12, oh."close_date")              AS "shifted_hist_close_date",
      DATEADD(month, p.year_offset * 12, oh."last_stage_change_date")  AS "shifted_hist_last_stage_change_date",
      DATEADD(month, p.year_offset * 12, oh."first_demo_date")         AS "shifted_hist_first_demo_date",
      DATEADD(month, p.year_offset * 12, oh."trial_start_date")        AS "shifted_hist_trial_start_date",
      ROW_NUMBER() OVER (
        PARTITION BY oh."opportunity_id"
        ORDER BY oh."created_date" DESC 
      ) AS rn
    FROM {{ ref('stg_saas__opportunity_history') }} oh
    CROSS JOIN params p
    WHERE DATEADD(month, p.year_offset * 12, oh."created_date") <= p.as_of_date
  ) WHERE rn = 1
),

closed_asof AS (
  SELECT
    "id", "account_id", "name", "stage_name", "amount", 
    "arr", "acv", "tcv", "contract_term_months",
    "probability",
    "shifted_close_date" AS "close_date",
    "type", "next_steps", "lead_source", "is_won", "forecast_category",
    "owner_id", "sales_engineer_id", 
    "shifted_created_date" AS "created_date",
    "contact_id", 
    "shifted_last_stage_change_date" AS "last_stage_change_date",
    "shifted_first_demo_date" AS "first_demo_date",
    "shifted_trial_start_date" AS "trial_start_date",
    "competitor", "loss_reason"
  FROM base_opps
  CROSS JOIN params p
  WHERE "shifted_close_date" IS NOT NULL AND "shifted_close_date" < p.as_of_date
),

open_asof_overlay AS (
  SELECT
    o."id",
    o."account_id",
    COALESCE(h."name",               o."name")               AS "name",
    COALESCE(h."stage_name",         o."stage_name")         AS "stage_name",
    COALESCE(h."amount",             o."amount")             AS "amount",
    o."arr", o."acv", o."tcv", o."contract_term_months",
    COALESCE(h."probability",        o."probability")        AS "probability",
    COALESCE(h."shifted_hist_close_date", o."shifted_close_date") AS "close_date",
    COALESCE(h."type",               o."type")               AS "type",
    COALESCE(h."next_steps",         o."next_steps")         AS "next_steps",
    COALESCE(h."lead_source",        o."lead_source")        AS "lead_source",
    COALESCE(h."is_won",             o."is_won")             AS "is_won",
    COALESCE(h."forecast_category",  o."forecast_category")  AS "forecast_category",
    COALESCE(h."owner_id",           o."owner_id")           AS "owner_id",
    COALESCE(h."sales_engineer_id",  o."sales_engineer_id")  AS "sales_engineer_id",
    o."shifted_created_date"                                 AS "created_date",
    COALESCE(h."contact_id",         o."contact_id")         AS "contact_id",
    -- FIXED FALLBACK ALIASES BELOW
    COALESCE(h."shifted_hist_last_stage_change_date", o."shifted_last_stage_change_date") AS "last_stage_change_date",
    COALESCE(h."shifted_hist_first_demo_date",        o."shifted_first_demo_date")        AS "first_demo_date",
    COALESCE(h."shifted_hist_trial_start_date",       o."shifted_trial_start_date")       AS "trial_start_date",
    COALESCE(h."competitor",         o."competitor")         AS "competitor",
    COALESCE(h."loss_reason",        o."loss_reason")        AS "loss_reason"
  FROM base_opps o
  CROSS JOIN params p
  LEFT JOIN latest_hist h ON h."opportunity_id" = o."id"
  WHERE (o."shifted_close_date" IS NULL OR o."shifted_close_date" >= p.as_of_date)
)

SELECT * FROM closed_asof
UNION ALL
SELECT * FROM open_asof_overlay
ORDER BY "created_date" DESC