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
    import os
import pandas as pd
import psycopg2
from dotenv import load_dotenv
from sqlalchemy.engine import make_url

# Load environment variables
load_dotenv()

def get_db_connection():
    url = os.getenv("AIRFLOW__DATABASE__SQL_ALCHEMY_CONN")
    print(f"🔗 Connecting to DB: {url}")
    
    parsed_url = make_url(url)
    
    return psycopg2.connect(
        host=parsed_url.host,       # type: ignore
        port=parsed_url.port,       # type: ignore
        dbname=parsed_url.database, # type: ignore
        user=parsed_url.username,   # type: ignore
        password=parsed_url.password # type: ignore
    )

def extract_to_csv():
    
    schema = os.getenv("POSTGRES_SCHEMA")

    conn = get_db_connection()
    
    os.makedirs("files", exist_ok=True)

    with conn.cursor() as cur:
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables
            WHERE table_schema = %s AND table_type = 'BASE TABLE'
        """, (schema,))
        
        tables = cur.fetchall()
    
    print(f"📋 Schema: {schema}")
    print(f"📋 Tables found: {tables}")

    for (table_name,) in tables:
        print(f"📦 Exporting table `{table_name}`...")
        query = f"SELECT * FROM {schema}.{table_name}"
        
        try:
            df = pd.read_sql(query, conn)  # pyright: ignore
        except Exception as e:
            print(f"❌ Error reading from table `{table_name}`: {e}")
            continue

        output_path = f"files/{table_name}.csv"

        if os.path.exists(output_path):
            try:
                df_existing = pd.read_csv(output_path)
                if df_existing.equals(df):
                    print(f"⚠️ No changes in `{table_name}`. Skipping write.")
                    continue
                else:
                    print(f"✏️ Changes detected in `{table_name}`. Updating CSV.")
            except Exception as e:
                print(f"⚠️ Error reading existing CSV: {e}. Rewriting file.")
        else:
            print(f"🆕 Creating new CSV for `{table_name}`.")

        try:
            df.to_csv(output_path, index=False)
            print(f"💾 Saved to {output_path}")
        except Exception as e:
            print(f"❌ Error writing CSV for `{table_name}`: {e}")

    conn.close()
    print("✅ CSV export completed.")