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
  "additionalContext": "Skill Discovery Pass (skill_hunter): before you implement anything, check whether an existing skill, MCP server, CLI tool, plugin, repo, template, SDK, or API already solves the request. If there is a strong candidate, present it (Name / Type / Why it fits / Risk / Effort) or a shortlist of three and ask the user to pick before writing code. If nothing good exists, say so with the reason and implement minimally. Skip only for trivial edits, renames, or when the user explicitly asked for manual implementation."
}
EOF
