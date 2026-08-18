# Managed workflow state

IDD 4.1 managed workflows are stateful. The goal is to let the user run `idd start` once and then use `idd continue` from fresh sessions without reconstructing paths, children, review bases, candidate SHAs, or next phases.

A workflow may be delivered in one of exactly two ways:

```text
EXECUTE → deliver now
ISSUES  → publish approved work as issues and park
```

## Storage

Require Git for managed workflows.

Resolve shared metadata through the common Git directory:

```sh
GIT_COMMON_DIR="$(git rev-parse --path-format=absolute --git-common-dir)"
IDD_DIR="$GIT_COMMON_DIR/idd"
WORKFLOW_DIR="$IDD_DIR/workflows"
REVIEW_DIR="$IDD_DIR/reviews"
```

Never use a literal `.git/idd` path. Linked worktrees may have `.git` as a file.

Workflow state is local Git metadata. It must not modify working-tree files, index entries, refs, branches, remotes, or commits except where the checkpoint contract explicitly authorizes local workflow commits.

## Operational source of truth

The workflow JSON is the only operational source of truth for:

- current phase/status;
- destination;
- delivery disposition;
- active spec or child;
- dependency graph;
- claims;
- candidate SHAs and lineage;
- review verdicts;
- corrective round;
- delegation preferences;
- fog;
- tracker/issue references;
- active issue;
- next deterministic action;
- whether workflow is ACTIVE, PLANNED, BLOCKED, REPLAN_REQUIRED, or DONE.

Do not duplicate those values into specs or prose roadmaps.

Specs answer **what should exist**. Workflow state answers **where delivery currently is**. Issues answer **what approved unit is visible/assignable on the tracker**.

## Suggested schema

The exact JSON encoding may evolve, but preserve these semantics:

```json
{
  "schemaVersion": 2,
  "iddVersion": "4.1.0",
  "id": "harcha-ui-platform",
  "destination": "Harcha UI is installable, agent-ready, and independently verified.",
  "kind": "LARGE",
  "domainImpact": "NEW/TRANSVERSAL",
  "status": "PLANNED",
  "origin": {
    "kind": "IDEA",
    "repoRoot": "/repo",
    "branch": "feature/harcha-ui",
    "worktree": "/repo",
    "issue": null
  },
  "delivery": {
    "disposition": "ISSUES",
    "tracker": "github",
    "parentIssue": "#120",
    "activeIssue": null
  },
  "delegation": {
    "split": false,
    "implement": false,
    "review": false
  },
  "parentSpec": "docs/specs/harcha-ui-platform.md",
  "activeSpec": null,
  "phase": "PARKED",
  "planningCheckpoint": "44be725",
  "children": [
    {
      "id": "03",
      "name": "Chilean data controls",
      "spec": "docs/specs/harcha-ui-platform/03-chilean-data-controls.md",
      "issue": "#123",
      "dependsOn": ["02"],
      "state": "READY",
      "claim": null,
      "lineage": []
    }
  ],
  "fog": [
    "Final onboarding integration once the CLI contract is stable"
  ],
  "next": {
    "mode": "start-issue",
    "candidates": ["#123"]
  }
}
```

Do not manually store `frontier` as authoritative state. Compute it from child state, dependencies, and claims each time. A cached frontier may be written for diagnostics but must be recomputed before action.

## Delivery disposition

Allowed values:

```text
UNSET
EXECUTE
ISSUES
```

`UNSET` is temporary and must be resolved when executable READY work first exists.

If natural-language intent already selects EXECUTE or ISSUES, persist it and do not ask again.

If unset, ask exactly two choices. Do not add a third formal delivery mode.

### EXECUTE

Status remains ACTIVE and deterministic delivery proceeds through implementation/review with fresh-session boundaries.

### ISSUES

Publish approved work according to `ISSUES.md`, then set:

```text
status = PLANNED
phase = PARKED
activeIssue = null
```

`continue` on that state reports the park; it must not silently execute backlog issues.

## Destination

The destination is the low-resolution definition of success for the workflow. Establish it during definition and confirm it when grilling closes.

A good destination:

- is one or two sentences;
- defines the observable end of the effort;
- fixes scope;
- is stable enough to judge whether newly discovered work is in scope, fog, or out of scope.

If the destination materially changes, treat that as a product decision and replan affected work.

## Child states

Use operational states such as:

```text
DRAFT
READY
CLAIMED
IMPLEMENTING
REVIEW_REQUIRED
CHANGES_REQUIRED
BLOCKED
REPLAN_REQUIRED
DONE
```

`DONE` requires an independent `APPROVE`.

Spec files themselves remain `DRAFT` or `READY`; execution states live only in workflow state.

## Frontier

For LARGE work, compute the frontier as children that are:

1. `READY`;
2. all dependencies are `DONE`;
3. not blocked;
4. not actively claimed by another valid session/worktree.

Declared child order is default execution priority when several frontier children are equivalent.

EXECUTE disposition may take the first equivalent frontier child without a ceremonial question.

ISSUES disposition does **not** use frontier as permission to start work. Frontier is advisory for which issue(s) are executable; the user starts work explicitly with `idd start <issue>`.

## Fog

Fog is in-scope work that is visible but not precise enough to become a child spec yet.

Use fog when the agent can say **what area will probably need attention** but cannot yet state a sharp independent outcome because it depends on unresolved or not-yet-observed information.

After a child receives `APPROVE`, reevaluate fog:

- if now sharp and deterministic, graduate it into a child spec and dependency entry;
- in ISSUES disposition, also create the thin tracker issue under the existing parent;
- if it needs a product decision, stop for targeted grilling;
- if evidence shows it is unnecessary, remove it;
- if it lies beyond the destination, mark it out of scope rather than turning it into work.

Do not pre-slice vague fog into speculative children.

## Claims

A claim prevents duplicate implementation.

Before implementing a LARGE child, record at least:

```json
{
  "claimedBy": "<session or agent identifier when available>",
  "worktree": "<absolute path>",
  "branch": "<branch>",
  "claimedAt": "<timestamp>",
  "issue": "<issue ref or null>"
}
```

A claimed child is excluded from frontier selection by other sessions.

For issue-driven work, prefer tracker assignment/claim when available, but also persist the local claim so candidate lineage remains unambiguous.

Clear a claim when:

- a candidate checkpoint is created;
- implementation is blocked and the session releases ownership;
- the claim is conclusively stale because its worktree/branch no longer exists.

Do not steal a claim merely because its timestamp is old. If ownership is uncertain, report the conflict.

## Deterministic continuation

`continue` must reconcile before executing:

1. load workflow JSON;
2. inspect current branch/worktree and Git status;
3. validate known planning/candidate commits still exist;
4. validate active claims;
5. read any open review ledger;
6. recompute child states and frontier;
7. reevaluate fog when a recent approval may have clarified it;
8. reconcile tracker refs/status when delivery is ISSUES;
9. compute the next action.

Then:

- EXECUTE + exactly one safe action + no boundary → execute;
- EXECUTE + multiple equivalent frontier children → take declared first unless user choice materially matters;
- ISSUES + PLANNED + no active issue → remain parked and report executable issue refs;
- ISSUES + active issue → continue only that issue's lineage;
- genuine product choice → interactive question;
- fresh independent context required → persist next action and stop;
- unsafe/inconsistent state → BLOCKED or REPLAN_REQUIRED.

## Boundaries

### Decision boundary

Stop for the user when product behavior, scope, trade-offs, or destination require a decision.

### Delivery-disposition boundary

When executable READY work first exists and disposition is UNSET, stop for exactly one choice: EXECUTE or ISSUES.

### Isolation boundary

Stop when the next phase must be independently contextualized:

- planning → implementation;
- implementation candidate → review;
- review CHANGES_REQUIRED → corrective implementation;
- corrective candidate → corrective review;
- EXECUTE completed child review → next child implementation;
- integration candidate → parent review.

At an isolation boundary in an active execution lineage, the user should normally need only:

```text
idd continue
```

### Park boundary

ISSUES disposition intentionally stops after issue publication and after each completed issue when no issue remains active.

The explicit resume command is:

```text
idd start <issue ref/url>
```

### Safety boundary

Stop before destructive or externally visible actions not authorized by IDD. Selecting ISSUES authorizes only issue-plan publication; starting an issue authorizes only that issue's lifecycle updates. Git push/PR/merge/deploy/release remain separate.

### Blocker

Stop when required environment, access, evidence, tracker capability, or a coherent contract is unavailable.

## Workflow discovery

### `continue`

When no workflow id is given:

1. prefer ACTIVE workflow whose origin/current worktree or branch matches;
2. otherwise if exactly one ACTIVE workflow exists in this repository, use it;
3. a PLANNED workflow may be shown by status but is not auto-executed;
4. otherwise present a structured selection of plausible workflows;
5. never guess among materially distinct workflows.

When no resumable workflow exists, explain that `continue` has nothing to execute. Suggest `idd start <idea|spec|issue>` or `idd status` as appropriate.

### `start <issue>`

Use `ISSUES.md` to resolve the tracker issue to a workflow/spec. A planned issue is an explicit execution entry point; an ordinary issue is a new change request whose body becomes input to routing/grilling.

## Recovery and reconciliation

Workflow state must be checked against Git every session and, for ISSUES delivery, against tracker identity/status when relevant.

Examples of recoverable mechanical drift:

- candidate SHA exists but phase still says IMPLEMENTING → repair to REVIEW_REQUIRED;
- claim references a deleted worktree and no uncommitted work is recoverable → clear stale claim;
- review evidence proves APPROVE but workflow still says CHANGES_REQUIRED → repair state;
- issue was closed after recorded APPROVE but workflow still has it active → clear active issue mechanically.

Examples requiring a stop:

- candidate commit contains changes from multiple independently reviewable children;
- child says DONE but no APPROVE evidence exists;
- review base/candidate commit cannot be found;
- current branch rewrote candidate history;
- tracker issue points to a different spec/workflow than local state;
- working tree has unrelated changes that cannot be safely separated.

Do not solve ambiguity by re-running multiple full reviews of the same mixed diff.

## Completion vs planning completion

Execution completion:

```text
TRIVIAL EXECUTE: verified direct change
NORMAL EXECUTE: stable candidate + independent APPROVE
LARGE EXECUTE: every required child DONE + fog reconciled + integrated parent APPROVE
NORMAL ISSUES: planned issue later executed + independent APPROVE
LARGE ISSUES: required child issues executed + integrated parent APPROVE
```

Planning completion:

```text
PLANNED: approved work is published to tracker and execution is intentionally parked
```

`continue` on DONE reports completion. `continue` on PLANNED with no active issue reports the park and never invents more work.
