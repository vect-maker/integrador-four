with source as (
    select * from {{ source('raw', 'users') }}
)

select
    user_id,
    name,
    phone,
    preferred_payment_method,
    case when preferred_payment_method = 'efectivo' then true else false end as prefers_cash,
    average_rating,
    registration_date
from source
order by user_id
