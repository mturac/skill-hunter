# CLI Engine Prompt

Use `prompts/_contract.md` first.

You are a senior Python CLI engineer and AI tooling architect. Build a minimal and production-shaped CLI for Skill Hunter.

## Commands
- `skill-hunter recommend "<task>"`: ranked candidates and decision.
- `skill-hunter audit "<candidate>"`: trust score, risk score, install complexity, credential concerns, recommendation.
- `skill-hunter compare "<task>" --candidates a,b,c`: compare tools for the same task.
- `skill-hunter explain "<decision-json>"`: explain a decision.
- `skill-hunter benchmark ./benchmarks/tasks.yaml`: run benchmark tasks.

## Constraints
Use Python. Keep network access behind provider interfaces. Start with mocked/static data if needed. Required: never execute installs in audit mode. Required: never request secrets. Support human-readable and JSON output.

## Suggested Structure
`skill_hunter/cli.py`, `models.py`, `providers/`, `scoring/`, `benchmarks/`, `safety/`, and cheap tests.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
