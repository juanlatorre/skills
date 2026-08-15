# Implementing from a spec

The approved spec is the behavioral contract. The repository is the technical reality. Implementation must satisfy both without silently changing either.

In IDD 4 managed workflows, implementation produces a **stable local candidate commit** for exactly one reviewable unit.

## Entry gate

1. Read the complete active spec and parent/static index when applicable.
2. Read applicable `AGENTS.md`, `CONTEXT.md`, ADRs, and repository documentation.
3. Read managed workflow state when present.
4. Inspect current code, tests, schemas, contracts, and recent patterns in the affected area.
5. Extract objectives, non-objectives, invariants, acceptance criteria, verification, and rollout constraints.
6. Confirm the spec is `READY`.
7. Re-check scale. Stop and route to `split` if the active unit is not one reliable candidate/review boundary.
8. Read `CHECKPOINTS.md` before editing in a managed workflow.
9. Read the open review ledger before broad exploration when workflow state says CHANGES_REQUIRED or a matching ledger exists.

Stop on a material blocker:

- unresolved product decision;
- contradiction with an accepted ADR, domain rule, or external contract;
- required secret, service, environment, or data is unavailable;
- implementation requires materially broader behavior than the approved contract;
- working tree contains unrelated changes that cannot be isolated safely;
- LARGE child ownership/candidate isolation cannot be proven.

A valid explicit `implement` invocation or managed `continue` entering implementation authorizes the bounded implementation. Do not ask whether to begin when no blocker exists.

## Managed child claim

For LARGE managed work, claim the active child before editing.

Record worktree/branch/session identity when available. Other sessions must skip a valid active claim.

Clear the claim only after a candidate checkpoint is created or when the implementing session explicitly releases a blocked child.

## Choose implementation kind

### Initial implementation

Use when no open CHANGES_REQUIRED ledger exists for the active candidate lineage.

Implement the complete bounded active contract and prove its acceptance criteria.

### Corrective implementation

Use when an open ledger exists.

1. Read the full ledger first.
2. Extract open `BLOCKING` and `IMPORTANT` finding IDs.
3. Read prior candidate SHA and reviewed state from workflow/ledger.
4. Inspect only code needed to understand those findings and affected seams.
5. Fix the open findings and directly caused regressions.
6. Preserve already-satisfied criteria, approved siblings, and settled product decisions.
7. Do not restart broad implementation discovery or search for optional improvements.
8. Append corrective evidence to the ledger/workflow state.

If the findings expose wrong scope/boundary/contract, stop and route to REPLAN_REQUIRED rather than accumulating patches.

## Delegated implementation

Delegation is optional and user-controlled.

When enabled, use subagents only for isolated, non-overlapping implementation slices or independent supporting work.

Before dispatch, define for each subagent:

- active spec/child and inherited contract;
- exact ownership boundary;
- expected files/subsystem or isolated worktree;
- dependencies and base SHA;
- expected output;
- verification responsibility.

Concurrent editing should use separate worktrees/branches or equivalent host isolation. Never let two agents concurrently own overlapping implementation areas in the same worktree.

The primary agent must:

- inspect each contribution;
- integrate safely;
- resolve conflicts;
- verify the complete active unit;
- ensure one final candidate contains exactly that unit;
- produce the final acceptance matrix.

## Implementation discipline

- Work in coherent slices that preserve a runnable repository.
- Reuse existing abstractions/pipelines when the repository establishes them.
- Do not broaden scope under “while we are here”.
- Do not weaken validation, types, authorization, privacy, or failure handling to make tests pass.
- Treat retries, duplicates, ordering, transactions, and concurrency explicitly when relevant.
- Preserve compatibility unless the spec explicitly changes it.

## Tests and evidence

Use tests that prove observable behavior:

- domain/unit tests for rules/invariants;
- integration tests for persistence, jobs, APIs, and external seams;
- contract tests for compatibility;
- UI/component/end-to-end tests for user workflows;
- regression test for each corrected material defect when practical.

During development:

1. run focused tests for the current slice;
2. run broader affected-subsystem tests;
3. run type/lint/build/migration/schema/manual checks when relevant;
4. reserve expensive repository-wide gates for the stable candidate unless project instructions require them earlier.

Evidence is valid only for the code state it exercised. Record enough state to tie evidence to the candidate.

For corrective work, run focused checks for finding IDs and affected seams. Do not rerun unrelated expensive checks merely because the session changed.

Never hide a failure. Distinguish passed, change-caused failure, pre-existing failure, and unavailable/not-run.

## Candidate completion

A managed implementation is not complete until a stable candidate checkpoint exists.

Before commit:

1. inspect working tree and staged/unstaged diff;
2. prove changed paths belong to the active unit;
3. reject mixed sibling implementation;
4. run required local verification;
5. stage only owned files;
6. create the checkpoint per `CHECKPOINTS.md`;
7. record base and candidate SHAs in workflow state;
8. clear the claim;
9. set phase `REVIEW_REQUIRED`.

The review always receives exact candidate state rather than reconstructing the implementation from a large ambiguous working tree.

## Completion report

Return:

1. implemented scope and changed files/areas;
2. finding-ID-to-fix matrix for corrective work;
3. acceptance matrix;
4. exact checks and outcomes;
5. residual risks/unavailable verification;
6. intentionally untouched out-of-scope items;
7. checkpoint SHA/base when managed;
8. next isolation boundary.

A managed implementation ends at `REVIEW_REQUIRED`, never DONE.

Preferred managed next step:

```text
## Next step

Fresh independent review context required.
Run: idd continue
```
