
----this model will not create a view, temp table, or table in the data warehouse, it will only server as intermediate step for reading data. 
--so, dbt understand when we run the final_orders model, it will first run this model to get the data then create the table in the final_order model and insert into that. 
{{
    config
    (
        materialized = 'ephemeral'
    )
}}


with base_orders as ------where you are reading the data from should be the cte name
(
    select
    ORDER_ID,
    ORDER_DATE,
    CUSTOMER_ID,
    case when CUSTOMER_NAME is null then 'NA' else upper(CUSTOMER_NAME) end as CUSTOMER_NAME, --we are defaulting the null customer name to NA and also upper casing the names. 
    CREATED_AT
    from {{source('orders','BASE_ORDERS')}}
    where ORDER_DATE is not null   -----we only want to work with data that has order_date. 
)
select * from base_orders

----the above block alone will not create the table "clean_orders" in the data warehouse. So, we need another model and referen this model