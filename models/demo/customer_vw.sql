
---- we are also required to create a view on top of the customer table that was just created for country equal to USA only. 
{{
    config
    (
        materialized = 'view' 
    )
}}
select * from {{ ref('customer') }}
where country= 'USA'

-- referencing the customer table to avoid hard coding. you can right click the customer model and you will see an option called "copy as reference"