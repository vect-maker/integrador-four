with source as (
    select * from {{ source('raw', 'urban_zones') }}
)

select
    zone_id,
    zone_name,
    district,
    socioeconomic_stratum,
    case
        when socioeconomic_stratum = 'popular' then 1
        when socioeconomic_stratum = 'medio' then 2
        when socioeconomic_stratum = 'comercial' then 3
        when socioeconomic_stratum = 'alto' then 4
    end as stratum_level,
    latitude,
    longitude,
    coverage_radius_km,
    base_flag_drop_fare
from source
order by zone_id
