with staging as (
    select *
    from {{ ref('stg_bank_raw__auto_loan_payment') }}
)

select *
from staging
