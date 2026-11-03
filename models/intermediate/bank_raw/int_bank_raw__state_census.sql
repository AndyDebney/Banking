with staging as (
    select *
    from {{ ref('stg_bank_raw__state_census') }}
)

select *
from staging
