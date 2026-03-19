#!/bin/bash
set -euo pipefail

SKILL_NAME="${1:-}"
PROMPT_FILE="${2:-}"
MAX_TURNS="${3:-3}"

if [ -z "$SKILL_NAME" ] || [ -z "$PROMPT_FILE" ]; then
    echo "Usage: $0 <skill-name> <prompt-file> [max-turns]"
    exit 1
fi

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUTPUT_DIR="/tmp/devoskill-tests/$(date +%s)/${SKILL_NAME}"
LOG_FILE="$OUTPUT_DIR/output.json"

mkdir -p "$OUTPUT_DIR"
cp "$PROMPT_FILE" "$OUTPUT_DIR/prompt.txt"

timeout 300 claude -p "$(cat "$PROMPT_FILE")" \
    --plugin-dir "$PLUGIN_DIR" \
    --dangerously-skip-permissions \
    --max-turns "$MAX_TURNS" \
    --output-format stream-json \
    > "$LOG_FILE" 2>&1 || true

SKILL_PATTERN='"skill":"([^"]*:)?'"${SKILL_NAME}"'"'

if grep -q '"name":"Skill"' "$LOG_FILE" && grep -qE "$SKILL_PATTERN" "$LOG_FILE"; then
    echo "PASS: $SKILL_NAME"
    exit 0
fi

echo "FAIL: $SKILL_NAME"
echo "Log: $LOG_FILE"
exit 1
