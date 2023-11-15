WITH "sessions" AS (SELECT *
        FROM (WITH events_plus AS (
  SELECT
    id 
    , session_id
    , created_at
    , event_type
    , FIRST_VALUE(user_id) OVER (PARTITION BY session_id ORDER BY created_at asc) AS user_id
  
  FROM events
)
SELECT
  session_id
  , user_id
  , MIN(created_at) AS session_start
  , MAX(created_at) AS session_end
  , COUNT(DISTINCT CASE WHEN event_type = 'Product' THEN id ELSE NULL END) AS viewed_product_events
  , COUNT(DISTINCT CASE WHEN event_type = 'Cart' THEN id ELSE NULL END) AS add_to_cart_events
  , COUNT(DISTINCT CASE WHEN event_type = 'Purchase' THEN id ELSE NULL END) AS purchase_events
  , COUNT(DISTINCT CASE WHEN event_type = 'Home' THEN id ELSE NULL END) AS login_events
  , COUNT(*) AS total_events
FROM events_plus
GROUP BY 1,2
            ))

SELECT "sessions"."SESSION_ID" AS "sessions.session_id",
        "sessions"."USER_ID" AS "sessions.user_id",
        "sessions"."SESSION_START" AS "sessions.session_start__raw",
        "sessions"."SESSION_END" AS "sessions.session_end__raw",
        "sessions"."TOTAL_EVENTS" AS "sessions.events_in_sessions",
        DATEDIFF(SECOND, "sessions"."SESSION_START", "sessions"."SESSION_END") AS "sessions.duration",
        DATEDIFF(MONTH, "users"."CREATED_AT", "sessions"."SESSION_START") AS "sessions.months_since_created",
        ROUND(DATEDIFF(SECOND, "sessions"."SESSION_START", "sessions"."SESSION_END") / 60, 0) AS "sessions.duration_minutes",
        "sessions"."ADD_TO_CART_EVENTS" AS "sessions.add_to_cart_events",
        "sessions"."VIEWED_PRODUCT_EVENTS" AS "sessions.viewed_product_events",
        "sessions"."PURCHASE_EVENTS" AS "sessions.purchase_events",
        "sessions"."LOGIN_EVENTS" AS "sessions.login_events",
        "sessions"."ADD_TO_CART_EVENTS" > 0 AND "sessions"."PURCHASE_EVENTS" < 1 AS "sessions.is_abandoned_cart",
        "sessions"."LOGIN_EVENTS" > 0 AS "sessions.had_login_event",
        "sessions"."VIEWED_PRODUCT_EVENTS" > 0 AS "sessions.had_viewed_product_event",
        "sessions"."ADD_TO_CART_EVENTS" > 0 AS "sessions.had_add_to_cart_event",
        "sessions"."PURCHASE_EVENTS" > 0 AS "sessions.had_purchase_event",
        TO_CHAR("sessions"."SESSION_START", 'YYYY-MM-DD HH24:MI:SS.FF3') AS "sessions.session_start",
        TO_CHAR("sessions"."SESSION_END", 'YYYY-MM-DD HH24:MI:SS.FF3') AS "sessions.session_end"
    FROM "sessions"
        LEFT JOIN "USERS" AS "users" ON "sessions"."USER_ID" = "users"."ID"
    GROUP BY "sessions"."SESSION_ID", "sessions"."USER_ID", "sessions"."SESSION_START", "sessions"."SESSION_END", "sessions"."TOTAL_EVENTS", DATEDIFF(SECOND, "sessions"."SESSION_START", "sessions"."SESSION_END"), DATEDIFF(MONTH, "users"."CREATED_AT", "sessions"."SESSION_START"), ROUND(DATEDIFF(SECOND, "sessions"."SESSION_START", "sessions"."SESSION_END") / 60, 0), "sessions"."ADD_TO_CART_EVENTS", "sessions"."VIEWED_PRODUCT_EVENTS", "sessions"."PURCHASE_EVENTS", "sessions"."LOGIN_EVENTS", "sessions"."ADD_TO_CART_EVENTS" > 0 AND "sessions"."PURCHASE_EVENTS" < 1, "sessions"."LOGIN_EVENTS" > 0, "sessions"."VIEWED_PRODUCT_EVENTS" > 0, "sessions"."ADD_TO_CART_EVENTS" > 0, "sessions"."PURCHASE_EVENTS" > 0