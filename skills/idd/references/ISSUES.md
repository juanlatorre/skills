# Issue-backed delivery

IDD 4.1 has exactly two delivery dispositions once executable READY work exists:

```text
EXECUTE
ISSUES
```

`ISSUES` means: publish the approved plan to an issue tracker as a visible, assignable index and **park execution**. It is not another specification format and it is not permission to start coding.

## Authorization

Selecting `ISSUES` explicitly authorizes IDD to create the issues and tracker relationships required to represent the current approved plan.

It does not authorize:

- Git push or remote branch mutation;
- pull requests;
- merge;
- release/deploy;
- tags;
- unrelated issue edits.

Later, `idd start <issue>` explicitly authorizes lifecycle mutations needed for that issue's delivery, such as claim/assignment, status/progress updates, comments required by the tracker convention, and closure/completion after IDD `APPROVE`. Keep mutations scoped to the started issue and directly related parent/dependency metadata.

## Resolve the tracker

Prefer, in order:

1. tracker explicitly named by the user;
2. tracker configured by repository instructions or existing IDD workflow state;
3. a single available issue-tracker integration clearly associated with the repository.

If multiple materially different trackers are plausible, ask the user. If no writable tracker is available, stop and explain the capability gap; do not silently invent local markdown issues as a third delivery disposition.

Common trackers include GitHub Issues and Linear, but IDD is tracker-agnostic.

## Issues are indexes, not specs

The approved spec remains the behavioral contract.

An issue should contain only enough information to route and assign delivery:

```markdown
# <human-readable outcome title>

Implement the approved IDD specification.

Spec: `<repo-relative spec path>`
IDD workflow: `<workflow id>`
Role: `<standalone | child | parent>`

Dependencies:
- <issue/spec references, when applicable>

Done when:
- the linked spec is implemented;
- required verification has evidence;
- independent IDD review returns APPROVE.
```

Include a compact machine-readable marker when the tracker preserves HTML comments, for example:

```html
<!-- idd:v1 workflow=harcha-ui-platform role=child spec=docs/specs/harcha-ui-platform/03-chilean-data-controls.md -->
```

Do not copy the full spec, acceptance matrix, ADRs, or dynamic workflow status into the issue body.

## NORMAL planning

For one bounded READY spec:

1. create one implementation issue;
2. store tracker, issue ref/url, spec path, and workflow id in workflow state;
3. set workflow status `PLANNED`;
4. stop.

The issue is the explicit entry point for later execution:

```text
idd start <issue ref/url>
```

## LARGE planning

After parent spec + split:

1. create one parent/index issue for the destination;
2. create one child issue for every currently sharp child spec;
3. use native parent/child relationships when supported;
4. use native blocker/dependency relationships when supported;
5. otherwise include explicit issue links in the thin issue bodies;
6. preserve child order for equivalent frontier choices;
7. do not create issues for fog;
8. store issue refs against parent/children in workflow state;
9. set workflow status `PLANNED` and stop.

The parent issue is an index, not a duplicate map. It may list child issue links and the destination. Do not mirror the entire workflow JSON or child-spec contents into it.

## Spec addressability

Before creating remote issues, check whether collaborators can resolve the referenced spec.

Do not push automatically.

If planning artifacts exist only in local commits and the remote tracker cannot browse them, explain this before publishing. The user may:

- allow path-only issue references for now; or
- separately authorize publishing/pushing the planning branch.

This is an operational choice, not a third delivery disposition.

## Starting an issue

`idd start <issue>` does one of two things.

### Planned IDD issue

If the issue contains IDD workflow/spec markers:

1. locate the workflow;
2. reconcile local workflow state and tracker metadata;
3. resolve the exact linked spec/child;
4. ensure dependencies are satisfied;
5. claim/assign the issue when supported;
6. set it as the active issue/unit;
7. begin or resume EXECUTE delivery for that issue without asking disposition again.

If the issue is a parent/index issue:

- if all required child issues are DONE, use it as the entry point for integrated parent completion;
- if exactly one child is executable, select it;
- if multiple children are executable and order materially matters, ask; otherwise follow declared order;
- if none are executable, report blockers.

### Ordinary issue

If no IDD markers exist, treat the issue title/body as the incoming change request:

1. record issue as workflow origin;
2. set delivery disposition `EXECUTE` because the user explicitly started the issue;
3. route/grill/spec as needed;
4. do not create a duplicate planning issue for the same request.

## Parked workflows

A workflow with:

```text
status = PLANNED
delivery.disposition = ISSUES
activeIssue = null
```

is intentionally parked.

`idd continue` MUST NOT pick a backlog issue and start work automatically.

It should report the planned tracker entries and tell the user to start one explicitly:

```text
idd start <issue ref/url>
```

This is the key semantic difference between `EXECUTE` and `ISSUES`.

## Issue-driven lifecycle

While an issue is active:

```text
start <issue>
→ implement
→ candidate checkpoint
→ continue in fresh reviewer session
→ APPROVE / CHANGES_REQUIRED
```

On `CHANGES_REQUIRED`, keep the same issue active through corrective implementation/review.

On `APPROVE`:

- complete/close the issue when tracker convention permits;
- clear active issue/claim;
- persist child/standalone DONE state;
- update only directly related parent/dependency progress;
- do not automatically start another issue in ISSUES disposition.

For LARGE workflows, when all required child issues are DONE and fog is reconciled, the parent issue becomes ready for explicit final integrated delivery/review via `idd start <parent issue>`.

## Newly graduated fog

In ISSUES disposition, approved child work may make fog sharp enough to become a required child.

When that graduation is deterministic:

1. create the new child spec;
2. add its dependency entry to workflow state;
3. create a thin child issue under the existing parent issue;
4. remain `PLANNED` unless an issue is already active.

If graduation requires a product decision, stop for targeted grilling before creating the spec/issue.

## No duplicate truth

Keep responsibilities separate:

```text
spec              → what to build
issue tracker     → visible planned/assigned delivery unit
workflow JSON     → operational state and local candidate lineage
Git commits       → exact candidate states
review ledger     → open material findings
```

Tracker status must be reconciled when relevant, but issue prose is never the source for acceptance criteria or candidate/review state.
