import os

import psycopg


def connect(dsn: str | None = None) -> psycopg.Connection:
    if dsn is not None:
        return psycopg.connect(dsn)
    return psycopg.connect(
        host=os.environ["POSTGRES_HOST"],
        port=os.environ["POSTGRES_PORT"],
        dbname=os.environ["POSTGRES_DB"],
        user=os.environ["PIPELINE_DB_USER"],
        password=os.environ["PIPELINE_DB_PASSWORD"],
    )
