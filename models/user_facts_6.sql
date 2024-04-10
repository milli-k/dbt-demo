WITH "user_fact4" AS (SELECT "USER_ID" AS "user_id",
            MIN(DATE_TRUNC('DAY', "CREATED_AT")) AS "created_at_date_min",
            CAST(EXTRACT(EPOCH FROM CAST(CURRENT_DATE AS TIMESTAMP_LTZ)) - EXTRACT(EPOCH FROM CAST(MIN(DATE_TRUNC('DAY', "CREATED_AT")) AS TIMESTAMP_LTZ)) AS DECIMAL(19, 9)) / 86400 AS "days_since_first_order",
            COALESCE(SUM("SALE_PRICE"), 0) AS "total_sale_price",
            CASE
                WHEN TIMESTAMPADD(MONTH, 1 * TIMESTAMPDIFF(MONTH, MIN(DATE_TRUNC('DAY', "CREATED_AT")), CURRENT_DATE), MIN(DATE_TRUNC('DAY', "CREATED_AT"))) <= CURRENT_DATE THEN TIMESTAMPDIFF(MONTH, MIN(DATE_TRUNC('DAY', "CREATED_AT")), CURRENT_DATE)
                ELSE TIMESTAMPDIFF(MONTH, MIN(DATE_TRUNC('DAY', "CREATED_AT")), CURRENT_DATE) - 1
            END AS "months_since_order_created"
        FROM "PUBLIC"."ORDER_ITEMS" AS "order_items"
        GROUP BY "USER_ID"
        ORDER BY COALESCE(SUM("SALE_PRICE"), 0) DESC NULLS LAST)

SELECT "user_id" AS "user_fact4.user_id",
        CASE
            WHEN "total_sale_price" < 50 THEN 'below 50'
            WHEN "total_sale_price" >= 50 AND "total_sale_price" < 100 THEN '>= 50 and < 100'
            WHEN "total_sale_price" >= 100 AND "total_sale_price" < 300 THEN '>= 100 and < 300'
            WHEN "total_sale_price" >= 300 AND "total_sale_price" < 581.98 THEN '>= 300 and < 581.98'
            WHEN "total_sale_price" >= 581.98 AND "total_sale_price" < 872.95 THEN '>= 581.98 and < 872.95'
            WHEN "total_sale_price" >= 872.95 AND "total_sale_price" < 1163.93 THEN '>= 872.95 and < 1163.93'
            WHEN "total_sale_price" >= 1163.93 THEN '1163.93 and above'
            ELSE NULL
        END AS "user_fact4.total_sale_price_bin_1",
        "total_sale_price" AS "user_fact4.total_sale_price",
        "days_since_first_order" AS "user_fact4.days_since_first_order",
        DATE_TRUNC('DAY', "created_at_date_min") AS "user_fact4.created_at_date_min[date]__raw",
        "months_since_order_created" AS "user_fact4.months_since_order_created",
        CASE
            WHEN "total_sale_price" < 50 THEN 0
            WHEN "total_sale_price" >= 50 AND "total_sale_price" < 100 THEN 1
            WHEN "total_sale_price" >= 100 AND "total_sale_price" < 300 THEN 2
            WHEN "total_sale_price" >= 300 AND "total_sale_price" < 581.98 THEN 3
            WHEN "total_sale_price" >= 581.98 AND "total_sale_price" < 872.95 THEN 4
            WHEN "total_sale_price" >= 872.95 AND "total_sale_price" < 1163.93 THEN 5
            WHEN "total_sale_price" >= 1163.93 THEN 6
            ELSE 8
        END AS "user_fact4.total_sale_price_bin_1__omni_sort",
        TO_CHAR(DATE_TRUNC('DAY', "created_at_date_min"), 'YYYY-MM-DD') AS "user_fact4.created_at_date_min[date]"
    FROM "user_fact4"
    GROUP BY 1, 2, 3, 4, 5, 6, 7
    ORDER BY 5 NULLS FIRST
    LIMIT 1000
