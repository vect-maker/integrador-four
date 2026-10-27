with drivers as (
    select * from {{ source('raw', 'drivers') }}
),
vehicles as (
    select * from {{ source('raw', 'vehicles') }}
)

select
    d.driver_id as id_conductor,
    d.name as nombre,
    v.vehicle_id as id_vehiculo,
    coalesce(v.service_type, 'movigo_estandar') as tipo_servicio,
    coalesce(v.vehicle_model, 'No especificado') as modelo_vehiculo,
    coalesce(v.vehicle_year, 2020) as anio_vehiculo,
    coalesce(v.license_plate, 'N/A') as placa,
    v.fuel_type as tipo_combustible,
    v.fuel_efficiency_km_l as rendimiento_combustible_kml,
    d.average_rating as calificacion_promedio,
    d.acceptance_rate_pct as tasa_aceptacion_pct,
    d.status as estado,
    case when d.status = 'activo' then true else false end as es_activo
from drivers d
left join vehicles v on d.driver_id = v.driver_id
order by d.driver_id
