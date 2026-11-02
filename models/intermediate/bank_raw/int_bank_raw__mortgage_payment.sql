with mortgage_payment as (

    select
        mortgage_id,
        to_date(payment_date) as payment_date,
        payment_amount,
        to_date(payment_due_date) as payment_due_date,
        case
            when delinquent_payment = 'Y' then true
            when delinquent_payment = 'N' then false
        end as is_delinquent_payment,
        balance as balance_after_payment
    from {{ ref('stg_bank_raw__mortgage_payment') }}

)

select *
from mortgage_payment
