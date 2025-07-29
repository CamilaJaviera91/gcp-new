# 🌀 Airflow + DBT + PostgreSQL Data Pipeline

This repository implements a modern, modular data pipeline using:

- Apache Airflow for orchestration

- DBT for SQL-based transformations

- PostgreSQL as both the source/target database and metadata store

> 💡 Ideal for learning, development, and lightweight data integration projects.

---

## 🚀 Getting Started

Before running the pipeline, make sure to create the following folders in the root directory of the project:

```
.
├── dags/               # Airflow DAG definitions
├── dbt_project/        # DBT transformations and config
│   └── models/
│       ├── staging/    # Raw → Staging transformations
│       └── marts/      # Staging → Marts (analytics-ready)
├── files/              # CSVs, exports, mock datasets
├── scripts/            # Python utilities for extract/load/validation
│   ├── extract/
│   ├── load/
│   └── utils/
```

- `dags/`: Contains Airflow DAGs to orchestrate the pipeline.
- `dbt_project/`: Contains the DBT project with all SQL transformation models.
  - `dbt_project/models`
    - `dbt_project/models/staging/`: Contains staging models for cleaning and preparing raw data.
    - `dbt_project/models/marts/`: Contains data marts for final models ready for analysis and reporting.
- `files/`: Stores input/output files such as CSVs.
- `scripts/`: Includes helper scripts for data extraction, validation, and loading.
---

## 🛠️ Prerequisites

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

| Service               | Description                                    |
| --------------------- | ---------------------------------------------- |
| **PostgreSQL**        | Stores raw/transformed data & Airflow metadata |
| **Airflow Webserver** | UI to manage DAGs                              |
| **Airflow Scheduler** | Triggers DAG tasks based on time or sensors    |
| **Airflow Init**      | Initializes metadata DB, creates user          |

> Make sure the previous structure exists before launching the containers:

---

## ⚙️ .env Configuration

Create a .env file with the following (sample):

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

---

## 📦 Python Dependencies

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

### 🛠️ Docker Compose Setup

Sample docker-compose.yml setup is included in the repo and features:

- PostgreSQL with persistent volume

- Airflow Webserver, Scheduler, Init

- Custom Dockerfile for Airflow + DBT + Python deps

> ✅ Make sure volumes: in each service are properly mapped to ./dags, ./scripts, etc.

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

> 💡 You can customize these credentials by modifying the `airflow users create` command inside the `airflow-init` service or the `1_init.sh` script.

### 🖥️ What you’ll see

After logging in, you’ll be able to:

- View all DAGs in the `dags/` folder
- Trigger DAGs manually or wait for scheduled runs
- Monitor task statuses and inspect logs
- Manage Airflow Connections, Variables, and Pools
- Access admin configurations and user management

Airflow automatically refreshes the DAG list every ~30 seconds. If your DAGs don’t show up:

- Ensure the `.py` files in `dags/` define at least one valid `DAG` object
- Check container logs with `docker compose logs -f airflow-webserver`

---