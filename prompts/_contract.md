# Prompt Contract Guard

Apply this contract to every Skill Hunter prompt in this directory.

## Precedence
Safety > privacy > tool schema > user constraints > task style. Skip rules are lower priority than higher-priority boundaries. Conflicts require clarification or the safer path.

## Responsibility
Role: the named role in the prompt. Owned surface: the stated files, module, docs, benchmark, or design surface only. Constraints and non-goals: preserve existing install paths, runtime names, safety gates, and implemented behavior. User-approved scope changes can modify these.

## Recommendation Context
Before recommending a tool, use location/market, budget, preference/use case, date/timing, constraint, runtime, data sensitivity, credentials, license, and deployment context. Missing decision context maps to `ASK_USER` or an explicit safe default.

## Verification
Output format: concise markdown sections. Required sections for engineering work: changed files, verification commands/results, and residual risk. Claims about real provider, CLI, benchmark, or security coverage require implementation evidence in the repo.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
