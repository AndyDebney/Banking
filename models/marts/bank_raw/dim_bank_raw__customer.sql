with customer as (

    select
        custkey as customer_key,
        first_name,
        last_name,
        street,
        city,
        state as state_code,
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
    from {{ ref('int_bank_raw__customer') }}

),

customer_profile as (

    select
        custkey as customer_key,
        profilekey as customer_profile_key,
        nullif(career, '') as career,
        nullif(professional_status, '') as professional_status,
        nullif(risk_appetite, '') as risk_appetite,
        nullif(customer_segment, '') as customer_segment
    from {{ ref('int_bank_raw__customer_profile') }}

),

product_profile as (

    select
        custkey as customer_key,
        profilekey as product_profile_key,
        nullif(cc_type, '') as credit_card_type,
        cc_rate as credit_card_rate,
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
    from {{ ref('int_bank_raw__product_profile') }}

),

account_rollup as (

    select
        custkey as customer_key,
        count(distinct acctkey) as account_count,
        max(case when cc_number is not null then 1 else 0 end) = 1 as has_credit_card,
        max(case when mortgage_id is not null then 1 else 0 end) = 1 as has_mortgage,
        max(case when auto_loan_id is not null then 1 else 0 end) = 1 as has_auto_loan
    from {{ ref('int_bank_raw__account') }}
    group by 1

),

state_census as (

    select
        abbreviation as state_code,
        name as state_name,
        popestimate2019 as state_population_2019,
        popest18plus2019 as state_adult_population_2019,
        pcnt_popest18plus as state_adult_population_pct
    from {{ ref('int_bank_raw__state_census') }}

)

select
    customer.customer_key,
    customer_profile.customer_profile_key,
    product_profile.product_profile_key,
    customer.first_name,
    customer.last_name,
    customer.street,
    customer.city,
    customer.state_code,
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
    coalesce(account_rollup.account_count, 0) as account_count,
    coalesce(account_rollup.has_credit_card, false) as has_credit_card,
    coalesce(account_rollup.has_mortgage, false) as has_mortgage,
    coalesce(account_rollup.has_auto_loan, false) as has_auto_loan,
    product_profile.credit_card_type,
    product_profile.credit_card_rate,
    product_profile.mortgage_officer,
    product_profile.mortgage_duration,
    product_profile.mortgage_residence_type,
    product_profile.mortgage_purchase_price,
    product_profile.mortgage_rate,
    product_profile.auto_loan_officer,
    product_profile.auto_loan_duration,
    product_profile.vehicle_type,
    product_profile.auto_purchase_price,
    product_profile.auto_loan_rate,
    state_census.state_population_2019,
    state_census.state_adult_population_2019,
    state_census.state_adult_population_pct
from customer
left join customer_profile
    on customer.customer_key = customer_profile.customer_key
left join product_profile
    on customer.customer_key = product_profile.customer_key
left join account_rollup
    on customer.customer_key = account_rollup.customer_key
left join state_census
    on customer.state_code = state_census.state_code
