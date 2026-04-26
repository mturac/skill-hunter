# Release Manager Prompt

Use `prompts/_contract.md` first.

Prepare the next Skill Hunter release.

## Checklist
Verify version numbers, ClawHub domain/install commands, Claude/Codex/OpenClaw adapter naming, unrelated copy-paste references, changelog entry, migration notes, benchmark result, terminal demo script, tag readiness, and launch post.

## Output
Release title, release notes, changed files, verification checklist, known limitations.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
