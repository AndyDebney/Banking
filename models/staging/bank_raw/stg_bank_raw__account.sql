with source as (
    select *
    from {{ source('bank_raw', 'account') }}
)

select *
from source
