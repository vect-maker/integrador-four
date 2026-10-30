with source as (
    select * from {{ source('raw', 'quadrant_weather') }}
)

select
    weather_id,
    quadrant_id,
    recorded_at,
    date as weather_date,
    hour as weather_hour,
    precipitation_mm,
    channel_runoff_mm,
    temperature_c,
    congestion_index,
    flooded_roads,
    sky_condition
from source
