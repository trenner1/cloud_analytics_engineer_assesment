{{
  config(
    alias="stg_phone",
    materialized = 'incremental',
    unique_key = 'ID_1',
    )
}}

/* this model has the properties of a SCD type 2 table where contacts have updated their 
created multiple id's with the same phone number. This could be better handled with an
incremental insert+delete strategy using a dbt.utils surrogate key to form the unique key
*/

with cast_to_numbers as (
  
  select 
    
    ID_1 as id
  
  -- strip contact out of contact_id and cast to 123
  , replace(ENTITY_1,'Contact ')::number as contact_id
  
  -- remove any parenthesis and # symbols and cast from abc to 123
  , replace(replace(replace(replace(PHONE_1,'('),')'),'-'),'#')::number as primary_phone
  , MOBILE_1 as mobile_phone  
  , COUNTRY_CD_1 as country_code
  
  from {{ ref('raw_phone') }}
  )

select * from cast_to_numbers
