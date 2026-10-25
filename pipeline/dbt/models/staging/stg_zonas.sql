with source as (
    select * from {{ source('raw', 'zonas_urbanas') }}
)

select
    id_zona,
    nombre_zona,
    estrato_socioeconomico,
    case
        when estrato_socioeconomico = 'popular' then 1
        when estrato_socioeconomico = 'medio' then 2
        when estrato_socioeconomico = 'comercial' then 3
        when estrato_socioeconomico = 'alto' then 4
    end as nivel_estrato,
    latitud,
    longitud,
    radio_cobertura_km,
    tarifa_base_bajada_bandera
from source
order by id_zona
