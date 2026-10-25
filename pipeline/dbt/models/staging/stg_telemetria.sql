with source as (
    select * from {{ source('raw', 'telemetria_conductores') }}
)

select
    id_telemetria,
    id_conductor,
    id_zona,
    fecha_hora,
    fecha_hora::date as fecha,
    extract(hour from fecha_hora)::int as hora,
    latitud,
    longitud,
    velocidad_kmh,
    estado_disponibilidad
from source
order by fecha_hora
