import os
import pandas as pd
from sqlalchemy import create_engine, inspect
from google.cloud import bigquery

def load_all_tables_to_bq():
    # PostgreSQL connection
    db_user = os.getenv("POSTGRES_USER")
    db_pass = os.getenv("POSTGRES_PASSWORD")
    db_host = os.getenv("POSTGRES_HOST")
    db_port = os.getenv("POSTGRES_PORT", "5432")
    db_name = os.getenv("POSTGRES_DB")
    schema = os.getenv("POSTGRES_SCHEMA", "public")

    postgres_url = f"postgresql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}"
    engine = create_engine(postgres_url)

    # BigQuery config
    bq_credentials_path = os.getenv("GOOGLE_CREDENTIALS_PATH")
    bq_project = os.getenv("BQ_PROJECT_ID")
    bq_dataset = os.getenv("BQ_DATASET")

    if not bq_project or not bq_dataset:
        raise ValueError("Missing BQ_PROJECT_ID or BQ_DATASET environment variables.")

    # Set credentials path
    if bq_credentials_path:
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = bq_credentials_path

    # Create dataset if not exists
    client = bigquery.Client(project=bq_project)
    dataset_ref = bigquery.Dataset(f"{bq_project}.{bq_dataset}")
    try:
        client.get_dataset(dataset_ref) # type: ignore
    except Exception:
        print(f"📁 Dataset {bq_dataset} not found. Creating it...")
        client.create_dataset(dataset_ref)
        print(f"✅ Dataset {bq_dataset} created.")

    # Export each table
    inspector = inspect(engine)
    table_names = inspector.get_table_names(schema=schema) # type: ignore

    for table in table_names:
        full_table_name = f"{bq_dataset}.{table}"
        print(f"📤 Uploading table: {schema}.{table} ➡️ {full_table_name}")

        df = pd.read_sql_table(table_name=table, con=engine, schema=schema)
        df.to_gbq(
            destination_table=full_table_name,
            project_id=bq_project,
            if_exists="replace"
        )

        print(f"✅ Table '{table}' loaded successfully.")