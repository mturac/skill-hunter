#!/usr/bin/env bash
# Skill Hunter installer — drops the agent spec into the right place for each runtime.
#
# Usage:
#   ./install.sh <target> [--dir <path>]
#
# Targets:
#   claude        Install as CLAUDE.md in the current (or given) project dir
#   claude-skill  Install as ~/.claude/skills/skill-hunter/SKILL.md (user-wide)
#   codex         Install as AGENTS.md in the current (or given) project dir
#   cursor        Install as .cursor/rules/skill-hunter.md
#   openclaw      Copy system prompt to clipboard (paste into OpenClaw agent config)
#   hermes        Print path to skill.json for Hermes agent runtime
#
# Examples:
#   ./install.sh claude
#   ./install.sh claude --dir ~/my-project
#   ./install.sh claude-skill
#   ./install.sh openclaw

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-}"
DIR="$PWD"

shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir) DIR="$2"; shift 2 ;;
    *) echo "Unknown flag: $1"; exit 2 ;;
  esac
done

usage() {
  sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
}

[[ -z "$TARGET" ]] && usage

case "$TARGET" in
  claude)
    dest="$DIR/CLAUDE.md"
    if [[ -f "$dest" ]]; then
      echo "CLAUDE.md exists at $dest — appending Skill Hunter block."
      echo "" >> "$dest"
      cat "$REPO_DIR/adapters/claude-code/CLAUDE.md" >> "$dest"
    else
      cp "$REPO_DIR/adapters/claude-code/CLAUDE.md" "$dest"
      echo "Wrote $dest"
    fi
    ;;

  claude-skill)
    skill_dir="$HOME/.claude/skills/skill-hunter"
    mkdir -p "$skill_dir"
    cp "$REPO_DIR/skill.md" "$skill_dir/SKILL.md"
    echo "Installed as user-wide Claude skill: $skill_dir/SKILL.md"
    echo "Invoke in Claude Code via the Skill tool or /skill-hunter."
    ;;

  codex)
    dest="$DIR/AGENTS.md"
    if [[ -f "$dest" ]]; then
      echo "AGENTS.md exists at $dest — appending Skill Hunter block."
      echo "" >> "$dest"
      cat "$REPO_DIR/adapters/codex/AGENTS.md" >> "$dest"
    else
      cp "$REPO_DIR/adapters/codex/AGENTS.md" "$dest"
      echo "Wrote $dest"
    fi
    ;;

  cursor)
    rules_dir="$DIR/.cursor/rules"
    mkdir -p "$rules_dir"
    cp "$REPO_DIR/adapters/cursor/skill-hunter.md" "$rules_dir/skill-hunter.md"
    echo "Wrote $rules_dir/skill-hunter.md"
    ;;

  openclaw)
    src="$REPO_DIR/adapters/openclaw/system-prompt.txt"
    if command -v pbcopy >/dev/null; then
      pbcopy < "$src"
      echo "OpenClaw system prompt copied to clipboard. Paste into your agent's Instructions / System Prompt field."
    elif command -v xclip >/dev/null; then
      xclip -selection clipboard < "$src"
      echo "OpenClaw system prompt copied to clipboard (xclip)."
    else
      echo "No clipboard tool found. Read the prompt from:"
      echo "  $src"
    fi
    ;;

  hermes)
    echo "Point your Hermes agent at:"
    echo "  $REPO_DIR/adapters/hermes/skill.json"
    echo "It references adapters/openclaw/system-prompt.txt as the system prompt."
    ;;

  *)
    echo "Unknown target: $TARGET"
    usage
    ;;
esac
