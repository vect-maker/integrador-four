with trips as (
    select * from {{ source('raw', 'trips') }}
),
quadrants as (
    select * from {{ source('raw', 'quadrants') }}
),
payments as (
    select * from {{ source('raw', 'trip_payments') }}
),
cancellations as (
    select * from {{ source('raw', 'trip_cancellations') }}
),
ratings as (
    select * from {{ source('raw', 'trip_ratings') }}
)

select
    t.trip_id as id_viaje,
    t.user_id as id_usuario,
    t.driver_id as id_conductor,
    qo.zone_id as id_zona_origen,
    qd.zone_id as id_zona_destino,
    t.origin_quadrant_id as id_cuadrante_origen,
    t.destination_quadrant_id as id_cuadrante_destino,
    t.origin_latitude as latitud_origen,
    t.origin_longitude as longitud_origen,
    t.destination_latitude as latitud_destino,
    t.destination_longitude as longitud_destino,
    t.requested_at as fecha_hora_solicitud,
    t.started_at as fecha_hora_inicio,
    t.completed_at as fecha_hora_fin,
    t.requested_at::date as fecha_solicitud,
    extract(hour from t.requested_at)::int as hora_solicitud,
    extract(isodow from t.requested_at)::int as dia_semana_iso,
    case 
        when extract(isodow from t.requested_at) in (6, 7) then true 
        else false 
    end as es_fin_de_semana,
    case 
        when (extract(hour from t.requested_at) between 7 and 8)
          or (extract(hour from t.requested_at) between 17 and 18) then true 
        else false 
    end as es_hora_pico,
    t.distance_km as distancia_km,
    t.duration_minutes as duracion_minutos,
    p.base_fare as tarifa_base,
    p.surge_multiplier as multiplicador_dinamico,
    case when p.surge_multiplier > 1.00 then true else false end as tiene_surge,
    p.final_fare as tarifa_final,
    round(p.final_fare - p.base_fare, 2) as sobrecosto_surge_nio,
    p.payment_method as metodo_pago,
    p.tip_amount as propina,
    p.payment_status as estado_pago,
    t.trip_status as estado_viaje,
    case when t.trip_status in ('cancelado_usuario', 'cancelado_conductor') then true else false end as es_cancelado,
    case when t.trip_status = 'cancelado_usuario' then true else false end as es_cancelado_usuario,
    case when t.trip_status = 'cancelado_conductor' then true else false end as es_cancelado_conductor,
    case when t.trip_status = 'completado' then true else false end as es_completado,
    coalesce(
        c.wait_time_minutes,
        case 
            when t.started_at is not null 
            then round(extract(epoch from (t.started_at - t.requested_at)) / 60.0, 2) 
            else null 
        end
    ) as tiempo_espera_minutos,
    c.cancellation_reason as motivo_cancelacion,
    c.cancelled_by as cancelado_por,
    c.origin_active_requests as solicitudes_activas_origen,
    c.origin_available_drivers as conductores_disponibles_origen,
    r.user_rating as calificacion_usuario,
    r.driver_rating as calificacion_conductor
from trips t
left join quadrants qo on t.origin_quadrant_id = qo.quadrant_id
left join quadrants qd on t.destination_quadrant_id = qd.quadrant_id
left join payments p on t.trip_id = p.trip_id
left join cancellations c on t.trip_id = c.trip_id
left join ratings r on t.trip_id = r.trip_id
order by t.requested_at
