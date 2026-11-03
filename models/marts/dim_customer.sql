with customer as (
    select *
    from {{ ref('int_bank_raw__customer') }}
),

customer_profile as (
    select *
    from {{ ref('int_bank_raw__customer_profile') }}
),

product_profile as (
    select *
    from {{ ref('int_bank_raw__product_profile') }}
),

account as (
    select *
    from {{ ref('int_bank_raw__account') }}
)

select
    c.custkey as customer_id,
    cp.profilekey as customer_profile_id,
    pp.profilekey as product_profile_id,
    a.acctkey as account_id,
    c.first_name,
    c.last_name,
    c.first_name || ' ' || c.last_name as full_name,
    try_to_date(c.dob) as date_of_birth,
    c.gender,
    case
        when c.married = 'Y' then true
        when c.married = 'N' then false
    end as is_married,
    c.street,
    c.city,
    c.state,
    c.postcode,
    c.country,
    c.phone as phone_number,
    case
        when c.paycheck_dd = 'Y' then true
        when c.paycheck_dd = 'N' then false
    end as is_paycheck_direct_deposit,
    c.estimated_income,
    c.fico as fico_score,
    try_to_date(c.registration_date) as registration_date,
    cp.career,
    cp.professional_status,
    cp.risk_appetite,
    cp.customer_segment,
    pp.cc_type as credit_card_type,
    pp.cc_rate as credit_card_rate,
    pp.mortgage_officer,
    try_to_number(pp.mortgage_duration) as mortgage_duration_months,
    pp.mortgage_residence_type,
    pp.mortgage_purchase_price,
    pp.mortgage_rate,
    pp.auto_loan_officer,
    try_to_number(pp.auto_loan_duration) as auto_loan_duration_months,
    pp.vehicle_type,
    pp.auto_purchase_price,
    pp.auto_loan_rate,
    a.products as account_products,
    a.cc_number as credit_card_number,
    try_to_date(a.cc_open_date) as credit_card_open_date,
    try_to_date(a.cc_closed_date) as credit_card_closed_date,
    a.cc_balance as credit_card_balance,
    a.cc_status as credit_card_status,
    case
        when a.cc_default = 'Y' then true
        when a.cc_default = 'N' then false
    end as is_credit_card_in_default,
    a.mortgage_id,
    try_to_date(a.mortgage_open_date) as mortgage_open_date,
    try_to_date(a.mortgage_closed_date) as mortgage_closed_date,
    a.mortgage_balance,
    a.mortgage_status,
    case
        when a.mortgage_default = 'Y' then true
        when a.mortgage_default = 'N' then false
    end as is_mortgage_in_default,
    a.auto_loan_id,
    try_to_date(a.auto_loan_open_date) as auto_loan_open_date,
    try_to_date(a.auto_loan_closed_date) as auto_loan_closed_date,
    a.auto_loan_balance,
    a.auto_loan_status,
    case
        when a.auto_loan_default = 'Y' then true
        when a.auto_loan_default = 'N' then false
    end as is_auto_loan_in_default,
    a.cc_number is not null as has_credit_card,
    a.mortgage_id is not null as has_mortgage,
    a.auto_loan_id is not null as has_auto_loan
from customer c
left join customer_profile cp
    on c.custkey = cp.custkey
left join product_profile pp
    on c.custkey = pp.custkey
left join account a
    on c.custkey = a.custkey
