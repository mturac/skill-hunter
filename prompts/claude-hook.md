# Claude Hook Prompt Output

Use `prompts/_contract.md` first.

Skill Hunter is active. Before generating custom code or automation, run a Skill Discovery Pass:
- What existing skill/tool/MCP/API/package/workflow could solve this?
- Is reuse safer or faster than building?
- What risk or approval is needed?
- Should we use existing, adapt existing, build minimal, build custom, or ask user?

Avoid silently install or execute unknown tools.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
