#!/usr/bin/env bash
# Skill Hunter — installer for Claude Code and Codex CLI.
#
# Each primary target installs both the skill (matched implicitly) and the
# UserPromptSubmit hook (guaranteed to inject the Skill Discovery Pass even
# when another skill would win the matcher).
#
# Usage:
#   ./install.sh <target> [--force]
#
# Primary:
#   claude        Claude Code    (skill + hook, user-wide)
#   codex         Codex CLI      (skill + hook, user-wide)
#   all           Both runtimes
#   uninstall     Remove skill + hook from both runtimes
#   status        Show what is installed where
#
# Advanced:
#   claude-skill | claude-hook | codex-skill | codex-hook | openclaw | hermes | cursor
#
# Flags:
#   --force       Replace existing skill path / overwrite existing copy
#
# Requires: jq (for hook registration) — brew install jq

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$REPO_DIR/skills/skill_hunter"
SKILL_SRC="$SKILL_DIR/SKILL.md"
HOOK_SRC="$REPO_DIR/hooks/skill-hunter-hook.sh"
TARGET="${1:-}"
FORCE=0

shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 2 ;;
  esac
done

ok()   { printf '\033[32m  ✓\033[0m %s\n' "$*"; }
warn() { printf '\033[33m  ⚠\033[0m %s\n' "$*"; }
err()  { printf '\033[31m  ✗\033[0m %s\n' "$*" >&2; }
hdr()  { printf '\n\033[1m%s\033[0m\n' "$*"; }
say()  { printf '  %s\n' "$*"; }

usage() { sed -n '2,24p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
[[ -z "$TARGET" ]] && usage

require_jq() { command -v jq >/dev/null || { err "jq required — brew install jq"; exit 1; }; }

remove_path() {
  local p="$1"
  if [[ -L "$p" || -f "$p" ]]; then rm -f "$p"
  elif [[ -d "$p" ]]; then rm -r "$p"
  fi
}

install_skill_symlink() {
  local runtime="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" ]]; then
    local current; current="$(readlink "$dest")"
    if [[ "$current" == "$SKILL_DIR" ]]; then ok "[$runtime skill] already linked"; return 0; fi
    [[ $FORCE -eq 0 ]] && { warn "[$runtime skill] symlink → $current (--force to replace)"; return 0; }
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    [[ $FORCE -eq 0 ]] && { warn "[$runtime skill] $dest exists (--force to replace)"; return 0; }
    remove_path "$dest"
  fi
  ln -sfn "$SKILL_DIR" "$dest"
  ok "[$runtime skill] → $dest"
}

install_skill_copy() {
  local runtime="$1" dest_dir="$2"
  mkdir -p "$dest_dir"
  if [[ -f "$dest_dir/SKILL.md" && $FORCE -eq 0 ]]; then
    warn "[$runtime skill] $dest_dir/SKILL.md exists (--force to overwrite)"
    return 0
  fi
  cp "$SKILL_SRC" "$dest_dir/SKILL.md"
  ok "[$runtime skill] → $dest_dir/SKILL.md (copy)"
}

install_hook() {
  local runtime="$1" hooks_json="$2"
  require_jq
  chmod +x "$HOOK_SRC" 2>/dev/null || true
  mkdir -p "$(dirname "$hooks_json")"
  local existing='{"hooks":{}}'
  [[ -f "$hooks_json" ]] && existing=$(cat "$hooks_json")
  printf '%s\n' "$existing" | jq --arg cmd "$HOOK_SRC" '
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
  ok "[$runtime hook]  → $hooks_json"
}

uninstall_skill() {
  local runtime="$1" dest="$2"
  if [[ -L "$dest" || -e "$dest" ]]; then remove_path "$dest"; ok "[$runtime skill] removed"
  else say "[$runtime skill] nothing to remove"; fi
}

uninstall_hook() {
  local runtime="$1" hooks_json="$2"
  require_jq
  [[ -f "$hooks_json" ]] || { say "[$runtime hook]  no hooks.json"; return 0; }
  jq --arg cmd "$HOOK_SRC" '
    .hooks.UserPromptSubmit = (
      (.hooks.UserPromptSubmit // [])
      | map(.hooks |= (map(select(.command != $cmd))))
      | map(select((.hooks // []) | length > 0))
    )
    | if (.hooks.UserPromptSubmit // [] | length) == 0 then del(.hooks.UserPromptSubmit) else . end
  ' "$hooks_json" > "$hooks_json.tmp" && mv "$hooks_json.tmp" "$hooks_json"
  ok "[$runtime hook]  deregistered"
}

do_claude_skill() { install_skill_symlink "claude" "$HOME/.claude/skills/skill_hunter"; }
do_claude_hook()  { install_hook          "claude" "$HOME/.claude/hooks.json"; }
do_codex_skill()  { install_skill_symlink "codex"  "$HOME/.codex/skills/skill_hunter"; }
do_codex_hook()   { install_hook          "codex"  "$HOME/.codex/hooks/hooks.json"; }
do_openclaw()     { install_skill_copy    "openclaw" "$HOME/.openclaw/skills/skill_hunter"; }
do_hermes()       { install_skill_copy    "hermes" "$HOME/.hermes/skills/utility/skill_hunter"; }
do_cursor()       {
  mkdir -p ".cursor/rules"
  cp "$REPO_DIR/adapters/cursor/skill-hunter.md" ".cursor/rules/skill-hunter.md"
  ok "[cursor] → $PWD/.cursor/rules/skill-hunter.md"
}

do_claude() { hdr "Claude Code"; do_claude_skill; do_claude_hook; }
do_codex()  { hdr "Codex CLI";   do_codex_skill;  do_codex_hook;  }

do_status() {
  hdr "Claude Code"
  [[ -e "$HOME/.claude/skills/skill_hunter" ]] && ok "skill present" || warn "skill missing"
  grep -q "skill-hunter-hook.sh" "$HOME/.claude/hooks.json" 2>/dev/null && ok "hook registered" || warn "hook missing"
  hdr "Codex CLI"
  [[ -e "$HOME/.codex/skills/skill_hunter" ]] && ok "skill present" || warn "skill missing"
  grep -q "skill-hunter-hook.sh" "$HOME/.codex/hooks/hooks.json" 2>/dev/null && ok "hook registered" || warn "hook missing"
}

do_uninstall() {
  hdr "Claude Code"
  uninstall_skill "claude" "$HOME/.claude/skills/skill_hunter"
  uninstall_hook  "claude" "$HOME/.claude/hooks.json"
  hdr "Codex CLI"
  uninstall_skill "codex"  "$HOME/.codex/skills/skill_hunter"
  uninstall_hook  "codex"  "$HOME/.codex/hooks/hooks.json"
}

case "$TARGET" in
  claude)        do_claude ;;
  codex)         do_codex ;;
  all)           do_claude; do_codex ;;
  uninstall)     do_uninstall ;;
  status)        do_status ;;
  claude-skill)  do_claude_skill ;;
  claude-hook)   do_claude_hook ;;
  codex-skill)   do_codex_skill ;;
  codex-hook)    do_codex_hook ;;
  openclaw)      do_openclaw ;;
  hermes)        do_hermes ;;
  cursor)        do_cursor ;;
  *) err "Unknown target: $TARGET"; usage ;;
esac
