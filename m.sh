#!/bin/bash

COPY_TO_CLIPBOARD=false
PATH_ARG=""

for arg in "$@"; do
    if [ "$arg" == "-c" ]; then
        COPY_TO_CLIPBOARD=true
    else
        PATH_ARG="$arg"
    fi
done

if [ -z "$PATH_ARG" ]; then
    echo "Usage: ./m.sh <path> [-c]"
    exit 1
fi

python scripts/merge_contents.py "$PATH_ARG"

if [ "$COPY_TO_CLIPBOARD" = true ]; then
    TARGET=$(basename "$PATH_ARG")
    OUTPUT_FILE="scripts/outputs/${TARGET}.txt"

    if [ -f "$OUTPUT_FILE" ]; then
        if command -v pbcopy >/dev/null; then
            cat "$OUTPUT_FILE" | pbcopy
            echo "📋 Contents of $OUTPUT_FILE copied to clipboard (macOS)."
        elif command -v xclip >/dev/null; then
            cat "$OUTPUT_FILE" | xclip -selection clipboard
            echo "📋 Contents of $OUTPUT_FILE copied to clipboard (Linux)."
        elif command -v clip.exe >/dev/null; then
            cat "$OUTPUT_FILE" | clip.exe
            echo "📋 Contents of $OUTPUT_FILE copied to clipboard (Windows)."
        else
            echo "❌ Error: No clipboard tool found (pbcopy, xclip, or clip.exe)."
        fi
    else
        echo "⚠️  Warning: Expected file $OUTPUT_FILE not found. Nothing copied."
    fi
fi
