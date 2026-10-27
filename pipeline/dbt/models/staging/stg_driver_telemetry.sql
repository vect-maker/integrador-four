with source as (
    select * from {{ source('raw', 'driver_telemetry') }}
)

select
    telemetry_id,
    driver_id,
    trip_id,
    quadrant_id,
    recorded_at,
    recorded_at::date as record_date,
    extract(hour from recorded_at)::int as record_hour,
    latitude,
    longitude,
    speed_kmh,
    availability_status
from source
order by recorded_at
