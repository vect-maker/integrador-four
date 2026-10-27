with source as (
    select * from {{ source('raw', 'trips') }}
)

select
    trip_id,
    user_id,
    driver_id,
    origin_quadrant_id,
    destination_quadrant_id,
    origin_latitude,
    origin_longitude,
    destination_latitude,
    destination_longitude,
    requested_at,
    started_at,
    completed_at,
    requested_at::date as request_date,
    extract(hour from requested_at)::int as request_hour,
    extract(isodow from requested_at)::int as iso_day_of_week,
    case 
        when extract(isodow from requested_at) in (6, 7) then true 
        else false 
    end as is_weekend,
    case 
        when (extract(hour from requested_at) between 7 and 8)
          or (extract(hour from requested_at) between 17 and 18) then true 
        else false 
    end as is_peak_hour,
    distance_km,
    duration_minutes,
    trip_status,
    case when trip_status in ('cancelado_usuario', 'cancelado_conductor') then true else false end as is_cancelled,
    case when trip_status = 'cancelado_usuario' then true else false end as is_cancelled_by_user,
    case when trip_status = 'cancelado_conductor' then true else false end as is_cancelled_by_driver,
    case when trip_status = 'completado' then true else false end as is_completed
from source
order by requested_at
