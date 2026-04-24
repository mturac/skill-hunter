#!/usr/bin/env bash
# Skill Hunter installer — auto-installs the skill into the right runtime.
#
# Usage:
#   ./install.sh <target> [--dir <path>] [--force]
#
# Targets:
#   claude        Install as user-wide Claude Code skill (~/.claude/skills/skill_hunter/SKILL.md)
#   claude-md     Write/append CLAUDE.md in the current (or --dir) project
#   openclaw      Install as OpenClaw skill (~/.openclaw/skills/skill_hunter/SKILL.md)
#   hermes        Install as Hermes skill (~/.hermes/skills/utility/skill_hunter/SKILL.md)
#   codex         Write/append AGENTS.md in the current (or --dir) project
#   cursor        Write .cursor/rules/skill-hunter.md in the current (or --dir) project
#   all           Install everywhere above that is applicable to this machine
#
# All three of claude/openclaw/hermes use the agentskills.io SKILL.md standard,
# so the same SKILL.md is copied verbatim.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-}"
DIR="$PWD"
FORCE=0

shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir) DIR="$2"; shift 2 ;;
    --force) FORCE=1; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 2 ;;
  esac
done

usage() { sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
[[ -z "$TARGET" ]] && usage

install_skill() {
  local runtime="$1" dest_dir="$2"
  mkdir -p "$dest_dir"
  if [[ -f "$dest_dir/SKILL.md" && $FORCE -eq 0 ]]; then
    echo "[$runtime] exists — skipping (use --force to overwrite): $dest_dir/SKILL.md"
    return 0
  fi
  cp "$REPO_DIR/SKILL.md" "$dest_dir/SKILL.md"
  echo "[$runtime] installed → $dest_dir/SKILL.md"
}

install_md() {
  local name="$1" filename="$2" src="$3"
  local dest="$DIR/$filename"
  if [[ -f "$dest" ]]; then
    if grep -q "BEGIN skill-hunter" "$dest" 2>/dev/null; then
      echo "[$name] already contains skill-hunter block — skipping: $dest"
      return 0
    fi
    echo "" >> "$dest"
    cat "$src" >> "$dest"
    echo "[$name] appended to existing $dest"
  else
    cp "$src" "$dest"
    echo "[$name] wrote $dest"
  fi
}

do_claude()    { install_skill "claude"   "$HOME/.claude/skills/skill_hunter"; }
do_openclaw()  { install_skill "openclaw" "$HOME/.openclaw/skills/skill_hunter"; }
do_hermes()    { install_skill "hermes"   "$HOME/.hermes/skills/utility/skill_hunter"; }
do_claude_md() { install_md "claude-md" "CLAUDE.md" "$REPO_DIR/adapters/claude-code/CLAUDE.md"; }
do_codex()     { install_md "codex"     "AGENTS.md" "$REPO_DIR/adapters/codex/AGENTS.md"; }
do_cursor()    {
  mkdir -p "$DIR/.cursor/rules"
  cp "$REPO_DIR/adapters/cursor/skill-hunter.md" "$DIR/.cursor/rules/skill-hunter.md"
  echo "[cursor] wrote $DIR/.cursor/rules/skill-hunter.md"
}

case "$TARGET" in
  claude)    do_claude ;;
  claude-md) do_claude_md ;;
  openclaw)  do_openclaw ;;
  hermes)    do_hermes ;;
  codex)     do_codex ;;
  cursor)    do_cursor ;;
  all)
    do_claude
    do_openclaw
    do_hermes
    echo "(skipping claude-md/codex/cursor — those are per-project; run them in the project dir)"
    ;;
  *) echo "Unknown target: $TARGET" >&2; usage ;;
esac
