with source as (

    select *
    from {{ source('bank_raw', 'mortgage_payment') }}

)

select *
from source
