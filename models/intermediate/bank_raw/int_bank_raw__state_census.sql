with state_census as (

    select
        sumlev,
        region,
        division,
        abbreviation as state_code,
        name as state_name,
        popestimate2019 as population_2019,
        popest18plus2019 as adult_population_2019,
        pcnt_popest18plus as adult_population_pct
    from {{ ref('stg_bank_raw__state_census') }}

)

select *
from state_census
