with source as (
    select *
    from {{ source('bank_raw', 'employee') }}
)

select *
from source
