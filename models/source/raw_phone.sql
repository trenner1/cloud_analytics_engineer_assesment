{{
  config(
    alias='raw_phone',
    materialized = 'table',
    )
}}

select * from {{ source('raw', 'CDAWE_ASSESSMENT') }}