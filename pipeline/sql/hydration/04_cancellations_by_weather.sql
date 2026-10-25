-- 04_cancellations_by_weather.sql: Impact of rainfall intensity and traffic congestion on cancellations
SELECT 
    c.tiene_lluvia,
    c.categoria_precipitacion,
    COUNT(f.sk_viaje) AS total_viajes,
    COUNT(CASE WHEN f.es_cancelado THEN 1 END) AS total_cancelados,
    ROUND(COUNT(CASE WHEN f.es_cancelado THEN 1 END) * 100.0 / COUNT(f.sk_viaje), 2) AS tasa_cancelacion_pct,
    ROUND(AVG(f.multiplicador_dinamico), 2) AS surge_promedio,
    ROUND(AVG(f.tarifa_final), 2) AS tarifa_promedio_nio,
    ROUND(AVG(c.indice_congestion), 2) AS congestion_promedio,
    ROUND(AVG(c.temperatura_c), 2) AS temperatura_promedio_c
FROM fct_viajes f
JOIN dim_clima c ON f.sk_clima = c.sk_clima
GROUP BY c.tiene_lluvia, c.categoria_precipitacion
ORDER BY c.tiene_lluvia, c.categoria_precipitacion
