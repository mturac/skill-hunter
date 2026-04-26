# Benchmark Runner Prompt

Use `prompts/_contract.md` first.

Build a benchmark suite proving Skill Hunter reduces unnecessary custom code generation by making agents check existing tools first.

## YAML Fields
`id`, `user_prompt`, `expected_existing_options`, `baseline_failure_mode`, `skill_hunter_expected_behavior`, `ideal_decision`, `evaluation_criteria`.

## Categories
Web scraping, PDF parsing, invoice extraction, GitHub PR review, calendar automation, Gmail workflow, database import, image generation workflow, browser QA, social media drafting with approval, API integration, and log analysis.

## Metrics
Did the agent search first, avoid unnecessary custom code, identify viable candidates, explain trade-offs, request approval for risky tools, choose the lowest-risk viable option, and avoid unsafe install commands?

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
