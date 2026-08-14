# Writing the feature spec

The spec is a durable contract between product intent, the repository, implementation, and review.

## Inputs

Use all of the following when available:

1. decisions from the current grilling conversation;
2. current behavior observed in the repository;
3. canonical language from `CONTEXT.md`;
4. accepted ADRs and project instructions;
5. existing contracts, tests, schemas, APIs, and operational constraints.

Do not silently resolve contradictions. Product behavior, durable architectural decisions, and current code may disagree; surface the disagreement and keep the spec in `DRAFT` until the owner resolves it.

## What belongs in the spec

- the before/after story in plain language;
- current and expected behavior;
- objectives and explicit non-objectives;
- affected users, roles, entities, data, and integrations;
- domain rules and invariants;
- pseudocode describing triggers, guards, transitions, and promises;
- testable acceptance criteria;
- errors, degraded states, retries, duplicates, concurrency, and permissions when relevant;
- technical constraints discovered from the repository;
- expected tests and operational verification;
- migration, rollout, rollback, observability, and compatibility when relevant;
- assumptions and unresolved questions.

## What does not belong

- final production code;
- full implementation bodies;
- finished screen designs unless a supplied design is itself an approved input;
- arbitrary technology choices not required by the repository;
- exhaustive file-by-file task lists for normal work;
- vague aspirations that cannot be observed or verified.

## Repository grounding

Inspect enough code to answer:

- Where does the current behavior live?
- Which existing abstractions or pipelines should be reused?
- What is the current source of truth?
- Which contracts must remain compatible?
- What tests demonstrate adjacent behavior?
- Which migrations, permissions, privacy rules, or operational constraints apply?

The spec may name relevant modules, tables, endpoints, events, or interfaces as existing context. It should not dictate exact code bodies unless compatibility requires a fixed contract.

## Acceptance criteria

Give every criterion a stable ID: `AC1`, `AC2`, and so on.

Prefer concrete scenarios:

```text
AC1 — Successful recurring booking
GIVEN an active member and three available weekly slots
WHEN the operator confirms the four-week pattern
THEN twelve bookings are created with the selected trainer and times.
```

Include the normal case and the principal failure or edge cases. Criteria must be independently reviewable.

## Readiness

Use `READY` only when:

- behavior and scope are explicit;
- no material product question remains open;
- rules, permissions, errors, and principal edge cases are defined;
- acceptance criteria are testable;
- repository constraints have been checked;
- the work can be implemented without inventing a product decision.

Before marking `READY`, re-check delivery scale. If the contract contains multiple independently implementable and reviewable outcomes, subsystems, permission/data boundaries, or migration/rollout stages, treat it as a parent spec and route to `idd split`. Never send a flat `LARGE` spec directly to implementation.

Otherwise use `DRAFT` and identify blockers precisely.
