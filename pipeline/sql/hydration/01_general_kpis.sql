-- 01_general_kpis.sql: Annual macro operational KPIs for MoviGo (2024 cycle)
SELECT 
    COUNT(*) AS total_viajes,
    COUNT(CASE WHEN is_cancelled THEN 1 END) AS total_cancelados,
    COUNT(CASE WHEN is_completed THEN 1 END) AS total_completados,
    ROUND(COUNT(CASE WHEN is_cancelled THEN 1 END) * 100.0 / COUNT(*), 2) AS tasa_cancelacion_pct,
    ROUND(AVG(surge_multiplier), 2) AS surge_promedio,
    ROUND(AVG(base_fare), 2) AS tarifa_base_promedio_nio,
    ROUND(AVG(final_fare), 2) AS tarifa_final_promedio_nio,
    ROUND(AVG(surge_cost_nio), 2) AS sobrecosto_promedio_nio,
    ROUND(AVG(distance_km), 2) AS distancia_promedio_km,
    ROUND(AVG(wait_time_minutes), 2) AS tiempo_espera_promedio_min,
    -- Dimensional system counts
    (SELECT COUNT(*) FROM dim_zones) AS total_zonas,
    (SELECT COUNT(*) FROM dim_weather) AS total_dias_clima,
    (SELECT COUNT(*) FROM dim_users) AS total_usuarios,
    (SELECT COUNT(*) FROM dim_drivers) AS total_conductores,
    (SELECT COUNT(*) FROM dim_campaigns) AS total_campanias
FROM fct_viajes
