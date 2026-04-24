# Argus Skill Radar

> **Before building, scan the ecosystem.**

A pre-execution layer for coding/automation agents (Codex, Claude, OpenClaw, …) that asks a single question before writing any code:

> "Is there already a skill, MCP server, CLI tool, plugin, repo, template, SDK, API, or workflow that can solve this — or accelerate it?"

If yes, it surfaces the best candidate, evaluates risk, and asks for approval before use.
If no, it says so plainly and builds manually with a clean, minimal approach.

The core insight: in agent systems, intelligence is not only knowing how to build — it is knowing **when not to build**.

## Why

The internet is now a landfill of skills, MCPs, plugins, templates, and half-finished repos. The bottleneck for agents is no longer *capability* — it is *discovery*. Argus sits in front of execution and prevents:

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

## Use as an agent instruction

Drop [`CLAUDE.md`](./CLAUDE.md) into your project (or rename to `AGENTS.md` / `.cursor/rules/argus.md` / system prompt) to activate the Skill Discovery Pass for your agent.

Works with:

- Claude Code (`CLAUDE.md`)
- Codex / OpenAI agents (`AGENTS.md` or system prompt)
- Cursor (`.cursor/rules/`)
- OpenClaw, Aider, Continue, custom LLM orchestrators — any runtime that honors a system prompt

## Response shapes

**One good candidate**

```
Aga, bu is icin hazir bir skill/tool kullanilabilir gibi gorunuyor 😎

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

## Security posture

- Never install or run unknown tools without approval.
- Always explain credential/permission scope before recommending a tool that needs them.
- Prefer official and well-maintained sources. Flag abandoned repos.

## License

MIT — see [`LICENSE`](./LICENSE).
