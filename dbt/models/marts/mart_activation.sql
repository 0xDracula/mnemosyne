select
    count(*) as invited,
    count(*) filter (where claimed_at is not null) as claimed,
    round(
        count(*) filter (where claimed_at is not null)::numeric
        / nullif(count(*), 0),
        4
    ) as claim_rate,
    'v1' as metric_version
from {{ ref('dim_member') }}
