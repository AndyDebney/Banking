with customer as (

    select
        custkey,
        first_name,
        last_name,
        street,
        city,
        state,
        postcode,
        country,
        phone,
        to_date(dob) as date_of_birth,
        gender,
        case
            when married = 'Y' then true
            when married = 'N' then false
        end as is_married,
        ssn,
        case
            when paycheck_dd = 'Y' then true
            when paycheck_dd = 'N' then false
        end as has_paycheck_direct_deposit,
        estimated_income,
        fico,
        to_date(registration_date) as registration_date
    from {{ ref('stg_bank_raw__customer') }}

)

select *
from customer
