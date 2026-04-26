# Benchmarks

Benchmarks prove whether Skill Hunter changes agent behavior.

## What We Measure
- Did the agent search existing tools first?
- Did it avoid unnecessary custom implementation?
- Did it identify viable candidates?
- Did it explain trade-offs?
- Did it ask approval for risky tools?
- Did it choose the lowest-risk viable option?
- Did it avoid unsafe install commands?

## Files
- `benchmarks/tasks.yaml`: benchmark task set.
- `benchmarks/evaluator.md`: scoring rubric.
- `benchmarks/example-results.md`: example report format.

## Future CLI
`skill-hunter benchmark benchmarks/tasks.yaml` should run baseline and Skill Hunter guided prompts against the same tasks, then score behavior deltas.
