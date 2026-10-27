with source as (
    select * from {{ ref('stg_urban_zones') }}
)

select
    md5(cast(zone_id as text)) as sk_zona,
    zone_id as id_zona,
    zone_name as nombre_zona,
    district as distrito,
    socioeconomic_stratum as estrato_socioeconomico,
    stratum_level as nivel_estrato,
    latitude as latitud,
    longitude as longitud,
    coverage_radius_km as radio_cobertura_km,
    base_flag_drop_fare as tarifa_base_bajada_bandera
from source
