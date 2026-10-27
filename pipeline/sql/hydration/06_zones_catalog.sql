-- 06_zones_catalog.sql: Unified territorial and base pricing catalog from dim_zones
SELECT 
    zone_id AS id_zona,
    zone_name AS nombre_zona,
    district AS distrito,
    socioeconomic_stratum AS estrato_socioeconomico,
    stratum_level AS nivel_estrato,
    latitude AS latitud,
    longitude AS longitud,
    coverage_radius_km AS radio_cobertura_km,
    base_flag_drop_fare AS tarifa_base_bajada_bandera
FROM dim_zones
ORDER BY zone_id
