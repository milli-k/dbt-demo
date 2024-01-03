SELECT DATE_TRUNC('MONTH', created_at) AS order_created_month,
    COALESCE(SUM("SALE_PRICE"), 0) AS total_sale_price
FROM ecomm.public."ORDER_ITEMS" AS order_items
WHERE NOT "STATUS" = 'Returned' OR "STATUS" IS NULL
GROUP BY 1
