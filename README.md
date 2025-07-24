# 🚀 GCP-New

**gcp-new** is a template/repository featuring Google Cloud Platform projects, scripts, and infrastructure-as-code for quick and easy deployment and experimentation.

---

## 🎯 Overview
- **Purpose**: Briefly codify the mission or main function of the repo (e.g., deploying Cloud Run services, automating GCP infra with Terraform, etc.).
- **Use cases**: Who is this for and in what scenarios—tutorial, POC, CI/CD demo, etc.

---

## 📂 Project Structure

├── dags/
│   └── dag.py
├── dbt_project/
│   ├── models/
│   │   ├── marts/
│   │   ├── schema.sql
│   │   └── staging/
│   │       └── users.sql
│   ├── dbt_project.yml
│   └── profiles.yml
├── files/
├── scripts/
├── 1_init.sh
├── 2_reset_docker.sh
├── 3_fix_permissions.sh
├── docker-compose.yml
├── Dockerfile.airflow
├── LICENSE
├── README.md
└── requirements.txt
