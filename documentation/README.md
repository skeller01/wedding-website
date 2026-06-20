# Documentation Guide

## Current Source Of Truth

Use these durable documents for current planning and implementation decisions:

| Purpose | Current Document |
|---|---|
| Product scope | `documentation/planning/prd.md` |
| Deployment architecture | `documentation/planning/deployment-footprint.md` |
| System/design model | `documentation/requirements/current-state-design.md` |
| Use case behavior | `documentation/requirements/use-case-requirements.md` |
| Formal requirements | `documentation/requirements/requirements.md` |

Each current document starts with an `Ordered Refresh - 2026-06-20` section. That section is canonical.

## Historical Material

Older AWS/PHP/contact-form-era sections were moved to:

```text
documentation/planning/archive/historical-doc-conflicts-2026-06-20.md
```

Use archived material only for historical context. Do not treat archived use case IDs, requirement IDs, sprint status, AWS-first deployment steps, or PHP/contact-form behavior as current scope unless a new decision explicitly reactivates them.

## Working And Sprint Documents

Files under `documentation/planning/working/` are analysis and evidence. Files under `documentation/planning/sprints/` are sprint records or fallback plans. They may contain older observations; current durable docs win when there is a conflict.

Current high-level truth:

- Hosting: GitHub Pages is current; AWS static hosting is fallback only.
- Domain: GoDaddy forwarding remains a verification item.
- Backend/data: no RSVP, address, message, email form, PHP endpoint, database, or server runtime is current scope.
- Next likely work: verify final domain, refresh stale external links, and remove or archive unused legacy interaction assets.
