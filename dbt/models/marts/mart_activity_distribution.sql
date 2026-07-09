with members as (
    select
        m.user_id,
        coalesce(act.messages_posted, 0) as messages_posted
    from {{ ref('dim_member') }} m
    left join {{ ref('fct_member_activity') }} act using (user_id)
    where m.claimed_at is not null
)
select
    case
        when messages_posted = 0 then 0
        when messages_posted between 1 and 5 then 1
        when messages_posted between 6 and 50 then 2
        when messages_posted between 51 and 500 then 3
        else 4
    end as band_order,
    case
        when messages_posted = 0 then '0 (dormant)'
        when messages_posted between 1 and 5 then '1-5'
        when messages_posted between 6 and 50 then '6-50'
        when messages_posted between 51 and 500 then '51-500'
        else '500+'
    end as activity_band,
    count(*) as members,
    'v1' as metric_version
from members
group by 1, 2
order by band_order
