#!/bin/bash
# loc.sh - A script to run add_localizations.py

# Get the path to the 'scripts' directory relative to this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)/scripts"

# Check if the scripts directory exists
if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Error: scripts directory not found at $SCRIPT_DIR"
    exit 1
fi

# Run the add_localizations.py script with the provided arguments
python3 "$SCRIPT_DIR/add_localizations.py" "$@"
