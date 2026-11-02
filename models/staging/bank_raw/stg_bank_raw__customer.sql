with source as (

    select *
    from {{ source('bank_raw', 'customer') }}

)

select *
from source
