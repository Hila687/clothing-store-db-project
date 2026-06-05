"""
Database helper module – connection handling and safe query execution.
"""

import psycopg2
from psycopg2 import Error as Psycopg2Error

from config import DB_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT


def get_connection():
    """Open and return a new PostgreSQL connection."""
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT,
    )


def fetch_all(query, params=None):
    """
    Run a SELECT query and return (column_names, rows).
    Read-only – no commit needed.
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(query, params or ())
            if cur.description is None:
                return [], []
            columns = [desc[0] for desc in cur.description]
            rows = cur.fetchall()
            return columns, rows
    finally:
        conn.close()


def fetch_one(query, params=None):
    """Run a SELECT query and return a single row (or None)."""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(query, params or ())
            return cur.fetchone()
    finally:
        conn.close()


def execute_write(query, params=None):
    """
    Run INSERT / UPDATE / DELETE / CALL.
    Commits on success, rolls back on error, then re-raises.
    Returns rowcount.
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(query, params or ())
            rowcount = cur.rowcount
        conn.commit()
        return rowcount
    except Psycopg2Error:
        conn.rollback()
        raise
    finally:
        conn.close()


def execute_write_returning(query, params=None):
    """Run INSERT/UPDATE ... RETURNING and commit. Returns the fetched row."""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(query, params or ())
            result = cur.fetchone()
        conn.commit()
        return result
    except Psycopg2Error:
        conn.rollback()
        raise
    finally:
        conn.close()


def call_function(function_name, params):
    """
    Call a PostgreSQL function that returns a scalar value.
    Example: calculate_customer_marketing_score(5)
    """
    placeholders = ", ".join(["%s"] * len(params))
    query = f"SELECT {function_name}({placeholders})"
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(query, params)
            result = cur.fetchone()[0]
        conn.commit()
        return result
    except Psycopg2Error:
        conn.rollback()
        raise
    finally:
        conn.close()


def call_procedure(procedure_name, params):
    """Call a PostgreSQL stored procedure using CALL syntax."""
    placeholders = ", ".join(["%s"] * len(params))
    query = f"CALL {procedure_name}({placeholders})"
    execute_write(query, params)


def fetch_lookup(table, id_col, display_col):
    """Load FK dropdown options: list of (id, display_text)."""
    query = f"SELECT {id_col}, {display_col} FROM {table} ORDER BY {display_col}"
    _, rows = fetch_all(query)
    return rows
