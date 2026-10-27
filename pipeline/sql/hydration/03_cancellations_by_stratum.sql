-- 03_cancellations_by_stratum.sql: Pricing sensitivity and cancellation propensities by socioeconomic stratum
SELECT 
    z.socioeconomic_stratum AS estrato_socioeconomico,
    z.stratum_level AS nivel_estrato,
    COUNT(f.sk_trip) AS total_viajes,
    COUNT(CASE WHEN f.is_cancelled THEN 1 END) AS total_cancelados,
    ROUND(COUNT(CASE WHEN f.is_cancelled THEN 1 END) * 100.0 / COUNT(f.sk_trip), 2) AS tasa_cancelacion_pct,
    ROUND(AVG(f.surge_multiplier), 2) AS surge_promedio,
    ROUND(AVG(f.final_fare), 2) AS tarifa_promedio_nio,
    ROUND(AVG(f.wait_time_minutes), 2) AS tiempo_espera_promedio_min
FROM fct_viajes f
JOIN dim_zones z ON f.sk_zone_origin = z.sk_zone
GROUP BY z.socioeconomic_stratum, z.stratum_level
ORDER BY z.stratum_level
