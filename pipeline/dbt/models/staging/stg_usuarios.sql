with source as (
    select * from {{ source('raw', 'usuarios') }}
)

select
    id_usuario,
    nombre,
    telefono,
    metodo_pago_preferido,
    case when metodo_pago_preferido = 'efectivo' then true else false end as prefiere_efectivo,
    calificacion_promedio,
    fecha_registro
from source
order by id_usuario
