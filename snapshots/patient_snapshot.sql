
--- if we have a requirement where we need to store or maintain all the version of the data into our target table using slowly changing dimension type 2. 
--- With this, we will add two additional column called "version start date or vrsn_strt_dt", and "version end date or vrsn_end_dt"
---vrsn_strt_dt tracks when the record get inserted into the target table, and vrsn_end_dt will track any new verson of the new record that will be 
----inserted. If not, it will still as null records. 
---for example, if a customer has an address call LA, vrsn_strt_dt will track when LA was first inserted as address, and vrsn_end_dt column will always be null.
---But if he changes his address from LA to NYC, then the vrsn_end_dt will record when the LA address ended, and then vrsn_strt_dt records the insert for the new address NYC
---and vrsn_end_dt will remains null again untill another address changes, and so on. 
--- snapshot helps us to implement this. There are two ways to achieve this in snapshot: 1. Timestamp. this uses an updated_at column to determine if a row was change
---2. check. The check function compares a list of columns between their current and historical values to determine if a row has changed. 
---this has to be located inside the "snapshots" folder for it to work, not in the model session.
---- below is the snapshot block with a configuration that defines the strategy which is "check", specify the unique_key, and the columns to be checked. Only none primary keys are checked
---if there is a changes in any of these columns, we need to maintain the old and new version of that: ['PATIENT_NAME','PATIENT_CONTACT_NUMBER','PATIENT_EMAIL_ID','PATIENT_ADDRESS']

{% snapshot patient_snapshot %}


{{
    config
    (
        strategy = 'check',
        unique_key = 'PATIENT_ID',
        check_cols = ['PATIENT_NAME','PATIENT_CONTACT_NUMBER','PATIENT_EMAIL_ID','PATIENT_ADDRESS']
    )
}}


select * from {{source('patient','PATIENT_SRC')}} ----"patient" is just the name of the source within the yaml file, not in the model. We just gave it a name.



{% endsnapshot %}

----to execute the snapshot we write: "dbt snapshot". This will take all the sql files within the snapshot folder and execute them alone with the specified yaml file. 