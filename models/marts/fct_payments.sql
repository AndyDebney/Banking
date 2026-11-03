with account as (
    select *
    from {{ ref('int_bank_raw__account') }}
),

credit_card_payments as (
    select
        'credit_card' as payment_type,
        a.custkey as customer_id,
        a.acctkey as account_id,
        p.cc_number as payment_reference_id,
        try_to_date(p.payment_date) as payment_date,
        try_to_date(p.payment_due_date) as payment_due_date,
        p.payment_amount,
        case
            when p.delinquent_payment = 'Y' then true
            when p.delinquent_payment = 'N' then false
        end as is_delinquent_payment,
        p.balance as balance_after_payment
    from {{ ref('int_bank_raw__credit_card_payment') }} p
    left join account a
        on p.cc_number = a.cc_number
),

mortgage_payments as (
    select
        'mortgage' as payment_type,
        a.custkey as customer_id,
        a.acctkey as account_id,
        p.mortgage_id as payment_reference_id,
        try_to_date(p.payment_date) as payment_date,
        try_to_date(p.payment_due_date) as payment_due_date,
        p.payment_amount,
        case
            when p.delinquent_payment = 'Y' then true
            when p.delinquent_payment = 'N' then false
        end as is_delinquent_payment,
        p.balance as balance_after_payment
    from {{ ref('int_bank_raw__mortgage_payment') }} p
    left join account a
        on p.mortgage_id = a.mortgage_id
),

auto_loan_payments as (
    select
        'auto_loan' as payment_type,
        a.custkey as customer_id,
        a.acctkey as account_id,
        p.auto_loan_id as payment_reference_id,
        try_to_date(p.payment_date) as payment_date,
        try_to_date(p.payment_due_date) as payment_due_date,
        p.payment_amount,
        case
            when p.delinquent_payment = 'Y' then true
            when p.delinquent_payment = 'N' then false
        end as is_delinquent_payment,
        p.balance as balance_after_payment
    from {{ ref('int_bank_raw__auto_loan_payment') }} p
    left join account a
        on p.auto_loan_id = a.auto_loan_id
)

select * from credit_card_payments
union all
select * from mortgage_payments
union all
select * from auto_loan_payments
