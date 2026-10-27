with source as (
    select * from {{ ref('stg_urban_zones') }}
)

select
    md5(cast(zone_id as text)) as sk_zone,
    zone_id,
    zone_name,
    district,
    socioeconomic_stratum,
    stratum_level,
    latitude,
    longitude,
    coverage_radius_km,
    base_flag_drop_fare
from source
order by zone_id
