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

## 📂 Project Structure

```
├── dags/
│   └── dag.py
├── dbt_project/
│   ├── models/
│   │   ├── marts/
│   │   ├── schema.sql
│   │   └── staging/
│   │       ├── orders.sql
│   │       ├── products.sql
│   │       └── users.sql
│   ├── dbt_project.yml
│   └── profiles.yml
├── files/
├── scripts/
│   └── extract/
│       └── extract_users.py
├── 1_init.sh
├── 2_reset_docker.sh
├── 3_fix_permissions.sh
├── docker-compose.yml
├── Dockerfile.airflow
├── LICENSE
├── README.md
└── requirements.txt
```

---

## 🛠 Requirements

Make sure you have the following installed:

- Python 3.10+
- Docker & Docker Compose
- DBT (`dbt-core`, `dbt-postgres`)
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