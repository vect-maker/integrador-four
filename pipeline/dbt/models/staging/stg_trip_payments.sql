with source as (
    select * from {{ source('raw', 'trip_payments') }}
)

select
    payment_id,
    trip_id,
    payment_method,
    base_fare,
    surge_multiplier,
    case when surge_multiplier > 1.00 then true else false end as has_surge,
    tip_amount,
    final_fare,
    round(final_fare - base_fare, 2) as surge_cost_nio,
    payment_status
from source
order by payment_id
