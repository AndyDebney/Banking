with staging as (
    select *
    from {{ ref('stg_bank_raw__customer_profile') }}
)

select *
from staging
