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
└── README.md
```

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

### 🐍 Dockerfile.airflow