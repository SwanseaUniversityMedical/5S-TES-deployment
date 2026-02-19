#!/usr/bin/env bash
set -euo pipefail

echo "Validating merged Compose config (includes all manifests)..."
docker compose -f docker-compose.yml config >/dev/null
echo "✅ Compose config is valid."


# ----- Purpose ------

# This script validates the structural correctness of the entire
# Docker Compose stack before running or deploying it.
#
# It helps developers quickly confirm that:
#   • All compose YAML files are syntactically valid
#   • Included manifests are resolved correctly
#   • Environment variables from .env are substituted
#   • Networks, volumes, and configs are defined properly
#   • The final merged Docker Compose configuration is valid

# ----- When to use -----

# Run this script before:
#   • executing `docker compose up`
#   • deploying to any environment


# ----- Note ------
# This script runs ONLY if validation succeeded (configuration-level only).

# ----- It does NOT verify -----
#   • containers successfully start
#   • images can be pulled from registries
#   • ports are free on the host machine
#   • services become healthy at runtime
#   • application-level errors
#
# If this script passes, the compose structure is valid.
# Any later failure will be a runtime issue, not a config issue.