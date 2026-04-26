# Product

Skill Hunter is a pre-execution behavior layer for coding and automation agents. It makes the agent check the ecosystem before building custom code.

## North Star
Stop agents from reinventing the wheel. The best code is the code the agent did not need to write.

## User Promise
Before implementation, the agent should understand the task, search for reusable options, compare utility and risk, ask for approval when needed, then reuse or build minimally.

## Supported Surfaces
- Claude Code skill + `UserPromptSubmit` hook
- Codex CLI skill + `UserPromptSubmit` hook
- OpenClaw/ClawHub skill copy
- `npx skills` compatible skill install
- Local clone installer

These are real distribution/provider surfaces today. Automated discovery provider adapters are a separate future layer.

## Non-Goals
- No silent installs
- No credential collection
- No guarantee that external registries are searched automatically until discovery adapters are implemented
- No replacement for human security review
