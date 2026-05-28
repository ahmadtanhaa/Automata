#!/usr/bin/env bash
#
# rename.sh
#
# Purpose:
#   Append the .json extension to files in a target directory.
#
# Notes:
#   - Sanitized version for public portfolio use.
#   - Existing .json files are skipped.
#   - Existing destination files are not overwritten.
#
# License:
#   Apache License 2.0

set -euo pipefail

# -----------------------------
# Configuration
# -----------------------------

TARGET_DIR="${TARGET_DIR:-$HOME/test-jsons}"

# -----------------------------
# Helper functions
# -----------------------------

log() {
  echo "[$(date +%Y-%m-%d_%H:%M:%S)] $*"
}

# -----------------------------
# Pre-checks
# -----------------------------

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

shopt -s nullglob

# -----------------------------
# Rename files
# -----------------------------

log "Appending .json extension to files in: $TARGET_DIR"

for file in "$TARGET_DIR"/*; do
  [[ -f "$file" ]] || continue

  if [[ "$file" == *.json ]]; then
    log "Skipping already-renamed file: $file"
    continue
  fi

  destination="${file}.json"

  if [[ -e "$destination" ]]; then
    log "Skipping because destination already exists: $destination"
    continue
  fi

  mv "$file" "$destination"
  log "Renamed: $file -> $destination"
done

log "Renaming completed successfully."
