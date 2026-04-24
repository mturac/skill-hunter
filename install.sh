#!/usr/bin/env bash
# Skill Hunter installer — auto-installs the skill into the right runtime.
#
# Usage:
#   ./install.sh <target> [--dir <path>] [--force]
#
# Targets:
#   claude        Install as user-wide Claude Code skill (~/.claude/skills/skill_hunter/SKILL.md)
#   claude-md     Write/append CLAUDE.md in the current (or --dir) project
#   shared        Install to ~/.agents/skills/skill_hunter  (read by Codex AND OpenClaw)
#   openclaw      Install to ~/.openclaw/skills/skill_hunter (OpenClaw reads this too; no symlink allowed)
#   hermes        Install as Hermes skill (~/.hermes/skills/utility/skill_hunter/SKILL.md)
#   codex-md      Write/append AGENTS.md in the current (or --dir) project
#   cursor        Write .cursor/rules/skill-hunter.md in the current (or --dir) project
#   claude-hook   Register UserPromptSubmit hook in ~/.claude/hooks.json (always-on)
#   codex-hook    Register UserPromptSubmit hook in ~/.codex/hooks/hooks.json (always-on)
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
do_shared()    {
  # ~/.agents/skills/ is read by Codex and OpenClaw. Codex follows symlinks,
  # OpenClaw does not — so we prefer a symlink here for editability, and fall
  # back to a copy if you pass --force on a non-Codex machine.
  local dest="$HOME/.agents/skills/skill_hunter"
  mkdir -p "$HOME/.agents/skills"
  [[ -e "$dest" && $FORCE -eq 0 ]] && { echo "[shared] exists — skipping (use --force): $dest"; return 0; }
  rm -f "$dest" 2>/dev/null
  ln -sfn "$REPO_DIR" "$dest"
  echo "[shared] symlinked → $dest  (read by Codex + OpenClaw)"
}
do_claude_md() { install_md "claude-md" "CLAUDE.md" "$REPO_DIR/adapters/claude-code/CLAUDE.md"; }
do_codex_md()  { install_md "codex-md" "AGENTS.md" "$REPO_DIR/adapters/codex/AGENTS.md"; }
do_cursor()    {
  mkdir -p "$DIR/.cursor/rules"
  cp "$REPO_DIR/adapters/cursor/skill-hunter.md" "$DIR/.cursor/rules/skill-hunter.md"
  echo "[cursor] wrote $DIR/.cursor/rules/skill-hunter.md"
}
install_hook() {
  # Registers hooks/skill-hunter-hook.sh under UserPromptSubmit in the given
  # hooks.json. Merges with existing hooks without clobbering them. Requires jq.
  local runtime="$1" hooks_json="$2"
  local script="$REPO_DIR/hooks/skill-hunter-hook.sh"
  chmod +x "$script" 2>/dev/null || true
  mkdir -p "$(dirname "$hooks_json")"
  if ! command -v jq >/dev/null; then
    echo "[$runtime-hook] jq is required. brew install jq"; return 1
  fi
  local existing='{"hooks":{}}'
  [[ -f "$hooks_json" ]] && existing=$(cat "$hooks_json")
  printf '%s\n' "$existing" | jq --arg cmd "$script" '
    .hooks.UserPromptSubmit = (
      (.hooks.UserPromptSubmit // [])
      | map(select((.hooks // []) | any(.command == $cmd) | not))
    ) + [{
      "hooks": [{
        "type": "command",
        "command": $cmd,
        "statusMessage": "Skill Discovery Pass...",
        "timeout": 5
      }]
    }]
  ' > "$hooks_json.tmp" && mv "$hooks_json.tmp" "$hooks_json"
  echo "[$runtime-hook] registered UserPromptSubmit → $script in $hooks_json"
}
do_claude_hook() { install_hook "claude" "$HOME/.claude/hooks.json"; }
do_codex_hook()  { install_hook "codex"  "$HOME/.codex/hooks/hooks.json"; }

case "$TARGET" in
  claude)       do_claude ;;
  claude-md)    do_claude_md ;;
  claude-hook)  do_claude_hook ;;
  shared)       do_shared ;;
  openclaw)     do_openclaw ;;
  hermes)       do_hermes ;;
  codex-md)     do_codex_md ;;
  codex-hook)   do_codex_hook ;;
  cursor)       do_cursor ;;
  all)
    do_claude
    do_shared       # covers Codex + gives OpenClaw a second read path (symlink)
    do_openclaw     # non-symlink fallback for OpenClaw which rejects symlinks
    do_hermes
    do_claude_hook  # pre-turn hook — guarantees Skill Discovery Pass fires first
    do_codex_hook
    echo "(skipping claude-md/codex-md/cursor — those are per-project; run them in the project dir)"
    ;;
  *) echo "Unknown target: $TARGET" >&2; usage ;;
esac
