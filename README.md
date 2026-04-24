# Skill Hunter

A pre-execution layer for coding/automation agents (Codex, Claude, OpenClaw, …) that asks a single question before writing any code:

> "Is there already a skill, MCP server, CLI tool, plugin, repo, template, SDK, API, or workflow that can solve this — or accelerate it?"

If yes, it surfaces the best candidate, evaluates risk, and asks for approval before use.
If no, it says so plainly and builds manually with a clean, minimal approach.

The core insight: in agent systems, intelligence is not only knowing how to build — it is knowing **when not to build**.

## Why

The internet is now a landfill of skills, MCPs, plugins, templates, and half-finished repos. The bottleneck for agents is no longer *capability* — it is *discovery*. Skill Hunter sits in front of execution and prevents:

- rebuilding what already exists
- picking the most popular tool instead of the right one
- pulling in abandoned or unsafe repos
- silently installing things that need credentials or system access

## How it works

1. **Classify** the request (coding, design, browser automation, file conversion, scraping, CI/CD, …).
2. **Decide** whether a reusable skill/tool likely exists.
3. **Search** local skills, project docs, GitHub, MCP registry, package managers, tool docs.
4. **Evaluate** candidates by relevance, maintenance, docs, stack fit, security, effort, licensing.
5. **Present** one recommendation, a shortlist of three, or an honest "build it yourself".
6. **Gate** on user approval before running anything external.

## Install

Skill Hunter ships as a **skill + hook pair** for each runtime:

- The **skill** (`SKILL.md`) gets picked up when the user's prompt matches its description — the standard [agentskills.io](https://agentskills.io) path.
- The **hook** (`hooks/skill-hunter-hook.sh`) injects the Skill Discovery Pass into *every* interactive turn via `UserPromptSubmit`, so the pass fires even when a more specific skill would otherwise win the matcher.

Clone the repo, then run the installer:

```bash
git clone https://github.com/mturac/skill-hunter.git
cd skill-hunter
./install.sh all           # Claude Code + Codex CLI (skill + hook)
./install.sh status        # verify
```

Per-runtime:

```bash
./install.sh claude        # Claude Code   — ~/.claude/skills/skill_hunter + ~/.claude/hooks.json
./install.sh codex         # Codex CLI     — ~/.codex/skills/skill_hunter + ~/.codex/hooks/hooks.json
./install.sh uninstall     # remove skill + hook from both
```

Each runtime target installs **both** the skill and the hook. The skill is symlinked back to the cloned repo so local edits propagate without reinstalling. Hook registration is idempotent (jq-merged into existing `hooks.json`, no clobbering).

Optional runtimes (no hooks — skill only):

```bash
./install.sh openclaw      # ~/.openclaw/skills/skill_hunter   (copy — OpenClaw rejects symlinks)
./install.sh hermes        # ~/.hermes/skills/utility/skill_hunter
./install.sh cursor        # ./.cursor/rules/skill-hunter.md (per-project)
```

**Requires:** `jq` (for hook registration). `brew install jq` on macOS.

### What installs where

| Runtime   | Skill path                                  | Hook path                            |
|-----------|---------------------------------------------|--------------------------------------|
| Claude Code | `~/.claude/skills/skill_hunter → repo`    | `~/.claude/hooks.json`               |
| Codex CLI   | `~/.codex/skills/skill_hunter → repo`     | `~/.codex/hooks/hooks.json`          |
| OpenClaw    | `~/.openclaw/skills/skill_hunter/SKILL.md`  | — (OpenClaw hook API differs)        |
| Hermes      | `~/.hermes/skills/utility/skill_hunter/SKILL.md` | —                               |

The hook only fires in **interactive** Claude / Codex sessions. `codex exec` and Claude's `-p` headless modes currently do not fire `UserPromptSubmit` — for those, the skill's implicit matching is the only mechanism.

## Verify it works

Open `claude` or `codex` (interactive TUI). Type:

```
Scrape e-ticaret sitelerinden fiyat veri çekip günlük CSV olarak kaydet.
```

Expected: a short **"Skill Discovery Pass..."** status indicator, then a structured reply beginning with "Best candidate:" (Name / Type / Why it fits / Risk / Effort) or "Three viable options:", followed by **"Use this? 1/2/3"** before any code is written.

If the pass doesn't fire, run `./install.sh status` and check that both `skill` and `hook` show `✓` for your runtime.

## Response shapes

**One good candidate**

```
A reusable skill/tool looks like a good fit for this.

Best candidate:
- Name: …
- Type: …
- Why it fits: …
- Risk: …
- Effort: …

Use this?
1. Yes  2. No, build manually  3. Show alternatives
```

**Shortlist of three** — side-by-side pros/cons + a pick.

**Nothing good exists** — explicit reason (outdated / too broad / unsafe / low quality), then build manually.

## Examples

See [`examples/`](./examples) for real interactions — single-candidate pick, 3-way shortlist, skipped discovery, "build it yourself", and a credential-scope warning.

## Security posture

- Never install or run unknown tools without approval.
- Always explain credential/permission scope before recommending a tool that needs them.
- Prefer official and well-maintained sources. Flag abandoned repos.

## License

MIT — see [`LICENSE`](./LICENSE).
