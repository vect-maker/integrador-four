with source as (
    select * from {{ source('raw', 'trip_ratings') }}
)

select
    rating_id,
    trip_id,
    user_rating,
    driver_rating
from source
order by rating_id
