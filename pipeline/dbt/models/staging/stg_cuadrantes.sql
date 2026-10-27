with source as (
    select * from {{ source('raw', 'quadrants') }}
)

select
    quadrant_id as id_cuadrante,
    zone_id as id_zona,
    quadrant_code as codigo_cuadrante,
    quadrant_name as nombre_cuadrante,
    grid_row as fila_cuadricula,
    grid_col as columna_cuadricula,
    lat_min,
    lat_max,
    lon_min,
    lon_max,
    mean_altitude_masl as altitud_msnm,
    flood_risk as riesgo_inundacion,
    main_drainage_channels as cauces_principales
from source
order by quadrant_id
