with source as (
    select * from {{ ref('stg_incentive_campaigns') }}
)

select
    md5(cast(campaign_id as text)) as sk_campania,
    campaign_id as id_campania,
    target_zone_id as id_zona_objetivo,
    bonus_name as nombre_bono,
    budget_cost_nio as costo_presupuesto_nio,
    online_hours_increase as incremento_horas_conexion,
    cost_per_online_hour_nio as costo_por_hora_conexion,
    incentive_type as tipo_incentivo,
    start_date as fecha_inicio,
    end_date as fecha_fin,
    duration_days as duracion_dias,
    status as estado,
    is_active as es_activa
from source
