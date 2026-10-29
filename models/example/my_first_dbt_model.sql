
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

--- whatever metadata is created here will also be created in our Snowflake environment. 
{{ config(materialized='table') }} --- this will create table because we specified "table", if view, it will create view, etc. 
----if you don't give it a table name, it will automatically take the file name "my_first_dbt_model".

---we are using CTE to create a table then insert 1 as the id alone with a null record for another id within the id column. 
with source_data as (

    select 1 as id
    union all
    ----select null as id ---- the test failed on this because we said insert null value whereby in the test script, we said id is unique and not_null
    select 2 as id ---we can fix the issue by changing our second satement "select null as id" to "select 2 as id" then save in the upper left corner, and run again. 

)

---- to run the code, there are two ways: 1. dbt run will only execute the specific model within that folder, but dbt build will execute 
----the entire files within the model's folder, including all test cases in the model folder. 
---you can choose to run through the command line "Commands" below. dbt run will run both the first and second models example folder. 
---dbt run  -- select modelname this is how you can run a specific model
---but to run both models at the same time, just type dbt run and hit enter. 
select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
