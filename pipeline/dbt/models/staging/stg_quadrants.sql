with source as (
    select * from {{ source('raw', 'quadrants') }}
)

select
    quadrant_id,
    zone_id,
    district,
    quadrant_code,
    quadrant_name,
    grid_row,
    grid_col,
    lat_min,
    lat_max,
    lon_min,
    lon_max,
    mean_altitude_masl,
    flood_risk,
    main_drainage_channels
from source
order by quadrant_id
