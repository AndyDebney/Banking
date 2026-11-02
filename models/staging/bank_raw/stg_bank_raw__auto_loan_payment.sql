with source as (

    select *
    from {{ source('bank_raw', 'auto_loan_payment') }}

)

select *
from source
