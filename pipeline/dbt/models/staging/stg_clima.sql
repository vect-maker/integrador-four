with weather_daily as (
    select
        date as fecha,
        round(avg(precipitation_mm), 2) as precipitacion_mm,
        round(avg(temperature_c), 1) as temperatura_c,
        round(avg(congestion_index), 2) as indice_congestion,
        mode() within group (order by sky_condition) as condicion_cielo,
        bool_or(flooded_roads) as hubo_inundacion
    from {{ source('raw', 'quadrant_weather') }}
    group by date
)

select
    fecha,
    precipitacion_mm,
    case
        when precipitacion_mm = 0 then 'sin lluvia'
        when precipitacion_mm < 10 then 'ligera'
        when precipitacion_mm < 30 then 'moderada'
        else 'fuerte'
    end as intensidad_lluvia,
    case
        when precipitacion_mm = 0 then 'sin lluvia'
        when precipitacion_mm < 10 then 'ligera'
        when precipitacion_mm < 30 then 'moderada'
        else 'fuerte'
    end as categoria_precipitacion,
    temperatura_c,
    indice_congestion,
    case
        when indice_congestion < 1.30 then 'baja'
        when indice_congestion < 1.70 then 'moderada'
        when indice_congestion < 2.20 then 'alta'
        else 'critica'
    end as nivel_congestion,
    condicion_cielo,
    hubo_inundacion,
    case when precipitacion_mm > 0 then true else false end as hubo_lluvia,
    case when precipitacion_mm > 0 then true else false end as tiene_lluvia
from weather_daily
order by fecha
