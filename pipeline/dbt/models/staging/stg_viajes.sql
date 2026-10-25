with source as (
    select * from {{ source('raw', 'viajes') }}
)

select
    id_viaje,
    id_usuario,
    id_conductor,
    id_zona_origen,
    id_zona_destino,
    fecha_hora_solicitud,
    fecha_hora_inicio,
    fecha_hora_fin,
    fecha_hora_solicitud::date as fecha_solicitud,
    extract(hour from fecha_hora_solicitud)::int as hora_solicitud,
    extract(isodow from fecha_hora_solicitud)::int as dia_semana_iso,
    case 
        when extract(isodow from fecha_hora_solicitud) in (6, 7) then true 
        else false 
    end as es_fin_de_semana,
    case 
        when (extract(hour from fecha_hora_solicitud) between 7 and 8)
          or (extract(hour from fecha_hora_solicitud) between 17 and 18) then true 
        else false 
    end as es_hora_pico,
    distancia_km,
    duracion_minutos,
    tarifa_base,
    multiplicador_dinamico,
    case when multiplicador_dinamico > 1.00 then true else false end as tiene_surge,
    tarifa_final,
    round(tarifa_final - tarifa_base, 2) as sobrecosto_surge_nio,
    metodo_pago,
    estado_viaje,
    case when estado_viaje in ('cancelado_usuario', 'cancelado_conductor') then 1 else 0 end as es_cancelado,
    case when estado_viaje = 'cancelado_usuario' then 1 else 0 end as es_cancelado_usuario,
    case when estado_viaje = 'cancelado_conductor' then 1 else 0 end as es_cancelado_conductor,
    case when estado_viaje = 'completado' then 1 else 0 end as es_completado,
    case 
        when fecha_hora_inicio is not null 
        then round(extract(epoch from (fecha_hora_inicio - fecha_hora_solicitud)) / 60.0, 2) 
        else null 
    end as tiempo_espera_minutos,
    calificacion_usuario,
    calificacion_conductor,
    propina,
    motivo_cancelacion
from source
order by fecha_hora_solicitud
