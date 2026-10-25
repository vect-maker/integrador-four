with source as (
    select * from {{ source('raw', 'conductores') }}
)

select
    id_conductor,
    nombre,
    tipo_servicio,
    modelo_vehiculo,
    anio_vehiculo,
    placa,
    calificacion_promedio,
    tasa_aceptacion_pct,
    estado,
    case when estado = 'activo' then true else false end as es_activo
from source
order by id_conductor
