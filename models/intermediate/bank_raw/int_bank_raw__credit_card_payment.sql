with source as (

    select *
    from {{ ref('stg_bank_raw__credit_card_payment') }}

)

select *
from source
