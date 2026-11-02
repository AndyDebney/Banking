with auto_loan_payments as (

    select
        'auto_loan' as product_type,
        auto_loan_id as product_identifier,
        to_date(payment_date) as payment_date,
        payment_amount,
        to_date(payment_due_date) as payment_due_date,
        case
            when delinquent_payment = 'Y' then true
            when delinquent_payment = 'N' then false
        end as is_delinquent_payment,
        balance as balance_after_payment
    from {{ ref('stg_bank_raw__auto_loan_payment') }}

),

credit_card_payments as (

    select
        'credit_card' as product_type,
        cc_number as product_identifier,
        to_date(payment_date) as payment_date,
        payment_amount,
        to_date(payment_due_date) as payment_due_date,
        case
            when delinquent_payment = 'Y' then true
            when delinquent_payment = 'N' then false
        end as is_delinquent_payment,
        balance as balance_after_payment
    from {{ ref('stg_bank_raw__credit_card_payment') }}

),

mortgage_payments as (

    select
        'mortgage' as product_type,
        mortgage_id as product_identifier,
        to_date(payment_date) as payment_date,
        payment_amount,
        to_date(payment_due_date) as payment_due_date,
        case
            when delinquent_payment = 'Y' then true
            when delinquent_payment = 'N' then false
        end as is_delinquent_payment,
        balance as balance_after_payment
    from {{ ref('stg_bank_raw__mortgage_payment') }}

),

all_payments as (

    select * from auto_loan_payments
    union all
    select * from credit_card_payments
    union all
    select * from mortgage_payments

),

account_products as (

    select
        custkey,
        acctkey,
        product_type,
        product_identifier
    from {{ ref('int_bank_raw__account_products') }}

)

select
    account_products.custkey,
    account_products.acctkey,
    all_payments.product_type,
    all_payments.product_identifier,
    all_payments.payment_date,
    all_payments.payment_amount,
    all_payments.payment_due_date,
    all_payments.is_delinquent_payment,
    all_payments.balance_after_payment
from all_payments
left join account_products
    on all_payments.product_type = account_products.product_type
    and all_payments.product_identifier = account_products.product_identifier
