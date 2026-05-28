#!/usr/bin/env bash
#
# post2elk.sh
#
# Purpose:
#   Post JSON files from a local directory to an Elasticsearch index.
#
# Notes:
#   - Sanitized version for public portfolio use.
#   - Replace ELASTICSEARCH_URL and INDEX_NAME before use.
#   - For secured clusters, add authentication carefully.
#
# License:
#   Apache License 2.0

set -euo pipefail

# -----------------------------
# Configuration
# -----------------------------

JSON_DIR="${JSON_DIR:-$HOME/test-jsons}"
ELASTICSEARCH_URL="${ELASTICSEARCH_URL:-http://localhost:9200}"
INDEX_NAME="${INDEX_NAME:-test-index}"

# Optional authentication.
# Example:
#   export ELASTIC_USER="elastic"
#   export ELASTIC_PASSWORD="your_password"
ELASTIC_USER="${ELASTIC_USER:-}"
ELASTIC_PASSWORD="${ELASTIC_PASSWORD:-}"

# -----------------------------
# Helper functions
# -----------------------------

log() {
  echo "[$(date +%Y-%m-%d_%H:%M:%S)] $*"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: required command '$1' is not installed or not available in PATH." >&2
    exit 1
  fi
}

# -----------------------------
# Pre-checks
# -----------------------------

require_command curl

if [[ ! -d "$JSON_DIR" ]]; then
  echo "Error: JSON directory does not exist: $JSON_DIR" >&2
  exit 1
fi

shopt -s nullglob
JSON_FILES=("$JSON_DIR"/*.json)

if [[ ${#JSON_FILES[@]} -eq 0 ]]; then
  log "No JSON files found in: $JSON_DIR"
  exit 0
fi

# -----------------------------
# Post JSON files
# -----------------------------

log "Posting JSON files from '$JSON_DIR' to '${ELASTICSEARCH_URL}/${INDEX_NAME}/_doc'..."

for jf in "${JSON_FILES[@]}"; do
  log "Posting file: $jf"

  if [[ -n "$ELASTIC_USER" && -n "$ELASTIC_PASSWORD" ]]; then
    curl -sS \
      -u "${ELASTIC_USER}:${ELASTIC_PASSWORD}" \
      -H "Content-Type: application/json" \
      -X POST "${ELASTICSEARCH_URL}/${INDEX_NAME}/_doc" \
      --data-binary @"$jf"
  else
    curl -sS \
      -H "Content-Type: application/json" \
      -X POST "${ELASTICSEARCH_URL}/${INDEX_NAME}/_doc" \
      --data-binary @"$jf"
  fi

  echo
done

log "JSON ingestion completed successfully."
