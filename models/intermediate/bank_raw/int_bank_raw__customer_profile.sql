with customer_profile as (

    select
        profilekey,
        custkey,
        nullif(career, '') as career,
        nullif(professional_status, '') as professional_status,
        nullif(risk_appetite, '') as risk_appetite,
        nullif(customer_segment, '') as customer_segment
    from {{ ref('stg_bank_raw__customer_profile') }}

)

select *
from customer_profile
