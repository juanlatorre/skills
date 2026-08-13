# Reviewing an implementation against its spec

Review is read-only and evidence-driven. Its purpose is not to produce a large list; it is to find material mismatches and risks.

## Independence

The reviewer should run in a fresh session and preferably a different model. If this session implemented the change, stop and request a fresh session.

## Establish the review set

Read:

- the approved spec and parent/child specs;
- applicable `AGENTS.md`, `CONTEXT.md`, ADRs, and repository documentation;
- all changed files and relevant surrounding code;
- tests and migrations associated with the change.

Determine the diff without losing uncommitted work:

1. inspect `git status --short`;
2. include unstaged and staged diffs;
3. when reviewing a branch, use the user-provided base or determine a sensible merge base from `origin/main`, `main`, or `master`;
4. include new untracked files that belong to the implementation;
5. never assume a clean working tree means there is no branch diff.

If the review range cannot be established, use verdict `CANNOT VERIFY` and explain exactly what is missing.

## Axis 1 — Spec fidelity

Check every objective, non-objective, rule, invariant, acceptance criterion, error case, permission, compatibility requirement, and rollout constraint.

Look for:

- missing behavior;
- behavior that contradicts the spec;
- accidental scope expansion;
- incorrect data ownership or source of truth;
- duplicate/retry/concurrency failures;
- missing degraded-state behavior;
- tests that do not prove the promised behavior.

## Axis 2 — Engineering quality

Check compatibility with the repository rather than personal preference:

- correctness and failure safety;
- authorization, privacy, and input trust;
- transactional boundaries and data integrity;
- API/event/schema compatibility;
- race conditions, idempotency, retries, and ordering;
- maintainability at the existing architectural seam;
- performance regressions with plausible impact;
- observability and recoverability;
- meaningful test coverage.

Ignore cosmetic style unless it violates explicit project rules or hides a defect.

## Findings

Every finding must include:

- severity: `BLOCKING`, `IMPORTANT`, or `OPTIONAL`;
- concise title;
- file and line/range when available;
- evidence;
- user/system impact;
- the smallest correct direction for remediation;
- related acceptance criterion or rule.

Do not report speculation as fact. Mark uncertainty explicitly.

## Verification

Run safe checks when they materially improve confidence. Record exact commands and outcomes. Do not modify code or snapshots merely to make checks pass.

## Output

```text
# Review verdict
APPROVE | CHANGES REQUIRED | CANNOT VERIFY

## Blocking findings
...

## Important findings
...

## Optional improvements
...

## Acceptance matrix
| Criterion | PASS/FAIL/NOT VERIFIED | Evidence |

## Checks run
...

## Residual uncertainty
...
```

Use `APPROVE` only when there are no blocking or important findings and all material acceptance criteria are verified.
