with viajes as (
    select * from {{ ref('stg_viajes') }}
)

select
    -- Llave primaria subrogada
    md5(cast(id_viaje as text)) as sk_viaje,
    id_viaje,

    -- Llaves foráneas subrogadas conformadas
    md5(cast(id_zona_origen as text)) as sk_zona_origen,
    md5(cast(id_zona_destino as text)) as sk_zona_destino,
    case 
        when id_conductor is not null then md5(cast(id_conductor as text)) 
        else null 
    end as sk_conductor,
    md5(cast(id_usuario as text)) as sk_usuario,
    md5(cast(fecha_solicitud as text)) as sk_clima,

    -- Cuadrantes espaciales y coordenadas GPS
    id_cuadrante_origen,
    id_cuadrante_destino,
    latitud_origen,
    longitud_origen,
    latitud_destino,
    longitud_destino,

    -- Fechas y componentes temporales
    fecha_solicitud,
    hora_solicitud,
    dia_semana_iso,
    es_fin_de_semana,
    es_hora_pico,
    fecha_hora_solicitud,
    fecha_hora_inicio,
    fecha_hora_fin,

    -- Métricas financieras y de tarifa dinámica
    tarifa_base,
    multiplicador_dinamico,
    tiene_surge,
    tarifa_final,
    sobrecosto_surge_nio,
    propina,
    metodo_pago,
    estado_pago,

    -- Métricas de resultado del servicio y cancelaciones (Eje central del paper)
    estado_viaje,
    es_cancelado,
    es_cancelado_usuario,
    es_cancelado_conductor,
    es_completado,
    motivo_cancelacion,
    cancelado_por,
    solicitudes_activas_origen,
    conductores_disponibles_origen,

    -- Métricas operativas
    distancia_km,
    duracion_minutos,
    tiempo_espera_minutos,

    -- Calificaciones
    calificacion_usuario,
    calificacion_conductor
from viajes
