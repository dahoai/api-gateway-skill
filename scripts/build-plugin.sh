#!/bin/sh
# Regenerates the Claude Code plugin's copy of the skill from the single source of truth (SKILL.md + references/).
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
DEST="$ROOT/plugins/api-gateway/skills/api-gateway"
rm -rf "$DEST"
mkdir -p "$DEST"
cp "$ROOT/SKILL.md" "$DEST/SKILL.md"
cp -R "$ROOT/references" "$DEST/references"
echo "plugin copy rebuilt at plugins/api-gateway/skills/api-gateway"
