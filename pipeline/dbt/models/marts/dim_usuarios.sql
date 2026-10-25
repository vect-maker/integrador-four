with source as (
    select * from {{ ref('stg_usuarios') }}
)

select
    md5(cast(id_usuario as text)) as sk_usuario,
    id_usuario,
    nombre,
    telefono,
    metodo_pago_preferido,
    prefiere_efectivo,
    calificacion_promedio,
    fecha_registro
from source
