with source as (
    select * from {{ source('raw', 'urban_zones') }}
)

select
    zone_id as id_zona,
    zone_name as nombre_zona,
    socioeconomic_stratum as estrato_socioeconomico,
    case
        when socioeconomic_stratum = 'popular' then 1
        when socioeconomic_stratum = 'medio' then 2
        when socioeconomic_stratum = 'comercial' then 3
        when socioeconomic_stratum = 'alto' then 4
    end as nivel_estrato,
    latitude as latitud,
    longitude as longitud,
    coverage_radius_km as radio_cobertura_km,
    base_flag_drop_fare as tarifa_base_bajada_bandera
from source
order by zone_id
