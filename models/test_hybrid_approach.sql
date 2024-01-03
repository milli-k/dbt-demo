SELECT "order_items.created_at[month]" AS "order_items.created_at[month]__raw",
    "order_items.sale_price_sum",
    ("order_items.sale_price_sum" - (LAG("order_items.sale_price_sum", 1) OVER (ORDER BY "order_items.created_at[month]"))) / (LAG("order_items.sale_price_sum", 1) OVER (ORDER BY "order_items.created_at[month]")) AS "mom_change",
    TO_CHAR("order_items.created_at[month]", 'YYYY-MM') AS "order_items.created_at[month]"
FROM (SELECT DATE_TRUNC('MONTH', "CREATED_AT") AS "order_items.created_at[month]",
            COALESCE(SUM("SALE_PRICE"), 0) AS "order_items.sale_price_sum"
        FROM "ORDER_ITEMS" AS "order_items"
        WHERE NOT "STATUS" = 'Returned' OR "STATUS" IS NULL
        GROUP BY DATE_TRUNC('MONTH', "CREATED_AT")
        ORDER BY DATE_TRUNC('MONTH', "CREATED_AT") DESC NULLS LAST
        LIMIT 1000) AS "t2"
ORDER BY "order_items.created_at[month]" DESC NULLS LAST
