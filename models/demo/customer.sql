
----when no tabel name is provided, it takes the model name "customer" in this case. 
    
{{
    config
    (
        materialized = 'table'
    )
}}


with customer_src as
(
    select
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    PHONE,
    COUNTRY,
    CREATED_AT,
    CURRENT_TIMESTAMP AS INSERT_DTS --We listed all the columns from the CUSTOMER_SRC table and also added the  CURRENT_TIMESTAMP as the INSERT_DTS. This is the transformation 
    FROM {{source('customer','CUSTOMER_SRC')}}


)
SELECT * FROM customer_src



