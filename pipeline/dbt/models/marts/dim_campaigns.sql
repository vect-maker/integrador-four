with campaigns as (
    select * from {{ ref('stg_incentive_campaigns') }}
),
zones as (
    select * from {{ ref('stg_urban_zones') }}
)

select
    md5(cast(c.campaign_id as text)) as sk_campaign,
    c.campaign_id,
    md5(cast(c.target_zone_id as text)) as sk_target_zone,
    c.target_zone_id,
    z.zone_name as target_zone_name,
    z.district as target_district,
    z.socioeconomic_stratum as target_socioeconomic_stratum,
    c.bonus_name,
    c.budget_cost_nio,
    c.online_hours_increase,
    c.cost_per_online_hour_nio,
    c.incentive_type,
    c.start_date,
    c.end_date,
    c.duration_days,
    c.status,
    c.is_active
from campaigns c
left join zones z on c.target_zone_id = z.zone_id
order by c.campaign_id
