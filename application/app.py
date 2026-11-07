from __future__ import annotations

import os
from contextlib import closing

import psycopg2
from flask import Flask, render_template
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

DATABASE_URL = os.environ.get("DATABASE_URL")


def get_connection():
    if not DATABASE_URL:
        raise RuntimeError("DATABASE_URL is not configured")
    return psycopg2.connect(DATABASE_URL, connect_timeout=3)


@app.get("/health")
def health():
    """Liveness endpoint for the load balancer; does not depend on RDS."""
    return {"status": "ok"}, 200


@app.get("/ready")
def ready():
    """Readiness endpoint that confirms the database can be reached."""
    try:
        with closing(get_connection()) as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
        return {"status": "ready"}, 200
    except Exception:
        app.logger.exception("Readiness check could not reach the database")
        return {"status": "not_ready"}, 503


@app.get("/")
def catalog():
    try:
        with closing(get_connection()) as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    "SELECT id, name, description, price "
                    "FROM products ORDER BY id"
                )
                products = cursor.fetchall()
        return render_template("catalog.html", products=products)
    except Exception:
        app.logger.exception("Could not load the product catalog")
        return render_template("unavailable.html"), 503


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "8080")))

