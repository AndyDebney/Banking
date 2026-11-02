with account as (

    select
        custkey,
        acctkey,
        products as raw_products,
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

credit_card as (

    select
        custkey,
        acctkey,
        raw_products,
        'credit_card' as product_type,
        cc_number as product_identifier,
        cc_open_date as product_open_date,
        cc_closed_date as product_closed_date,
        cc_balance as current_balance,
        cc_status as product_status,
        is_credit_card_in_default as is_in_default
    from account
    where cc_number is not null

),

mortgage as (

    select
        custkey,
        acctkey,
        raw_products,
        'mortgage' as product_type,
        mortgage_id as product_identifier,
        mortgage_open_date as product_open_date,
        mortgage_closed_date as product_closed_date,
        mortgage_balance as current_balance,
        mortgage_status as product_status,
        is_mortgage_in_default as is_in_default
    from account
    where mortgage_id is not null

),

auto_loan as (

    select
        custkey,
        acctkey,
        raw_products,
        'auto_loan' as product_type,
        auto_loan_id as product_identifier,
        auto_loan_open_date as product_open_date,
        auto_loan_closed_date as product_closed_date,
        auto_loan_balance as current_balance,
        auto_loan_status as product_status,
        is_auto_loan_in_default as is_in_default
    from account
    where auto_loan_id is not null

)

select * from credit_card
union all
select * from mortgage
union all
select * from auto_loan
