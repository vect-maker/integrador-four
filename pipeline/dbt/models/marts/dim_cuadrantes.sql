with source as (
    select * from {{ ref('stg_cuadrantes') }}
)

select
    md5(cast(id_cuadrante as text)) as sk_cuadrante,
    id_cuadrante,
    md5(cast(id_zona as text)) as sk_zona,
    id_zona,
    codigo_cuadrante,
    nombre_cuadrante,
    fila_cuadricula,
    columna_cuadricula,
    lat_min,
    lat_max,
    lon_min,
    lon_max,
    altitud_msnm,
    riesgo_inundacion,
    cauces_principales
from source
