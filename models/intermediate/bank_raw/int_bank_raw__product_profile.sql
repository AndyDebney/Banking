with source as (

    select *
    from {{ ref('stg_bank_raw__product_profile') }}

)

select *
from source
