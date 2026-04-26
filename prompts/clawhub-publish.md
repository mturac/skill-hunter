# ClawHub Publish Prompt

Use `prompts/_contract.md` first.

Prepare Skill Hunter as a clean, trustworthy OpenClaw skill.

## Requirements
`skills/skill_hunter/SKILL.md` must explain activation, Skill Discovery Pass, safety rules, examples, metadata/tags, version notes, limitations, and approval requirements. It must not imply inspection capabilities that are not implemented.

## Update
`skills/skill_hunter/SKILL.md`, README ClawHub section, `CHANGELOG.md`, and `examples/openclaw.md` if needed.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
