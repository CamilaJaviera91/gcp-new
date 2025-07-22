#!/bin/bash
echo "🧹 Cleaning the entire environment..."
docker compose down --volumes --remove-orphans

echo "⏹️ Stopping services..."
docker volume prune -f
docker container prune

echo "🔧 Building images..."
docker compose build

echo "▶️ Starting services..."
docker compose up -d

echo "Services are up"
docker ps

# 1. Make sure to give execute permissions: chmod +x 2_reset_docker.sh
# 2. Run the script: ./2_reset_docker.sh