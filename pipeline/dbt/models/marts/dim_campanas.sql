with source as (
    select * from {{ ref('stg_campanas') }}
)

select
    md5(cast(id_campana as text)) as sk_campana,
    id_campana,
    nombre_bono,
    costo_presupuesto_nio,
    incremento_horas_conexion,
    costo_por_hora_conexion,
    tipo_incentivo,
    fecha_inicio,
    fecha_fin,
    estado
from source
