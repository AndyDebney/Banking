with source as (

    select *
    from {{ ref('stg_bank_raw__mortgage_payment') }}

)

select *
from source
