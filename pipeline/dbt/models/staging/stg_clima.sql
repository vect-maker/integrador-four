with source as (
    select * from {{ source('raw', 'clima_cuadrantes') }}
)

select
    fecha,
    precipitacion_mm,
    temperatura_c,
    indice_congestion,
    condicion_cielo,
    case when precipitacion_mm > 0 then true else false end as tiene_lluvia,
    case
        when precipitacion_mm = 0 then 'sin_lluvia'
        when precipitacion_mm < 5.0 then 'lluvia_ligera'
        when precipitacion_mm < 20.0 then 'lluvia_moderada'
        else 'lluvia_torrencial'
    end as categoria_precipitacion,
    case
        when indice_congestion >= 2.50 then 'alta'
        when indice_congestion >= 1.70 then 'moderada'
        else 'baja'
    end as nivel_congestion
from source
order by fecha
