{{ config(materialized='table') }}

SELECT "order_items"."ID"  AS "id",
    "order_items"."ID" + 1  AS "id_plus_one",
    "order_items"."ORDER_ID" AS "order_id",
    "order_items"."USER_ID" AS "user_id",
    "order_items"."INVENTORY_ITEM_ID" AS "inventory_item_id",
    "order_items"."SALE_PRICE" AS "sale_price",
    "order_items"."STATUS" AS "status",
    "order_items"."CREATED_AT" AS "created_at",
    "order_items"."RETURNED_AT" AS "returned_at",
    "order_items"."SHIPPED_AT" AS "shipped_at",
    "order_items"."DELIVERED_AT" AS "delivered_at",
    "order_items"."RETURNED_AT" IS NOT NULL AS "is_returned",
    "order_items"."DELIVERED_AT" IS NOT NULL AS "is_delivered",
    "order_items"."SHIPPED_AT" IS NOT NULL AS "is_shipped",
    "order_items"."SALE_PRICE" - "inventory_items"."COST" AS "margin",
    DATEDIFF(MONTH, "users"."CREATED_AT", "order_items"."CREATED_AT") AS "months_since_signup",
    DATEDIFF('days', "order_items"."CREATED_AT", "order_items"."SHIPPED_AT") AS "time_to_ship",
    UPPER("order_items"."STATUS") AS "upper_case_status"
FROM ecomm.public."ORDER_ITEMS" AS "order_items"
    LEFT JOIN ecomm.public.INVENTORY_ITEMS AS "inventory_items" ON "order_items"."INVENTORY_ITEM_ID" = "inventory_items"."ID"
    LEFT JOIN ecomm.public.USERS AS "users" ON "order_items"."USER_ID" = "users"."ID"