

----we can execute two models at the same time, example: "dbt  build --select concat_name, concat_address"

{{ 
    config
    ( 
        materialized='table'
    )
}}

select {{ concat_macro('123Street','Chicago') }} as address





