with source as (
    select * from {{ source('raw', 'campanas_incentivos') }}
)

select
    id_campana,
    nombre_bono,
    costo_presupuesto_nio,
    incremento_horas_conexion,
    round(costo_presupuesto_nio / nullif(incremento_horas_conexion, 0), 2) as costo_por_hora_conexion,
    tipo_incentivo,
    fecha_inicio,
    fecha_fin,
    estado
from source
order by id_campana
