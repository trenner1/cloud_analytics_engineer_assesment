{{
  config(
    alias='dim_phone',
    materialized = 'view',
    )
}}

/* creating a view on top of the stage layer to add business logic.
In this fictional case, I am going to remove all but the latest numbers per
account id with a window function */

with list_duplicates as (
    
    select 
          id
        , contact_id
        , primary_phone
        , mobile_phone
        , country_code
    
    from {{ ref('stg_phone') }}
    qualify row_number() over (partition by primary_phone order by contact_id desc) = 1
     
),

-- removing low digit numbers for analysis layer.  Ideally these would have constraints placed on the ingest to warn when low numbers occur.
remove_low_digit_numbers as (
    
    select * from list_duplicates where primary_phone > 1000000
    
)


select * from remove_low_digit_numbers