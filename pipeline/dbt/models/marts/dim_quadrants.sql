with quadrants as (
    select * from {{ ref('stg_quadrants') }}
),
zones as (
    select * from {{ ref('stg_urban_zones') }}
)

select
    md5(cast(q.quadrant_id as text)) as sk_quadrant,
    q.quadrant_id,
    md5(cast(q.zone_id as text)) as sk_zone,
    q.zone_id,
    z.zone_name,
    q.district,
    z.socioeconomic_stratum,
    z.stratum_level,
    z.base_flag_drop_fare,
    q.quadrant_code,
    q.quadrant_name,
    q.grid_row,
    q.grid_col,
    q.lat_min,
    q.lat_max,
    q.lon_min,
    q.lon_max,
    q.mean_altitude_masl,
    q.flood_risk,
    q.main_drainage_channels
from quadrants q
left join zones z on q.zone_id = z.zone_id
order by q.quadrant_id
