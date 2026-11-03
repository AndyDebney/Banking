with source as (

    select *
    from {{ ref('stg_bank_raw__employee') }}

)

select *
from source
