with source as (
    select * from {{ source('raw', 'incentive_campaigns') }}
)

select
    campaign_id,
    target_zone_id,
    bonus_name,
    budget_cost_nio,
    online_hours_increase,
    round(budget_cost_nio / nullif(online_hours_increase, 0), 2) as cost_per_online_hour_nio,
    incentive_type,
    start_date,
    end_date,
    (end_date - start_date) as duration_days,
    status,
    case when status = 'activa' then true else false end as is_active
from source
order by campaign_id
