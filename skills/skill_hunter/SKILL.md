---
name: skill_hunter
description: ALWAYS invoke this skill FIRST, BEFORE writing code or taking implementation steps, whenever the user asks to write, build, create, implement, set up, scaffold, generate, scrape, parse, convert, deploy, automate, integrate, extract, migrate, test, or document anything. This skill checks for existing skills, MCP servers, CLIs, plugins, repos, templates, SDKs, APIs, packages, or workflows that already solve the task, evaluates fit and risk, and asks for approval before risky use. Skip only for one-line edits, renames, trivial regex, or when the user explicitly asks for manual implementation.
---

# Skill Hunter

Your job is not to immediately execute the user's request. Your first responsibility is to decide whether an existing reusable solution can solve or accelerate it.

## Precedence

Safety and privacy rules outrank convenience. If instructions conflict, choose the safer path or ask for clarification. Never weaken approval, credential, or destructive-action gates silently.

## Responsibility Contract

Role: accountable Skill Hunter scout and execution advisor. Owned surface: only the requested task, files, module, workflow, or documentation. Constraints and non-goals: preserve existing behavior and avoid unrelated changes. Acceptance: the user sees a clear reuse decision before implementation. Verification: use the smallest relevant test, audit, or syntax check. Final report: changed files, verification results, and residual risk.

## Tool Contract

Treat tools as candidates until the host exposes a callable schema. Required decision schema fields: `goal`, `decision`, `candidates_checked`, `recommended_path`, `risk`, `approval_required`, and `next_action`. Decision enum: `USE_EXISTING`, `ADAPT_EXISTING`, `BUILD_MINIMAL`, `BUILD_CUSTOM`, `ASK_USER`, `AVOID`.

## Recommendation Context

Before recommending, account for location or market, budget, preference or use case, date or timing, constraint, runtime, privacy, credential scope, license, and deployment environment. Missing decision context maps to `ASK_USER` or an explicit safe default.

## Core Rule

Before implementing from scratch, ask: "Is there likely an existing skill/tool/workflow that can solve or accelerate this task?"

If yes, search or reason about candidates, evaluate them, and present the best option before execution.

## Skill Discovery Pass

Run when the task involves file conversion, document generation, browser automation, data extraction, scraping, testing, deployment, CI/CD, media generation, design-to-code, API integration, migration, docs generation, scaffolding, database analysis, cloud setup, LLM orchestration, or agent workflows.

Skip when the task is trivial, the user explicitly asked for manual implementation, searching costs more than doing, or the project already has a known internal path.

## Evaluate Candidates By

Relevance, trustworthiness, maintenance, documentation quality, stack fit, security risk, credential scope, install complexity, licensing, testability, and time saved.

## Decision Values

- `USE_EXISTING`: a mature solution directly fits.
- `ADAPT_EXISTING`: a small wrapper around an existing solution is best.
- `BUILD_MINIMAL`: reuse is partial; build only the missing thin layer.
- `BUILD_CUSTOM`: reuse is weak or unsafe; build from scratch.
- `ASK_USER`: approval, credentials, cost, risk, or ambiguity blocks a safe decision.
- `AVOID`: candidate is unsafe or too low-quality.

## Output Format

```text
Skill Discovery Pass:
- Goal:
- Existing options checked:
- Best option:
- Decision:
- Risk:
- Next action:
```

## Approval Gate

Ask before installing unknown tools, using external services, accessing credentials, posting to email/calendar/social systems, writing outside the repo, running networked execution, or doing destructive operations.

## Security Rules

- Never install or run unknown tools without user approval.
- Never run remote shell scripts, obfuscated commands, credential collectors, browser-profile access, wallet access, or broad secret access.
- Prefer official, maintained, documented, low-permission tools.
- If a task is small and a tool adds complexity, say so and build minimally.

## Goal

Prevent wasted implementation effort and tool chaos. Skill Hunter is a scout, evaluator, and execution advisor: the intelligence in agent systems is knowing when not to build.
