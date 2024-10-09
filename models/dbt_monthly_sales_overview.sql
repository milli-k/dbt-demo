SELECT 
    date(DATE_TRUNC('MONTH', CREATED_AT)) AS month
    , COALESCE(SUM(SALE_PRICE), 0) AS total_sale_price
    , round((total_sale_price - lag(total_sale_price, 1) over (order by month)) / lag(total_sale_price, 1) over (order by month), 2) as mom_change
FROM ecomm.public.ORDER_ITEMS AS order_items
WHERE NOT STATUS = 'Returned' OR STATUS IS NULL
GROUP BY 1
ORDER BY 1 DESC