import os
import pandas as pd
import psycopg2
from dotenv import load_dotenv
load_dotenv()

def get_db_connection():
    """Function printing python version."""
    return psycopg2.connect(
        host=os.getenv("POSTGRES_HOST"),
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        port=os.getenv("POSTGRES_PORT"))

def extract_to_csv(schema: str | None = os.getenv("POSTGRES_SCHEMA")):
    """Function printing python version."""
    conn = get_db_connection()
    os.makedirs("files", exist_ok=True)
    with conn.cursor() as cur:
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables
            WHERE table_schema = %s AND table_type = 'BASE TABLE'
        """, (schema,))
        tables = cur.fetchall()
    for (table_name,) in tables:
        print(f"📦 Exporting table `{table_name}`...")
        query = f"SELECT * FROM {schema}.{table_name}"
        df = pd.read_sql(query, conn) # pyright: ignore[reportArgumentType]
        output_path = "/opt/airflow/files/users.csv"
        if os.path.exists(output_path):
            try:
                df_existing = pd.read_csv(output_path)
                if df_existing.equals(df):
                    print(f"⚠️ No changes in `{table_name}`. Skipping write.")
                    continue
                else:
                    print(f"✏️ Changes detected in `{table_name}`. Updating CSV.")
            except Exception as e:
                print(f"⚠️ Error reading `{output_path}`: {e}. Rewriting file.")
        else:
            print(f"🆕 File for `{table_name}` does not exist. Creating CSV.")
        df.to_csv(output_path, index=False)
        print(f"💾 Saved to {output_path}")
    conn.close()
    print("✅ CSV export completed.")
    