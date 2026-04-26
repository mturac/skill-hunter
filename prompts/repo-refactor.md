# Repository Refactor Prompt

Use `prompts/_contract.md` first.

You are improving the Skill Hunter repository. Keep the product identity: a pre-execution layer that makes agents search for existing skills/tools/MCPs/packages/workflows before building from scratch.

## Requirements
- Preserve current install surfaces: Claude Code, Codex CLI, OpenClaw/ClawHub, local clone, and `npx skills`.
- Add or improve docs in `docs/` for product, architecture, trust score, security, benchmarks, and roadmap.
- Add reusable prompts in `prompts/`.
- Add examples for scraping, PDFs, PR review, workspace automation, social drafting with approval, database import, and API integration.
- Add benchmark tasks comparing baseline agent behavior with Skill Hunter guided behavior.
- Add a minimal CLI skeleton only if it is reviewable and does not imply real providers.

## Done
Return changed files, verification, and remaining work.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
