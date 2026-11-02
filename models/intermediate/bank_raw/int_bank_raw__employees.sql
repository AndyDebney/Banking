with employee as (

    select
        employee_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as full_name,
        title,
        manger_id as manager_id,
        start_date as start_date_raw,
        case
            when to_date(start_date) <= current_date then to_date(start_date)
        end as start_date,
        to_date(dob) as date_of_birth,
        street,
        city,
        state,
        postcode,
        country,
        phone,
        case
            when to_date(start_date) > current_date then true
            else false
        end as has_future_start_date
    from {{ ref('stg_bank_raw__employee') }}

)

select *
from employee
