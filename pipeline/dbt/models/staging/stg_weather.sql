with weather_daily as (
    select
        date,
        round(avg(precipitation_mm), 2) as precipitation_mm,
        round(avg(channel_runoff_mm), 2) as avg_channel_runoff_mm,
        round(max(channel_runoff_mm), 2) as max_channel_runoff_mm,
        round(avg(temperature_c), 1) as temperature_c,
        round(avg(congestion_index), 2) as congestion_index,
        mode() within group (order by sky_condition) as sky_condition,
        bool_or(flooded_roads) as has_flooded_roads
    from {{ source('raw', 'quadrant_weather') }}
    group by date
)

select
    date,
    precipitation_mm,
    avg_channel_runoff_mm,
    max_channel_runoff_mm,
    case
        when precipitation_mm = 0 then 'sin lluvia'
        when precipitation_mm < 10 then 'ligera'
        when precipitation_mm < 30 then 'moderada'
        else 'fuerte'
    end as rain_intensity,
    case
        when precipitation_mm = 0 then 'sin lluvia'
        when precipitation_mm < 10 then 'ligera'
        when precipitation_mm < 30 then 'moderada'
        else 'fuerte'
    end as precipitation_category,
    temperature_c,
    congestion_index,
    case
        when congestion_index < 1.30 then 'baja'
        when congestion_index < 1.70 then 'moderada'
        when congestion_index < 2.20 then 'alta'
        else 'critica'
    end as congestion_level,
    sky_condition,
    has_flooded_roads,
    case when precipitation_mm > 0 then true else false end as has_rain
from weather_daily
order by date
