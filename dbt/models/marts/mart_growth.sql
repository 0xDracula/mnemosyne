with joined as (
    select
        date_trunc('month', claimed_at)::date as month,
        count(*) as joined_members
    from {{ ref('dim_member') }}
    where claimed_at is not null
    group by 1
),
departed as (
    select
        date_trunc('month', deactivated_at)::date as month,
        count(*) as deactivated
    from {{ ref('dim_member') }}
    where deactivated_at is not null
    group by 1
)
select
    coalesce(joined.month, departed.month) as month,
    coalesce(joined.joined_members, 0) as joined_members,
    coalesce(departed.deactivated, 0) as deactivated,
    coalesce(joined.joined_members, 0) - coalesce(departed.deactivated, 0) as net_change,
    'v2' as metric_version
from joined
full outer join departed on joined.month = departed.month
order by month
