#!/bin/bash
echo "🚀 Initializing Airflow..."
docker compose run airflow-init

# 1. Make sure to give execute permissions: chmod +x 1_init.sh
# 2. Run the script: ./1_init.sh
