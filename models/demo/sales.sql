
---- there are different materialized incremental strategies: append, merge, delete+insert, insert_overwrite, and microbatch
---here, we are using the append method. 

{{
    config
    (
        materialized = 'incremental',
        incremental_strategy = 'append' 
    )
}}


with sales_src as
(
    select
    SALE_ID,
    SALE_DATE,
    CUSTOMER_ID,
    PRODUCT_ID,
    QUANTITY,
    TOTAL_AMOUNT,
    CREATED_AT,
    CURRENT_TIMESTAMP AS INSERT_DTS
    from {{source('sales','SALES_SRC')}}


    {% if is_incremental() %} ----we will always need a if block.
    where CREATED_AT > (select max(INSERT_DTS) from {{this}}) --- "this" means from the "sales" model, because the table that will be created will take on the model name. 
    {% endif %}
)
select * from sales_src

--- the where clause above means, create date time (from table) > max(insert date) (from target table).
---that means dbt will use the condition above to only extract data from the source table that has a created time bigger than the inserted time on the target table. 
---there different increamental solutions: append, merge, delete + insert, insert_overwrite, and microbatch. Read more on these. 

---- after testing the append strategy, dbt created a temporary view DBT_DB.PUBLIC.sales__dbt_tmp to store only the three inserted record, then inserted those records into 
----the target table. You can see that in the log file after the build. 


