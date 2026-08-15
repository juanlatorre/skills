# Writing the feature spec

The spec is a durable behavioral contract between product intent, repository reality, implementation, and review. It is not workflow history.

## Inputs

Use when available:

1. decisions from the current grilling conversation;
2. current behavior observed in the repository;
3. canonical language from `CONTEXT.md`;
4. accepted ADRs and repository instructions;
5. existing contracts, tests, schemas, APIs, and operational constraints.

Do not silently resolve contradictions. Keep the spec DRAFT until a material conflict is resolved.

## What belongs

- before/after story;
- current and expected behavior;
- objectives and explicit non-objectives;
- affected users, roles, entities, data, integrations;
- rules and invariants;
- behavioral pseudocode;
- testable acceptance criteria;
- errors/degraded states/retries/duplicates/concurrency/permissions when relevant;
- technical constraints discovered from the repository;
- expected tests and operational verification;
- migration, rollout, rollback, observability, compatibility;
- assumptions and unresolved questions.

## What does not belong

- final production code or full bodies;
- dynamic execution state (`IMPLEMENTED`, `DONE`, candidate SHA, review verdict, next child);
- finished screens unless approved input;
- arbitrary technology choices not required by repository constraints;
- exhaustive file-by-file task lists for NORMAL work;
- vague aspirations that cannot be observed or verified.

## Repository grounding

Inspect enough code to answer:

- where current behavior lives;
- which abstractions/pipelines should be reused;
- current source of truth;
- contracts that must remain compatible;
- tests demonstrating adjacent behavior;
- migrations, permissions, privacy, or operational constraints.

The spec may name modules/tables/endpoints/events/interfaces as context without dictating exact code bodies.

## Acceptance criteria

Give every criterion stable IDs (`AC1`, `AC2`, ...).

Prefer concrete scenarios:

```text
AC1 — Successful recurring booking
GIVEN an active member and three available weekly slots
WHEN the operator confirms the four-week pattern
THEN twelve bookings are created with the selected trainer and times.
```

Criteria must be independently reviewable.

## Readiness and scale

Use only:

```text
DRAFT
READY
```

READY requires:

- explicit behavior/scope;
- no material product question;
- rules/permissions/errors/principal edge cases defined;
- testable acceptance criteria;
- repository constraints checked;
- implementation does not require inventing product behavior.

Before READY, re-check scale:

- one bounded candidate/review outcome → NORMAL READY;
- multiple independently implementable/reviewable outcomes → LARGE parent, then split;
- unresolved decision → DRAFT.

Never send a flat LARGE spec directly to implementation.

## Managed workflow planning checkpoint

In a managed workflow, once planning is stable:

- NORMAL: READY spec + accepted context/ADR changes form the planning checkpoint;
- LARGE: parent + sharp child specs/static map + accepted context/ADR changes form the planning checkpoint.

Execution status remains in workflow JSON, not in the spec.
