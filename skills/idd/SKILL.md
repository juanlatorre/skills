---
name: idd
description: "Inshallah Driven Development (IDD), an explicit software-delivery workflow for routing changes, grilling decisions, maintaining domain language and ADRs, writing repository-grounded specs, splitting large work, implementing approved specs, and independently reviewing changes. Modes: route, direct, grill, grill-docs, spec, split, implement, and review."
license: MIT. Adapted third-party portions are documented in THIRD_PARTY_NOTICES.md.
compatibility: Requires an Agent Skills-compatible coding agent with repository filesystem access. Implementation and review also require shell execution inside a trusted project.
disable-model-invocation: true
metadata:
  author: juanlatorre
  version: "3.1.0"
---

# IDD — Inshallah Driven Development

A controlled path from an idea to verified code. The workflow must converge: scale work before implementation, preserve review state across sessions, and narrow corrective reviews instead of restarting them.

## Activation

IDD is explicit. If the user did not request `idd`, `Inshallah Driven Development`, or one of these modes, show the modes and stop:

```text
idd route <change or idea>
idd direct <small explicit change>
idd grill <plan, decision, or feature>
idd grill-docs <plan, decision, or feature>
idd spec <slug or destination path>
idd split <parent spec path>
idd implement <spec path>
idd review <spec path> [base branch or commit]
```

Aliases: `grill-me → grill`, `grill-with-docs → grill-docs`.

Use the current host's native explicit invocation syntax when known:

```text
Pi:          /skill:idd <mode> <arguments>
Claude Code: /idd <mode> <arguments>
Codex:       $idd <mode> <arguments>, or select idd through /skills
```

Otherwise label host-neutral notation. Do not invent commands for creating sessions or switching models.

## Workflow

```text
TRIVIAL
→ direct → focused verification → DONE

NORMAL + STABLE DOMAIN
→ grill → spec → fresh implement → independent review → DONE

NORMAL + NEW/TRANSVERSAL DOMAIN
→ grill-docs → spec → fresh implement → independent review → DONE

LARGE
→ grill-docs → parent spec → split → child implement/review cycles
→ one integrated parent review → DONE
```

`grill-docs` is a domain-impact choice, not a size. `LARGE` work must be split before implementation.

## Core contracts

1. Use the user's language and preserve canonical repository terms.
2. Read applicable `AGENTS.md` and repository instructions before changing files.
3. Resolve bundled references relative to this skill directory.
4. Load only the references required by the selected mode.
5. Never silently transition between modes.
6. `grill` and `grill-docs` may span turns. Every other mode is one bounded operation.
7. Product definition, specification, implementation, and independent review are separate phases.
8. Investigate repository facts yourself. Ask the user only for product decisions and genuine trade-offs.
9. Never invent permissions, failure behavior, domain meaning, acceptance criteria, or missing product rules.
10. Never claim evidence, commands, tests, or criteria that were not actually verified.
11. Never commit, push, open a pull request, merge, publish, deploy, or alter remote state unless explicitly requested.
12. A valid explicit `implement` invocation authorizes implementation. Do not pause to ask whether to begin or continue unless a real blocker or scope-changing decision exists.
13. If a required reference or host capability is unavailable, identify the precise packaging or capability failure and stop.
14. Every completed mode ends with `## Next step`.

### Optional subagent delegation

IDD is single-agent by default. Delegation is opt-in and is allowed only for `split`, `implement`, and `review`. Never delegate any part of `route`, `direct`, `grill`, `grill-docs`, or `spec`; their 3.0.0 behavior remains unchanged.

Enable delegation only when the user explicitly requests it for the current phase or for explicitly named eligible phases in the current workflow. Do not infer permission from task size, available host features, a previous workflow, or a previous session. Any phase not covered by the user's instruction runs single-agent.

Conversational controls include:

```text
Use subagents for this implementation.
Use subagents for split and review in this workflow.
Use subagents for this workflow.
Do not use subagents.
```

`Use subagents for this workflow` enables delegation only in the eligible `split`, `implement`, and `review` phases of the current workflow. `Do not use subagents` disables delegation and overrides earlier enablement for the covered phase or workflow.

When delegation is enabled:

1. The primary agent owns the phase, assigns bounded tasks with explicit inputs, outputs, and boundaries, and remains the sole interface for workflow state and user-facing conclusions.
2. Every subagent must follow the same spec, repository instructions, core contracts, and safety constraints as the primary agent.
3. Subagent output is evidence or a candidate contribution, never self-validating. The primary agent must inspect and reconcile it before acceptance.
4. If the host cannot create subagents, continue the phase single-agent and state that delegation was requested but unavailable. Do not treat missing subagent capability as an IDD failure.

### Required references

- `route`, `direct`: [routing](references/ROUTING.md)
- `grill`: [grilling](references/GRILLING.md)
- `grill-docs`: [grilling](references/GRILLING.md), [domain modeling](references/DOMAIN_MODELING.md), [context format](references/CONTEXT_FORMAT.md), [ADR format](references/ADR_FORMAT.md)
- `spec`: [specification](references/SPECIFICATION.md), [spec template](references/SPEC_TEMPLATE.md)
- `split`: [large work](references/LARGE_WORK.md)
- `implement`: [implementation](references/IMPLEMENTATION.md)
- `review`: [review](references/REVIEW.md)

### Mandatory scale checkpoints

Classify size during `route`, then re-check it:

1. when grilling closes;
2. before a spec becomes `READY`;
3. before `implement` edits code.

Reclassify as `LARGE` when the approved outcome contains multiple independently verifiable behaviors, subsystems, migration/rollout stages, or permission/data boundaries, or when one implementation plus review is unlikely to fit reliably in one session.

Do not use line count alone. The operational test is whether one agent can implement the whole contract and another can review it completely without losing context or repeatedly rediscovering scope.

If a checkpoint says `LARGE`, stop the flat flow. Create or use a parent spec and run `split`; do not begin a partial implementation of the flat spec.

### Active specification and next step

Once a mode knows a spec path, preserve it exactly:

```text
ACTIVE_SPEC = <resolved spec path>
```

All later commands use that path unless moving explicitly to a child or parent spec. Never make the user reconstruct it.

Every completed mode ends with:

```text
## Next step

<short explanation>
<exact copy-pasteable native command, when another IDD command is required>
```

State when a fresh session or different model is recommended. The only successful terminal text is:

```text
## Next step

IDD complete. No further IDD command is required.
```

While an interactive questionnaire is awaiting answers, the questionnaire itself is the next step.

### Specification and workflow state

The spec stores the behavioral contract, not execution history:

```text
DRAFT → material decision or contradiction remains
READY → contract is closed and may be implemented
```

Do not rewrite the spec as `IMPLEMENTED`, `CHANGES REQUIRED`, or `DONE` merely to track execution.

Logical workflow states are:

```text
READY → IMPLEMENTED → CHANGES REQUIRED (when applicable) → DONE
```

A successful `implement` ends at `IMPLEMENTED`. Only an independent `review` with `APPROVE` ends at `DONE`.

### Worktree-safe review handoff

Review findings must survive fresh sessions. Never address Git metadata through the literal path `.git/idd/...`; `.git` is a file in linked worktrees.

When Git is available, both `review` and `implement` MUST resolve the review directory exactly as follows:

```sh
REVIEW_DIR="$(git rev-parse --path-format=absolute --git-path idd/reviews)"
SPEC_KEY="$(printf '%s' "$ACTIVE_SPEC" | git hash-object --stdin)"
REVIEW_HANDOFF="$REVIEW_DIR/$SPEC_KEY.md"
```

Both phases must use that exact derivation. Create `REVIEW_DIR` only when a handoff must be written. The handoff lives only at `REVIEW_HANDOFF`; it must never alter the working tree, index, refs, branches, commits, or remotes.

When a review returns `CHANGES REQUIRED`, persist a ledger containing at least:

```text
Spec: <exact ACTIVE_SPEC>
Review kind: INITIAL | CORRECTIVE
Corrective review round: <0 | 1 | 2>
Review base and reviewed state: <base, HEAD, changed paths or diff fingerprint>
Verdict: CHANGES REQUIRED

Findings:
- ID, severity, status OPEN, affected rule/criterion, evidence, impact,
  location, and required correction

Acceptance evidence:
<matrix and evidence still valid for the reviewed state>

Checks run:
<commands, outcomes, and the state they apply to>

Residual uncertainty:
<remaining uncertainty>
```

`implement` must look for this ledger before general exploration. If found, it is a corrective implementation: fix the open findings, run targeted checks, and append the finding IDs addressed plus corrective evidence. Do not restart the entire implementation or reopen settled product decisions.

`review` must look for the ledger before choosing its review kind. On `APPROVE`, remove the matching ledger. If Git metadata cannot be written, print the complete ledger in the response and state that persistence is unavailable.

## Mode contracts

### `route`

Use when the needed process is unclear. Read `references/ROUTING.md`, inspect the repository only when classification depends on it, and return:

```text
Size: TRIVIAL | NORMAL | LARGE
Domain impact: STABLE | NEW/TRANSVERSAL
Reason: <brief evidence>
Recommended flow: <workflow>
```

Do not modify files. End with the exact command for the first mode.

### `direct`

Re-check `TRIVIAL` before editing. Schema, permissions, external contracts, concurrency, irreversible behavior, migrations, domain decisions, or meaningful ambiguity are not trivial.

For a true trivial change: inspect the smallest relevant area, implement the localized behavior, add a narrow regression test when meaningful, and run the narrowest useful verification plus mandatory repository checks. Do not create a spec. Report files, checks, and residual risk; then end IDD.

If not trivial, do not edit. Return the correct route and exact next command.

### `grill` and `grill-docs`

Read the required references and repository instructions. Build a decision tree and ask only the current frontier: unresolved decisions whose prerequisites are settled.

Use a native structured questionnaire when available. Each question isolates one decision, explains the consequence, offers concrete alternatives, and puts the recommendation first. Do not ask repository facts the agent can inspect. Wait for answers before recomputing the frontier.

`grill-docs` additionally inspects and, when decisions are accepted, maintains the appropriate `CONTEXT.md`, context map, or ADR. Glossaries hold durable concepts; ADRs hold accepted hard-to-reverse decisions; neither replaces the feature spec.

At closure:

1. summarize decisions, facts, assumptions, non-objectives, and remaining uncertainty;
2. run the mandatory size checkpoint;
3. ask the user to confirm shared understanding;
4. after confirmation, end with an exact `spec` command in the same session.

Do not write code or silently run `spec`.

### `spec`

Use after confirmed grilling, normally in the same conversation. Read the specification references, repository instructions, domain context, ADRs, relevant code, tests, and existing specs.

Write the behavioral contract to the user-supplied path or `docs/specs/<slug>.md`. Ground it in actual repository seams without embedding final code. Include objectives, non-objectives, rules, permissions, failure behavior, acceptance criteria, tests, rollout/migration needs, observability, and open blockers as applicable.

Before setting status, run the mandatory size checkpoint:

- unresolved material decisions → `DRAFT`, route to targeted grilling;
- one bounded outcome → `READY`, route to fresh `implement`;
- multiple independently verifiable outcomes → write/mark a parent spec and route to `split`.

Never send a flat `LARGE` spec directly to implementation.

### `split`

Require and completely read the parent spec plus `references/LARGE_WORK.md`. Create vertical, independently implementable and reviewable child specs and an index with dependencies, inherited invariants, ordering, parallelism, child state, and integrated parent criteria.

When the user has enabled delegation for `split`, subagents may independently analyze decomposition options, dependencies, inherited invariants, delivery boundaries, and safe parallelism. Treat their work as advisory analysis: the primary agent must compare and reconcile it, and exclusively owns the final child-spec plan, child specs, index, ordering, and next-step commands.

Do not split mechanically into frontend/backend/database unless those are genuine delivery boundaries. Do not implement. End with exact commands for the ready child or children.

### `implement`

Run in a fresh session that did not materially author the spec. Resolve `ACTIVE_SPEC`; read `references/IMPLEMENTATION.md`, the complete spec and parent/index when applicable, repository instructions, context, ADRs, code, schemas, migrations, and tests.

Before editing:

1. require `READY`;
2. run the mandatory scale checkpoint and route a flat `LARGE` spec to `split`;
3. resolve `REVIEW_DIR` and read a matching open ledger first;
4. stop only for a material contradiction, unavailable dependency, or missing product decision.

Choose one path:

- **Initial implementation:** implement the complete bounded scope and its tests.
- **Corrective implementation:** address only open blocking/important finding IDs and directly affected behavior. Preserve already-verified criteria and do not re-audit unrelated code.

When the user has enabled delegation for `implement`, use subagents only for isolated, non-overlapping implementation slices or independent supporting work. Before dispatch, define each slice's ownership, file or subsystem boundaries, inputs, expected output, dependencies, and verification responsibility. Avoid concurrent overlapping edits unless the host provides safe isolation, such as separate worktrees, and the boundaries and integration order are explicit. The primary agent must inspect and integrate every contribution, resolve cross-slice conflicts, preserve overall coherence, run integrated verification, and produce the final acceptance matrix.

Use small coherent slices. Run focused and broader relevant checks during development. Defer an expensive repository-wide suite to the final stable candidate unless repository instructions explicitly require it earlier. Reuse valid evidence tied to unchanged code; do not rerun expensive checks merely because the session changed.

Report changed behavior/files, exact checks, residual risk, and an evidence-backed acceptance matrix. A corrective report must map each finding ID to its fix and targeted verification. End at `IMPLEMENTED` with an exact fresh independent `review ACTIVE_SPEC` command.

### `review`

Run in a fresh session that did not implement the current change, preferably with a different model. Read `references/REVIEW.md`, resolve `ACTIVE_SPEC`, establish the actual diff/base, and resolve `REVIEW_DIR` before deciding scope.

Choose exactly one review kind:

- **INITIAL** — no open ledger exists. Review the full relevant diff on both spec fidelity and engineering quality.
- **CORRECTIVE** — an open ledger exists. Verify only the open blocking/important findings, the corrective delta, affected criteria/invariants, and new blocking/important regressions introduced by that delta. Do not restart a full audit or actively search unrelated closed areas.
- **INTEGRATED PARENT** — all required child workflows are `DONE`. Review cross-child behavior and the complete parent contract without reopening independently approved child internals unless integration evidence invalidates them.

When the user has enabled delegation for `review`, subagents may independently inspect distinct, explicitly assigned lenses such as spec fidelity, architecture, security/privacy, tests, or migrations/regressions. Subagent review is strictly read-only: subagents must not edit code, tests, specs, working-tree files, or the review ledger, and must not issue the authoritative verdict. The primary reviewer must validate evidence against the actual diff and spec, deduplicate and reconcile candidate findings, determine final severities, manage the ledger, and issue the single final verdict.

Review is read-only except for its Git-metadata ledger. Report only evidenced findings with severity `BLOCKING`, `IMPORTANT`, or `OPTIONAL`. Optional improvements never block approval and should be listed in the final response rather than extending the correction loop. On `APPROVE`, delete the ledger; optional follow-ups are not open IDD state and become tracker work only if the user explicitly requests it.

Run checks only when they add missing confidence. Reuse still-valid evidence. Once no blocking/important finding remains, run any required expensive final gate once against the stable candidate rather than on every correction round.

Allowed verdicts:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

- `APPROVE`: no blocking/important finding remains and material criteria have sufficient evidence. Remove the ledger. A standalone or integrated parent workflow becomes `DONE`.
- `CHANGES REQUIRED`: persist/update the ledger and route to a fresh corrective `implement ACTIVE_SPEC`.
- `CANNOT VERIFY`: identify the missing evidence, environment, access, or spec decision. Do not send work to implementation unless evidence indicates an implementation defect.

After at most two corrective review rounds, do not continue a blind patch loop. If blocking/important findings remain or new serious waves keep appearing, keep verdict `CHANGES REQUIRED`, set workflow state `REPLAN REQUIRED`, explain the recurring root cause, and route to targeted `grill`, `grill-docs`, or `split`. Reopen only the affected contract or slice.

Every review ends with exactly:

```text
## Verdict
<APPROVE | CHANGES REQUIRED | CANNOT VERIFY>

## IDD status
<standalone, child, or parent state>

## Next step
<exact next action and native command when applicable>
```

For child specs, advance only dependencies unlocked by `APPROVE`. Recommend the integrated parent review only when all required children are logically `DONE`. Never reopen unrelated completed children.
