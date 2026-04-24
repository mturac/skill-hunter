# Changelog

All notable changes follow [keepachangelog.com](https://keepachangelog.com) and [semver](https://semver.org).

## [1.1.0] — 2026-04-24

### Added
- Claude Code plugin manifest at `.claude-plugin/plugin.json` plus a root `.claude-plugin/marketplace.json` — users install with `/plugin marketplace add mturac/skill-hunter` + `/plugin install skill-hunter` without cloning.
- Codex CLI plugin manifest at `.codex-plugin/plugin.json` — `codex plugin marketplace add …` path works the same way.
- `hooks/hooks.json` so plugin loaders register the `UserPromptSubmit` hook automatically.
- Canonical skill location is now `skills/skill_hunter/SKILL.md` (matches the `owner/repo@skill` convention used by `npx skills add`). A backwards-compatible symlink at the repo root keeps the old path working.

### Changed
- `install.sh` now symlinks `~/.claude/skills/skill_hunter → skills/skill_hunter` (scoped to the skill directory, not the whole repo) — cleaner, avoids leaking repo tooling into the skill namespace.
- README documents four install channels: Claude plugin marketplace, Codex plugin marketplace, `npx skills`, and the local clone + `install.sh` flow.

## [1.0.0] — 2026-04-24

Initial deploy-ready release.

### Added
- `SKILL.md` — canonical agentskills.io-compatible skill with an imperative description that triggers on implementation verbs (`write`, `build`, `create`, `scrape`, `parse`, `convert`, `deploy`, …).
- `hooks/skill-hunter-hook.sh` — `UserPromptSubmit` hook that injects the Skill Discovery Pass into every interactive turn of Claude Code and Codex CLI, guaranteeing the pass fires even when a more specific skill would otherwise win the matcher.
- `install.sh` — idempotent installer with `claude` / `codex` / `all` / `uninstall` / `status` targets. Symlinks the skill back to the clone so edits propagate live. Hook registration is jq-merged into existing `hooks.json` files without clobbering other hooks.
- `adapters/` — per-runtime Markdown surfaces for Claude Code (`CLAUDE.md`), Codex (`AGENTS.md`), and Cursor rules.
- `agents/openai.yaml` — Codex UI metadata.
- `examples/` — five real interaction transcripts covering single-candidate pick, 3-way shortlist, skipped discovery, "build it yourself", and credential-scope warning.

### Known limitations
- `codex exec` and Claude's `-p` headless modes do not fire `UserPromptSubmit` hooks. The skill's implicit matching is the only mechanism in those modes.
- OpenClaw rejects symlinked skills — the `openclaw` target installs a file copy. OpenClaw hook integration is not yet covered.
