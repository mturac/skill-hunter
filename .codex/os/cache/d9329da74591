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

Claude Code, OpenClaw, and Hermes all use the [agentskills.io](https://agentskills.io) `SKILL.md` standard — the same [`SKILL.md`](./SKILL.md) file works for all three. `install.sh` drops it into the right place:

```bash
./install.sh claude      # ~/.claude/skills/skill-hunter/SKILL.md
./install.sh openclaw    # ~/.openclaw/skills/skill-hunter/SKILL.md
./install.sh hermes      # ~/.hermes/skills/utility/skill-hunter/SKILL.md
./install.sh all         # all three at once
```

Per-project (adds to the current directory, not user-wide):

```bash
./install.sh claude-md   # ./CLAUDE.md
./install.sh codex       # ./AGENTS.md
./install.sh cursor      # ./.cursor/rules/skill-hunter.md
```

### Alternatives

- **Claude Code**: no restart — skills auto-load on next session.
- **OpenClaw**: equivalent one-liner via the runtime — `openclaw skills install skill-hunter` once it's published to ClawHub.
- **Hermes**: drop-in — `~/.hermes/skills/…` is hot-reloaded.
- **Codex / AGENTS.md**: place `AGENTS.md` at repo root (the file works anywhere Codex reads agent instructions).

The canonical source of truth is [`SKILL.md`](./SKILL.md). Per-project markdown variants live under [`adapters/`](./adapters) (`claude-code/`, `codex/`, `cursor/`).

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
