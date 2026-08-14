# Routing changes

Classify on two axes. Size determines delivery structure. Domain impact determines whether the repository's shared language or durable decisions must change.

## Size

### `TRIVIAL`

Use only when all are true:

- behavior is already unambiguous;
- the change is localized and reversible;
- no new domain concept or cross-feature rule is introduced;
- no schema migration, permission model, external contract, concurrency rule, or rollout decision is required;
- verification is narrow and obvious;
- a durable spec would cost more than the ambiguity it removes.

Examples: copy correction, localized validation, obvious bug fix with a known cause, small styling correction, dependency-safe mechanical edit.

### `NORMAL`

Use when the work is one coherent feature or behavioral change that should fit in one implementation session after decisions are closed.

Typical signals:

- multiple files or layers are involved;
- acceptance criteria and edge cases matter;
- behavior must be discussed before implementation;
- data, permissions, integration, or error handling may be involved, but the work still has one clear boundary;
- one spec can remain the source of truth.

### `LARGE`

Use when one implementation session or one flat spec would hide material independent work.

Typical signals:

- several subsystems or deployable slices are involved;
- multiple models or contributors can work independently;
- rollout, migration, compatibility, or operational sequencing is substantial;
- several user-visible capabilities need separate acceptance criteria;
- the parent outcome is clear but delivery must be divided into child outcomes;
- the context would become too large for reliable implementation or review.

Do not classify purely by line count. A small diff can still be high-risk, while a broad mechanical migration can remain operationally simple.

## Domain impact

### `STABLE`

Use when the change applies terms, ownership boundaries, and durable decisions already established by `CONTEXT.md`, ADRs, code, and product language.

Recommended grilling mode:

```text
/skill:idd grill <idea>
```

### `NEW/TRANSVERSAL`

Use when any of these is true:

- a business concept is introduced, split, renamed, or redefined;
- two people or modules use one word for different things;
- the change establishes a source-of-truth or authority boundary;
- a hard-to-reverse decision has real alternatives;
- the decision will shape many future features;
- current code and stated product language disagree;
- another model could reasonably interpret the terms differently.

Recommended grilling mode:

```text
/skill:idd grill-docs <idea>
```

## Route matrix

| Size | Stable domain | New/transversal domain |
|---|---|---|
| `TRIVIAL` | `direct` | Reclassify as `NORMAL` |
| `NORMAL` | `grill → spec → implement → review` | `grill-docs → spec → implement → review` |
| `LARGE` | `grill-docs` is still recommended at parent level | `grill-docs → parent spec → child specs → implementations → final review` |

## Guardrails

- A high-risk area is not trivial merely because the diff is small.
- A large feature does not require `grill-docs` on every child.
- Use `grill` for children whose domain is already settled.
- `grill-docs` is not a fourth size category. It is the grilling variant for durable domain knowledge.
- Classification is provisional until grilling closes and the complete contract is visible.
- Re-check size before a spec becomes `READY` and again before implementation edits code.
- If one flat spec contains several independently verifiable behaviors, subsystems, permission/data boundaries, or migration stages, reclassify it as `LARGE` and run `split`.
- A change that cannot be implemented and independently reviewed reliably in one bounded cycle is operationally `LARGE`, even when its product story sounds singular.
