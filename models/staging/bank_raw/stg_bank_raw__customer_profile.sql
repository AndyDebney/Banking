with source as (

    select *
    from {{ source('bank_raw', 'customer_profile') }}

)

select *
from source
