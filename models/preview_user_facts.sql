WITH "user_facts" AS (SELECT "USER_ID" AS "user_id",
            COALESCE(SUM("SALE_PRICE"), 0) AS "total_sale_price",
            MIN(DATE_TRUNC('DAY', "CREATED_AT")) AS "created_at_date_min",
            CAST(EXTRACT(EPOCH FROM CAST(CURRENT_DATE AS TIMESTAMP_LTZ)) - EXTRACT(EPOCH FROM CAST(MIN(DATE_TRUNC('DAY', "CREATED_AT")) AS TIMESTAMP_LTZ)) AS DECIMAL(19, 9)) / 86400 AS "days_since_first_order",
            CASE
                WHEN TIMESTAMPADD(MONTH, 1 * TIMESTAMPDIFF(MONTH, MIN(DATE_TRUNC('DAY', "CREATED_AT")), CURRENT_DATE), MIN(DATE_TRUNC('DAY', "CREATED_AT"))) <= CURRENT_DATE THEN TIMESTAMPDIFF(MONTH, MIN(DATE_TRUNC('DAY', "CREATED_AT")), CURRENT_DATE)
                ELSE TIMESTAMPDIFF(MONTH, MIN(DATE_TRUNC('DAY', "CREATED_AT")), CURRENT_DATE) - 1
            END AS "months_since_first_order"
        FROM PUBLIC."ORDER_ITEMS" AS "order_items"
        GROUP BY "USER_ID"
        ORDER BY MIN(DATE_TRUNC('DAY', "CREATED_AT")) DESC NULLS LAST)

SELECT "created_at_date_min" AS "user_facts.created_at_date_min__raw",
        "days_since_first_order" AS "user_facts.days_since_first_order",
        CASE
            WHEN "total_sale_price" < 50 THEN 'below 50'
            WHEN "total_sale_price" >= 50 AND "total_sale_price" < 100 THEN '>= 50 and < 100'
            WHEN "total_sale_price" >= 100 AND "total_sale_price" < 300 THEN '>= 100 and < 300'
            WHEN "total_sale_price" >= 300 AND "total_sale_price" < 581.98 THEN '>= 300 and < 581.98'
            WHEN "total_sale_price" >= 581.98 AND "total_sale_price" < 872.95 THEN '>= 581.98 and < 872.95'
            WHEN "total_sale_price" >= 872.95 AND "total_sale_price" < 1163.93 THEN '>= 872.95 and < 1163.93'
            WHEN "total_sale_price" >= 1163.93 THEN '1163.93 and above'
            ELSE NULL
        END AS "user_facts.total_sale_price_bin",
        "months_since_first_order" AS "user_facts.months_since_first_order",
        "total_sale_price" AS "user_facts.total_sale_price",
        "user_id" AS "user_facts.user_id",
        CASE
            WHEN "total_sale_price" < 50 THEN 0
            WHEN "total_sale_price" >= 50 AND "total_sale_price" < 100 THEN 1
            WHEN "total_sale_price" >= 100 AND "total_sale_price" < 300 THEN 2
            WHEN "total_sale_price" >= 300 AND "total_sale_price" < 581.98 THEN 3
            WHEN "total_sale_price" >= 581.98 AND "total_sale_price" < 872.95 THEN 4
            WHEN "total_sale_price" >= 872.95 AND "total_sale_price" < 1163.93 THEN 5
            WHEN "total_sale_price" >= 1163.93 THEN 6
            ELSE 8
        END AS "user_facts.total_sale_price_bin__omni_sort",
        TO_CHAR("created_at_date_min", 'YYYY-MM-DD') AS "user_facts.created_at_date_min"
    FROM "user_facts"
    GROUP BY 1, 2, 3, 4, 5, 6, 7
    LIMIT 1000
