# Discovery Provider Prompt

Use `prompts/_contract.md` first.

Design the provider layer that searches multiple ecosystems for reusable solutions before an AI agent builds from scratch.

## Providers
ClawHub skills/plugins, GitHub repositories, MCP servers, npm packages, PyPI packages, official API docs, local repository utilities, and internal workspace docs.

## Interface
- `search(task_query) -> candidate[]`
- `inspect(candidate_id) -> candidate_detail`
- `normalize(candidate_detail) -> normalized_candidate`

## Normalized Candidate Fields
`id`, `name`, `source`, `url`, `summary`, `tags`, `install_command`, `usage_example`, `stars`, `downloads`, `current_installs`, `version`, `last_updated`, `maintainer`, `license`, `requires_credentials`, `credential_scope`, `executes_code`, `network_access`, `filesystem_access`, `documentation_quality`, `testability`, `known_risks`.

## Ranking
Prefer exact fit, official or maintained sources, low permissions, recent updates, and examples. Penalize obfuscated commands, broad credentials, unclear license, missing docs, and remote-script installs.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
