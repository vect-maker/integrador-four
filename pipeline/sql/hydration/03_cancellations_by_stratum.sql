-- 03_cancellations_by_stratum.sql: Pricing sensitivity and cancellation propensities by socioeconomic stratum
SELECT 
    z.estrato_socioeconomico,
    z.nivel_estrato,
    COUNT(f.sk_viaje) AS total_viajes,
    COUNT(CASE WHEN f.es_cancelado THEN 1 END) AS total_cancelados,
    ROUND(COUNT(CASE WHEN f.es_cancelado THEN 1 END) * 100.0 / COUNT(f.sk_viaje), 2) AS tasa_cancelacion_pct,
    ROUND(AVG(f.multiplicador_dinamico), 2) AS surge_promedio,
    ROUND(AVG(f.tarifa_final), 2) AS tarifa_promedio_nio,
    ROUND(AVG(f.tiempo_espera_minutos), 2) AS tiempo_espera_promedio_min
FROM fct_viajes f
JOIN dim_zonas z ON f.sk_zona_origen = z.sk_zona
GROUP BY z.estrato_socioeconomico, z.nivel_estrato
ORDER BY z.nivel_estrato
