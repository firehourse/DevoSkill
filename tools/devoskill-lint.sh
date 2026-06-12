#!/usr/bin/env bash
# DevoSkill lint — mechanized checks for rules that need no model judgment.
# Usage: tools/devoskill-lint.sh [SKILLDOCS_BASE]
#   SKILLDOCS_BASE defaults to <workspace>/docs resolved from config/workspace-map.local.json
#   when present, else ../docs relative to this repo.
# Exit code: number of violation categories that fired (0 = clean).

set -u
DEVOSKILL_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAP="$DEVOSKILL_ROOT/skills/devoskill/config/workspace-map.local.json"

if [ "${1:-}" != "" ]; then
  DOCS="$1"
elif [ -f "$MAP" ]; then
  DOCS="$(grep -o '"skilldocs_base_path"[^,}]*' "$MAP" | head -1 | sed 's/.*: *"\(.*\)"/\1/')"
else
  DOCS="$DEVOSKILL_ROOT/../docs"
fi

if [ ! -d "$DOCS" ]; then
  echo "lint: skilldocs base not found: $DOCS" >&2
  exit 1
fi

fail_categories=0
section() { printf '\n== %s ==\n' "$1"; }
violation() { printf 'VIOLATION  %s\n' "$1"; }

# --- 1. Planning-surface size limit (600 lines per .md) -----------------------
section "Oversized skilldocs files (>600 lines)"
count=0
while IFS= read -r f; do
  lines=$(wc -l < "$f")
  violation "$lines lines  ${f#"$DOCS"/}"
  count=$((count+1))
done < <(find "$DOCS" -name '*.md' -not -path '*/node_modules/*' -print0 \
          | xargs -0 awk 'ENDFILE { if (FNR > 600) print FILENAME }' 2>/dev/null)
echo "total: $count"
[ "$count" -gt 0 ] && fail_categories=$((fail_categories+1))

# --- 2. study/ registry threshold (>10 files requires registry.md) ------------
section "study/ folders over 10 files without registry.md"
count=0
while IFS= read -r d; do
  n=$(find "$d" -maxdepth 1 -name '*.md' ! -name 'registry.md' | wc -l)
  if [ "$n" -gt 10 ] && [ ! -f "$d/registry.md" ]; then
    violation "$n files, no registry.md  ${d#"$DOCS"/}"
    count=$((count+1))
  fi
done < <(find "$DOCS" -type d -name study)
echo "total: $count"
[ "$count" -gt 0 ] && fail_categories=$((fail_categories+1))

# --- 3. PR artifact naming canon (PR.md / PR-<repo>.md only) ------------------
section "Non-canonical PR artifact names"
count=0
while IFS= read -r f; do
  base=$(basename "$f")
  case "$base" in
    PR.md|PR-*.md) ;; # canonical
    *) violation "${f#"$DOCS"/}"; count=$((count+1)) ;;
  esac
done < <(find "$DOCS" -iname 'pr.md' -o -iname 'pr-*.md' -o -iname 'pull-request*.md')
echo "total: $count"
[ "$count" -gt 0 ] && fail_categories=$((fail_categories+1))

# --- 4. Stream shape: stream subfolders must not carry architecture.md --------
section "Stream subfolders carrying architecture.md (authority clone)"
count=0
while IFS= read -r f; do
  d=$(dirname "$f")
  parent=$(dirname "$d")
  if [ -f "$d/task.md" ] && [ -f "$parent/architecture.md" ] && [ "$parent" != "$DOCS" ]; then
    violation "${f#"$DOCS"/}"
    count=$((count+1))
  fi
done < <(find "$DOCS" -mindepth 4 -maxdepth 4 -name architecture.md)
echo "total: $count"
[ "$count" -gt 0 ] && fail_categories=$((fail_categories+1))

# --- 5. Legacy twin folders (metric, not a violation; migration debt) ---------
section "Legacy sibling twin folders (metric)"
twin=$(find "$DOCS" -mindepth 2 -maxdepth 2 -type d -name '*-integration-testing' | wc -l)
echo "total: $twin (migrate under legacy-migration.md when reopened)"

# --- 6. CJK prose in DevoSkill skill files (allowlisted exceptions) ------------
section "CJK content in skill files outside allowlist"
ALLOW='registry.md$|quality-comments.md$|engineering-standards.md$'
# Downstream skill repos may extend the allowlist for verbatim-evidence files:
[ -n "${DEVOSKILL_LINT_CJK_ALLOW:-}" ] && ALLOW="$ALLOW|$DEVOSKILL_LINT_CJK_ALLOW"
count=0
while IFS= read -r f; do
  rel=${f#"$DEVOSKILL_ROOT"/}
  if ! echo "$rel" | grep -qE "$ALLOW"; then
    violation "$rel"
    count=$((count+1))
  fi
done < <(grep -rlP '[\x{4e00}-\x{9fff}]' "$DEVOSKILL_ROOT/skills" 2>/dev/null)
echo "total: $count"
[ "$count" -gt 0 ] && fail_categories=$((fail_categories+1))

# --- Summary -------------------------------------------------------------------
section "Summary"
echo "violation categories fired: $fail_categories"
exit "$fail_categories"
