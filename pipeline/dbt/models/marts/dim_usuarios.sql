with source as (
    select * from {{ ref('stg_users') }}
)

select
    md5(cast(user_id as text)) as sk_usuario,
    user_id as id_usuario,
    name as nombre,
    phone as telefono,
    preferred_payment_method as metodo_pago_preferido,
    prefers_cash as prefiere_efectivo,
    average_rating as calificacion_promedio,
    registration_date as fecha_registro
from source
