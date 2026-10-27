with source as (
    select * from {{ source('raw', 'incentive_campaigns') }}
)

select
    campaign_id as id_campana,
    target_zone_id as id_zona_objetivo,
    bonus_name as nombre_bono,
    budget_cost_nio as costo_presupuesto_nio,
    online_hours_increase as incremento_horas_conexion,
    round(budget_cost_nio / nullif(online_hours_increase, 0), 2) as costo_por_hora_conexion,
    incentive_type as tipo_incentivo,
    start_date as fecha_inicio,
    end_date as fecha_fin,
    (end_date - start_date) as duracion_dias,
    status as estado,
    case when status = 'activa' then true else false end as es_activa
from source
order by campaign_id
