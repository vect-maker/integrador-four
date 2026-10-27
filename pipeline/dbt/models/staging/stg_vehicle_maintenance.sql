with source as (
    select * from {{ source('raw', 'vehicle_maintenance') }}
)

select
    maintenance_id,
    vehicle_id,
    service_date,
    maintenance_type,
    odometer_km,
    description,
    cost_nio,
    downtime_hours,
    workshop_name
from source
order by maintenance_id
