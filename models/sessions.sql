WITH "sessions" AS (SELECT *
        FROM (WITH events_plus AS (
  SELECT
    id 
    , session_id
    , created_at
    , event_type
    , FIRST_VALUE(user_id) OVER (PARTITION BY session_id ORDER BY created_at asc) AS user_id
  
  FROM ecomm.public.events
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

SELECT "sessions"."SESSION_ID" AS "session_id",
        "sessions"."USER_ID" AS "user_id",
        "sessions"."SESSION_START" AS "session_start",
        "sessions"."SESSION_END" AS "session_end",
        "sessions"."TOTAL_EVENTS" AS "events_in_sessions",
        DATEDIFF(SECOND, "sessions"."SESSION_START", "sessions"."SESSION_END") AS "duration",
        DATEDIFF(MONTH, "users"."CREATED_AT", "sessions"."SESSION_START") AS "months_since_created",
        ROUND(DATEDIFF(SECOND, "sessions"."SESSION_START", "sessions"."SESSION_END") / 60, 0) AS "duration_minutes",
        "sessions"."ADD_TO_CART_EVENTS" AS "add_to_cart_events",
        "sessions"."VIEWED_PRODUCT_EVENTS" AS "viewed_product_events",
        "sessions"."PURCHASE_EVENTS" AS "purchase_events",
        "sessions"."LOGIN_EVENTS" AS "login_events",
        "sessions"."ADD_TO_CART_EVENTS" > 0 AND "sessions"."PURCHASE_EVENTS" < 1 AS "is_abandoned_cart",
        "sessions"."LOGIN_EVENTS" > 0 AS "had_login_event",
        "sessions"."VIEWED_PRODUCT_EVENTS" > 0 AS "had_viewed_product_event",
        "sessions"."ADD_TO_CART_EVENTS" > 0 AS "had_add_to_cart_event",
        "sessions"."PURCHASE_EVENTS" > 0 AS "had_purchase_event"
    FROM "sessions"
        LEFT JOIN ecomm.public."USERS" AS "users" ON "sessions"."USER_ID" = "users"."ID"