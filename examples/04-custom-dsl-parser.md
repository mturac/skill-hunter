# Example 04 — Parse an Internal YAML-ish DSL

**User**

> Write a parser for our internal config format. It looks like YAML but has custom `@include` directives and inline expressions.

**Skill Hunter**

```
Aga buna uygun guvenilir bir skill/tool bulamadim.
Bu durumda custom implementation daha mantikli.

Reason:
- YAML supersets I found (StrictYAML, HJSON) don't support your @include semantics.
- The two GitHub repos that match are abandoned (last commit 2021, open CVEs in deps).
- Writing a thin parser on top of an existing YAML lib is smaller than adapting any of them.

Next step:
I will implement it manually with a clean, minimal approach:
- parse YAML first (js-yaml)
- post-process @include and inline expressions in a second pass
- ~80 lines, fully testable, no external maintenance risk
```
