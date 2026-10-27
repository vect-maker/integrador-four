with source as (
    select * from {{ source('raw', 'trip_cancellations') }}
)

select
    cancellation_id,
    trip_id,
    cancelled_by,
    cancellation_reason,
    wait_time_minutes,
    origin_active_requests,
    origin_available_drivers
from source
order by cancellation_id
