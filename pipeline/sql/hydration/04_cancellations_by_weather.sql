-- 04_cancellations_by_weather.sql: Impact of rainfall intensity and traffic congestion on cancellations
SELECT 
    w.has_rain AS tiene_lluvia,
    w.precipitation_category AS categoria_precipitacion,
    COUNT(f.sk_trip) AS total_viajes,
    COUNT(CASE WHEN f.is_cancelled THEN 1 END) AS total_cancelados,
    ROUND(COUNT(CASE WHEN f.is_cancelled THEN 1 END) * 100.0 / COUNT(f.sk_trip), 2) AS tasa_cancelacion_pct,
    ROUND(AVG(f.surge_multiplier), 2) AS surge_promedio,
    ROUND(AVG(f.final_fare), 2) AS tarifa_promedio_nio,
    ROUND(AVG(w.congestion_index), 2) AS congestion_promedio,
    ROUND(AVG(w.temperature_c), 2) AS temperatura_promedio_c
FROM fct_viajes f
JOIN dim_weather w ON f.sk_weather = w.sk_weather
GROUP BY w.has_rain, w.precipitation_category
ORDER BY w.has_rain, w.precipitation_category
