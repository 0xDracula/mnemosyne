from pathlib import Path

from dotenv import load_dotenv

from lib.db import connect_admin

SQL_DIR = Path(__file__).resolve().parents[1] / "sql"
ENV_FILE = Path(__file__).resolve().parents[2] / "infra" / ".env"


def main() -> None:
    load_dotenv(ENV_FILE)
    with connect_admin() as conn:
        for path in sorted(SQL_DIR.glob("*.sql")):
            for statement in path.read_text().split(";"):
                stmt = statement.strip()
                if stmt:
                    conn.execute(stmt)


if __name__ == "__main__":
    main()
