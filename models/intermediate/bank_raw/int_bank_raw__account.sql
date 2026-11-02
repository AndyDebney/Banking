with source as (

    select *
    from {{ ref('stg_bank_raw__account') }}

)

select *
from source
