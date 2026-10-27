with drivers as (
    select * from {{ ref('stg_drivers') }}
),
vehicles as (
    select * from {{ ref('stg_vehicles') }}
),
maintenance_summary as (
    select
        vehicle_id,
        count(maintenance_id) as total_maintenance_services,
        coalesce(sum(cost_nio), 0) as total_maintenance_cost_nio,
        coalesce(sum(downtime_hours), 0) as total_downtime_hours,
        max(service_date) as last_service_date
    from {{ ref('stg_vehicle_maintenance') }}
    group by vehicle_id
)

select
    md5(cast(d.driver_id as text)) as sk_driver,
    d.driver_id,
    d.name,
    v.vehicle_id,
    coalesce(v.service_type, 'movigo_estandar') as service_type,
    coalesce(v.vehicle_model, 'No especificado') as vehicle_model,
    coalesce(v.vehicle_year, 2020) as vehicle_year,
    (2024 - coalesce(v.vehicle_year, 2020)) as vehicle_age_years,
    coalesce(v.license_plate, 'N/A') as license_plate,
    v.fuel_type,
    v.fuel_efficiency_km_l,
    v.initial_odometer_km,
    coalesce(m.total_maintenance_services, 0) as total_maintenance_services,
    coalesce(m.total_maintenance_cost_nio, 0.0) as total_maintenance_cost_nio,
    coalesce(m.total_downtime_hours, 0.0) as total_downtime_hours,
    m.last_service_date,
    d.average_rating,
    d.acceptance_rate_pct,
    d.status,
    d.is_active
from drivers d
left join vehicles v on d.driver_id = v.driver_id
left join maintenance_summary m on v.vehicle_id = m.vehicle_id
order by d.driver_id
