#!/bin/bash

set -e

PROJECT_ROOT=$(pwd)
FOLDERS=("dags" "scripts" "dbt_project" "files")

# UID and GID you want to use (airflow user inside the container)
TARGET_UID=50000
TARGET_GID=0   # like the root group that airflow uses

echo "Fixing permissions in project folders for UID:${TARGET_UID}, GID:${TARGET_GID}..."

for folder in "${FOLDERS[@]}"; do
    if [ -d "$PROJECT_ROOT/$folder" ]; then
        echo " - Adjusting ownership and permissions in $folder ..."
        # Change ownership to UID 50000 and GID 0
        sudo chown -R ${TARGET_UID}:${TARGET_GID} "$PROJECT_ROOT/$folder"
        # Permissions: owner read/write, group/others read and execute for directories
        sudo find "$PROJECT_ROOT/$folder" -type d -exec chmod 755 {} \;
        # Permissions: owner read/write, group/others read for files
        sudo find "$PROJECT_ROOT/$folder" -type f -exec chmod 644 {} \;
    else
        echo " - Folder $folder not found, skipping."
    fi
done

echo "Permissions successfully fixed for the airflow user."