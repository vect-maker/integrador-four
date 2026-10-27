with source as (
    select * from {{ source('raw', 'users') }}
)

select
    user_id as id_usuario,
    name as nombre,
    phone as telefono,
    preferred_payment_method as metodo_pago_preferido,
    case when preferred_payment_method = 'efectivo' then true else false end as prefiere_efectivo,
    average_rating as calificacion_promedio,
    registration_date as fecha_registro
from source
order by user_id
