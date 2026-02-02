WITH params AS (
  SELECT 
    CURRENT_DATE() AS as_of_date,
    (YEAR(CURRENT_DATE()) - 2025) AS year_offset 
),

shifted_tickets AS (
  SELECT
    *,
    -- Use double quotes to match your Snowflake staging schema
    DATEADD(month, (SELECT year_offset * 12 FROM params), "created_date") AS "raw_shifted_created",
    DATEADD(month, (SELECT year_offset * 12 FROM params), "updated_date") AS "raw_shifted_updated",
    DATEADD(month, (SELECT year_offset * 12 FROM params), "resolved_date") AS "raw_shifted_resolved",
    DATEADD(month, (SELECT year_offset * 12 FROM params), "due_date") AS "raw_shifted_due"
  FROM {{ ref('stg_saas__zendesk_tickets') }}
)

SELECT
  "id",
  "account_id",
  "ticket_id",
  "type",
  "subject",
  "description",
  "priority",
  
  -- Logic: If we nulled the resolved_date, flip status back to 'open'
  IFF(
    "raw_shifted_resolved" > p.as_of_date AND "raw_shifted_resolved" != "raw_shifted_updated",
    'open',
    "status"
  ) AS "status",

  "channel",
  "requester_id",
  "assignee_id",
  "group_id",
  "raw_shifted_created" AS "created_date",
  
  -- Updated Date logic (capped at today)
  IFF("raw_shifted_updated" > p.as_of_date, p.as_of_date, "raw_shifted_updated") AS "updated_date",

  -- Resolved Date logic (future becomes NULL)
  CASE 
    WHEN "raw_shifted_resolved" > p.as_of_date THEN 
      IFF("raw_shifted_resolved" = "raw_shifted_updated", p.as_of_date, NULL)
    ELSE "raw_shifted_resolved" 
  END AS "resolved_date",

  "first_response_time_hours",
  "resolution_time_hours",
  "satisfaction_score",
  "satisfaction_comment",
  "tags",
  "account_segment",
  "brand_id",
  "locale",
  "timezone",
  "raw_shifted_due" AS "due_date",
  "external_id",
  "jira_issue_id"

FROM shifted_tickets
CROSS JOIN params p
WHERE "raw_shifted_created" <= p.as_of_date 
ORDER BY "created_date" DESC