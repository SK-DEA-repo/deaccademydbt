
----This is a merge using slowly changing demison type 1 where we keep only the latest version of the record. 
--- if you don't define the incremental_strategy, it will automatically default to "merge"
---Based on the unique_key, it will update and insert records. 
---You can also specify which column to exclude from the merge statement using "merge_exclude_columns".  
{{
    config
    (
        materialized = 'incremental',
        incremental_strategy = 'merge', 
        unique_key = 'PURCHASE_ID', 
        merge_exclude_columns = ['INSERT_DTS']
    )
}}
with purchase_src as
(
    select
    PURCHASE_ID,
    PURCHASE_DATE,
    PURCHASE_STATUS,
    CREATED_AT,
    CURRENT_TIMESTAMP as INSERT_DTS,
    CURRENT_TIMESTAMP as UPDATE_DTS  --- for this, we are also tracking when a record was updated. 
    from {{source('purchase','PURCHASE_SRC')}}


    {% if is_incremental() %}
    where CREATED_AT > (select max(UPDATE_DTS) from {{this}})
    {% endif %}
)
select * from purchase_src

---Transit table will be created first the first time you run the build. 


---in the below, it first created a view, then performed the logic provieded above. 
-- create or replace  temporary view DBT_DB.PUBLIC.purchase__dbt_tmp
  
  
--   as (
    
-- ----This is a merge using slowly changing demison type 1. 
-- --- if you don't define the incremental_strategy, it will automatically default to "merge"
-- ---Based on the unique_key, it will update and insert records. 
-- ---You can also specify which column to exclude from the merge statement using "merge_exclude_columns".  

-- with purchase_src as
-- (
--     select
--     PURCHASE_ID,
--     PURCHASE_DATE,
--     PURCHASE_STATUS,
--     CREATED_AT,
--     CURRENT_TIMESTAMP as INSERT_DTS,
--     CURRENT_TIMESTAMP as UPDATE_DTS  --- for this, we are also tracking when a record was updated. 
--     from DBT_DB.PUBLIC.PURCHASE_SRC


    
--     where CREATED_AT > (select max(UPDATE_DTS) from DBT_DB.PUBLIC.purchase)
    
-- )
-- select * from purchase_src




---It also went as far as running the actual merge statement and usng the purchase id for both the source and target table.
----- Also something interesting here is that "INSERT_DTS" was excluded from the update statement in the merge below. 

--   merge into DBT_DB.PUBLIC.purchase as DBT_INTERNAL_DEST
--         using DBT_DB.PUBLIC.purchase__dbt_tmp as DBT_INTERNAL_SOURCE
--         on ((DBT_INTERNAL_SOURCE.PURCHASE_ID = DBT_INTERNAL_DEST.PURCHASE_ID))

    
--     when matched then update set
--         "PURCHASE_ID" = DBT_INTERNAL_SOURCE."PURCHASE_ID","PURCHASE_DATE" = DBT_INTERNAL_SOURCE."PURCHASE_DATE","PURCHASE_STATUS" = DBT_INTERNAL_SOURCE."PURCHASE_STATUS","CREATED_AT" = DBT_INTERNAL_SOURCE."CREATED_AT","UPDATE_DTS" = DBT_INTERNAL_SOURCE."UPDATE_DTS"


--     when not matched then insert
--         ("PURCHASE_ID", "PURCHASE_DATE", "PURCHASE_STATUS", "CREATED_AT", "INSERT_DTS", "UPDATE_DTS")
--     values
--         ("PURCHASE_ID", "PURCHASE_DATE", "PURCHASE_STATUS", "CREATED_AT", "INSERT_DTS", "UPDATE_DTS")

