from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from datetime import datetime

import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from scripts.extract.extract import extract_to_csv as csv
from scripts.load.load_data import load_all_tables_to_bq as bq

default_args = {
    'owner': 'CamilaJaviera',
    'start_date': datetime(2024, 7, 26),
    'depends_on_past': False,
    'retries': 1,
}

with DAG(
    'dbt_postgres_setup',
    default_args=default_args,
    schedule=None,
    catchup=False
) as dag:

    task_users = BashOperator(
        task_id='clients',
        bash_command='dbt run --select staging.clients --profiles-dir /opt/airflow/dbt_project --project-dir /opt/airflow/dbt_project'
    )

    task_products = BashOperator(
        task_id='products',
        bash_command='dbt run --select staging.products --profiles-dir /opt/airflow/dbt_project --project-dir /opt/airflow/dbt_project'
    )

    task_orders = BashOperator(
        task_id='orders',
        bash_command='dbt run --select staging.orders --profiles-dir /opt/airflow/dbt_project --project-dir /opt/airflow/dbt_project'
    )

    task_report = BashOperator(
        task_id='final_report',
        bash_command='dbt run --select marts.final_report --profiles-dir /opt/airflow/dbt_project --project-dir /opt/airflow/dbt_project'
    )

    task_report_2 = BashOperator(
        task_id='sales_by_product',
        bash_command='dbt run --select marts.sales_by_product --profiles-dir /opt/airflow/dbt_project --project-dir /opt/airflow/dbt_project'
    )

    task_bq = PythonOperator(
        task_id='load_all_tables_to_bq',
        python_callable=bq,
    )

    task_csv = PythonOperator(
        task_id='extract_to_csv',
        python_callable=csv,
    )

    task_users >> task_products >> task_orders >> task_report >> task_report_2 >> task_bq >> task_csv # type: ignore
