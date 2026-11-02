with product_profile as (

    select
        profilekey,
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

)

select *
from product_profile
