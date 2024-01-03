SELECT DATE_TRUNC('MONTH', "CREATED_AT") AS "order_items.created_at[month]__raw",
    COALESCE(SUM("SALE_PRICE"), 0) AS "order_items.sale_price_sum",
    TO_CHAR(DATE_TRUNC('MONTH', "CREATED_AT"), 'YYYY-MM') AS "order_items.created_at[month]"
FROM "ORDER_ITEMS" AS "order_items"
WHERE NOT "STATUS" = 'Returned' OR "STATUS" IS NULL
GROUP BY DATE_TRUNC('MONTH', "CREATED_AT")
ORDER BY DATE_TRUNC('MONTH', "CREATED_AT") NULLS FIRST
LIMIT 1000
