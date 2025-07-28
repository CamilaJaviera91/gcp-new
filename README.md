# 🚀 GCP-New

This project defines a modern data pipeline architecture using Airflow, DBT, and PostgreSQL. Below you'll find instructions on how to get started and how the repository is structured.

---

## 🚀 Getting Started

Before running the pipeline, make sure to create the following folders in the root directory of the project:

```
.
├── dags/
├── dbt_project/
├── files/
└── scripts/
```

- `dags/`: Contains Airflow DAGs to orchestrate the pipeline.
- `dbt_project/`: Contains the DBT project with all SQL transformation models.
- `files/`: Stores input/output files such as CSVs.
- `scripts/`: Includes helper scripts for data extraction, validation, and loading.

Inside the `dbt_project/` folder, make sure to create the following structure for your DBT models:

```
dbt_project/
└── models/
├── marts/
└── staging/
```

- `models/staging/`: Contains staging models for cleaning and preparing raw data.
- `models/marts/`: Contains data marts for final models ready for analysis and reporting.

---

## 🛠️ Requirements

Make sure you have the following installed:

- Python 3.10+
- Docker & Docker Compose
- DBT
- Apache Airflow (v2+)
- PostgreSQL

---

## 📦 Installation

```bash
# Clone the repository
git clone git@github.com:CamilaJaviera91/gcp-new.git
cd gcp-new

# Create required folders
mkdir -p dags dbt_project/models/{staging,marts} files scripts/{extract,load,utils}
```

---

## 🐳 Docker Setup with Airflow and PostgreSQL

This project uses Docker Compose to orchestrate the following services:

- **PostgreSQL**: Acts as the metadata database for Airflow and also stores project data.
- **Airflow Webserver**: Provides the UI for managing and monitoring DAGs.
- **Airflow Scheduler**: Triggers task instances based on scheduling.
- **Airflow Init**: Initializes the Airflow metadata database and prepares folders and permissions.

### 📁 Directory Structure

Make sure the following structure exists before launching the containers:

```
.
├── dags/ # Your Airflow DAGs go here
├── dbt_project/ # DBT models and config
├── files/ # CSVs, exports, or intermediate files
├── scripts/ # Python scripts used in the pipeline
├── docker-compose.yml # Docker Compose setup file
├── Dockerfile.airflow
├── README.md
└── requirements.txt
```

### 🐍 Python .env

```
# Airflow
AIRFLOW__CORE__EXECUTOR=...
AIRFLOW__CORE__LOAD_EXAMPLES=...
AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=...
AIRFLOW__WEBSERVER__SECRET_KEY=...

# PostgreSQL
POSTGRES_SCHEMA=...
POSTGRES_HOST=...
POSTGRES_PORT=...
POSTGRES_DB=...
POSTGRES_USER=...
POSTGRES_PASSWORD=...
```

### 📦 Python Dependencies

This project uses a `requirements.txt` file to manage all Python dependencies needed for the data pipeline, including Airflow, DBT, PostgreSQL, testing, and development tools.

#### 🔧 What's Included

| Category | Package(s) | Purpose |
| -------- | ---------- | ------- |
| **DBT** | `dbt-core`, `dbt-postgres`, `dbt-bigquery` | DBT functionality for PostgreSQL and BigQuery |
| **Airflow** | `apache-airflow==2.9.1`, `apache-airflow-providers-openlineage` | Workflow orchestration |
| **Database** | `psycopg2-binary==2.9.9` | PostgreSQL connector used by Airflow and DBT |
| **Compatibility** | `protobuf<5`, `sqlparse<0.5` | Ensures compatibility with DBT and Airflow |
| **Environment Variables** | `python-dotenv==1.1.0` | Loads `.env` files for secure and flexible config |
| **Synthetic Data** | `faker==24.9.0` | Generate fake data for testing or mock pipelines  |
| **Testing** | `pytest`, `pytest-mock`  Unit testing and mocking for pipeline components |
| **Code Quality** | `black`, `flake8`, `isort` | Code formatting, linting, and import sorting |
| **Data Analysis** | `numpy`, `pandas`, `matplotlib` | Analyze, transform, and visualize data in Python |
| **GoogleSheets Integration**|`gspread`, `gspread-dataframe`, `oauth2client`| Interact with GoogleSheets via API |

### ⚙️ docker-compose.yml

A simplified example of your `docker-compose.yml` might look like:

```
services:
  postgres:
    image: postgres:15
    container_name: postgres
    environment:
      POSTGRES_USER: ...
      POSTGRES_PASSWORD: ...
      POSTGRES_DB: ...
    ports:
      - "5432:5432"
    networks:
      - airflow_network

  airflow-webserver:
    build:
      context: .
      dockerfile: Dockerfile.airflow
    container_name: airflow-webserver
    restart: always
    environment:
      AIRFLOW__CORE__EXECUTOR: ...
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: ...
      AIRFLOW__CORE__LOAD_EXAMPLES: ...
    volumes:
      - (add folders in the structure ex:./dags:/opt/airflow/dags)
    ports:
      - "8080:8080"
    depends_on:
      - postgres
    networks:
      - airflow_network
    command: webserver

  airflow-scheduler:
    build:
      context: .
      dockerfile: Dockerfile.airflow
    container_name: airflow-scheduler
    restart: always
    depends_on:
      - postgres
    volumes:
      - (add folders in the structure ex:./dags:/opt/airflow/dags)
    environment:
      AIRFLOW__CORE__EXECUTOR: ...
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: ...
    networks:
      - airflow_network
    command: scheduler

  airflow-init:
    build:
      context: .
      dockerfile: Dockerfile.airflow
    container_name: airflow-init
    depends_on:
      - postgres      
    volumes:
        - (add folders in the structure ex:./dags:/opt/airflow/dags)
    environment:
      AIRFLOW__CORE__EXECUTOR: ...
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: ...
    entrypoint: >
      bash -c "airflow db init &&
               airflow users create --username admin --password admin --firstname User --lastname UserLastName --role Admin --email user@example.com"
    networks:
      - airflow_network

volumes:
  pgdata:

networks:
  airflow_network:

```

### 🌀 Dockerfile.airflow

This file sets up the Airflow environment with Python dependencies and your DBT project.

```
FROM apache/airflow:2.10.0-python3.11

USER root
RUN apt-get update && apt-get install -y build-essential git

USER airflow

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
```

---

## ⚙️ Helper Scripts

To simplify setup and maintenance, the project includes the following Bash scripts:

- `1_init.sh` — Airflow Initialization:

    - This script runs the Airflow initialization process (`airflow db init` and user creation).

- `2_reset_docker.sh'`  — Full Environment Reset:
    
    - Stop all containers

    - Remove volumes and orphans

    - Rebuild and relaunch the environment from scratch

- `3_fix_permissions.sh` — Set Permissions for Mounted Volumes

    - Run this if you encounter permission issues when mounting folders into the Airflow container (especially on Linux).

---

## 🌐 Access the Airflow Web UI

Once the containers are up and the initialization step has been completed, you can access the **Apache Airflow** web interface to monitor, manage, and trigger your DAGs.

### 🔗 Open in your browser

[Localhost:8080](http://localhost:8080)

This URL points to the **Airflow webserver** running inside the Docker container and exposed on your local machine's port `8080`.

### 🔐 Default login credentials

If you used the initialization script (`./1_init.sh`), the following admin user was created automatically:

- **Username:** `admin`  
- **Password:** `admin`