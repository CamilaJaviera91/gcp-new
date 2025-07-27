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