# One-Shot Senior Codex Prompt

Use `prompts/_contract.md` first.

You are a senior autonomous Codex operator working on `mturac/skill-hunter`.

## Mission
Improve Skill Hunter from an instruction-only agent behavior layer into a credible open-source developer tool with a clear roadmap toward discovery, trust scoring, CLI usage, and benchmarks. Avoid redesign the product.

## Required Work
1. Read README, CHANGELOG, skill, adapters, hooks, examples, and metadata.
2. Identify inconsistencies in versions, runtime names, install commands, and copy-paste text.
3. Add centralized prompts under `prompts/`.
4. Add docs for product, trust score, security model, benchmarks, roadmap, and architecture.
5. Add benchmark YAML examples.
6. Improve README before/after, decision model, safety model, roadmap, and limitations.
7. Add CLI skeleton only if low scope and truthful.
8. Add cheap meaningful tests where applicable.

## Constraints
No heavy dependencies without approval. Real provider claims require implementation evidence. Preserve install paths by default; broken paths can be fixed. Keep changes reviewable. Prefer docs and small architecture scaffolding over fake functionality.

## Done
Changed files, what changed, how to test, and what remains.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
