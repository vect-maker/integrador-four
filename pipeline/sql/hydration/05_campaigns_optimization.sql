-- 05_campaigns_optimization.sql: Incentive program budget parameters for 0/1 knapsack optimization
SELECT 
    id_campania,
    nombre_bono,
    tipo_incentivo,
    costo_presupuesto_nio,
    incremento_horas_conexion,
    ROUND(costo_por_hora_conexion, 2) AS costo_por_hora_nio,
    estado
FROM dim_campanias
ORDER BY id_campania
