# PRD — <Feature name>

- **Status:** DRAFT | READY
- **Owner:** <name or TBD>
- **Created:** YYYY-MM-DD
- **Size:** NORMAL | LARGE-PARENT | LARGE-CHILD
- **Domain impact:** STABLE | NEW/TRANSVERSAL
- **Scope:** <one sentence>
- **Parent:** <path or none>
- **Related ADRs:** <links or none>

## 1. Summary

**Today:** <current observable behavior>

**After:** <future observable behavior>

## 2. Story

### Before

<Who experiences the problem, at what moment, what happens, and why it matters. No technical jargon.>

### After

<The same moment after the feature exists.>

## 3. Objectives and non-objectives

### Objectives

- **O1:** ...
- **O2:** ...

### Non-objectives

- **NO1:** ...
- **NO2:** ...

## 4. Current flow → future flow

### Current

```text
...
```

### Future

```text
...
```

## 5. Actors, roles, and permissions

| Actor or role | Can do | Cannot do | Notes |
|---|---|---|---|
| ... | ... | ... | ... |

Remove this section only when permissions genuinely do not apply.

## 6. Domain, entities, and data

### Canonical terms

- **Term:** concise meaning. `_Avoid: synonym, overloaded term_`

Reference `CONTEXT.md` instead of duplicating established definitions.

### Affected entities and data

| Entity/data | Current meaning/source | Required change | Authority/owner |
|---|---|---|---|
| ... | ... | ... | ... |

### Triggers and integrations

- Trigger: ...
- Existing pipeline or integration to reuse: ...
- External dependency: ...

## 7. Rules and invariants

- **R1:** The system MUST ...
- **R2:** The system MUST NOT ...
- **I1:** ... remains true before and after the operation.

Cover idempotency, ordering, concurrency, privacy, retries, and compatibility when relevant.

## 8. Pseudocode — behavioral agreement

```text
WHEN ...
IF ... THEN ...
IF ... THEN stop because ...
OTHERWISE ...
PROMISES:
- ...
- ...
```

Describe triggers, guards, state changes, and promises. Do not include final code.

## 9. Acceptance criteria

### AC1 — <normal case>

**GIVEN** ...

**WHEN** ...

**THEN** ...

### AC2 — <principal edge or failure case>

**GIVEN** ...

**WHEN** ...

**THEN** ...

Add criteria until every objective and material rule is verifiable.

## 10. Errors, degraded states, and edge cases

| Situation | Expected safe state | User/system feedback | Retry or recovery | Observability |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

## 11. Repository constraints and reuse

- Current implementation area: ...
- Existing abstraction/pipeline to reuse: ...
- Contracts that must remain compatible: ...
- Prohibited shortcuts: ...
- Performance/security/privacy constraints: ...

## 12. Test and verification strategy

- Unit/domain tests: ...
- Integration/contract tests: ...
- UI/end-to-end checks: ...
- Static checks: ...
- Manual or operational verification: ...

Map each acceptance criterion to at least one verification method.

## 13. Migration, rollout, and rollback

- Data migration/backfill: ...
- Feature flag or staged rollout: ...
- Compatibility window: ...
- Rollback path: ...
- Metrics/alerts: ...

Write `Not applicable — <reason>` when genuinely unnecessary.

## 14. Assumptions and open questions

### Confirmed assumptions

- ...

### Blocking questions

- None.

A spec with blocking questions remains `DRAFT`.
