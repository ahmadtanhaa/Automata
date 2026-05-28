#!/usr/bin/env bash
#
# spaceremover.sh
#
# Purpose:
#   Remove spaces, tabs, newlines, and carriage returns from files
#   in a target directory and write compacted outputs as .json files.
#
# Notes:
#   - Sanitized version for public portfolio use.
#   - Existing .json files are skipped by default.
#   - Original files are removed only after successful conversion.
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
# Remove whitespace
# -----------------------------

log "Removing whitespace from files in: $TARGET_DIR"

for file in "$TARGET_DIR"/*; do
  [[ -f "$file" ]] || continue

  if [[ "$file" == *.json ]]; then
    log "Skipping already-json file: $file"
    continue
  fi

  output_file="${file}.json"

  if [[ -e "$output_file" ]]; then
    log "Skipping because output already exists: $output_file"
    continue
  fi

  tr -d ' \t\n\r' < "$file" > "$output_file"

  rm -f "$file"

  log "Created compacted JSON file: $output_file"
done

log "Whitespace removal completed successfully."
