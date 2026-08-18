# Managed checkpoint commits and candidate isolation

IDD 4.x managed workflows use local Git commits as stable checkpoints. These commits make implementation and review reproducible across sessions and prevent two child specs from being reviewed against the same ambiguous working-tree diff.

Explicit legacy phase modes remain commit-free unless the user requests commits or they are attached to an active managed workflow.

## Authorization boundary

Running `idd start` or `idd continue` authorizes the **local checkpoint commits required by the managed workflow**.

This authorization never includes:

- push;
- pull-request creation;
- merge;
- deployment;
- release;
- tags;
- force push;
- remote branch mutation;
- destructive history rewriting.

Those actions still require explicit user instruction.

## Stable boundaries

Managed workflows may create checkpoints only at these boundaries:

1. **Planning checkpoint** — after a NORMAL spec is READY, or after a LARGE parent/split plan is sharp enough to begin child delivery.
2. **Initial candidate checkpoint** — after one bounded spec/child is implemented and required local verification succeeds.
3. **Corrective candidate checkpoint** — after open review findings are corrected and targeted verification succeeds.
4. **Integration checkpoint** — after approved parallel child candidates are integrated or when all children are composed into the stable parent candidate before integrated review.

Do not create checkpoint commits:

- during route;
- during an unfinished grilling round;
- for a DRAFT spec;
- during review;
- while required verification is failing or BLOCKED;
- merely because files changed.

## Clean ownership before commit

Before any checkpoint:

1. inspect `git status --short`;
2. inspect staged and unstaged diffs;
3. identify files owned by the current workflow/unit;
4. do not absorb unrelated user changes;
5. do not blindly use `git add -A` when unrelated files exist;
6. verify generated files/migrations belong to the active unit;
7. stage exact owned paths or an evidence-backed path set;
8. run the verification required for that checkpoint.

If unrelated changes cannot be safely separated, stop instead of creating a contaminated candidate.

## Planning checkpoint

The planning checkpoint freezes the contract before implementation.

Include only planning artifacts produced or intentionally updated by the workflow, for example:

- active spec or parent/child specs;
- split index/README when it contains static structure only;
- `CONTEXT.md` / context map updates;
- qualifying ADRs.

Do not include implementation code.

Record the SHA as `planningCheckpoint` in workflow state.

For `ISSUES` disposition, create this planning checkpoint **before** publishing tracker issues. Issue bodies should point to the stable spec paths/planning state. This checkpoint does not authorize pushing the planning commit; remote Git publication remains separate.

## Candidate lineage

Every reviewable unit has a lineage:

```text
base
→ initial candidate
→ corrective candidate 1 (optional)
→ corrective candidate 2 (optional)
```

Record every candidate SHA and its relationship to the previous reviewed state.

For NORMAL work, the initial candidate base is usually the planning checkpoint.

For a sequential LARGE child, the base is the stable workflow HEAD before that child begins.

For a parallel child worktree, the base is the exact commit from which that child worktree was created.

## One child = one candidate lineage

In LARGE work:

```text
one child
→ one claim
→ one candidate lineage
→ one independent review lineage
```

A child candidate must not include implementation belonging to another independently reviewable child.

Before creating a child candidate, inspect the changed paths and compare them with:

- the child spec;
- parent inherited invariants;
- known sibling boundaries;
- subagent/worktree ownership.

If implementation for two children is mixed and cannot be separated confidently, stop with candidate-isolation failure. Do not proceed by running two reviews over the same giant diff.

## Commit messages

Follow repository conventions first.

When no convention applies, prefer concise local workflow messages such as:

```text
idd(plan): define <workflow>
idd(<child>): candidate <outcome>
idd(<child>): address review findings
idd(integrate): compose <workflow>
```

Do not encode secrets, detailed findings, or sensitive data in commit messages.

## Initial candidate checkpoint

After implementation and required local verification:

1. prove the working set belongs to exactly one active unit;
2. commit the unit;
3. record:
   - base SHA;
   - candidate SHA;
   - verification evidence tied to candidate;
   - candidate kind `INITIAL`;
   - review state `PENDING`;
4. clear the implementation claim;
5. set next action to independent review.

The reviewer reviews exact `base..candidate`.

## Corrective candidate checkpoint

After CHANGES_REQUIRED:

1. read the open ledger before broad work;
2. fix only open blocking/important findings and directly affected regressions;
3. run targeted verification;
4. commit the corrective delta;
5. record previous candidate and new candidate;
6. set review kind `CORRECTIVE`.

The corrective reviewer reviews:

```text
previous candidate..corrective candidate
+ open finding IDs
+ affected criteria/invariants
+ serious regressions caused by the correction
```

Do not re-review the entire original diff unless the correction invalidated earlier evidence broadly.

## Parallel delegated implementation

When subagent implementation runs children in parallel:

- each child uses a separate worktree/branch or equivalent host isolation;
- each child starts from a recorded base SHA;
- each child produces its own candidate commit;
- child reviews occur against those isolated lineages;
- only approved child candidates may be integrated into the primary workflow branch;
- integration order follows dependencies;
- conflicts or cross-child interactions are resolved in the primary workflow and verified before parent review.

A subagent may create local commits inside its isolated worktree only when the primary agent explicitly assigned that managed child implementation.

## Integration checkpoint

After all required children are DONE:

1. ensure approved candidates are present in the workflow integration branch/worktree;
2. reconcile fog and newly surfaced required children first;
3. run cross-child integration verification appropriate before review;
4. create an integration checkpoint only if integration produced new local changes or a stable composed candidate needs a distinct SHA;
5. record parent review base and integrated candidate SHA.

The final parent reviewer reviews the integrated range and cross-child contract, not each approved child from scratch.

## Review never commits

Review may update only Git-metadata workflow/review files. It never creates a code/spec checkpoint commit.

The state reviewed must already be represented by a candidate SHA before review begins in a managed workflow.

## Reporting

After a checkpoint, report:

```text
Checkpoint: <sha>
Kind: PLAN | INITIAL CANDIDATE | CORRECTIVE CANDIDATE | INTEGRATION
Unit: <workflow/spec/child>
Base: <sha or none>
Verification: <brief evidence>
```

Then persist the same facts in workflow state so `idd continue` can resume without user copy/paste.
