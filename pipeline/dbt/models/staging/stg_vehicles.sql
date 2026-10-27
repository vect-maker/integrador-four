with source as (
    select * from {{ source('raw', 'vehicles') }}
)

select
    vehicle_id,
    driver_id,
    service_type,
    vehicle_model,
    vehicle_year,
    license_plate,
    fuel_type,
    fuel_efficiency_km_l,
    initial_odometer_km
from source
order by vehicle_id
