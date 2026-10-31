
---this is in case of slowly changing dimension type 1, where when a customer updates his address, the old deleted is shown and only the new address shows.
---That means we are only keeping the lastest version of the data. 
---the delete is done using the primary key
---it will look to see if the there is an id, the product_id in this case exists in both the source and target after it runs, then it will delete that record in the target table and
---insert the lastest version of the record for that id column.  In that, only the lastest version of the record is inserted. 
----delete and insert is faster than update.

{{
    config
    (
        materialized = 'incremental',
        incremental_strategy = 'delete+insert', 
        unique_key = 'PRODUCT_ID'
    )
}}


with product_src as
(
    select
    PRODUCT_ID,
    PRODUCT_NAME,
    PRODUCT_PRICE,
    CREATED_AT,
    CURRENT_TIMESTAMP AS INSERT_DTS
    from {{source('product','PRODUCT_SRC')}}


    {% if is_incremental() %}
    where CREATED_AT > (select max(INSERT_DTS) from {{this}}) ---- look for any records that is after the or bigger than the indert_dts records. 
    {% endif %}
)


select * from product_src

---dbt writes this delete statement after we run the build process. It first creates a temporary table to store the select records then do the delete from it. Below is it:

    -- delete from DBT_DB.PUBLIC.product as DBT_INTERNAL_DEST
    --     where (PRODUCT_ID) in (
    --         select distinct PRODUCT_ID
    --         from DBT_DB.PUBLIC.product__dbt_tmp as DBT_INTERNAL_SOURCE
    --     )