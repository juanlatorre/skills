---
name: idd
description: "Inshallah Driven Development (IDD), a stateful software-delivery workflow for turning ideas into verified code. IDD routes scope, grills decisions, preserves domain language and ADRs, writes repository-grounded specs, splits large work, implements isolated candidates, reviews them independently, and can resume deterministically with start/continue. Modes: start, continue, status, route, direct, grill, grill-docs, spec, split, implement, and review."
license: MIT. Adapted third-party portions are documented in THIRD_PARTY_NOTICES.md.
compatibility: Requires an Agent Skills-compatible coding agent with repository filesystem access. Managed start/continue workflows additionally require Git for durable local workflow state and candidate checkpoints.
disable-model-invocation: true
metadata:
  author: juanlatorre
  version: "4.0.0"
---

# IDD — Inshallah Driven Development

IDD turns an idea into a verified candidate while keeping the workflow itself explicit, durable, and resumable.

Version 4 introduces a managed workflow map inspired by wayfinding concepts: **destination, frontier, fog, claims, candidate lineage, and deterministic continuation**.

## Invocation

IDD is explicit. If the user did not request `idd`, `Inshallah Driven Development`, or one of these modes, show the modes and stop:

```text
idd start <change or idea>
idd continue [workflow id]
idd status [workflow id]
idd route <change or idea>
idd direct <small explicit change>
idd grill <plan, decision, or feature>
idd grill-docs <plan, decision, or feature>
idd spec <slug or destination path>
idd split <parent spec path>
idd implement <spec path>
idd review <spec path> [base commit]
```

Aliases: `grill-me → grill`, `grill-with-docs → grill-docs`.

Use the current host's native explicit syntax when known:

```text
Pi:          /skill:idd <mode> <arguments>
Claude Code: /idd <mode> <arguments>
Codex:       $idd <mode> <arguments>, or select idd through /skills
```

Otherwise use host-neutral notation and label it.

## Two ways to use IDD

### Managed workflow — recommended

Use `start` once, then `continue` from fresh sessions:

```text
idd start <idea>
→ decisions when required
→ deterministic steps auto-advance
→ fresh-session boundary

idd continue
→ next deterministic action
→ fresh-session boundary

idd continue
→ ...
```

The user should not need to remember spec paths, child numbers, review bases, candidate SHAs, or which phase comes next.

### Explicit modes — advanced / compatibility

The individual modes remain available. They perform one bounded phase and return an exact next step, but they do not provide all managed-workflow guarantees unless an active workflow exists.

## Core contracts

1. Use the user's language and preserve canonical repository terms.
2. Read applicable `AGENTS.md` and repository instructions before changing files.
3. Resolve bundled references relative to this skill directory.
4. Load only references required by the current action.
5. Product decisions belong to the user; repository facts belong to the agent to investigate.
6. Never invent permissions, domain meaning, failure behavior, acceptance criteria, or product rules.
7. Never claim evidence, commands, tests, or criteria that were not actually verified.
8. Never push, open a pull request, merge, publish, release, deploy, tag, or mutate remote state unless explicitly requested.
9. Managed workflow checkpoint commits are local workflow mechanics, not delivery authorization. See `references/CHECKPOINTS.md`.
10. Review is independent and read-only with respect to product/code artifacts; only Git-metadata workflow/review state may be written.
11. Specs store behavioral contracts only: `DRAFT` or `READY`. Execution status belongs to workflow state.
12. Every child in LARGE work has exactly one candidate lineage and one review lineage. Do not mix independently reviewable children into one candidate.
13. Do not silently cross a **decision boundary**, **isolation boundary**, **safety boundary**, or **blocker**.
14. IDD MAY auto-transition when exactly one valid next action exists, no user decision is required, no independent context is required, and the transition adds no unapproved external side effect.
15. Every completed action ends with `## Next step`. In managed workflows the preferred command is usually `idd continue`.

## Required references

- managed state / `start` / `continue` / `status`: [workflow](references/WORKFLOW.md)
- managed commits and candidate isolation: [checkpoints](references/CHECKPOINTS.md)
- `route`, `direct`: [routing](references/ROUTING.md)
- `grill`: [grilling](references/GRILLING.md)
- `grill-docs`: [grilling](references/GRILLING.md), [domain modeling](references/DOMAIN_MODELING.md), [context format](references/CONTEXT_FORMAT.md), [ADR format](references/ADR_FORMAT.md)
- `spec`: [specification](references/SPECIFICATION.md), [spec template](references/SPEC_TEMPLATE.md)
- `split`: [large work](references/LARGE_WORK.md)
- `implement`: [implementation](references/IMPLEMENTATION.md), [checkpoints](references/CHECKPOINTS.md)
- `review`: [review](references/REVIEW.md), [checkpoints](references/CHECKPOINTS.md)

## Managed workflow state

Managed workflows require Git. Resolve shared metadata through the common Git directory, never a literal `.git/` path:

```sh
GIT_COMMON_DIR="$(git rev-parse --path-format=absolute --git-common-dir)"
IDD_DIR="$GIT_COMMON_DIR/idd"
WORKFLOW_DIR="$IDD_DIR/workflows"
REVIEW_DIR="$IDD_DIR/reviews"
```

The workflow JSON in `WORKFLOW_DIR` is the **single operational source of truth**.

Other artifacts have one responsibility each:

```text
spec / child spec     → approved behavioral contract
CONTEXT.md / ADR      → durable domain knowledge and decisions
workflow JSON         → execution state, dependencies, claims, candidates, next action
Git commits           → exact candidate states
review ledger         → currently open review findings
```

Do not store dynamic execution state such as `DONE`, `next child`, candidate SHA, or review verdict in specs or hand-maintained README prose.

## Destination, frontier, fog, and claims

Every managed workflow has a **destination**: one or two lines describing what successful completion means.

For LARGE work:

- **children** are sharp, independently implementable/reviewable outcomes;
- **frontier** is computed, not manually stored: READY children whose dependencies are DONE and which are not actively claimed;
- **fog** contains in-scope work that is visible but not yet precise enough to become a child;
- **claims** prevent two sessions/worktrees from implementing the same child.

Never invent a complete child graph just to eliminate fog. Re-evaluate fog as approved children reveal more of the path.

## Optional subagent delegation

IDD is single-agent by default. Delegation is opt-in and allowed only for `split`, `implement`, and `review`. Never delegate `route`, `direct`, `grill`, `grill-docs`, or `spec`.

User controls include:

```text
Use subagents for this implementation.
Use subagents for split and review in this workflow.
Use subagents for this workflow.
Do not use subagents.
```

Persist delegation preferences in managed workflow state so fresh sessions retain them.

When delegation is enabled:

1. the primary agent owns workflow state and final conclusions;
2. subagents receive explicit scope, inputs, boundaries, and expected output;
3. subagent output is candidate evidence/work, never self-validating;
4. if host delegation is unavailable, continue single-agent and state that fact;
5. implementation subagents must use isolated non-overlapping work, preferably separate worktrees/branches when editing concurrently;
6. review subagents are read-only and never issue the authoritative verdict.

## Mandatory scale checkpoints

Classify during routing, then re-check:

1. when grilling closes;
2. before a spec becomes `READY`;
3. before implementation edits code.

Reclassify to `LARGE` when one bounded implementation/review cycle would hide independently verifiable behaviors, permission/data boundaries, rollout/migration stages, or too much context.

A flat `LARGE` spec must not be implemented. Route it to parent + `split`.

# Managed modes

## `start`

Read `references/WORKFLOW.md` first.

`start` creates a managed workflow and auto-advances until the first real boundary.

1. Require Git and inspect repository/worktree state.
2. Refuse to absorb unrelated dirty work into the workflow. If unrelated changes exist and cannot be safely excluded, stop and explain.
3. Create workflow state with:
   - workflow id;
   - provisional destination;
   - originating branch/worktree;
   - delegation preferences explicitly provided by the user;
   - status `ACTIVE`.
4. Run routing.
5. Auto-transition when deterministic:
   - `TRIVIAL` → `direct`;
   - `NORMAL + STABLE` → `grill`;
   - `NORMAL + NEW/TRANSVERSAL` → `grill-docs`;
   - `LARGE` → parent-level `grill-docs`.
6. During grilling, stop for the questionnaire whenever product decisions are required.
7. After shared understanding is confirmed, auto-run `spec` in the same session because no isolation boundary exists.
8. If the spec is LARGE, auto-run `split` in the same planning session when no new user decision is required.
9. Create the planning checkpoint required by `references/CHECKPOINTS.md`.
10. Persist the next deterministic action and stop at the fresh-session implementation boundary.

End with:

```text
## Next step

Fresh implementation context required.
Run: idd continue
```

Render the native host syntax.

## `continue`

Read `references/WORKFLOW.md` first.

`continue` is the normal command after `start`.

1. Resolve active workflow:
   - use the named id if provided;
   - otherwise prefer an ACTIVE workflow bound to the current branch/worktree;
   - otherwise use the only ACTIVE workflow in this repository;
   - if multiple plausible workflows remain, use a structured user choice when available.
2. Reconcile workflow state with Git before acting. Never trust stale state blindly.
3. Recompute dependencies, frontier, claims, candidate lineage, open review ledger, and fog.
4. If exactly one valid next action exists and no boundary requires user input, execute it.
5. If multiple frontier children are valid:
   - with implementation delegation enabled and safe isolation available, the primary may claim and dispatch independent children;
   - otherwise take the first frontier child in declared order unless the ordering is product-significant; ask only when a real choice matters.
6. Stop only at:
   - a product decision/questionnaire;
   - an isolation boundary requiring a fresh independent session;
   - a blocker or unsafe repository state;
   - workflow completion.
7. Persist state before stopping.

Typical managed sequence:

```text
continue → implement → candidate checkpoint → stop for independent review
continue → review → APPROVE → choose next frontier → stop for implementation
continue → review → CHANGES REQUIRED → stop for corrective implementation
continue → corrective implement → corrective candidate checkpoint → stop for review
```

## `status`

Read and reconcile the workflow without implementing or reviewing anything.

Return:

```text
Destination:
Workflow status:
Active spec/child:
Frontier:
Fog:
Claims:
Candidate lineage:
Open review findings:
Next deterministic action:
```

Do not mutate product/code artifacts. Repair only obviously stale Git-metadata state when the correction is mechanical and evidence is conclusive; otherwise report the inconsistency.

# Explicit phase modes

## `route`

Read `references/ROUTING.md`. Classify:

```text
Size: TRIVIAL | NORMAL | LARGE
Domain impact: STABLE | NEW/TRANSVERSAL
Reason: <brief evidence>
Recommended flow: <workflow>
```

Do not modify files. In a managed workflow, auto-transition if deterministic. Otherwise return the exact next explicit command.

## `direct`

Re-check `TRIVIAL`. Schema, migrations, permissions, external contracts, concurrency, durable domain decisions, or meaningful ambiguity are not trivial.

For a true trivial change, implement the localized behavior and narrow verification. Managed workflows may finish immediately; no candidate/review cycle is required unless repository policy or risk demands it.

If not trivial, do not edit; route upward.

## `grill` and `grill-docs`

Read the grilling references. Build a design tree and ask only the current decision frontier.

When the host exposes `ask_user_question` or equivalent structured UI, MUST use it for selectable grilling questions. Put the recommended option first and label it `(Recommended)` when the tool supports that convention. Fall back to Markdown only when native interactive questioning is unavailable or fails.

Do not delegate grilling.

`grill-docs` additionally maintains canonical context and qualifying ADRs as decisions are accepted.

At closure:

1. summarize decisions, facts, assumptions, non-goals, and residual uncertainty;
2. re-check scale;
3. ask the user to confirm shared understanding.

In a managed workflow, confirmation auto-transitions to `spec` in the same session. In explicit mode, return the exact `spec` command.

## `spec`

Read the specification references. Ground the contract in current repository behavior, domain context, ADRs, tests, schemas, and operational constraints.

Use only:

```text
DRAFT
READY
```

Before `READY`, re-check scale.

- unresolved material decision → `DRAFT` and targeted grilling;
- one bounded outcome → `READY`;
- multiple independently reviewable outcomes → parent spec and `split`.

Do not store execution status in the spec.

In managed mode, auto-transition to `split` for LARGE work when deterministic, create the planning checkpoint, then stop at the fresh implementation boundary.

## `split`

Read `references/LARGE_WORK.md` and `references/WORKFLOW.md`.

Create only child specs that are sharp enough now. Record unresolved but in-scope areas as workflow **fog** instead of inventing premature children.

Each child must be vertical, independently implementable, independently reviewable, and mapped to dependencies in workflow state.

When delegation is enabled for split, subagents may independently analyze decomposition/dependencies; the primary alone owns the final child plan and workflow graph.

Do not implement.

## `implement`

Read `references/IMPLEMENTATION.md`, `references/CHECKPOINTS.md`, and active workflow state when present.

Implementation must operate on exactly one reviewable unit:

- NORMAL workflow → active spec;
- LARGE workflow → exactly one claimed child, unless isolated delegated children are running in separate worktrees.

Before editing:

1. require `READY`;
2. re-check scale;
3. resolve any open review ledger before broad exploration;
4. verify candidate isolation and working-tree ownership;
5. claim the child when applicable.

Initial implementation completes the bounded contract. Corrective implementation addresses only open blocking/important findings and affected seams.

When delegation is enabled, use subagents only for isolated non-overlapping work. The primary integrates their contributions into one candidate for the active unit.

After required local verification succeeds, create the managed candidate checkpoint. A candidate must not contain another child's implementation.

Persist exact base and candidate SHAs, clear the implementation claim, set next state to independent review, and stop.

## `review`

Read `references/REVIEW.md`, `references/CHECKPOINTS.md`, and workflow state when present.

Review a stable candidate lineage, not “whatever is currently on the branch”.

- INITIAL: review exact `base..candidate` for one spec/child.
- CORRECTIVE: review previous candidate → corrective candidate, open finding IDs, affected criteria, and regressions caused by the correction.
- INTEGRATED PARENT: review the integrated parent range after all required children are DONE.

If candidate isolation cannot be proven, return `CANNOT VERIFY` or workflow recovery guidance; never run two nominal child reviews over the same mixed giant diff and pretend they are independent.

Delegated review may use distinct read-only lenses. The primary validates/deduplicates findings and issues the single verdict.

Allowed verdicts:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

On `APPROVE`:

- close the candidate review in workflow state;
- remove open review ledger;
- mark standalone workflow or child `DONE`;
- recompute the LARGE frontier and fog;
- never reopen unrelated approved children.

On `CHANGES REQUIRED`:

- persist/update the stable finding ledger;
- set next action to corrective implementation of the same unit.

After two corrective review rounds, persistent serious findings trigger `REPLAN REQUIRED`, not another blind patch loop.

# LARGE workflow invariants

These rules are non-negotiable in managed LARGE workflows:

```text
one child
→ one claim
→ one candidate lineage
→ one independent review lineage
→ DONE
```

- A child cannot become DONE without `APPROVE`.
- Dependencies unlock only from DONE children.
- A candidate commit that mixes independently reviewable children is invalid.
- Parallel child implementation requires isolation.
- Approved child candidates may be integrated locally in dependency order.
- When all required children are DONE, reconcile/graduate fog before declaring the frontier empty.
- Only after all required children are DONE and integration is stable may IDD create/use an integration checkpoint and run the integrated parent review.
- Parent `APPROVE` completes the workflow.

# Completion

A managed workflow completes only when its destination is satisfied and the required verification path is closed:

```text
TRIVIAL → verified direct change
NORMAL  → candidate reviewed APPROVE
LARGE   → all required children APPROVE + integrated parent review APPROVE
```

Final output:

```text
## Next step

IDD complete. No further IDD command is required.
```
