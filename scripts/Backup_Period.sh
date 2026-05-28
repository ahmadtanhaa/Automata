#!/usr/bin/env bash
#
# Backup_Period.sh
#
# Purpose:
#   Apply backup retention policies by deleting old backup directories
#   from test and live backup locations.
#
# Notes:
#   - Sanitized version for public portfolio use.
#   - Test backups are kept for TEST_RETENTION_DAYS.
#   - Live backups are kept for LIVE_RETENTION_DAYS.
#   - Review paths carefully before running this script.
#
# License:
#   Apache License 2.0

set -euo pipefail

# -----------------------------
# Configuration
# -----------------------------

BACKUP_ROOT="${BACKUP_ROOT:-/var/log/db_backup}"

TEST_MONGO_DIR="${TEST_MONGO_DIR:-${BACKUP_ROOT}/Test/Mongodb}"
TEST_MYSQL_DIR="${TEST_MYSQL_DIR:-${BACKUP_ROOT}/Test/Mysql}"

LIVE_MONGO_DIR="${LIVE_MONGO_DIR:-${BACKUP_ROOT}/Live/Mongodb}"
LIVE_MYSQL_DIR="${LIVE_MYSQL_DIR:-${BACKUP_ROOT}/Live/Mysql}"

TEST_RETENTION_DAYS="${TEST_RETENTION_DAYS:-6}"
LIVE_RETENTION_DAYS="${LIVE_RETENTION_DAYS:-13}"

# -----------------------------
# Helper functions
# -----------------------------

log() {
  echo "[$(date +%Y-%m-%d_%H:%M:%S)] $*"
}

cleanup_old_backups() {
  local target_dir="$1"
  local name_pattern="$2"
  local retention_days="$3"

  if [[ ! -d "$target_dir" ]]; then
    log "Skipping missing directory: $target_dir"
    return 0
  fi

  log "Removing backups older than ${retention_days} days from: $target_dir"

  find "$target_dir" \
    -mindepth 1 \
    -maxdepth 1 \
    -type d \
    -name "$name_pattern" \
    -mtime +"$retention_days" \
    -exec rm -rf {} +
}

# -----------------------------
# Retention policy
# -----------------------------

log "Starting backup retention cleanup..."

# Test/staging backups
cleanup_old_backups "$TEST_MONGO_DIR" "All_Mongodb*" "$TEST_RETENTION_DAYS"
cleanup_old_backups "$TEST_MYSQL_DIR" "All_Mysql*" "$TEST_RETENTION_DAYS"

# Live backups
cleanup_old_backups "$LIVE_MONGO_DIR" "All_Mongodb*" "$LIVE_RETENTION_DAYS"
cleanup_old_backups "$LIVE_MYSQL_DIR" "All_Mysql*" "$LIVE_RETENTION_DAYS"

log "Backup retention cleanup completed successfully."
