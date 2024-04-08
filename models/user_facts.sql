SELECT "users"."ID" AS "users.id",
    DATE_TRUNC('DAY', "users"."CREATED_AT") AS "users.created_at[date]__raw",
    CAST(EXTRACT(EPOCH FROM CAST(CURRENT_DATE AS TIMESTAMP_LTZ)) - EXTRACT(EPOCH FROM CAST(DATE_TRUNC('DAY', "users"."CREATED_AT") AS TIMESTAMP_LTZ)) AS DECIMAL(19, 9)) / 86400 AS "users.days_since_signup",
    MIN("order_items"."CREATED_AT") AS "order_items.created_at_min_1__raw",
    COALESCE(SUM("order_items"."SALE_PRICE"), 0) AS "order_items.total_sale_price",
    COUNT("order_items"."ID") AS "order_items.count",
FROM PUBLIC."USERS" AS "users"
    LEFT JOIN PUBLIC."ORDER_ITEMS" AS "order_items" ON "users"."ID" = "order_items"."USER_ID"
GROUP BY 1, 2, 3
ORDER BY 3 NULLS FIRST
