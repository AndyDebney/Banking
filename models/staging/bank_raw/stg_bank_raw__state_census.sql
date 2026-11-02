with source as (

    select *
    from {{ source('bank_raw', 'state_census') }}

)

select *
from source
