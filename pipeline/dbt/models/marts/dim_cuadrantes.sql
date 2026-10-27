with source as (
    select * from {{ ref('stg_quadrants') }}
)

select
    md5(cast(quadrant_id as text)) as sk_cuadrante,
    quadrant_id as id_cuadrante,
    md5(cast(zone_id as text)) as sk_zona,
    zone_id as id_zona,
    district as distrito,
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
