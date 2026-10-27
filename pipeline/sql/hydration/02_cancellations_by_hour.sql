-- 02_cancellations_by_hour.sql: Hourly distribution of trips, surge multipliers and cancellation rates
SELECT 
    request_hour AS hora_solicitud,
    is_peak_hour AS es_hora_pico,
    COUNT(*) AS total_viajes,
    COUNT(CASE WHEN is_cancelled THEN 1 END) AS total_cancelados,
    ROUND(COUNT(CASE WHEN is_cancelled THEN 1 END) * 100.0 / COUNT(*), 2) AS tasa_cancelacion_pct,
    ROUND(AVG(surge_multiplier), 2) AS surge_promedio,
    ROUND(AVG(final_fare), 2) AS tarifa_promedio_nio,
    ROUND(AVG(wait_time_minutes), 2) AS tiempo_espera_promedio_min
FROM fct_viajes
GROUP BY request_hour, is_peak_hour
ORDER BY request_hour
