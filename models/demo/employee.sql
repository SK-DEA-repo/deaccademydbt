

--- now this configuration will allow us to specify which table to create in Snowflake
---the default is a view if we do not provide the configuration.
---to write any configuration block, you need to start with two open and closed curly braces, the config, and one brackets after the config for the config. 
{{ 
    config
    (
        materialized = 'table'
    )


}} 


-- with employee as  -- if you don't specify that it is a table, dbt will automatically create a view, which it will in this case. 
--                 -----But after specifying that above, the view is changed or overrided to table called employee.
-- (
--     select * from DBT_DB.PUBLIC.EMPLOYEE_RAW  ----just creating this employee and inserting data from the "DBT_DB.PUBLIC.EMPLOYEE_RAW" table
    
    
-- )
-- select * from employee


with employee as
(
    select
    EMPID as emp_id,
    split_part(NAME,' ',1)  as emp_firstname,
    split_part(NAME,' ',2)  as emp_lastname,
    SALARY as emp_salary,
    HIREDATE as emp_hiredate,
    split_part(ADDRESS,',',1) as emp_street,
    split_part(ADDRESS,',',2) as emp_city,
    split_part(ADDRESS,',',3) as emp_country,
    split_part(ADDRESS,',',4) as emp_zipcode
    from {{source('employee', 'EMPLOYEE_RAW')}}---instead of harding the source table "DBT_DB.PUBLIC.EMPLOYEE_RAW", you are basically referencing the yaml file.  
                                            ----- we provide everything underneath the source section of the yaml file; "source = the model name = employee, table = EMPLOYEE_RAW 
                                            --if there was any change, we can do that within the yaml file. 
)
select * from employee


----the compile sign "</>" below is useful to generate the clean code. If there was a change to the yaml file, it will automatically show that. 