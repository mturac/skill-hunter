# Trust Score

The Trust Score makes reuse decisions explicit instead of vibes-based.

## Dimensions
- Relevance, 0-25: solves the real task, narrow scope, runtime fit.
- Maintenance, 0-20: recent updates, version history, maintainer identity, issue/PR activity.
- Adoption, 0-15: downloads, stars, installs, community use, examples.
- Security, 0-25: credential scope, network/filesystem access, shell execution, suspicious commands, permission minimization.
- Documentation, 0-10: README, install docs, examples, changelog, troubleshooting.
- Fit Cost, 0-5: install, wrapper, migration, and testing effort.

## Decisions
- 85-100: `USE_EXISTING`
- 70-84: `ADAPT_EXISTING`
- 50-69: `BUILD_MINIMAL` or `ASK_USER`
- 30-49: `ASK_USER` or `AVOID`
- 0-29: `AVOID`

## Hard Blockers
Remote shell execution without review, obfuscated install commands, unrelated secrets, browser profile or wallet access, credential exfiltration, and unclear provenance with broad permissions.
