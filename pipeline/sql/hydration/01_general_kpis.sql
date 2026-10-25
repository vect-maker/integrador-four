-- 01_general_kpis.sql: Annual macro operational KPIs for MoviGo (2024 cycle)
SELECT 
    COUNT(*) AS total_viajes,
    COUNT(CASE WHEN es_cancelado THEN 1 END) AS total_cancelados,
    COUNT(CASE WHEN es_completado THEN 1 END) AS total_completados,
    ROUND(COUNT(CASE WHEN es_cancelado THEN 1 END) * 100.0 / COUNT(*), 2) AS tasa_cancelacion_pct,
    ROUND(AVG(multiplicador_dinamico), 2) AS surge_promedio,
    ROUND(AVG(tarifa_base), 2) AS tarifa_base_promedio_nio,
    ROUND(AVG(tarifa_final), 2) AS tarifa_final_promedio_nio,
    ROUND(AVG(sobrecosto_surge_nio), 2) AS sobrecosto_promedio_nio,
    ROUND(AVG(distancia_km), 2) AS distancia_promedio_km,
    ROUND(AVG(tiempo_espera_minutos), 2) AS tiempo_espera_promedio_min
FROM fct_viajes
