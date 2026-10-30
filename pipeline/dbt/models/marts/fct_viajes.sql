with trips as (
    select * from {{ ref('stg_trips') }}
),
quadrants as (
    select * from {{ ref('stg_quadrants') }}
),
payments as (
    select * from {{ ref('stg_trip_payments') }}
),
cancellations as (
    select * from {{ ref('stg_trip_cancellations') }}
),
ratings as (
    select * from {{ ref('stg_trip_ratings') }}
),
weather_quadrant as (
    select * from {{ ref('stg_quadrant_weather') }}
),
vehicles as (
    select * from {{ ref('stg_vehicles') }}
)

select
    -- Llave primaria subrogada
    md5(cast(t.trip_id as text)) as sk_viaje,
    md5(cast(t.trip_id as text)) as sk_trip,
    t.trip_id as id_viaje,
    t.trip_id,

    -- Llaves foráneas subrogadas conformadas (inglés y español)
    md5(cast(qo.zone_id as text)) as sk_zona_origen,
    md5(cast(qo.zone_id as text)) as sk_zone_origin,
    md5(cast(qd.zone_id as text)) as sk_zona_destino,
    md5(cast(qd.zone_id as text)) as sk_zone_destination,
    case 
        when t.driver_id is not null then md5(cast(t.driver_id as text)) 
        else null 
    end as sk_conductor,
    case 
        when t.driver_id is not null then md5(cast(t.driver_id as text)) 
        else null 
    end as sk_driver,
    md5(cast(t.user_id as text)) as sk_usuario,
    md5(cast(t.user_id as text)) as sk_user,
    md5(cast(t.request_date as text)) as sk_clima,
    md5(cast(t.request_date as text)) as sk_weather,

    -- Cuadrantes espaciales, distritos y coordenadas GPS
    t.origin_quadrant_id as id_cuadrante_origen,
    t.origin_quadrant_id,
    qo.district as distrito_origen,
    qo.district as origin_district,
    t.destination_quadrant_id as id_cuadrante_destino,
    t.destination_quadrant_id,
    qd.district as distrito_destino,
    qd.district as destination_district,
    t.origin_latitude as latitud_origen,
    t.origin_latitude,
    t.origin_longitude as longitud_origen,
    t.origin_longitude,
    t.destination_latitude as latitud_destino,
    t.destination_latitude,
    t.destination_longitude as longitud_destino,
    t.destination_longitude,

    -- Fechas y componentes temporales
    t.request_date as fecha_solicitud,
    t.request_date,
    t.request_hour as hora_solicitud,
    t.request_hour,
    t.iso_day_of_week as dia_semana_iso,
    t.iso_day_of_week,
    t.is_weekend as es_fin_de_semana,
    t.is_weekend,
    t.is_peak_hour as es_hora_pico,
    t.is_peak_hour,
    t.requested_at as fecha_hora_solicitud,
    t.requested_at,
    t.started_at as fecha_hora_inicio,
    t.started_at,
    t.completed_at as fecha_hora_fin,
    t.completed_at,

    -- Métricas financieras y de tarifa dinámica
    p.base_fare as tarifa_base,
    p.base_fare,
    p.surge_multiplier as multiplicador_dinamico,
    p.surge_multiplier,
    p.has_surge as tiene_surge,
    p.has_surge,
    p.final_fare as tarifa_final,
    p.final_fare,
    p.surge_cost_nio as sobrecosto_surge_nio,
    p.surge_cost_nio,
    p.tip_amount as propina,
    p.tip_amount,
    p.payment_method as metodo_pago,
    p.payment_method,
    p.payment_status as estado_pago,
    p.payment_status,

    -- Métricas de resultado del servicio y cancelaciones
    t.trip_status as estado_viaje,
    t.trip_status,
    t.is_cancelled as es_cancelado,
    t.is_cancelled,
    t.is_cancelled_by_user as es_cancelado_usuario,
    t.is_cancelled_by_user,
    t.is_cancelled_by_driver as es_cancelado_conductor,
    t.is_cancelled_by_driver,
    t.is_completed as es_completado,
    t.is_completed,
    c.cancellation_reason as motivo_cancelacion,
    c.cancellation_reason,
    c.cancelled_by as cancelado_por,
    c.cancelled_by,
    c.origin_active_requests as solicitudes_activas_origen,
    c.origin_active_requests,
    c.origin_available_drivers as conductores_disponibles_origen,
    c.origin_available_drivers,

    -- Métricas operativas básicas
    t.distance_km as distancia_km,
    t.distance_km,
    t.duration_minutes as duracion_minutos,
    t.duration_minutes,
    coalesce(
        c.wait_time_minutes,
        case 
            when t.started_at is not null 
            then round(extract(epoch from (t.started_at - t.requested_at)) / 60.0, 2) 
            else null 
        end
    ) as tiempo_espera_minutos,
    coalesce(
        c.wait_time_minutes,
        case 
            when t.started_at is not null 
            then round(extract(epoch from (t.started_at - t.requested_at)) / 60.0, 2) 
            else null 
        end
    ) as wait_time_minutes,

    -- Calificaciones
    r.user_rating as calificacion_usuario,
    r.user_rating,
    r.driver_rating as calificacion_conductor,
    r.driver_rating,

    -- Métricas de microclima y congestión localizada en origen (cuadrante y hora)
    wq.congestion_index as indice_congestion_origen,
    wq.congestion_index as origin_congestion_index,
    wq.precipitation_mm as precipitacion_origen_mm,
    wq.precipitation_mm as origin_precipitation_mm,
    wq.channel_runoff_mm as escorrentia_origen_mm,
    wq.channel_runoff_mm as origin_channel_runoff_mm,
    wq.flooded_roads as calles_inundadas_origen,
    wq.flooded_roads as origin_flooded_roads,
    wq.sky_condition as condicion_cielo_origen,
    wq.sky_condition as origin_sky_condition,
    wq.temperature_c as temperatura_origen_c,
    wq.temperature_c as origin_temperature_c,

    -- Métricas operacionales y físicas derivadas
    case 
        when t.duration_minutes > 0 
        then round((t.distance_km / (t.duration_minutes / 60.0))::numeric, 2)
        else null 
    end as velocidad_media_kmh,
    case 
        when t.duration_minutes > 0 
        then round((t.distance_km / (t.duration_minutes / 60.0))::numeric, 2)
        else null 
    end as effective_speed_kmh,
    case 
        when v.fuel_efficiency_km_l is not null and v.fuel_efficiency_km_l > 0 
        then round((t.distance_km / v.fuel_efficiency_km_l)::numeric, 2)
        else null 
    end as consumo_combustible_litros,
    case 
        when v.fuel_efficiency_km_l is not null and v.fuel_efficiency_km_l > 0 
        then round((t.distance_km / v.fuel_efficiency_km_l)::numeric, 2)
        else null 
    end as estimated_fuel_liters
from trips t
left join quadrants qo on t.origin_quadrant_id = qo.quadrant_id
left join quadrants qd on t.destination_quadrant_id = qd.quadrant_id
left join payments p on t.trip_id = p.trip_id
left join cancellations c on t.trip_id = c.trip_id
left join ratings r on t.trip_id = r.trip_id
left join weather_quadrant wq on t.origin_quadrant_id = wq.quadrant_id 
                             and t.request_date = wq.weather_date 
                             and t.request_hour = wq.weather_hour
left join vehicles v on t.driver_id = v.driver_id
