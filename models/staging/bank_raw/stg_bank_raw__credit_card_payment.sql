with source as (
    select *
    from {{ source('bank_raw', 'credit_card_payment') }}
)

select *
from source
