with source as (
    select * from {{ source('raw', 'drivers') }}
)

select
    driver_id,
    name,
    average_rating,
    acceptance_rate_pct,
    status,
    case when status = 'activo' then true else false end as is_active
from source
order by driver_id
