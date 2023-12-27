SELECT DATE_TRUNC('MONTH', "CREATED_AT") AS "order_items.created_at[month]__raw",
    COALESCE(SUM("SALE_PRICE"), 0) AS "order_items.total_sale_price",
    TO_CHAR(DATE_TRUNC('MONTH', "CREATED_AT"), 'YYYY-MM') AS "order_items.created_at[month]"
FROM "ORDER_ITEMS" AS "order_items"
GROUP BY DATE_TRUNC('MONTH', "CREATED_AT")
ORDER BY DATE_TRUNC('MONTH', "CREATED_AT") NULLS FIRST
LIMIT 1000
