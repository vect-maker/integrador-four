with source as (
    select * from {{ ref('stg_weather') }}
)

select
    md5(cast(date as text)) as sk_weather,
    date,
    precipitation_mm,
    avg_channel_runoff_mm,
    max_channel_runoff_mm,
    case
        when max_channel_runoff_mm < 5.0 then 'bajo'
        when max_channel_runoff_mm < 15.0 then 'medio'
        else 'critico'
    end as channel_runoff_risk,
    temperature_c,
    congestion_index,
    sky_condition,
    has_rain,
    precipitation_category,
    rain_intensity,
    congestion_level,
    has_flooded_roads,
    -- Estacionalidad climática de Managua: Lluvia (Mayo a Octubre) vs Seca (Noviembre a Abril)
    case 
        when extract(month from date) between 5 and 10 then 'rainy'
        else 'dry'
    end as season,
    extract(month from date)::int as month,
    extract(quarter from date)::int as quarter,
    extract(isodow from date)::int as iso_day_of_week,
    case when extract(isodow from date) in (6, 7) then true else false end as is_weekend
from source
order by date
