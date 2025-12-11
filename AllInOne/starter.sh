#!/usr/bin/env bash
set -e

# Make sure to give permissions to execute this script: chmod +x starter.sh
# ----------------------------------


# ---- Start AllInOne Docker Stack -----
echo "Starting AllInOne Docker stack..."

# Run docker compose up -d and wait until it fully completes
if docker compose up -d; then
    echo "Docker Compose completed successfully."
    echo "   All containers are now pulled, created, started, and healthy."

else
    echo "ERROR: Docker Compose failed to start all services."
    exit 1
    
fi

# ---- Implement Funnel Setup ----

cd ..
echo "Continuing with Funnel setup..."

# Giving permissions and executing `funnel.sh`
FUNNEL_SCRIPT="./AllInOne/scripts/funnel.sh"
chmod +x "$FUNNEL_SCRIPT"
"$FUNNEL_SCRIPT"