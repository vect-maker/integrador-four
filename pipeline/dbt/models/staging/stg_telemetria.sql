with source as (
    select * from {{ source('raw', 'driver_telemetry') }}
),
quadrants as (
    select * from {{ source('raw', 'quadrants') }}
)

select
    t.telemetry_id as id_telemetria,
    t.driver_id as id_conductor,
    t.trip_id as id_viaje,
    t.quadrant_id as id_cuadrante,
    q.zone_id as id_zona,
    t.recorded_at as fecha_hora,
    t.recorded_at::date as fecha,
    extract(hour from t.recorded_at)::int as hora,
    t.latitude as latitud,
    t.longitude as longitud,
    t.speed_kmh as velocidad_kmh,
    t.availability_status as estado_disponibilidad
from source t
left join quadrants q on t.quadrant_id = q.quadrant_id
order by t.recorded_at
