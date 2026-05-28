#!/usr/bin/env bash
#
# Backup_Test.sh
#
# Purpose:
#   Create timestamped MongoDB and MySQL backups for a test/staging environment,
#   synchronize them with a remote backup server, and clean local temporary backups.
#
# Notes:
#   - Sanitized version for public portfolio use.
#   - Replace placeholders before real deployment.
#
# License:
#   Apache License 2.0

set -euo pipefail

# -----------------------------
# Configuration
# -----------------------------

TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"

LOCAL_BACKUP_ROOT="${LOCAL_BACKUP_ROOT:-/var/log/db_backup}"
MONGO_BACKUP_DIR="${LOCAL_BACKUP_ROOT}/Mongodb"
MYSQL_BACKUP_DIR="${LOCAL_BACKUP_ROOT}/Mysql"

REMOTE_USER="${REMOTE_USER:-backup_user}"
REMOTE_HOST="${REMOTE_HOST:-backup.example.com}"
REMOTE_TEST_MONGO_DIR="${REMOTE_TEST_MONGO_DIR:-/var/log/db_backup/Test/Mongodb}"
REMOTE_TEST_MYSQL_DIR="${REMOTE_TEST_MYSQL_DIR:-/var/log/db_backup/Test/Mysql}"

MONGO_USER="${MONGO_USER:-your_mongo_user}"
MONGO_PASSWORD="${MONGO_PASSWORD:-your_mongo_password}"

MYSQL_USER="${MYSQL_USER:-your_mysql_user}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-your_mysql_password}"

MYSQL_DATABASES=(
  "service_db_1"
  "service_db_2"
  "payment_db"
  "reporting_db"
  "scheduler_db"
  "lending_db"
  "quartz_db"
  "sales_db"
  "test_db"
)

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

require_command mongodump
require_command mysqldump
require_command rsync

mkdir -p "$MONGO_BACKUP_DIR"
mkdir -p "$MYSQL_BACKUP_DIR"

# -----------------------------
# MongoDB backup
# -----------------------------

log "Starting MongoDB test backup..."

MONGO_OUTPUT_DIR="${MONGO_BACKUP_DIR}/All_Mongodb_${TIMESTAMP}"

mongodump \
  -u "$MONGO_USER" \
  -p "$MONGO_PASSWORD" \
  --out="$MONGO_OUTPUT_DIR"

log "MongoDB backup created at: $MONGO_OUTPUT_DIR"

log "Synchronizing MongoDB backup to remote test backup location..."

rsync -avz \
  "$MONGO_OUTPUT_DIR" \
  "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_TEST_MONGO_DIR}/"

log "MongoDB backup synchronized successfully."

# -----------------------------
# MySQL backup
# -----------------------------

log "Starting MySQL test backup..."

MYSQL_OUTPUT_DIR="${MYSQL_BACKUP_DIR}/All_Mysql_${TIMESTAMP}"
mkdir -p "$MYSQL_OUTPUT_DIR"

for DB_NAME in "${MYSQL_DATABASES[@]}"; do
  log "Backing up MySQL database: $DB_NAME"

  mysqldump \
    -u "$MYSQL_USER" \
    -p"$MYSQL_PASSWORD" \
    "$DB_NAME" > "${MYSQL_OUTPUT_DIR}/${DB_NAME}-${TIMESTAMP}.sql"
done

log "MySQL backups created at: $MYSQL_OUTPUT_DIR"

log "Synchronizing MySQL backups to remote test backup location..."

rsync -avz \
  "$MYSQL_OUTPUT_DIR" \
  "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_TEST_MYSQL_DIR}/"

log "MySQL backups synchronized successfully."

# -----------------------------
# Local cleanup
# -----------------------------

log "Cleaning local temporary backup directories..."

find "$MONGO_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -name 'All_Mongodb*' -exec rm -rf {} +
find "$MYSQL_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -name 'All_Mysql*' -exec rm -rf {} +

log "Test backup process completed successfully."
