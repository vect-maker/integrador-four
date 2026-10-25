-- 02_cancellations_by_hour.sql: Hourly distribution of trips, surge multipliers and cancellation rates
SELECT 
    hora_solicitud,
    es_hora_pico,
    COUNT(*) AS total_viajes,
    COUNT(CASE WHEN es_cancelado THEN 1 END) AS total_cancelados,
    ROUND(COUNT(CASE WHEN es_cancelado THEN 1 END) * 100.0 / COUNT(*), 2) AS tasa_cancelacion_pct,
    ROUND(AVG(multiplicador_dinamico), 2) AS surge_promedio,
    ROUND(AVG(tarifa_final), 2) AS tarifa_promedio_nio,
    ROUND(AVG(tiempo_espera_minutos), 2) AS tiempo_espera_promedio_min
FROM fct_viajes
GROUP BY hora_solicitud, es_hora_pico
ORDER BY hora_solicitud
