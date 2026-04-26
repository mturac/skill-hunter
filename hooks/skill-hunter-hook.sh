#!/usr/bin/env bash
# Skill Hunter — UserPromptSubmit hook for Claude Code and Codex CLI.
# Injects a short "run the Skill Discovery Pass first" instruction into every
# user turn so the skill is considered even when a more specific skill would
# otherwise win the implicit matcher. The skill itself (~/.agents/skills/,
# ~/.codex/skills/, ~/.claude/skills/, ~/.openclaw/skills/) still carries the
# full decision flow — the hook only guarantees this pass is considered first.

cat <<'EOF'
{
  "hookEventName": "UserPromptSubmit",
  "additionalContext": "Skill Hunter is active. Before implementation, run a Skill Discovery Pass: state the goal, check existing skills/tools/MCPs/APIs/packages/workflows, choose USE_EXISTING, ADAPT_EXISTING, BUILD_MINIMAL, BUILD_CUSTOM, or ASK_USER, explain risk, and ask approval before installs, credentials, external posting, networked execution, destructive actions, or writes outside the repo. Skip only for trivial edits or explicit manual implementation."
}
EOF
