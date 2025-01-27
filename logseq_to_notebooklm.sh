#!/bin/bash

# LogSeq to NotebookLM Migration Script
# Purpose: Converts LogSeq markdown files into a single file for NotebookLM import
# Usage: ./logseq_to_notebooklm.sh [path_to_logseq_directory]
# Note: Can also be configured via LOGSEQ_DIR environment variable

# Exit on any error
set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration variables
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TEMP_DIR="/tmp/logseq_migration_${TIMESTAMP}"
BACKUP_DIR="${HOME}/Documents/logseq_backups/backup_${TIMESTAMP}"
OUTPUT_FILE="notebooklm_import_${TIMESTAMP}.md"

# Function to display error messages and exit
error_exit() {
  echo -e "${RED}Error: $1${NC}" >&2
  cleanup
  exit 1
}

# Function to display progress messages
progress() {
  echo -e "${GREEN}$1${NC}"
}

# Function for warning messages
warning() {
  echo -e "${YELLOW}Warning: $1${NC}"
}

# Cleanup function
cleanup() {
  if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
    progress "Cleaned up temporary files"
  fi
}

# Trap cleanup function on script exit
trap cleanup EXIT

# Determine LogSeq directory from argument or environment variable
if [ "$#" -eq 1 ]; then
  LOGSEQ_DIR="$1"
elif [ -n "$LOGSEQ_DIR" ]; then
  warning "Using LOGSEQ_DIR from environment variable: $LOGSEQ_DIR"
else
  error_exit "No LogSeq directory specified. Either provide as argument or set LOGSEQ_DIR environment variable\nUsage: $0 [path_to_logseq_directory]"
fi

# Validate input directory
if [ ! -d "$LOGSEQ_DIR" ]; then
  error_exit "LogSeq directory does not exist: $LOGSEQ_DIR"
fi

# Validate required subdirectories
if [ ! -d "$LOGSEQ_DIR/journals" ] || [ ! -d "$LOGSEQ_DIR/pages" ]; then
  error_exit "Invalid LogSeq directory structure. Missing journals or pages directory."
fi

# Create backup
progress "Creating backup..."
mkdir -p "$BACKUP_DIR" || error_exit "Failed to create backup directory"
cp -R "$LOGSEQ_DIR" "$BACKUP_DIR" || error_exit "Failed to create backup"
progress "Backup created at: $BACKUP_DIR"

# Create temporary working directory
progress "Setting up temporary workspace..."
mkdir -p "$TEMP_DIR" || error_exit "Failed to create temporary directory"

# Copy files to temporary directory
progress "Copying files..."
cp -R "$LOGSEQ_DIR/journals" "$TEMP_DIR/" || error_exit "Failed to copy journals"
cp -R "$LOGSEQ_DIR/pages" "$TEMP_DIR/" || error_exit "Failed to copy pages"

# Process markdown files
progress "Processing markdown files..."
{
  echo "# LogSeq Export - Created on $(date)"
  echo "---"
  echo

  # Process journals first
  if [ -d "$TEMP_DIR/journals" ]; then
    echo "## Journals"
    echo
    find "$TEMP_DIR/journals" -name "*.md" -type f | sort | while read -r file; do
      echo "### $(basename "$file" .md)"
      echo
      cat "$file"
      echo
      echo "---"
      echo
    done
  fi

  # Process pages
  if [ -d "$TEMP_DIR/pages" ]; then
    echo "## Pages"
    echo
    find "$TEMP_DIR/pages" -name "*.md" -type f | sort | while read -r file; do
      echo "### $(basename "$file" .md)"
      echo
      cat "$file"
      echo
      echo "---"
      echo
    done
  fi
} >"$OUTPUT_FILE"

# Validate output file
if [ ! -s "$OUTPUT_FILE" ]; then
  error_exit "Output file is empty. Migration failed."
fi

# Calculate statistics
TOTAL_FILES=$(find "$TEMP_DIR" -name "*.md" -type f | wc -l)
OUTPUT_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)

# Success message
progress "Migration completed successfully!"
echo "Statistics:"
echo "- Total files processed: $TOTAL_FILES"
echo "- Output file size: $OUTPUT_SIZE"
echo "- Output file location: $(pwd)/$OUTPUT_FILE"
echo "- Backup location: $BACKUP_DIR"

exit 0
