with source as (
    select * from {{ ref('stg_zonas') }}
)

select
    md5(cast(id_zona as text)) as sk_zona,
    id_zona,
    nombre_zona,
    estrato_socioeconomico,
    nivel_estrato,
    latitud,
    longitud,
    radio_cobertura_km,
    tarifa_base_bajada_bandera
from source
