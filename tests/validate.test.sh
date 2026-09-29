#!/bin/sh
# Runs validate.sh against a good fixture and against one broken fixture per rule.
HERE=$(cd "$(dirname "$0")" && pwd)
VALIDATE="$HERE/../scripts/validate.sh"
pass=0
failed=0
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

make_good() {
    d=$1
    rm -rf "$d"
    mkdir -p "$d/references"
    cat > "$d/SKILL.md" <<'EOM'
---
name: api-gateway
description: test
allowed-tools: Bash
---
# Test
See [the index](references/README.md) and [Slack](references/slack.md).
EOM
    printf '# References\n- [slack](slack.md)\n' > "$d/references/README.md"
    cat > "$d/references/slack.md" <<'EOM'
# Slack
Last checked: never

## App key
slack

## Reads
none

## Writes and risks
none

## Notes
none
EOM
}

# expect NAME DIR WANTED_EXIT [PATTERN]
expect() {
    out=$("$VALIDATE" "$2" 2>&1)
    code=$?
    if [ "$code" -eq "$3" ] && { [ -z "${4:-}" ] || printf '%s' "$out" | grep -q "$4"; }; then
        pass=$((pass + 1))
        echo "ok   $1"
    else
        failed=$((failed + 1))
        echo "FAIL $1 (exit $code, wanted $3)"
        printf '%s\n' "$out" | sed 's/^/     /'
    fi
}

D="$TMP/t"

make_good "$D"; expect "a good tree passes" "$D" 0 "OK: skill structure is valid"

make_good "$D"; sed -i.bak '1d' "$D/SKILL.md"; expect "missing frontmatter" "$D" 1 "must start with"
make_good "$D"; sed -i.bak '/^allowed-tools:/d' "$D/SKILL.md"; expect "missing allowed-tools" "$D" 1 "allowed-tools"
make_good "$D"; i=0; while [ $i -lt 400 ]; do echo "line $i" >> "$D/SKILL.md"; i=$((i + 1)); done; expect "SKILL.md too long" "$D" 1 "lines"
make_good "$D"; echo '[gone](references/nope.md)' >> "$D/SKILL.md"; expect "broken link in SKILL.md" "$D" 1 "broken links"
make_good "$D"; echo '[gone](nope.md)' >> "$D/references/README.md"; expect "broken link in the index" "$D" 1 "broken links"
make_good "$D"; cp "$D/references/slack.md" "$D/references/stray.md"; expect "orphan reference" "$D" 1 "stray.md is not listed"
make_good "$D"; sed -i.bak '/^## Reads$/d' "$D/references/slack.md"; expect "missing heading" "$D" 1 "## Reads"
make_good "$D"; sed -i.bak '/^Last checked:/d' "$D/references/slack.md"; expect "missing Last checked" "$D" 1 "Last checked"
make_good "$D"; printf 'key: daho_live_%s\n' "$(printf 'A%.0s' $(seq 1 43))" >> "$D/references/slack.md"; expect "key-shaped secret" "$D" 1 "DAHO API key"
make_good "$D"; printf 'daho_live_...\n' >> "$D/references/slack.md"; expect "the ellipsis placeholder is allowed" "$D" 0

make_good "$D"; mkdir -p "$D/plugins/api-gateway/skills/api-gateway"; cp -R "$D/SKILL.md" "$D/references" "$D/plugins/api-gateway/skills/api-gateway/"
expect "an identical plugin copy passes" "$D" 0
echo "extra" >> "$D/SKILL.md"; expect "plugin SKILL.md drift" "$D" 1 "differs from SKILL.md"
make_good "$D"; mkdir -p "$D/plugins/api-gateway/skills/api-gateway"; cp -R "$D/SKILL.md" "$D/references" "$D/plugins/api-gateway/skills/api-gateway/"
echo "extra" >> "$D/references/slack.md"; expect "plugin references drift" "$D" 1 "references differ"

# a real-looking key must be caught even under tests/ (the exclusion was a bypass)
make_good "$D"; mkdir -p "$D/tests"; printf 'daho_live_%s\n' "$(printf 'B%.0s' $(seq 1 43))" > "$D/tests/leak.txt"; expect "key-shaped secret under tests/" "$D" 1 "DAHO API key"

# a plugin marketplace with no plugin copy must fail, not pass silently
make_good "$D"; mkdir -p "$D/.claude-plugin"; echo '{}' > "$D/.claude-plugin/marketplace.json"; expect "marketplace without a plugin copy" "$D" 1 "copy is missing"

# other common secret shapes are caught too, but short placeholders are not
make_good "$D"; printf 'k: sk_live_%s\n' "$(printf 'a%.0s' $(seq 1 24))" >> "$D/references/slack.md"; expect "a Stripe-style live key" "$D" 1 "secret"
make_good "$D"; printf 'k: re_%s\n' "$(printf 'b%.0s' $(seq 1 30))" >> "$D/references/slack.md"; expect "a Resend-style key" "$D" 1 "secret"
make_good "$D"; printf 'k: ghp_%s\n' "$(printf 'c%.0s' $(seq 1 36))" >> "$D/references/slack.md"; expect "a GitHub token" "$D" 1 "secret"
make_good "$D"; printf 'use sk_live_... or re_... or sk-... as placeholders\n' >> "$D/references/slack.md"; expect "short placeholders are allowed" "$D" 0

# links are checked in every guide and in the top-level README, not just SKILL.md and the index
make_good "$D"; echo '[gone](nope.md)' >> "$D/references/slack.md"; expect "broken link inside a guide" "$D" 1 "broken links"
make_good "$D"; echo '[gone](docs/nope.md)' > "$D/README.md"; expect "broken link in the top-level README" "$D" 1 "broken links"

# an empty references/ folder must give the one clear error, not noise from an unmatched glob
make_good "$D"; rm -f "$D/references/README.md" "$D/references/slack.md"
out=$("$VALIDATE" "$D" 2>&1); code=$?
if [ "$code" -eq 1 ] && printf '%s' "$out" | grep -q "the index) is missing" && ! printf '%s' "$out" | grep -q 'references/\*\.md'; then
    pass=$((pass + 1)); echo "ok   empty references folder gives one clear error"
else
    failed=$((failed + 1)); echo "FAIL empty references folder gives one clear error (exit $code)"; printf '%s\n' "$out" | sed 's/^/     /'
fi

echo
echo "$pass passed, $failed failed"
[ "$failed" -eq 0 ]
