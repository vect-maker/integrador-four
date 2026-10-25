with source as (
    select * from {{ ref('stg_campanias') }}
)

select
    md5(cast(id_campania as text)) as sk_campania,
    id_campania,
    nombre_bono,
    costo_presupuesto_nio,
    incremento_horas_conexion,
    costo_por_hora_conexion,
    tipo_incentivo,
    fecha_inicio,
    fecha_fin,
    estado
from source
