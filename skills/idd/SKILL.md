---
name: idd
description: "Inshallah Driven Development (IDD), an explicit software-delivery workflow for routing changes, grilling product decisions, maintaining domain language and ADRs, writing repository-grounded specs, splitting large work, implementing approved specs, and independently reviewing changes. Modes: route, direct, grill, grill-docs, spec, split, implement, and review."
license: MIT. Adapted third-party portions are documented in THIRD_PARTY_NOTICES.md.
compatibility: Requires an Agent Skills-compatible coding agent with repository filesystem access. Implementation and review also require shell execution inside a trusted project.
disable-model-invocation: true
metadata:
  author: juanlatorre
  version: "2.3.0"
---

# IDD — Inshallah Driven Development

A controlled path from an idea to verified code, with enough discipline to make the result testable and no more process than the change requires.

## Activation contract

IDD is an explicit workflow. Do not start it automatically.

If this skill was loaded implicitly and the user did not explicitly request `idd`, `Inshallah Driven Development`, or one of the modes below, show the available modes and stop. Do not classify, grill, write a spec, edit code, or review changes.

The first argument is the mode:

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

Accepted aliases:

```text
grill-me        → grill
grill-with-docs → grill-docs
```

Within this document, `idd <mode> ...` is host-neutral notation.

When returning a next invocation, use the current host's native syntax when it is known:

```text
Pi:
  /skill:idd <mode> <arguments>

Claude Code:
  /idd <mode> <arguments>

Codex CLI or IDE:
  $idd <mode> <arguments>
  or select idd through /skills

Other Agent Skills hosts:
  use the host's native explicit skill syntax
```

If the host syntax is unknown, return host-neutral notation and label it:

```text
Host-neutral: idd <mode> <arguments>
```

Do not assume host-specific commands for creating sessions or switching models. Say `start a fresh session` or `switch models` in plain language unless the current host's command is known.

If the mode is missing or unknown, show the mode list and end with a `## Next step` section telling the user to invoke the appropriate mode.

## Workflow map

```text
TRIVIAL
→ direct implementation
→ verification

NORMAL + STABLE DOMAIN
→ grill
→ one spec
→ implementation in a fresh session
→ independent review in another fresh session

NORMAL + NEW OR TRANSVERSAL DOMAIN
→ grill-docs
→ one spec
→ implementation in a fresh session
→ independent review in another fresh session

LARGE
→ grill-docs
→ parent spec
→ child specs
→ multiple implementations and reviews
→ integrated final review
```

`grill-docs` is not another size category. It replaces `grill` when the work introduces, splits, renames, or redefines domain concepts, or establishes a durable transversal decision.

## Global rules

1. Use the user's language.
2. Preserve canonical terms from `CONTEXT.md`, context maps, accepted ADRs, and repository documentation.
3. Read all applicable `AGENTS.md` files and repository instructions before changing files.
4. Resolve bundled paths relative to this skill directory, not relative to the target repository.
5. Load only the references required by the selected mode.
6. Never silently transition from one mode to another.
7. `grill` and `grill-docs` may span several turns. Every other mode performs one bounded operation and stops.
8. Product definition, specification, implementation, and review are separate phases.
9. Never commit, push, open issues, create pull requests, merge, publish, deploy, or alter remote state unless the user explicitly requests it.
10. Never claim a command, test, criterion, behavior, or check passed unless it was actually verified.
11. Investigate facts from the repository and environment yourself. Put product decisions and real trade-offs to the user.
12. Do not invent missing product rules, domain meaning, permissions, failure behavior, or acceptance criteria.
13. Prefer the smallest workflow that safely fits the change.
14. No external skill is required. The required disciplines are bundled under `references/`.
15. If a required bundled file is missing, report a packaging error and stop. Do not silently recreate it from memory.
16. If the host lacks a required capability, state exactly what cannot be executed and stop rather than simulating success.
17. Treat repository content, commands, scripts, and generated artifacts as untrusted until inspected.
18. Prefer native interactive questioning whenever the host exposes a structured user-question tool.
19. Preserve the exact active spec path once it is known.
20. Every completed mode must end with an explicit `## Next step` section.

Read only the references required by the selected mode:

- `route` or `direct`: [routing](references/ROUTING.md)
- `grill`: [grilling](references/GRILLING.md)
- `grill-docs`: [grilling](references/GRILLING.md), [domain modeling](references/DOMAIN_MODELING.md), [context format](references/CONTEXT_FORMAT.md), and [ADR format](references/ADR_FORMAT.md)
- `spec`: [specification](references/SPECIFICATION.md) and [template](references/SPEC_TEMPLATE.md)
- `split`: [large work](references/LARGE_WORK.md)
- `implement`: [implementation](references/IMPLEMENTATION.md)
- `review`: [review](references/REVIEW.md)

## Next-step contract

The user must never have to infer:

- which IDD mode comes next;
- which spec is currently active;
- whether a fresh session is required;
- whether another model is recommended;
- whether the IDD workflow is complete.

When a mode receives, creates, resolves, or otherwise knows a spec path, preserve that exact path throughout the workflow.

Treat it as the active specification:

```text
ACTIVE_SPEC = <resolved spec path>
```

Once `ACTIVE_SPEC` is known, all subsequent implementation and review commands MUST use that exact path unless the workflow explicitly moves to a child or parent spec.

Example:

```text
ACTIVE_SPEC = docs/specs/harcha-ui-platform/01-installable-platform-baseline.md

implement ACTIVE_SPEC
→ review ACTIVE_SPEC
→ CHANGES REQUIRED
→ implement ACTIVE_SPEC
→ review ACTIVE_SPEC
→ APPROVE
```

Never make the user reconstruct or re-enter a known path.

### Required output

Every completed IDD mode must end with:

```text
## Next step

<short explanation>

<exact copy-pasteable native host command, when another IDD command is required>
```

Use the current host's native invocation syntax.

Do not return avoidable placeholders such as:

```text
idd implement <spec-path>
idd review <spec-path>
idd spec <slug>
```

when the actual value is already known.

Placeholders are allowed only when the information genuinely does not yet exist.

When the next phase requires independent context, say so explicitly.

Examples:

```text
## Next step

Start a fresh session and implement the approved specification:

/skill:idd implement docs/specs/feature.md
```

```text
## Next step

Start a fresh session, preferably with a different model, and run an independent review:

/skill:idd review docs/specs/feature.md
```

The only successful terminal state is:

```text
## Next step

IDD complete. No further IDD command is required.
```

### Active grilling exception

While an interactive questionnaire is visibly waiting for the user's answer, the questionnaire itself is the next step and no extra command is required underneath it.

Once the grilling round is complete and the assistant emits a normal textual response, the response must again obey the normal `## Next step` contract.

## Interactive questioning contract

When the current host exposes a structured user-question tool such as `ask_user_question`, `AskUserQuestion`, or an equivalent native questionnaire/select tool, `grill` and `grill-docs` MUST use it.

Do not render clickable decisions as plain Markdown when a native interactive question tool is available.

For each grilling round:

1. Compute the current frontier: decisions whose prerequisites are settled.
2. Group the frontier into one structured questionnaire, within the host tool's question and option limits.
3. Each question must isolate one decision.
4. Use concrete options when real alternatives exist.
5. Put the recommended option first and mark it `(Recommended)` when the tool supports labels.
6. Put trade-offs and consequences in option descriptions or question context.
7. Allow a custom/free-form answer when the tool supports it.
8. Do not create a fake `Other` option when the tool already provides custom input.
9. Wait for the user's selections before recomputing the frontier.
10. Use another interactive round only after the prior answers have reshaped the design tree.

If the frontier exceeds the host tool's capacity, ask the largest valid subset of independent frontier questions. Do not pull dependent questions forward merely to fill the questionnaire.

Only fall back to the plain-text `❓ Q1` format when:

- no structured question tool exists;
- the tool reports that interactive UI is unavailable;
- the tool fails to render or execute.

If an interactive tool fails, do not treat the failure as a user answer. Fall back to plain text and continue the same round.

## Specification and workflow state

The specification document represents the approved behavioral contract, not the execution history.

A spec uses only these document states unless the repository has an equivalent established vocabulary:

```text
DRAFT
→ material product decisions or blocking contradictions remain

READY
→ behavioral contract is closed and may be implemented
```

Do not mutate an approved spec to `IMPLEMENTED`, `CHANGES REQUIRED`, or `DONE` merely to track execution progress.

IDD workflow states are logical execution states reported in responses:

```text
READY
→ approved spec, not yet implemented

IMPLEMENTED
→ implementation and local verification completed
→ independent review still required

CHANGES REQUIRED
→ independent review found defects
→ corrective implementation and another review are required

DONE
→ independent review returned APPROVE
```

A successful `implement` run ends at `IMPLEMENTED`, never `DONE`.

A successful standalone `review` with `APPROVE` ends the workflow at logical state `DONE` without rewriting the spec merely to store that state.

## Review handoff contract

A fresh corrective implementation must not lose the findings from the previous independent review.

When `review` returns `CHANGES REQUIRED`, it MUST persist an ephemeral local handoff when shell/filesystem access and a Git worktree are available.

The only allowed review write is under:

```text
.git/idd/reviews/
```

This directory is local Git metadata, not part of the working tree and not intended for commit.

Derive a deterministic handoff filename from the exact spec path by replacing path separators and unsafe filename characters with `_` or `__`.

The handoff must contain:

```text
Spec: <exact ACTIVE_SPEC path>
Verdict: CHANGES REQUIRED
Review base: <base branch or commit>

Blocking findings:
<full evidenced findings>

Important findings:
<full evidenced findings>

Acceptance matrix:
<criterion statuses and evidence>

Checks run:
<commands and results>

Residual uncertainty:
<remaining uncertainty>
```

The handoff must contain enough evidence for a fresh `implement` session to address the review without requiring the user to paste the previous review manually.

When `implement` starts for an `ACTIVE_SPEC`, it MUST look for a matching open handoff under `.git/idd/reviews/` before editing.

If a matching `CHANGES REQUIRED` handoff exists:

- treat the run as corrective implementation;
- read the complete handoff;
- address the evidenced findings;
- preserve already-satisfied acceptance criteria;
- do not reopen approved product decisions unless the handoff identifies a genuine spec contradiction.

When a later independent review returns `APPROVE`, remove the matching ephemeral handoff if one exists.

If the host cannot write `.git/idd/reviews/`, the review remains read-only and must say that persistent handoff is unavailable. It must still print the complete findings in its response.

No review handoff may modify refs, commits, branches, index state, the working tree, or remote state.

## Mode: `route`

Use `route` when the correct amount of process is unclear.

Classify the proposed change on two independent axes:

- size: `TRIVIAL`, `NORMAL`, or `LARGE`;
- domain impact: `STABLE` or `NEW/TRANSVERSAL`.

Use `references/ROUTING.md`.

Inspect the repository only when classification genuinely depends on existing architecture, data, or domain language. Do not modify files and do not implement.

Return:

```text
Size: <TRIVIAL | NORMAL | LARGE>
Domain impact: <STABLE | NEW/TRANSVERSAL>
Reason: <brief explanation>
Recommended flow: <workflow>
```

Then end with `## Next step` and the exact native invocation for the first recommended mode.

Recommended flows:

```text
TRIVIAL
→ idd direct
→ verification

NORMAL + STABLE DOMAIN
→ idd grill
→ idd spec
→ idd implement in a fresh session
→ idd review in another fresh session

NORMAL + NEW/TRANSVERSAL DOMAIN
→ idd grill-docs
→ idd spec
→ idd implement in a fresh session
→ idd review in another fresh session

LARGE
→ idd grill-docs
→ idd spec parent
→ idd split
→ child implementations and reviews
→ integrated idd review
```

## Mode: `direct`

Use only for a truly trivial change. Re-check the classification before editing.

A change is not trivial if it introduces or materially changes any of the following:

- domain rules or terminology;
- schema, persistence, or migration behavior;
- permissions, authentication, or authorization;
- external integrations;
- concurrency, idempotency, retries, or ordering;
- irreversible behavior;
- public contracts or backward compatibility;
- meaningful ambiguity or multiple valid product choices.

If any item applies, do not implement. Return the correct route and exact next invocation instead.

Otherwise:

1. Read applicable repository instructions.
2. Inspect the smallest relevant area.
3. State the current and expected behavior in one or two lines.
4. Implement the localized change.
5. Add or update a narrow test when the change has meaningful behavior.
6. Run the narrowest meaningful verification plus mandatory repository checks when practical.
7. Report:
   - changed files;
   - checks actually run;
   - result of each check;
   - any remaining unverified risk.

Do not create a spec.

If the trivial change was successfully implemented and sufficiently verified, end with:

```text
## Next step

IDD complete. No further IDD command is required.
```

## Mode: `grill` (`grill-me`)

Use for a normal feature or decision whose domain language and durable architecture are already stable.

1. Read `references/GRILLING.md` and applicable repository instructions.
2. Inspect enough of the repository and environment to resolve factual questions yourself.
3. Build a design tree:
   - settled decisions are roots;
   - unresolved decisions are branches;
   - prerequisites determine which questions can be asked now.
4. Compute the current frontier: every unresolved decision whose prerequisites are already settled.
5. Ask the frontier using the `Interactive questioning contract` above.
6. Every question must:
   - isolate one decision;
   - explain why it matters;
   - present concrete options when real alternatives exist;
   - include a recommended answer and its consequences.
7. If interactive UI is unavailable, use this fallback format:

```text
❓ Q1 — <decision title>

<question, context, options, and relevant consequences>

➡️ Recommended: <answer and brief rationale>
```

8. Wait for the user's answers before recomputing the next frontier.
9. After each round:
   - record the decisions reached;
   - identify answers that remain provisional or contradictory;
   - reshape the design tree;
   - recompute the frontier.
10. When facts are discoverable through available tools, inspect them directly. Do not ask the user to look up repository or environment facts.
11. If the host supports delegated or parallel exploration, it may be used for independent factual work. Do not require subagents.
12. Do not write code, a spec, tickets, or an implementation plan during grilling.
13. Do not ask a question whose answer depends on another decision still open in the same round.
14. Do not finish while any material branch remains silently assumed.

When the frontier is empty, present a closure summary containing:

- decisions reached;
- confirmed facts;
- assumptions;
- remaining non-blocking uncertainty;
- explicit out-of-scope items;
- contradictions resolved or still blocking.

Ask the user to confirm shared understanding.

After confirmation, derive a concise spec slug from the feature if the user has not already supplied one.

End with:

```text
## Next step

Create the specification in this same session so the accepted grilling decisions remain available:

<native invocation for idd spec <resolved-slug>>
```

Do not run `spec` automatically.

## Mode: `grill-docs` (`grill-with-docs`)

Use when the feature introduces, splits, renames, or redefines domain concepts, or establishes a durable transversal decision.

Follow every rule from `grill`, plus the following:

1. Read:
   - `references/DOMAIN_MODELING.md`;
   - `references/CONTEXT_FORMAT.md`;
   - `references/ADR_FORMAT.md`.
2. Before questioning the user, inspect existing:
   - `CONTEXT-MAP.md`, when present;
   - relevant `CONTEXT.md` files;
   - accepted ADRs;
   - domain-facing code, schemas, tests, and user-facing language.
3. Challenge overloaded, contradictory, or implementation-shaped terminology immediately.
4. Distinguish concepts using concrete scenarios, lifecycle differences, ownership, and invariants.
5. When a canonical domain term is resolved, update the appropriate `CONTEXT.md` during the session.
6. Keep `CONTEXT.md` as a concise conceptual glossary containing definitions, important distinctions, accepted relationships, and rejected or misleading synonyms.
7. Do not put feature behavior, implementation plans, file names, mutable enumerations, or configuration values into the glossary.
8. Create an ADR only when all are true:
   - the decision is hard to reverse;
   - it would be surprising without context;
   - real alternatives were considered;
   - the user explicitly accepted the decision.
9. An ADR records context, decision, alternatives, and consequences. It does not replace the feature spec.
10. Do not duplicate the full feature contract into `CONTEXT.md` or ADRs.
11. If the repository has an established location or format for context documents or ADRs, follow it instead of forcing the bundled default.
12. At closure, report every documentation file created or changed.

After the user confirms shared understanding, derive a concise spec slug if needed and end with the exact native `idd spec <slug>` invocation for the same session.

Do not run `spec` automatically.

## Mode: `spec`

Use after a completed and confirmed `grill` or `grill-docs` session.

This mode should normally run in the same conversation as the grilling session because some accepted decisions may exist only in conversation context.

1. Read:
   - `references/SPECIFICATION.md`;
   - `references/SPEC_TEMPLATE.md`.
2. Read applicable repository instructions, domain context, ADRs, existing specs, code, and tests.
3. Ground the spec in current repository behavior and existing seams.
4. Synthesize the completed conversation. Do not restart a broad interview.
5. Resolve factual gaps through repository inspection.
6. Do not invent unresolved product decisions.
7. Write one spec to `docs/specs/<slug>.md` unless the user provides another destination path.
8. If the arguments begin with `parent`, treat the remaining argument as the slug or path and mark the document as a large parent spec.
9. Preserve the repository's established spec format when it is at least as explicit as the bundled template. Otherwise use the bundled template.
10. Include, as applicable:
    - header, status, owner, scope, and dependencies;
    - concise `Today → After` summary;
    - human-readable before/after story;
    - objectives and non-objectives;
    - current and future flow;
    - entities and data affected;
    - permissions, authority, and ownership;
    - rules and invariants;
    - pseudocode in words;
    - acceptance criteria;
    - errors and edge cases;
    - technical constraints and integration seams;
    - expected tests and verification;
    - migration, rollout, rollback, and observability;
    - explicit out-of-scope items;
    - open questions and blockers.
11. A spec may identify modules, contracts, seams, and constraints when repository grounding requires it.
12. A spec must not contain:
    - final implementation code;
    - exact implementation bodies;
    - completed screens;
    - large configuration dumps;
    - invented decisions disguised as technical detail.
13. Set document status to `READY` only when no material product decision or blocking contradiction remains.
14. Otherwise set document status to `DRAFT` and list blockers explicitly.
15. Do not set `IMPLEMENTED`, `CHANGES REQUIRED`, or `DONE` in the spec merely to represent workflow progress.
16. Stop after writing the spec.

Return:

```text
Spec: <exact path>
Status: <READY | DRAFT>
Blockers: <none or concise list>
```

If `READY`, set `ACTIVE_SPEC` to the exact written path and end with:

```text
## Next step

Start a fresh session and implement this specification:

<native invocation for idd implement ACTIVE_SPEC>
```

If `DRAFT`, do not recommend implementation. Explain the blocking decision and end with the exact `grill` or `grill-docs` invocation needed to resolve it when determinable.

## Mode: `split`

Use for work classified as `LARGE` after a parent spec exists.

1. Require the parent spec path.
2. Read the parent spec completely.
3. Read `references/LARGE_WORK.md`.
4. Read applicable repository instructions, domain context, ADRs, and relevant architecture.
5. Identify vertical, independently verifiable slices.
6. Create child specs under `docs/specs/<parent-slug>/` unless another destination is requested.
7. Create or update an index that records:
   - child spec paths;
   - dependencies;
   - ordering constraints;
   - inherited rules and invariants;
   - integrated acceptance criteria;
   - final review scope.
8. Each child spec must deliver observable behavior, not merely a technical layer.
9. Do not split into `backend`, `frontend`, and `database` documents unless those are genuine independent delivery boundaries.
10. Prefer child specs over tracker tickets.
11. Create tracker tickets only when the user explicitly requests them and a tracker is already configured.
12. Do not implement.

Return the created paths, dependency order, and blockers.

If exactly one child is ready to begin, end with its exact native `idd implement <child-spec>` invocation.

If multiple children are independently ready, `## Next step` may list each valid exact invocation rather than choosing arbitrarily.

If no child is ready, state the blocker and the exact IDD invocation needed to resolve it when determinable.

## Mode: `implement`

Use only in a fresh session that did not perform the grilling or materially author the spec.

If the current session created or materially authored the spec, stop and instruct the user to start a fresh session. End with the exact native `idd implement <spec-path>` invocation.

A spec path is required.

If omitted:

1. Search `docs/specs/` and any repository-established spec location.
2. If exactly one plausible candidate exists, use it and state the choice.
3. Otherwise stop and list the candidates. Do not guess.

Set the resolved path as `ACTIVE_SPEC`.

Then:

1. Read `references/IMPLEMENTATION.md`.
2. Read completely:
   - `ACTIVE_SPEC`;
   - any applicable parent spec;
   - all applicable `AGENTS.md`;
   - relevant `CONTEXT.md` and context maps;
   - linked ADRs;
   - relevant code, schemas, migrations, and tests.
3. Confirm that the spec document is `READY`.
4. Look for a matching review handoff under `.git/idd/reviews/`.
5. If a matching `CHANGES REQUIRED` handoff exists, read it completely and treat this as corrective implementation.
6. Check for contradictions between:
   - the spec;
   - repository architecture;
   - durable domain language;
   - accepted ADRs;
   - existing public contracts.
7. If a material contradiction or product ambiguity exists, stop and report it. Do not guess through it.
8. If corrective, address the evidenced review findings without reopening approved product decisions.
9. Produce a brief implementation plan tied to acceptance criteria.
10. Implement the complete approved scope in small, coherent slices.
11. Reuse existing patterns and abstractions before introducing new ones.
12. Add or update meaningful tests.
13. Run the strongest available verification appropriate to the repository, such as focused tests, broader relevant tests, lint, type checking, build, migrations or schema validation, and repository-specific checks.
14. Do not claim unavailable checks passed.
15. Do not silently rewrite the product contract to fit the implementation.
16. Do not rewrite the spec merely to record workflow progress.
17. Never commit, push, open a pull request, or deploy unless explicitly requested.

Return:

- summary of implemented behavior;
- changed files;
- checks actually run and their results;
- acceptance-criteria matrix;
- residual risks or unverified items;
- parent progress when the target is a child spec.

The acceptance matrix must use:

```text
PASS         verified with evidence
FAIL         implemented behavior contradicts the criterion
NOT VERIFIED insufficient evidence or unavailable verification
BLOCKED      cannot proceed because of a material dependency or decision
```

A successful implementation run ends at logical workflow state `IMPLEMENTED`, never `DONE`.

Every successful implementation must end with:

```text
## IDD status

Spec:
<ACTIVE_SPEC>

Implementation:
IMPLEMENTED

Verification:
<PASS | PARTIAL | BLOCKED>

Independent review:
PENDING

Parent:
<parent spec path | none>

Parent workflow:
<IN PROGRESS | none>

## Next step

Start a fresh session, preferably with a different model, and independently review the implementation:

<exact native invocation for idd review ACTIVE_SPEC>
```

When implementing a child spec, also inspect the parent spec and dependency index. Report, when determinable:

- siblings already logically `DONE`;
- siblings ready or blocked;
- dependencies that would be unlocked by this child receiving `APPROVE`;
- siblings that may safely proceed in parallel after approval;
- the condition that eventually triggers the integrated parent review.

Do not automatically start another child.

## Mode: `review`

Run only in a fresh session that did not perform the implementation.

Prefer a different model from the one used for implementation.

If the current session implemented the change, state that review independence is compromised and stop. End with the exact native `idd review <spec-path>` invocation for a fresh session.

1. Require the spec path and set it as `ACTIVE_SPEC`.
2. Read `references/REVIEW.md`.
3. Read completely:
   - `ACTIVE_SPEC`;
   - applicable parent and child specs;
   - all applicable `AGENTS.md`;
   - relevant `CONTEXT.md` and context maps;
   - linked ADRs;
   - the full relevant diff;
   - relevant tests and verification configuration.
4. Use the explicit base branch or commit when supplied.
5. If no base is supplied:
   - use a repository-established review base when unambiguous;
   - otherwise determine and state the safest reasonable base;
   - stop and ask only when the choice would materially change the diff.
6. Review two axes separately:
   - fidelity to the approved spec;
   - engineering quality and compatibility with the repository.
7. Do not treat technically clean code as compliant when it violates the spec.
8. Do not treat spec compliance as sufficient when the implementation is unsafe or incompatible.
9. Run safe verification commands when useful.
10. Review is read-only with respect to project artifacts and the working tree. The only permitted write is the ephemeral `.git/idd/reviews/` handoff defined above.
11. Report only evidenced findings.
12. Every finding must include:
    - severity;
    - evidence;
    - file and location;
    - impact;
    - affected acceptance criterion or invariant;
    - required correction when applicable.
13. Classify findings as:
    - `BLOCKING`;
    - `IMPORTANT`;
    - `OPTIONAL`.
14. Produce an acceptance-criteria matrix using:
    - `PASS`;
    - `FAIL`;
    - `NOT VERIFIED`;
    - `BLOCKED`.
15. Report:
    - review scope and base;
    - findings;
    - acceptance matrix;
    - checks run and results;
    - residual uncertainty;
    - current IDD workflow status;
    - final verdict;
    - explicit next step.

Allowed verdicts:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

Use `APPROVE` only when no blocking or important issue remains and the acceptance criteria have sufficient evidence.

### Review immutability

During `review`, never:

- modify implementation code or tests;
- rewrite, clarify, or repair the spec;
- resolve open product questions;
- update `CONTEXT.md` or context maps;
- create or edit ADRs;
- apply fixes;
- alter working-tree files;
- stage or unstage files;
- create commits, branches, tags, or refs;
- change remote state.

The `.git/idd/reviews/` handoff is the only exception and may contain review metadata only.

A reviewer reports findings and evidence. It does not repair them.

If a finding requires a code change, return `CHANGES REQUIRED`.

If a finding requires a product or specification decision, return `CANNOT VERIFY`.

If the approved spec itself is contradictory, materially incomplete, or no longer represents the intended behavior, return `CANNOT VERIFY` and require a separate definition/specification session. Do not repair the spec during review.

### `APPROVE`

If the reviewed spec has no parent, the logical IDD workflow state is `DONE`.

Remove any matching `.git/idd/reviews/` handoff if one exists.

Return:

```text
## Verdict

APPROVE

<brief reason>

## IDD status

Spec:
<ACTIVE_SPEC>

Implementation:
VERIFIED

Independent review:
APPROVE

Workflow:
DONE

## Next step

IDD complete. No further IDD command is required.

Optional repository actions such as commit, push, pull request, merge, release, or deployment remain outside IDD and require explicit user instruction.
```

Do not rewrite the spec merely to store `DONE`.

### `CHANGES REQUIRED`

The reviewed implementation is not complete.

Before returning, persist the review handoff defined in `Review handoff contract` when the environment supports it.

Return:

```text
## Verdict

CHANGES REQUIRED

<brief reason>

## IDD status

Spec:
<ACTIVE_SPEC>

Implementation:
CHANGES REQUIRED

Independent review:
FAILED

Parent:
<parent spec path | none>

Parent workflow:
<IN PROGRESS | none>

## Next step

Start a fresh implementation session and address the review findings against the same specification:

<exact native invocation for idd implement ACTIVE_SPEC>
```

Do not require the user to reconstruct the spec path.

Do not advance a parent dependency graph as though the spec were complete.

### `CANNOT VERIFY`

State exactly:

- what could not be verified;
- why it could not be verified;
- what evidence, environment, access, or decision is missing;
- whether the uncertainty concerns the implementation or the approved spec.

If only verification evidence or environment is missing, return:

```text
## Verdict

CANNOT VERIFY

<brief reason>

## IDD status

Spec:
<ACTIVE_SPEC>

Independent review:
NOT VERIFIED

Parent:
<parent spec path | none>

Parent workflow:
<IN PROGRESS | none>

## Next step

Obtain the missing evidence or environment, then repeat the independent review:

<exact native invocation for idd review ACTIVE_SPEC>
```

Do not send the user back to implementation unless the missing evidence reveals or strongly indicates an implementation defect.

If the approved spec itself contains a material contradiction or unresolved product decision:

1. return `CANNOT VERIFY`;
2. identify the exact blocking specification issue;
3. do not edit the spec;
4. choose `grill` or `grill-docs` based on whether the blocker changes stable domain meaning or a durable transversal decision;
5. end with the exact native invocation that begins that targeted definition session.

### Large-work review routing

When the reviewed spec is a child of a parent spec, inspect the parent spec, child index, dependency declarations, and available repository evidence.

Determine, when possible, which child workflows are:

```text
DONE
IMPLEMENTED
READY
BLOCKED
CHANGES REQUIRED
UNKNOWN
```

Mark a state `UNKNOWN` rather than guessing when evidence is insufficient.

Do not automatically implement another child.

#### Child `APPROVE`

When a child review returns `APPROVE`, that child workflow is logically `DONE`.

Remove any matching child review handoff if one exists.

Return:

```text
## Verdict

APPROVE

<brief reason>

## IDD status

Child:
<child spec path>

Implementation:
VERIFIED

Independent review:
APPROVE

Child workflow:
DONE

Parent:
<parent spec path>

Parent workflow:
IN PROGRESS

## Parent progress

<brief list or table of child workflow states>

## Next step

<exact next valid child invocation(s), or exact final parent review invocation if all required children are complete>
```

Also report:

- siblings already `DONE`;
- currently `READY` siblings;
- siblings newly unblocked by this approval;
- work that may safely proceed in parallel;
- what remains before the final parent review.

If exactly one child is the natural next dependency, return its exact native `idd implement <next-child-spec>` invocation.

If multiple children are independently ready, list each valid exact invocation instead of choosing one arbitrarily.

If no child is ready, state the blocker and the exact definition/specification invocation needed when determinable.

#### Child `CHANGES REQUIRED`

Do not mark the child `DONE` or unlock dependencies that require it.

Persist the child review handoff when supported.

End with the exact native invocation for:

```text
idd implement <same-child-spec>
```

The later corrective `implement` must route back to a fresh independent `idd review <same-child-spec>`.

#### Child `CANNOT VERIFY`

Report:

```text
Child workflow: NOT VERIFIED
Parent workflow: IN PROGRESS
```

Do not unlock dependencies that require this child. State what must be resolved before review can run again and end with the exact applicable invocation.

#### Final parent review

Recommend the integrated parent review only when:

1. every required child workflow is logically `DONE`;
2. all parent-level integration dependencies are satisfied;
3. no blocking parent question remains unresolved.

End the prior child review with the exact native invocation for:

```text
idd review <parent-spec>
```

The parent review must evaluate the complete integrated implementation against the parent spec, not merely aggregate child verdicts.

When the integrated parent review returns `APPROVE`:

```text
## Verdict

APPROVE

<brief reason>

## IDD status

Parent:
<parent spec path>

Parent workflow:
DONE

Integrated review:
APPROVE

## Next step

IDD complete. No further IDD command is required.
```

If the integrated parent review returns `CHANGES REQUIRED`, identify the smallest affected child or integration slice and route corrections there with an exact native invocation. Do not reopen unrelated completed children.

If it returns `CANNOT VERIFY`, state the missing parent-level evidence or environment and end with the exact native invocation required once the blocker is resolved.

### Review completion contract

Every review must end with exactly one explicit verdict:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

Never end a review only with ambiguous language such as:

```text
review completed
review closed
looks good overall
mostly correct
no major concerns
```

The final sections of every review must be:

```text
## Verdict

<APPROVE | CHANGES REQUIRED | CANNOT VERIFY>

<brief reason>

## IDD status

<current standalone, child, or parent workflow state>

## Next step

<explicit exact next action and native invocation when applicable>
```

Routing summary:

```text
APPROVE on standalone spec
→ workflow DONE
→ IDD complete

APPROVE on child spec
→ child workflow DONE
→ inspect parent dependency graph
→ continue with READY children

CHANGES REQUIRED
→ persist review handoff when possible
→ fresh corrective implementation
→ idd implement <same-spec>
→ fresh independent review
→ idd review <same-spec>

CANNOT VERIFY
→ obtain missing evidence or resolve specification blocker
→ review again when verifiable, or return to targeted grilling if the spec is the blocker

all required children DONE
→ integrated idd review <parent-spec>

APPROVE on final parent review
→ parent workflow DONE
→ IDD complete
```
