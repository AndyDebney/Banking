with source as (
    select *
    from {{ source('bank_raw', 'product_profile') }}
)

select *
from source
