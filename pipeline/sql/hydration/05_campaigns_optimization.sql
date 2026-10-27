-- 05_campaigns_optimization.sql: Incentive program budget parameters for 0/1 knapsack optimization
SELECT 
    campaign_id AS id_campania,
    bonus_name AS nombre_bono,
    incentive_type AS tipo_incentivo,
    budget_cost_nio AS costo_presupuesto_nio,
    online_hours_increase AS incremento_horas_conexion,
    ROUND(cost_per_online_hour_nio, 2) AS costo_por_hora_nio,
    status AS estado
FROM dim_campaigns
ORDER BY campaign_id
