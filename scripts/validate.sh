#!/bin/sh
# Checks the skill's structure. Usage: scripts/validate.sh [root]   (default: the repo this script lives in)
ROOT=${1:-$(cd "$(dirname "$0")/.." && pwd)}
fail=0
err() {
    echo "FAIL: $*"
    fail=1
}

SKILL="$ROOT/SKILL.md"
if [ ! -f "$SKILL" ]; then
    echo "FAIL: SKILL.md is missing"
    exit 1
fi

# 1. frontmatter
if [ "$(head -n 1 "$SKILL")" != "---" ]; then
    err "SKILL.md must start with '---' frontmatter"
fi
FM=$(awk 'NR==1 && /^---$/ {f=1; next} f && /^---$/ {exit} f {print}' "$SKILL")
for key in name description allowed-tools; do
    printf '%s\n' "$FM" | grep -q "^$key:" || err "frontmatter is missing '$key:'"
done

# 2. the core manual stays compact
LINES=$(wc -l < "$SKILL" | tr -d ' ')
[ "$LINES" -le 350 ] || err "SKILL.md is $LINES lines; keep it under 350 (move detail into references/)"

# 3. relative links resolve
check_links() {
    file=$1
    dir=$(dirname "$file")
    grep -o '](\([^)]*\))' "$file" | sed 's/^](//; s/)$//; s/#.*$//' | grep -v -e '^$' -e '^https\{0,1\}:' -e '^mailto:' | while IFS= read -r target; do
        [ -e "$dir/$target" ] || echo "$file -> $target"
    done
}
BROKEN=$(
    check_links "$SKILL"
    [ -f "$ROOT/references/README.md" ] && check_links "$ROOT/references/README.md"
)
if [ -n "$BROKEN" ]; then
    printf 'FAIL: broken links:\n%s\n' "$BROKEN"
    fail=1
fi

# 4. references: indexed, complete
REFS="$ROOT/references"
if [ -d "$REFS" ]; then
    [ -f "$REFS/README.md" ] || err "references/README.md (the index) is missing"
    for f in "$REFS"/*.md; do
        name=$(basename "$f")
        [ "$name" = README.md ] && continue
        grep -q "($name)" "$REFS/README.md" 2>/dev/null || err "references/$name is not listed in references/README.md"
        for h in '## App key' '## Reads' '## Writes and risks' '## Notes'; do
            grep -q "^$h\$" "$f" || err "references/$name is missing the heading '$h'"
        done
        grep -q '^Last checked:' "$f" || err "references/$name is missing a 'Last checked:' line"
    done
fi

# 5. no key-shaped secrets ('daho_live_...' with three dots is the allowed placeholder)
if grep -rEq 'daho_live_[A-Za-z0-9_-]{43}' "$ROOT" --exclude-dir=.git --exclude-dir=tests; then
    err "a string shaped like a DAHO API key is committed"
fi

# 6. the plugin copy matches the source
COPY="$ROOT/plugins/api-gateway/skills/api-gateway"
if [ -d "$COPY" ]; then
    diff -q "$SKILL" "$COPY/SKILL.md" > /dev/null 2>&1 || err "plugins/api-gateway/skills/api-gateway/SKILL.md differs from SKILL.md (run scripts/build-plugin.sh)"
    if [ -d "$REFS" ]; then
        diff -rq "$REFS" "$COPY/references" > /dev/null 2>&1 || err "plugin references differ from references/ (run scripts/build-plugin.sh)"
    fi
fi

if [ "$fail" -eq 0 ]; then
    echo "OK: skill structure is valid"
else
    exit 1
fi
