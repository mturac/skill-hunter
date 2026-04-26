# Architecture

Skill Hunter currently has three layers.

## 1. Runtime Instructions
`skills/skill_hunter/SKILL.md` and runtime adapters define when the Skill Discovery Pass activates and how the agent reports options.

## 2. Hook Injection
`hooks/skill-hunter-hook.sh` injects a short discovery reminder into interactive Claude/Codex turns so the behavior triggers even when another skill might match.

## 3. Product Scaffolding
`docs/`, `prompts/`, and `benchmarks/` define the next product layer: provider discovery, trust scoring, security audits, and measurable behavior changes.

## Current Provider Surfaces

Skill Hunter already has real distribution surfaces for Claude Code, Codex CLI, OpenClaw/ClawHub, `npx skills`, and local installer workflows.

## Future CLI Shape
A future CLI should keep automated discovery network access behind provider adapters and start with safe, inspect-only commands: `recommend`, `audit`, `compare`, `explain`, and `benchmark`.
