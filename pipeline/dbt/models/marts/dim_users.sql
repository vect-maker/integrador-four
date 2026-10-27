with source as (
    select * from {{ ref('stg_users') }}
)

select
    md5(cast(user_id as text)) as sk_user,
    user_id,
    name,
    phone,
    preferred_payment_method,
    prefers_cash,
    average_rating,
    case
        when average_rating >= 4.80 then 'excelente'
        when average_rating >= 4.50 then 'bueno'
        else 'regular'
    end as rating_segment,
    registration_date,
    ('2024-12-31'::date - registration_date) as days_registered_2024
from source
order by user_id
