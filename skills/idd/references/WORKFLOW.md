# Managed workflow state

IDD 4 managed workflows are stateful. The goal is to let the user run `idd start` once and then use `idd continue` from fresh sessions without reconstructing paths, children, review bases, or candidate SHAs.

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

- current phase;
- active spec or child;
- dependency graph;
- claims;
- candidate SHAs and lineage;
- review verdicts;
- corrective round;
- delegation preferences;
- fog;
- next deterministic action;
- whether the workflow is ACTIVE, BLOCKED, REPLAN_REQUIRED, or DONE.

Do not duplicate those values into specs or prose roadmaps.

Specs answer **what should exist**. Workflow state answers **where delivery currently is**.

## Suggested schema

The exact JSON encoding may evolve, but preserve these semantics:

```json
{
  "schemaVersion": 1,
  "iddVersion": "4.0.0",
  "id": "harcha-ui-platform",
  "destination": "Harcha UI is installable, agent-ready, and independently verified.",
  "kind": "LARGE",
  "domainImpact": "NEW/TRANSVERSAL",
  "status": "ACTIVE",
  "origin": {
    "repoRoot": "/repo",
    "branch": "feature/harcha-ui",
    "worktree": "/repo"
  },
  "delegation": {
    "split": false,
    "implement": false,
    "review": false
  },
  "parentSpec": "docs/specs/harcha-ui-platform.md",
  "activeSpec": "docs/specs/harcha-ui-platform/03-chilean-data-controls.md",
  "phase": "REVIEW_REQUIRED",
  "planningCheckpoint": "44be725",
  "children": [
    {
      "id": "03",
      "name": "Chilean data controls",
      "spec": "docs/specs/harcha-ui-platform/03-chilean-data-controls.md",
      "dependsOn": ["02"],
      "state": "REVIEW_REQUIRED",
      "claim": null,
      "lineage": [
        {
          "kind": "INITIAL",
          "base": "44be725",
          "candidate": "3a74d0e",
          "review": "PENDING"
        }
      ]
    }
  ],
  "fog": [
    "Final onboarding integration once the CLI contract is stable"
  ],
  "next": {
    "mode": "review",
    "spec": "docs/specs/harcha-ui-platform/03-chilean-data-controls.md",
    "base": "44be725",
    "candidate": "3a74d0e"
  }
}
```

Do not manually store `frontier` as authoritative state. Compute it from child state, dependencies, and claims each time. A cached frontier may be written for diagnostics but must be recomputed before action.

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

Spec files themselves remain `DRAFT` or `READY`; these execution states live only in workflow state.

## Frontier

For LARGE work, compute the frontier as children that are:

1. `READY`;
2. all dependencies are `DONE`;
3. not blocked;
4. not actively claimed by another valid session/worktree.

Declared child order is the default execution priority. If multiple frontier children exist and order has no product significance, `continue` may take the first rather than ask a ceremonial question.

When delegation for implementation is enabled and safe isolation is available, several frontier children may be claimed in parallel.

## Fog

Fog is in-scope work that is visible but not precise enough to become a child spec yet.

Use fog when the agent can say **what area will probably need attention** but cannot yet state a sharp independent outcome because it depends on unresolved or not-yet-observed information.

After a child receives `APPROVE`, reevaluate fog:

- if now sharp and deterministic, graduate it into a child spec and dependency entry;
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
  "claimedAt": "<timestamp>"
}
```

A claimed child is excluded from frontier selection by other sessions.

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
8. compute the next action.

Then:

- exactly one safe action + no boundary → execute;
- multiple equivalent frontier children → take declared first, unless user choice is materially meaningful;
- genuine product choice → interactive question;
- fresh independent context required → persist next action and stop;
- unsafe/inconsistent state → BLOCKED or REPLAN_REQUIRED.

## Boundaries

### Decision boundary

Stop for the user when product behavior, scope, trade-offs, or destination require a decision.

### Isolation boundary

Stop when the next phase must be independently contextualized:

- spec/planning → implementation;
- implementation candidate → review;
- review CHANGES_REQUIRED → corrective implementation;
- corrective candidate → corrective review;
- completed child review → next child implementation;
- integration candidate → parent review.

At an isolation boundary the only thing the user should normally need to run in a fresh session is:

```text
idd continue
```

### Safety boundary

Stop before destructive or externally visible actions not authorized by IDD, including push, PR, merge, deployment, release, tags, remote branch changes, or destructive history rewriting.

### Blocker

Stop when required environment, access, evidence, or a coherent contract is unavailable.

## Workflow discovery for `continue`

When no workflow id is given:

1. prefer ACTIVE workflow whose origin/current worktree or branch matches;
2. otherwise if exactly one ACTIVE workflow exists in this repository, use it;
3. otherwise present a structured selection of plausible ACTIVE workflows;
4. never guess among materially distinct workflows.

When no workflow exists, explain that `continue` has nothing to resume and suggest `idd start <idea>` or an explicit mode.

## Recovery and reconciliation

The workflow state must be checked against Git every session.

Examples of recoverable mechanical drift:

- candidate SHA exists but phase still says IMPLEMENTING → repair to REVIEW_REQUIRED;
- claim references a deleted worktree and no uncommitted work is recoverable → clear stale claim;
- review ledger says APPROVE but workflow still says CHANGES_REQUIRED and candidate/ledger evidence is conclusive → repair state.

Examples requiring a stop:

- candidate commit contains changes from multiple independently reviewable children;
- child says DONE but no APPROVE evidence exists;
- review base/candidate commit cannot be found;
- current branch rewrote candidate history;
- working tree has unrelated changes that cannot be safely separated.

Do not solve ambiguity by re-running multiple full reviews of the same mixed diff.

## Completion

A workflow is DONE only when the destination is satisfied:

```text
TRIVIAL: verified direct change
NORMAL: stable candidate + independent APPROVE
LARGE: every required child DONE + fog reconciled + integrated parent APPROVE
```

Persist DONE state for status/history. `continue` on a DONE workflow reports completion and does not invent more work.
