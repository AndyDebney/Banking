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
        case
            when paycheck_dd = 'Y' then true
            when paycheck_dd = 'N' then false
        end as has_paycheck_direct_deposit,
        estimated_income,
        fico,
        to_date(registration_date) as registration_date
    from {{ ref('stg_bank_raw__customer') }}

),

customer_profile as (

    select
        profilekey as customer_profile_key,
        custkey,
        career,
        professional_status,
        risk_appetite,
        customer_segment
    from {{ ref('stg_bank_raw__customer_profile') }}

),

product_profile as (

    select
        profilekey as product_profile_key,
        custkey,
        nullif(cc_type, '') as cc_type,
        cc_rate,
        mortgage_officer,
        mortgage_duration,
        nullif(mortgage_residence_type, '') as mortgage_residence_type,
        mortgage_purchase_price,
        mortgage_rate,
        auto_loan_officer,
        auto_loan_duration,
        nullif(vehicle_type, '') as vehicle_type,
        auto_purchase_price,
        auto_loan_rate
    from {{ ref('stg_bank_raw__product_profile') }}

),

account as (

    select
        custkey,
        acctkey,
        products,
        nullif(cc_number, '') as cc_number,
        to_date(nullif(cc_open_date, '')) as cc_open_date,
        to_date(nullif(cc_closed_date, '')) as cc_closed_date,
        cc_balance,
        nullif(cc_status, '') as cc_status,
        case
            when cc_default = 'Y' then true
            when cc_default = 'N' then false
        end as is_credit_card_in_default,
        nullif(mortgage_id, '') as mortgage_id,
        to_date(nullif(mortgage_open_date, '')) as mortgage_open_date,
        to_date(nullif(mortgage_closed_date, '')) as mortgage_closed_date,
        mortgage_balance,
        nullif(mortgage_status, '') as mortgage_status,
        case
            when mortgage_default = 'Y' then true
            when mortgage_default = 'N' then false
        end as is_mortgage_in_default,
        nullif(auto_loan_id, '') as auto_loan_id,
        to_date(nullif(auto_loan_open_date, '')) as auto_loan_open_date,
        to_date(nullif(auto_loan_closed_date, '')) as auto_loan_closed_date,
        auto_loan_balance,
        nullif(auto_loan_status, '') as auto_loan_status,
        case
            when auto_loan_default = 'Y' then true
            when auto_loan_default = 'N' then false
        end as is_auto_loan_in_default
    from {{ ref('stg_bank_raw__account') }}

),

state_census as (

    select
        abbreviation as state_code,
        name as state_name,
        popestimate2019 as state_population_2019,
        popest18plus2019 as state_adult_population_2019,
        pcnt_popest18plus as state_adult_population_pct
    from {{ ref('stg_bank_raw__state_census') }}

)

select
    customer.custkey,
    account.acctkey,
    customer_profile.customer_profile_key,
    product_profile.product_profile_key,
    customer.first_name,
    customer.last_name,
    customer.street,
    customer.city,
    customer.state as state_code,
    state_census.state_name,
    customer.postcode,
    customer.country,
    customer.phone,
    customer.date_of_birth,
    customer.gender,
    customer.is_married,
    customer.has_paycheck_direct_deposit,
    customer.estimated_income,
    customer.fico,
    customer.registration_date,
    customer_profile.career,
    customer_profile.professional_status,
    customer_profile.risk_appetite,
    customer_profile.customer_segment,
    account.products as raw_products,
    account.cc_number,
    account.cc_open_date,
    account.cc_closed_date,
    account.cc_balance,
    account.cc_status,
    account.is_credit_card_in_default,
    product_profile.cc_type,
    product_profile.cc_rate,
    account.mortgage_id,
    account.mortgage_open_date,
    account.mortgage_closed_date,
    account.mortgage_balance,
    account.mortgage_status,
    account.is_mortgage_in_default,
    product_profile.mortgage_officer,
    product_profile.mortgage_duration,
    product_profile.mortgage_residence_type,
    product_profile.mortgage_purchase_price,
    product_profile.mortgage_rate,
    account.auto_loan_id,
    account.auto_loan_open_date,
    account.auto_loan_closed_date,
    account.auto_loan_balance,
    account.auto_loan_status,
    account.is_auto_loan_in_default,
    product_profile.auto_loan_officer,
    product_profile.auto_loan_duration,
    product_profile.vehicle_type,
    product_profile.auto_purchase_price,
    product_profile.auto_loan_rate,
    account.cc_number is not null as has_credit_card,
    account.mortgage_id is not null as has_mortgage,
    account.auto_loan_id is not null as has_auto_loan,
    state_census.state_population_2019,
    state_census.state_adult_population_2019,
    state_census.state_adult_population_pct
from customer
left join customer_profile
    on customer.custkey = customer_profile.custkey
left join product_profile
    on customer.custkey = product_profile.custkey
left join account
    on customer.custkey = account.custkey
left join state_census
    on customer.state = state_census.state_code
