# Decomposing large work

A parent spec explains the complete outcome and cross-cutting contract. Child specs are sharp, independently implementable and independently reviewable outcomes toward that destination.

IDD 4 does not require the whole future to be known before work begins. It distinguishes **children** from **fog** and computes a live **frontier** from dependencies and claims.

## Parent responsibilities

The parent owns:

- destination / overall before-and-after story;
- global objectives and non-objectives;
- canonical terms and cross-cutting invariants;
- system-level actors, permissions, data ownership, and compatibility;
- integrated acceptance criteria;
- rollout/migration constraints and final success measures.

It must not become a giant implementation checklist or execution-status dashboard.

## Child rules

Each child must:

- deliver a vertical observable outcome, not merely a technical layer;
- reference the parent and inherited invariants;
- define its own bounded story, scope, rules, acceptance criteria, errors, tests, and dependencies;
- fit one reliable implementation/candidate/review lineage;
- leave the system coherent when completed;
- avoid duplicating parent decisions.

If a child still contains several independently reviewable outcomes or repeatedly produces new review waves, it is not a usable boundary. Split or redefine it.

Prefer:

```text
01-define-availability.md
02-create-recurring-bookings.md
03-handle-exceptions-and-rescheduling.md
```

Avoid horizontal slices such as:

```text
backend.md
frontend.md
database.md
```

unless architecture/deployment makes them independent outcomes.

## Static docs versus dynamic workflow state

Recommended layout:

```text
docs/specs/<parent-slug>.md
docs/specs/<parent-slug>/
├── README.md
├── 01-<slice>.md
├── 02-<slice>.md
└── 03-<slice>.md
```

The README/index is a **static map**, not the execution truth. It may describe:

| Child | Outcome | Depends on | Can run in parallel |
|---|---|---|---|
| ... | ... | ... | yes/no |

Do not hand-maintain dynamic columns such as `DONE`, candidate SHA, review verdict, or “next child” in that README. Those belong to managed workflow JSON.

This avoids the same state being contradicted by README, child spec, Git, and review output.

## Fog

Do not create children for work that is visible but not yet sharp enough to state as one bounded outcome.

Put that area in managed workflow `fog` instead.

The test is:

- **child** when the outcome and acceptance boundary can be stated precisely now, even if blocked;
- **fog** when the area is in scope but its correct outcome/boundary still depends on information that later children will reveal.

After each child approval, reevaluate fog. Graduate only what has become sharp.

## Dependencies and frontier

Store child dependencies in workflow state when `split` creates the plan.

The runtime frontier is computed as READY, unblocked, unclaimed children.

Declared order is the default execution order when several frontier children are equivalent. Do not ask the user to choose merely to preserve ceremony.

When a choice changes product delivery, rollout, risk, or cost materially, ask.

## Claims

Before implementing a child, claim it in workflow state. Other sessions skip active claims.

Claims are especially important with subagents/worktrees. A child has one owner at a time and one candidate lineage.

## One child = one lineage

Every LARGE child follows:

```text
READY
→ CLAIMED
→ IMPLEMENTING
→ candidate checkpoint
→ REVIEW_REQUIRED
→ APPROVE → DONE
             or
  CHANGES_REQUIRED
→ corrective candidate
→ corrective review
→ DONE / REPLAN_REQUIRED
```

A candidate may not contain another independently reviewable child's implementation.

If two children are implemented concurrently, use separate worktrees/branches or equivalent isolation.

## Delegated split analysis

Delegation for `split` is optional and user-controlled.

When enabled, subagents may independently analyze:

- candidate vertical decompositions;
- dependency edges;
- inherited invariants;
- rollout boundaries;
- safe parallelism;
- likely fog.

They do not write authoritative child specs or mutate workflow state independently. The primary reconciles their analysis and owns the final plan.

## Child grilling

After the parent domain is settled:

- use `grill` for a child that only applies established domain rules;
- use `grill-docs` only when a child introduces a genuinely new/transversal concept or changes a durable decision.

Do not re-grill already settled parent decisions.

## Integration and completion

Approved children remain closed. Corrective reviews do not reopen unrelated siblings.

After all required children are DONE:

1. reevaluate fog;
2. graduate newly sharp required work before final review;
3. ensure all approved candidates are integrated on the workflow's integration branch/worktree;
4. create/use a stable integration candidate;
5. run one integrated parent review for cross-child invariants, end-to-end behavior, permissions/data ownership, migration/rollout composition, and parent acceptance criteria.

Reuse child approvals unless integration evidence invalidates them.

The parent becomes DONE only after integrated `APPROVE`.
