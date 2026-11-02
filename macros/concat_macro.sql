
---here, we define the macros block that starts and ends
---- what "macro" this is how we define the block, "concat_macro" is the name of the block, we are going to have the two columns concatinated like "(value1,value2)"

{% macro concat_macro(value1,value2) %} 


concat( '{{value1}}','|', '{{value2}}' ) ---we are definding funtion, meaning the concatination we are having. And this is how I want my function to be. 


{% endmacro %}



-- concat_name.sql
-- =============

-- {{
--     config(
--         materialized='table'
--     )
-- }}


-- select {{ concat_macro('John','Smith') }} as name


-- concat_address.sql
-- ===============

-- {{
--     config
--     (
--         materialized = 'table'
--     )
-- }}
-- select {{ concat_macro('123street','Chicago') }} as address
