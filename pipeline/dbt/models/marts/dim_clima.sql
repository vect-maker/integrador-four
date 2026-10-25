with source as (
    select * from {{ ref('stg_clima') }}
)

select
    md5(cast(fecha as text)) as sk_clima,
    fecha,
    precipitacion_mm,
    temperatura_c,
    indice_congestion,
    condicion_cielo,
    tiene_lluvia,
    categoria_precipitacion,
    nivel_congestion
from source
