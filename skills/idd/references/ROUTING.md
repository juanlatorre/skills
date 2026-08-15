# Routing changes by size and domain impact

Classify on two axes. Size determines delivery structure. Domain impact determines whether shared language/durable decisions must change.

## Size

### `TRIVIAL`

Use only when all are true:

- behavior is already unambiguous;
- change is localized and reversible;
- no new domain concept/cross-feature rule;
- no schema migration, permission model, external contract, concurrency rule, or rollout decision;
- verification is narrow and obvious;
- a durable spec would cost more than the ambiguity it removes.

Examples: copy correction, localized validation, obvious bug fix with a known cause, small styling correction, dependency-safe mechanical edit.

### `NORMAL`

One coherent behavior that should fit one implementation candidate and one independent review lineage after decisions are closed.

Signals:

- multiple files/layers may be involved;
- acceptance criteria and edge cases matter;
- behavior needs discussion;
- data, permissions, integration, or error handling may be involved;
- one spec remains a reliable contract;
- one candidate commit can represent the whole implementation safely.

### `LARGE`

One flat spec/candidate/review would hide material independent work.

Signals:

- several user-visible capabilities or subsystems;
- multiple contributors can work independently;
- substantial rollout/migration/compatibility sequencing;
- several permission/data boundaries;
- parent outcome is clear but delivery needs child outcomes;
- one candidate/reviewer would repeatedly lose context;
- independently reviewable children are likely.

Do not classify by line count alone.

## Domain impact

### `STABLE`

Existing terms, ownership boundaries, and durable decisions are already established.

Use `grill` for NORMAL work.

### `NEW/TRANSVERSAL`

Use when a business concept is introduced/split/renamed/redefined, authority/source-of-truth shifts, real hard-to-reverse alternatives exist, terminology conflicts, or the decision shapes many future features.

Use `grill-docs`.

## Route matrix

| Size | Stable domain | New/transversal domain |
|---|---|---|
| `TRIVIAL` | `direct` | Reclassify as NORMAL |
| `NORMAL` | `grill → spec → candidate → review` | `grill-docs → spec → candidate → review` |
| `LARGE` | parent-level `grill-docs` recommended | `grill-docs → parent → split → child lineages → parent review` |

In a managed `start` workflow, deterministic routing auto-transitions into the selected mode. The user should not have to copy the route's next command when no decision exists.

## Guardrails

- High-risk is not trivial merely because diff is small.
- LARGE does not require grill-docs on every child.
- Use grill for children whose domain is already settled.
- Re-check size when grilling closes, before READY, and before implementation.
- If one flat spec contains independently reviewable behaviors, permission/data boundaries, or migration stages, route to split.
- If a single candidate cannot be isolated and independently reviewed reliably, the work is operationally LARGE.
