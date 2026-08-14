# Decomposing large work

A parent spec explains the complete product outcome and cross-cutting rules. Child specs are independently implementable and verifiable slices of that outcome.

## Parent spec responsibilities

The parent owns:

- the overall before/after story;
- global objectives and non-objectives;
- canonical terms and cross-cutting invariants;
- system-level actors, permissions, data ownership, and compatibility;
- integrated acceptance criteria;
- rollout order and final success measures.

It must not become a giant implementation checklist.

## Child spec rules

Each child must:

- deliver a vertical behavior, not merely a technical layer;
- reference the parent and inherited invariants;
- define its own bounded story, scope, rules, acceptance criteria, errors, tests, and dependencies;
- be implementable and reviewable in one reliable session when practical;
- leave the system in a coherent state when completed;
- avoid duplicating parent decisions.

If a child still contains multiple independently verifiable outcomes or repeatedly produces new review waves, it is not a usable child boundary. Split or redefine that child before continuing implementation.

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

unless the architecture or deployment boundary makes them independently valuable.

## Output layout

```text
docs/specs/<parent-slug>.md
docs/specs/<parent-slug>/
├── README.md
├── 01-<slice>.md
├── 02-<slice>.md
└── 03-<slice>.md
```

The child index must include:

| Child | Outcome | Depends on | Can run in parallel | Status |
|---|---|---|---|---|
| ... | ... | ... | yes/no | DRAFT/READY |

Also include:

- inherited invariants;
- integration order;
- shared migration/rollout constraints;
- integrated final-review checklist.

## Grilling child specs

After the parent domain is settled:

- use `/skill:idd grill` for a child that only applies established terms and rules;
- use `/skill:idd grill-docs` for a child that introduces new concepts or changes a transversal decision.

## Convergence

Each child has its own bounded implementation and review ledger. A corrective re-review verifies only open findings and the corrective delta; it does not reopen approved siblings.

After all required children are independently `DONE`, run one integrated parent review for cross-child invariants, end-to-end behavior, and rollout composition. Reuse child evidence unless integration changes invalidate it.
