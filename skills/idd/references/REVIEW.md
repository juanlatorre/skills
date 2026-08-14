# Reviewing an implementation against its spec

Review is independent, read-only, evidence-driven, and designed to converge. It finds material mismatches and risks; it does not maximize finding count.

## Independence and state

Use a fresh session that did not implement the current change, preferably with a different model.

Resolve the Git-metadata handoff directory before choosing review scope:

```sh
REVIEW_DIR="$(git rev-parse --path-format=absolute --git-path idd/reviews)"
SPEC_KEY="$(printf '%s' "$ACTIVE_SPEC" | git hash-object --stdin)"
REVIEW_HANDOFF="$REVIEW_DIR/$SPEC_KEY.md"
```

Never use literal `.git/idd/reviews`; `.git` is a file in linked worktrees.

Both review and implementation use that exact filename derivation. If `REVIEW_HANDOFF` exists, read it completely before broad exploration.

## Establish the review set

Read the approved spec and applicable parent/index, repository instructions, domain context, ADRs, and verification configuration.

Determine the actual implementation state without losing uncommitted work:

1. inspect `git status --short`;
2. include unstaged, staged, and relevant untracked files;
3. use the supplied base, or determine a safe merge base from repository evidence;
4. record HEAD plus changed paths or a diff fingerprint;
5. never assume a clean working tree means there is no branch diff.

If the review range cannot be established, use `CANNOT VERIFY` and identify the missing evidence.

## Choose exactly one review kind

### Initial review

Use only when no open handoff exists.

Review the full relevant diff on two axes:

1. **Spec fidelity** — every objective, non-objective, rule, invariant, acceptance criterion, error case, permission, compatibility requirement, and rollout constraint.
2. **Engineering quality** — correctness, failure safety, authorization/privacy, transactional integrity, API/schema compatibility, concurrency/idempotency, maintainability at existing seams, plausible performance risk, observability, recoverability, and meaningful tests.

Ignore cosmetic preference unless it violates an explicit project rule or hides a defect.

### Corrective review

Use whenever an open handoff exists. This is not another full audit.

Review only:

- open `BLOCKING` and `IMPORTANT` finding IDs;
- the corrective delta since the prior reviewed state;
- criteria, invariants, and seams directly affected by that delta;
- new `BLOCKING` or `IMPORTANT` regressions caused by the correction.

Do not actively re-audit closed findings, unchanged acceptance criteria, or unrelated original files. Reuse still-valid acceptance and test evidence. If a serious unrelated defect becomes unavoidably visible, report it; do not search for optional work outside the corrective scope.

Increment `Corrective review round` in the handoff. There may be at most two corrective review rounds.

### Integrated parent review

Use only after every required child workflow is `DONE`.

Review cross-child behavior, parent invariants, end-to-end permissions/data ownership, migration/rollout composition, and integrated parent acceptance criteria. Reuse child approvals and do not reopen child internals unless integration evidence invalidates them.

## Findings ledger

Each finding has a stable ID and includes:

- severity: `BLOCKING`, `IMPORTANT`, or `OPTIONAL`;
- status: `OPEN`, `ADDRESSED`, or `CLOSED`;
- concise title and location;
- observed evidence, not speculation;
- user/system impact;
- affected rule, invariant, or acceptance criterion;
- smallest correct remediation direction.

`BLOCKING` and `IMPORTANT` findings block approval. `OPTIONAL` findings never block approval. List them in the final response rather than extending the correction loop. On `APPROVE`, delete the ledger; optional items are not open IDD state and become tracker work only if the user explicitly requests it.

During corrective review, preserve finding IDs. Mark the prior item `CLOSED` with evidence when corrected. Create a new ID only for a distinct regression or root cause.

When verdict is `CHANGES REQUIRED`, persist the complete ledger in `REVIEW_DIR`, including:

- exact spec path;
- review kind and corrective round;
- base and reviewed state;
- all finding records and statuses;
- acceptance evidence that remains valid;
- commands, outcomes, and state they exercised;
- residual uncertainty;
- corrective implementation notes when present.

The handoff is the only review write. Never modify implementation code, tests, specs, context documents, ADRs, index state, refs, commits, branches, or remotes.

## Verification budget

Run a check when it closes a material evidence gap. Do not rerun expensive checks solely because the reviewer is in a new session.

Use this order:

1. inspect existing evidence and whether its exercised state is still valid;
2. run focused checks for unverified findings or affected criteria;
3. run broader affected-subsystem checks if the delta warrants them;
4. once no blocking/important finding remains, run any repository-required expensive final gate against the stable candidate.

Do not launch the full suite in every implementation, review, correction, and re-review by default. If the final gate fails because of the change, report the defect. If it cannot run because of environment or access, use `CANNOT VERIFY`; do not restart implementation without evidence of a defect.

## Convergence limit

The normal path is:

```text
initial full review
→ corrective implementation
→ narrow corrective review
→ optional second correction and narrow review
→ approve or replan
```

After two corrective review rounds, do not route to another blind patch cycle.

If blocking/important findings remain or new serious waves keep appearing:

1. keep verdict `CHANGES REQUIRED`;
2. set logical workflow state `REPLAN REQUIRED`;
3. identify the recurring root cause—oversized scope, contradictory contract, wrong boundary, migration strategy, permission model, or missing invariant;
4. route only the affected contract to targeted `grill`, `grill-docs`, or `split`.

Completed, unrelated behavior remains closed.

## Verdict and output

Allowed verdicts:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

Use `APPROVE` only when no blocking/important finding remains and material criteria have sufficient evidence. Remove the matching handoff.

Use `CHANGES REQUIRED` for evidenced implementation defects. Persist/update the handoff and route to corrective implementation, except when the convergence limit requires replan.

Use `CANNOT VERIFY` for missing review range, evidence, environment, access, or a contradictory/unresolved spec. Say exactly what is missing. Route to implementation only if evidence indicates an implementation defect.

Return:

```text
# Review scope
<INITIAL | CORRECTIVE round N | INTEGRATED PARENT; base and reviewed state>

## Blocking findings
<stable IDs and evidence>

## Important findings
<stable IDs and evidence>

## Optional follow-ups
<non-blocking only>

## Acceptance matrix
| Criterion | PASS/FAIL/NOT VERIFIED/BLOCKED | Evidence |

## Checks run
<commands, outcomes, reused evidence>

## Residual uncertainty
<uncertainty>

## Verdict
<APPROVE | CHANGES REQUIRED | CANNOT VERIFY>

## IDD status
<standalone, child, or parent state>

## Next step
<exact native action and command when applicable>
```

For child specs, unlock dependencies only after `APPROVE`. Recommend integrated parent review only when all required children are `DONE`. Never reopen unrelated completed children.
