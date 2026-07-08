import os

import psycopg


def connect(dsn: str | None = None) -> psycopg.Connection:
    return psycopg.connect(dsn or os.environ["PIPELINE_DATABASE_URL"])
