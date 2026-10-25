-- 06_zones_catalog.sql: Unified territorial and base pricing catalog from dim_zonas
SELECT 
    id_zona,
    nombre_zona,
    estrato_socioeconomico,
    nivel_estrato,
    latitud,
    longitud,
    radio_cobertura_km,
    tarifa_base_bajada_bandera
FROM dim_zonas
ORDER BY id_zona
