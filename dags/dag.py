from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'owner': 'CamilaJaviera',
    'start_date': datetime(2023, 1, 1),
    'depends_on_past': False,
    'retries': 1,
}

with DAG(
    'dbt_postgres_setup',
    default_args=default_args,
    schedule=None,
    catchup=False
) as dag:

    run_dbt_users = BashOperator(
        task_id='run_dbt_users',
        bash_command='dbt run --select staging.users --profiles-dir /opt/airflow/dbt_project --project-dir /opt/airflow/dbt_project'
    )