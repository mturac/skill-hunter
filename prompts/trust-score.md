# Trust Score Prompt

Use `prompts/_contract.md` first.

Given a candidate skill/tool/package/workflow, produce a transparent score that helps an AI agent decide whether to use, adapt, avoid, or ask for approval.

## Dimensions
- Relevance, 0-25: task fit, narrowness, runtime fit.
- Maintenance, 0-20: updates, versions, maintainer, issue/PR activity, compatibility.
- Adoption, 0-15: downloads, stars, installs, comments, examples.
- Security, 0-25: credential scope, network/filesystem access, shell execution, suspicious commands, permission minimization.
- Documentation, 0-10: README, install, examples, changelog, troubleshooting.
- Fit Cost, 0-5: install, migration, wrapper, and testing effort.

## Thresholds
85-100 `USE_EXISTING`; 70-84 `ADAPT_EXISTING`; 50-69 `BUILD_MINIMAL` or `ASK_USER`; 30-49 `ASK_USER` or `AVOID`; 0-29 `AVOID`.

## Hard Blockers
Remote shell execution without review, obfuscated installs, unrelated secrets, browser profile or wallet access, credential exfiltration, or unclear provenance with broad permissions.

## PromptGuard Acceptance Contract
Schema: required arguments, enum values, payload shape, and invalid-state behavior are explicit. Output format: concise markdown sections or JSON where requested. Scope: target files, module, owned surface, constraints, non-goals, acceptance criteria, verification test command, and stopping condition. Technical risk: target file/module/schema/endpoint, preserve backward compatibility, rollback note, validation/error handling, risk, edge cases, and verify result. Recommendation context: location, budget, preference, date, and constraint. Responsibility: role, responsible owner, owned surface, files, module, constraints, non-goals, preserve unrelated behavior, acceptance criteria, verification, changed files, final report, and residual risk.
