
--- micros is a function in dbt. You can write it once and then reference it in multiple placese. So that if there is a change in that logic, you
---can only change in that logic instead of making the changes every where. So, this is where we write reusable code. 
--- example is concatinating for a models. 

{{ 
    config
    ( 
        materialized='table'
    )
}}

select {{ concat_macro('John','Smith') }} as name 

----This is how we refer the macro model. 


