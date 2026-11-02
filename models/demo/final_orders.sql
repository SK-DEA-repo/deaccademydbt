
---this model will read the data from the clean_orders model
---this model will create a table called "final_orders" and insert the data into that
----so, the the clean_order model will fist run before this final_orders

{{
    config
    (
        materialized = 'table' 
    )
}}
with clean_orders as ---where you're reading the data from should be the cte name. 
(
    select
    ORDER_ID,
    ORDER_DATE,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    CREATED_AT,
    CURRENT_TIMESTAMP as INSERT_DTS
    from {{ ref('clean_orders') }}
)
select * from clean_orders