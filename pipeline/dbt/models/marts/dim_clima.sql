with source as (
    select * from {{ ref('stg_weather') }}
)

select
    md5(cast(date as text)) as sk_clima,
    date as fecha,
    precipitation_mm as precipitacion_mm,
    avg_channel_runoff_mm as escorrentia_cauces_mm,
    max_channel_runoff_mm as escorrentia_maxima_mm,
    temperature_c as temperatura_c,
    congestion_index as indice_congestion,
    sky_condition as condicion_cielo,
    has_rain as tiene_lluvia,
    has_rain as hubo_lluvia,
    precipitation_category as categoria_precipitacion,
    rain_intensity as intensidad_lluvia,
    congestion_level as nivel_congestion,
    has_flooded_roads as hubo_inundacion
from source
