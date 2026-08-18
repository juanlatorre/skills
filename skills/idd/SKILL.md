---
name: idd
description: "Inshallah Driven Development (IDD), a stateful software-delivery workflow for turning ideas, specs, or issues into verified code or an issue-backed delivery plan. IDD routes scope, grills decisions, preserves domain language and ADRs, writes repository-grounded specs, splits large work, can publish approved work as issues, implements isolated candidates, reviews them independently, and resumes deterministically with start/continue. Modes: start, continue, status, route, direct, grill, grill-docs, spec, split, implement, and review."
license: MIT. Adapted third-party portions are documented in THIRD_PARTY_NOTICES.md.
compatibility: Requires an Agent Skills-compatible coding agent with repository filesystem access. Managed start/continue workflows additionally require Git for durable local workflow state and candidate checkpoints. ISSUE delivery additionally requires access to a configured issue tracker for remote issue creation.
disable-model-invocation: true
metadata:
  author: juanlatorre
  version: "4.1.0"
---

# IDD — Inshallah Driven Development

IDD turns an idea, approved spec, or planned issue into a verified candidate while keeping workflow state explicit, durable, and resumable.

Version 4.1 adds a two-way delivery disposition once executable work exists:

```text
EXECUTE → deliver now through implementation + independent review
ISSUES  → publish the approved plan as thin tracker issues and park execution
```

There is no third disposition.

## Invocation

IDD is explicit. If the user did not request `idd`, `Inshallah Driven Development`, or one of these modes, show the modes and stop:

```text
idd start <idea | spec path | issue ref/url>
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

## Normal managed UX

```text
idd start <idea>
→ route
→ grill / grill-docs when needed
→ spec
→ split when LARGE
→ EXECUTE or ISSUES
```

### EXECUTE

```text
planning
→ fresh implementation
→ candidate checkpoint
→ fresh independent review
→ correction loop when needed
→ DONE
```

After planning, fresh sessions normally need only:

```text
idd continue
```

### ISSUES

```text
planning
→ publish thin issues pointing to approved specs
→ PLANNED / parked
→ stop
```

Later:

```text
idd start <issue ref/url>
```

Once that issue is actively being delivered, fresh sessions use `idd continue` until the issue reaches `APPROVE` or another real boundary.

## Core contracts

1. Use the user's language and preserve canonical repository terms.
2. Read applicable `AGENTS.md` and repository instructions before changing files.
3. Resolve bundled references relative to this skill directory and load only those needed for the current action.
4. Product decisions belong to the user; repository facts belong to the agent to investigate.
5. Never invent permissions, domain meaning, failure behavior, acceptance criteria, or product rules.
6. Never claim evidence, commands, tests, or criteria that were not actually verified.
7. Never push, open a pull request, merge, publish, release, deploy, tag, or mutate remote Git state unless explicitly requested.
8. Managed checkpoint commits are local workflow mechanics, not delivery authorization. See `references/CHECKPOINTS.md`.
9. Selecting `ISSUES` authorizes issue creation/relationship wiring for the current approved plan only. Starting an existing issue authorizes lifecycle updates only for that issue and directly related tracker metadata. See `references/ISSUES.md`.
10. Review is independent and read-only with respect to product/code artifacts; only Git-metadata workflow/review state may be written.
11. Specs store behavioral contracts only: `DRAFT` or `READY`. Execution/tracker state belongs to workflow state.
12. Every LARGE child has one candidate lineage and one review lineage. Never mix independently reviewable children into one candidate.
13. Do not silently cross a decision, delivery-disposition, isolation, safety, or blocker boundary.
14. IDD MAY auto-transition when exactly one valid next action exists, no user decision is required, no independent context is required, and no unapproved side effect is introduced.
15. Every completed action ends with `## Next step`. In active EXECUTE lineages the preferred command is usually `idd continue`.

## Required references

- managed state / `start` / `continue` / `status`: [workflow](references/WORKFLOW.md)
- issue planning/resume: [issues](references/ISSUES.md)
- managed commits/candidate isolation: [checkpoints](references/CHECKPOINTS.md)
- `route`, `direct`: [routing](references/ROUTING.md)
- `grill`: [grilling](references/GRILLING.md)
- `grill-docs`: [grilling](references/GRILLING.md), [domain modeling](references/DOMAIN_MODELING.md), [context format](references/CONTEXT_FORMAT.md), [ADR format](references/ADR_FORMAT.md)
- `spec`: [specification](references/SPECIFICATION.md), [spec template](references/SPEC_TEMPLATE.md)
- `split`: [large work](references/LARGE_WORK.md)
- `implement`: [implementation](references/IMPLEMENTATION.md), [checkpoints](references/CHECKPOINTS.md)
- `review`: [review](references/REVIEW.md), [checkpoints](references/CHECKPOINTS.md)

## Operational source of truth

Managed workflows require Git. Resolve metadata through the common Git directory as defined in `WORKFLOW.md`.

Responsibilities are intentionally separate:

```text
spec / child spec     → approved behavioral contract
CONTEXT.md / ADR      → durable domain knowledge and decisions
workflow JSON         → delivery disposition, execution state, dependencies, claims, candidates, issue refs, next action
Git commits           → exact planning/candidate states
review ledger         → currently open review findings
issue tracker         → visible planned/assigned delivery units pointing back to specs
```

Do not hand-maintain dynamic progress such as `DONE`, “next child”, candidate SHA, or review verdict in specs/README prose.

## Delivery disposition

When executable `READY` work first exists, managed workflows must resolve exactly one of:

```text
EXECUTE
ISSUES
```

If the user's natural-language request already chose one, persist it and do not ask again. Otherwise ask once, preferably with native structured UI:

```text
How do you want to continue?

1. Execute now
2. Take it to issues
```

Do not invent a third formal option.

- EXECUTE → create the planning checkpoint and stop at the fresh implementation boundary.
- ISSUES → create the planning checkpoint, publish the approved plan according to `ISSUES.md`, set workflow `PLANNED`, and stop.

A parked ISSUES workflow never auto-starts backlog work through `continue`; resume one unit explicitly with `idd start <issue>`.

## Destination, frontier, fog, and claims

Every managed workflow has a **destination**: the low-resolution definition of success.

For LARGE work:

- **children** are sharp independently implementable/reviewable outcomes;
- **frontier** is computed from READY + dependency + claim state;
- **fog** is in-scope work not yet sharp enough to become a child;
- **claims** prevent duplicate implementation.

Never invent children just to eliminate fog. Re-evaluate fog as approved work reveals more of the path.

## Optional subagent delegation

IDD is single-agent by default. Delegation is opt-in and allowed only for `split`, `implement`, and `review`. Never delegate `route`, `direct`, `grill`, `grill-docs`, or `spec`.

Examples:

```text
Use subagents for this implementation.
Use subagents for split and review in this workflow.
Use subagents for this workflow.
Do not use subagents.
```

Persist delegation preferences in managed workflow state.

When enabled:

1. the primary owns workflow state and final conclusions;
2. subagents receive explicit scope/boundaries/expected output;
3. implementation editing must be isolated and non-overlapping, preferably worktrees/branches;
4. review subagents are read-only and never issue the authoritative verdict;
5. if the host lacks delegation, continue single-agent and state that fact.

## Mandatory scale checkpoints

Classify during routing, then re-check:

1. when grilling closes;
2. before a spec becomes `READY`;
3. before implementation edits code.

A flat `LARGE` spec must not be implemented. Route it to parent + `split`.

# Managed modes

## `start`

Read `WORKFLOW.md` and `ISSUES.md` first.

`start` accepts an **idea**, **READY spec**, or **issue ref/URL**.

### Idea

1. Require Git and safe working-tree ownership.
2. Create managed workflow state with provisional destination, origin, explicit delegation preferences, and any delivery intent already stated by the user.
3. Route and auto-enter `direct`, `grill`, or `grill-docs` as appropriate.
4. Stop for real product questions; use native structured questioning when available.
5. After shared understanding, auto-run `spec` in the same planning session.
6. Auto-run `split` for LARGE when deterministic.
7. When READY executable work exists, resolve EXECUTE vs ISSUES.
8. EXECUTE → planning checkpoint → persist next action → stop for fresh implementation.
9. ISSUES → planning checkpoint → publish issues → `PLANNED` → stop.

### Spec

1. Resolve/read spec, parent/index, context, and ADRs.
2. Require `READY`; otherwise route to the missing definition work.
3. Re-check scale and split when required.
4. Resolve EXECUTE vs ISSUES if unset.
5. Proceed using the selected disposition.

### Issue

Follow `ISSUES.md`.

- IDD-created issue → locate workflow/spec, verify dependencies, claim it when supported, make it the active unit, and execute it without asking disposition again.
- parent/index issue → choose the next executable child only when appropriate, or enter integrated completion when children are DONE.
- ordinary unmarked issue → treat its body as the incoming change request, record it as origin, set disposition EXECUTE, then route/grill/spec as needed.

Because `start <issue>` is already a fresh delivery session, it may enter implementation immediately when the linked spec is READY.

At later isolation boundaries, persist state and end with native `idd continue`.

## `continue`

Read `WORKFLOW.md` and `ISSUES.md` first.

1. Resolve and reconcile the active workflow against Git, claims, candidate lineage, review ledger, fog, and tracker state when applicable.
2. EXECUTE disposition → run the one deterministic safe action until the next boundary.
3. ISSUES disposition + active issue → continue only that issue's lineage.
4. ISSUES disposition + `PLANNED` + no active issue → do **not** start backlog work. Report executable issue refs and remain parked.
5. Stop only at a decision, disposition choice, isolation boundary, blocker/unsafe state, park boundary, or completion.
6. Persist state before stopping.

## `status`

Read/reconcile workflow state without implementing, reviewing, or creating issues.

Return:

```text
Destination:
Workflow status:
Delivery disposition:
Tracker / planned issues:
Active issue:
Active spec/child:
Frontier:
Fog:
Claims:
Candidate lineage:
Open review findings:
Next deterministic action:
```

# Explicit phase modes

## `route`

Read `ROUTING.md`. Classify size + domain impact. Do not modify files. In managed mode, auto-transition when deterministic.

## `direct`

Re-check `TRIVIAL` before editing. Schema/migrations/permissions/external contracts/concurrency/domain decisions/meaningful ambiguity are not trivial.

- EXECUTE → implement localized behavior + focused verification; finish unless repository risk requires review.
- ISSUES → do not implement; publish one thin issue for the bounded change and park.

## `grill` and `grill-docs`

Read grilling references. Ask only the current decision frontier. MUST use `ask_user_question` or equivalent structured UI when available; fall back to Markdown only when unavailable/failing. Do not delegate grilling.

`grill-docs` additionally maintains canonical context and qualifying ADRs.

At closure: summarize, re-check scale, ask for confirmation. Managed mode auto-runs `spec` after confirmation; explicit mode returns the exact spec command.

## `spec`

Ground the contract in repository behavior/context/ADRs/tests/schemas. Use only `DRAFT` or `READY`. Re-check scale before READY.

- unresolved material decision → DRAFT + targeted grilling;
- one bounded outcome → READY;
- several independently reviewable outcomes → parent + split.

Do not store execution/tracker state in specs. Managed mode resolves delivery disposition before implementation.

## `split`

Read `LARGE_WORK.md`, `WORKFLOW.md`, and `ISSUES.md`.

Create only sharp vertical children; keep unresolved in-scope areas as fog. Record dependencies in workflow state. Optional split subagents may analyze; the primary owns final children/graph.

Do not implement. In ISSUES disposition, only sharp child specs become issues; fog does not.

## `implement`

Read `IMPLEMENTATION.md`, `CHECKPOINTS.md`, and workflow state.

Operate on exactly one reviewable unit:

- NORMAL EXECUTE → active spec;
- LARGE EXECUTE → one claimed child unless isolated delegated children run in separate worktrees;
- ISSUES → exactly the explicitly started/claimed issue's linked spec/child.

Require READY, re-check scale, read open review ledger first when corrective, verify ownership/candidate isolation, then implement. After required local verification, create the managed candidate checkpoint, persist exact base/candidate SHAs, clear implementation claim, set REVIEW_REQUIRED, and stop.

## `review`

Read `REVIEW.md`, `CHECKPOINTS.md`, and workflow state.

Review stable candidate lineage only:

- INITIAL → exact `base..candidate`;
- CORRECTIVE → previous candidate..corrective candidate + open findings/affected criteria;
- INTEGRATED PARENT → stable integrated parent candidate after required children DONE.

Candidate isolation failure is not a reason to run duplicate giant reviews; return recovery/CANNOT VERIFY guidance.

Allowed verdicts:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

On APPROVE: record candidate approval, clear ledger, mark active unit DONE, recompute frontier/fog, never reopen unrelated approved children. In issue-driven delivery, complete/close the active issue when permitted and clear it. NORMAL ISSUES becomes DONE; LARGE ISSUES returns to PLANNED after a child approval until final parent integration is explicitly started.

On CHANGES_REQUIRED: persist/update ledger and keep the same unit/issue active for corrective implementation.

After two corrective review rounds, persistent serious findings trigger `REPLAN_REQUIRED` instead of a blind patch loop.

# LARGE invariants

```text
one child
→ one claim
→ one candidate lineage
→ one independent review lineage
→ DONE
```

- Dependencies unlock only from DONE children.
- Mixed child candidates are invalid.
- Parallel implementation requires isolation.
- Approved children remain closed.
- EXECUTE may proceed through deterministic frontier choices after isolation boundaries.
- ISSUES never auto-starts another backlog child; use `idd start <issue>`.
- Reconcile/graduate fog before final parent review.
- Parent APPROVE completes the workflow.

# Completion

```text
PLANNED → approved work exists as tracker issues; execution intentionally parked
DONE    → destination delivered and required independent verification closed
```

Final delivery output:

```text
## Next step

IDD complete. No further IDD command is required.
```
