with source as (
    select * from {{ ref('stg_conductores') }}
)

select
    md5(cast(id_conductor as text)) as sk_conductor,
    id_conductor,
    nombre,
    tipo_servicio,
    modelo_vehiculo,
    anio_vehiculo,
    placa,
    calificacion_promedio,
    tasa_aceptacion_pct,
    estado,
    es_activo
from source
