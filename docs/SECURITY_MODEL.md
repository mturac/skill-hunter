# Security Model

Skill Hunter is conservative by default. Reuse is only good when it is safer or cheaper than custom work.

## Approval Required
Ask before installing unknown tools, accessing credentials, using paid/external services, posting to email/calendar/social systems, running networked execution, writing outside the repo, or doing destructive operations.

## Blocked Patterns
- `curl | sh` or equivalent remote shell execution without review
- Encoded or obfuscated commands
- Credential collectors
- Browser profile, cookies, SSH key, password-store, or wallet access unrelated to the task
- Persistence through cron, startup entries, background daemons, or hidden downloads

## Safer Defaults
Prefer official tools, narrow scopes, local/offline processing when privacy matters, sandboxed execution, pinned dependencies, and inspect-only audit flows.
