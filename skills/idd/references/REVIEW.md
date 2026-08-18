# Reviewing an implementation against its spec

Review is independent, read-only, evidence-driven, and designed to converge. In IDD 4.x managed workflows, review evaluates an exact candidate lineage rather than “whatever is on the branch”.

## Independence

Use a fresh session that did not implement the current candidate, preferably with a different model.

Review never edits code, tests, specs, context docs, ADRs, or README progress state. It may update only Git-metadata workflow/review files.

## Establish the reviewed candidate

Read:

- active spec;
- parent/static child map when relevant;
- repository instructions;
- context/ADRs;
- workflow state;
- candidate lineage;
- open review ledger;
- relevant verification configuration.

Managed review requires exact SHAs.

### Initial child/normal review

Review exact:

```text
base..candidate
```

The candidate must belong to exactly one active reviewable unit.

If two nominal child specs point to the same mixed candidate diff and independence cannot be proven, do **not** run duplicate reviews. Return CANNOT VERIFY/recovery guidance because candidate isolation failed.

### Corrective review

Review exact:

```text
previous candidate..corrective candidate
```

plus:

- open `BLOCKING` and `IMPORTANT` finding IDs;
- affected acceptance criteria/invariants;
- serious regressions introduced by the correction.

Do not restart a full audit of unchanged original work.

### Integrated parent review

Use only after every required child is DONE and fog has been reconciled.

Review the stable integrated parent candidate/range for:

- cross-child invariants;
- end-to-end flows;
- permissions/data ownership across boundaries;
- migration/rollout composition;
- parent acceptance criteria;
- integration regressions.

Reuse approved child evidence unless integration invalidates it.

## Review kinds

Choose exactly one:

```text
INITIAL
CORRECTIVE round N
INTEGRATED PARENT
```

Workflow state and candidate lineage determine the kind; do not infer from prose status in specs.

## Findings ledger

Each finding has a stable ID and includes:

- severity: `BLOCKING`, `IMPORTANT`, or `OPTIONAL`;
- status: `OPEN`, `ADDRESSED`, or `CLOSED`;
- concise title/location;
- observed evidence;
- user/system impact;
- affected rule/invariant/criterion;
- smallest correct remediation direction.

`BLOCKING` and `IMPORTANT` block approval. `OPTIONAL` never blocks approval.

Persist the ledger in shared Git metadata when verdict is CHANGES_REQUIRED. Include:

- workflow id;
- exact spec/child;
- review kind/round;
- base, previous candidate, current candidate;
- finding records/statuses;
- acceptance evidence still valid;
- commands/outcomes and candidate they exercised;
- residual uncertainty.

On APPROVE, remove open finding ledger for that candidate lineage after workflow state records approval.

## Delegated review

Delegation is optional and user-controlled.

When enabled, subagents may inspect distinct read-only lenses, for example:

- spec fidelity;
- architecture/contracts;
- security/privacy;
- tests/verification;
- migrations/recovery/regressions.

Every subagent receives the exact candidate range and active contract.

Subagents must not edit artifacts, ledger, or workflow state and must not issue the authoritative verdict.

The primary reviewer validates evidence, deduplicates findings, reconciles conflicts, assigns final severity, updates workflow/ledger, and issues the single verdict.

## Verification budget

Run checks only when they close a material evidence gap.

Order:

1. reuse still-valid candidate-tied evidence;
2. focused checks for unverified findings/criteria;
3. broader affected-subsystem checks when needed;
4. required expensive final gate once against the stable candidate when approval is otherwise plausible.

Do not rerun expensive suites solely because the reviewer is in a new session.

## Convergence

Normal correction path:

```text
initial review
→ corrective implementation
→ corrective candidate
→ narrow corrective review
→ optional second correction/review
→ approve or replan
```

After two corrective review rounds, persistent blocking/important findings or new serious waves trigger `REPLAN_REQUIRED` instead of another blind patch loop.

Reopen only the affected contract/slice. Approved siblings remain closed.

## Verdicts

Allowed:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

### APPROVE

Use only when no blocking/important finding remains and material criteria have sufficient evidence.

Managed effects:

- record APPROVE for exact candidate;
- remove matching open ledger;
- mark normal workflow or child DONE;
- recompute LARGE dependencies/frontier;
- reevaluate fog after child approval;
- never reopen unrelated DONE children.
- in issue-driven delivery, complete/close the active issue when the tracker convention permits, clear the active issue/claim, and return the workflow to PLANNED unless the full destination is DONE;
- never auto-start another backlog issue in ISSUES disposition.

### CHANGES REQUIRED

Use for evidenced implementation defects.

Managed effects:

- persist/update ledger;
- record candidate verdict;
- set same unit CHANGES_REQUIRED;
- next action = corrective implementation of same unit in a fresh session.

### CANNOT VERIFY

Use for missing candidate range, evidence, environment/access, candidate-isolation failure, or contradictory/unresolved contract.

Say exactly what is missing. Do not route to implementation unless evidence indicates an implementation defect.

## Output

Return:

```text
# Review scope
<kind; active unit; exact base/candidate range>

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
<workflow/child state>

## Next step
<managed `idd continue`, exact explicit command, blocker, or completion>
```

In a managed workflow, prefer `idd continue` at the next fresh-session boundary. The workflow state already knows the exact spec, child, base, candidate, and review kind.
