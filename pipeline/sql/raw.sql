CREATE TABLE IF NOT EXISTS raw.member_dim (
    user_id text PRIMARY KEY,
    account_type text,
    is_guest boolean,
    account_created timestamptz,
    claimed_at timestamptz,
    deactivated_at timestamptz,
    workspaces integer,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS raw.member_activity_snapshot (
    user_id text NOT NULL,
    window_start date NOT NULL,
    window_end date NOT NULL,
    source text NOT NULL,
    days_active integer,
    days_active_desktop integer,
    days_active_android integer,
    days_active_ios integer,
    days_slack_connect integer,
    messages_posted integer,
    channel_messages_posted integer,
    reactions_added integer,
    files_uploaded integer,
    huddles integer,
    searches integer,
    channels_joined integer,
    last_active_at timestamptz,
    last_active_desktop_at timestamptz,
    last_active_android_at timestamptz,
    last_active_ios_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, window_start, window_end, source)
);

CREATE TABLE IF NOT EXISTS raw.channel_dim (
    channel_id text PRIMARY KEY,
    date_created timestamptz,
    workspaces integer,
    external_organizations integer,
    last_active_at timestamptz,
    total_members integer,
    regular_members integer,
    guests integer,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS raw.channel_activity_snapshot (
    channel_id text NOT NULL,
    window_start date NOT NULL,
    window_end date NOT NULL,
    source text NOT NULL,
    messages_posted integer,
    messages_posted_by_members integer,
    members_who_posted integer,
    change_in_members_who_posted integer,
    members_who_viewed integer,
    reactions_added integer,
    members_who_reacted integer,
    huddles_initiated integer,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (channel_id, window_start, window_end, source)
);
