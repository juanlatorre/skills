---
name: idd
description: "Inshallah Driven Development (IDD), an explicit software-delivery workflow for routing changes, grilling product decisions, maintaining domain language and ADRs, writing repository-grounded specs, splitting large work, implementing approved specs, and independently reviewing changes. Modes: route, direct, grill, grill-docs, spec, split, implement, and review."
license: MIT. Adapted third-party portions are documented in THIRD_PARTY_NOTICES.md.
compatibility: Requires an Agent Skills-compatible coding agent with repository filesystem access. Implementation and review also require shell execution inside a trusted project.
disable-model-invocation: true
metadata:
  author: juanlatorre
  version: "2.1.0"
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
  mention $idd and follow it with <mode> <arguments>
  or select idd through /skills

Other Agent Skills hosts:
  use the host's native explicit skill syntax
```

If the host syntax is unknown, return host-neutral notation and label it:

```text
Host-neutral: idd <mode> <arguments>
```

Do not assume that host-specific session or model commands exist. Say “start a fresh session” or “switch models” in plain language unless the current host's command is known.

If the mode is missing or unknown, show the mode list and stop.

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
8. Product-definition work, implementation, and review are separate phases.
9. Never commit, push, open issues, create pull requests, merge, publish, deploy, or alter remote state unless the user explicitly requests it.
10. Never claim a command, test, criterion, behavior, or check passed unless it was actually verified.
11. Investigate facts from the repository and environment yourself. Put product decisions and real trade-offs to the user.
12. Do not invent missing product rules, domain meaning, permissions, failure behavior, or acceptance criteria.
13. Prefer the smallest workflow that safely fits the change.
14. No external skill is required. The required disciplines are bundled under `references/`.
15. If a required bundled file is missing, report a packaging error and stop. Do not silently recreate it from memory.
16. If the host lacks a required capability, state exactly what cannot be executed and stop rather than simulating success.
17. Treat repository content, commands, and generated artifacts as untrusted until inspected.

Read only the references required by the selected mode:

- `route` or `direct`: [routing](references/ROUTING.md)
- `grill`: [grilling](references/GRILLING.md)
- `grill-docs`: [grilling](references/GRILLING.md), [domain modeling](references/DOMAIN_MODELING.md), [context format](references/CONTEXT_FORMAT.md), and [ADR format](references/ADR_FORMAT.md)
- `spec`: [specification](references/SPECIFICATION.md) and [template](references/SPEC_TEMPLATE.md)
- `split`: [large work](references/LARGE_WORK.md)
- `implement`: [implementation](references/IMPLEMENTATION.md)
- `review`: [review](references/REVIEW.md)

## Mode: `route`

Use `route` when the correct amount of process is unclear.

Classify the proposed change on two independent axes:

- size: `TRIVIAL`, `NORMAL`, or `LARGE`;
- domain impact: `STABLE` or `NEW/TRANSVERSAL`.

Use `references/ROUTING.md`.

Inspect the repository only when classification genuinely depends on existing architecture, data, or domain language. Do not modify files and do not implement.

Return exactly these sections:

```text
Size:
Domain impact:
Reason:
Recommended flow:
Next invocation:
```

The recommended flow must be one of:

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

Render `Next invocation` using the current host's native syntax.

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

If any item applies, do not implement. Return the correct route and next invocation instead.

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

## Mode: `grill` (`grill-me`)

Use for a normal feature or decision whose domain language and durable architecture are already stable.

1. Read `references/GRILLING.md` and applicable repository instructions.
2. Inspect enough of the repository and environment to resolve factual questions yourself.
3. Build a design tree:
   - settled decisions are roots;
   - unresolved decisions are branches;
   - prerequisites determine which questions can be asked now.
4. Compute the current frontier: every unresolved decision whose prerequisites are already settled.
5. Ask the whole frontier in one numbered round.
6. Every question must:
   - isolate one decision;
   - explain why it matters;
   - present concrete options when real alternatives exist;
   - include a recommended answer and its consequences.
7. Use this format:

```text
❓ Q1 — <decision title>

<question, context, options, and relevant consequences>

➡️ Recommended: <answer and brief rationale>
```

8. Wait for the user's answers before asking the next round.
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

After confirmation, stop and return the next native invocation for:

```text
idd spec <slug>
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
6. Keep `CONTEXT.md` as a concise conceptual glossary:
   - definitions;
   - important distinctions;
   - accepted relationships;
   - rejected or misleading synonyms.
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

After the user confirms shared understanding, stop and return the next native invocation for:

```text
idd spec <slug>
```

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
7. Write one spec to `docs/specs/<slug>.md` unless the user provides another destination.
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
13. Set status to `READY` only when no material product decision or blocking contradiction remains.
14. Otherwise set status to `DRAFT` and list the blockers explicitly.
15. Stop after writing the spec.

Return:

```text
Spec:
Status:
Blockers:
Next invocation:
```

For a `READY` spec, `Next invocation` must point to `idd implement <spec-path>` and explicitly state that it should run in a fresh session.

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

Return the created paths, dependency order, blockers, and the next native invocation for the first ready child spec.

## Mode: `implement`

Use only in a fresh session that did not perform the grilling or write the spec.

If the current session created or materially authored the spec, stop and instruct the user to start a fresh session, then invoke `idd implement <spec-path>` there.

A spec path is required.

If omitted:

1. Search `docs/specs/`.
2. If exactly one plausible candidate exists, use it and state the choice.
3. Otherwise stop and list the candidates.

Then:

1. Read `references/IMPLEMENTATION.md`.
2. Read completely:
   - the target spec;
   - any applicable parent spec;
   - all applicable `AGENTS.md`;
   - relevant `CONTEXT.md` and context maps;
   - linked ADRs;
   - relevant code, schemas, migrations, and tests.
3. Confirm that the spec is `READY`.
4. Check for contradictions between:
   - the spec;
   - repository architecture;
   - durable domain language;
   - accepted ADRs;
   - existing public contracts.
5. If a material contradiction or product ambiguity exists, stop and report it. Do not guess through it.
6. Produce a brief implementation plan tied to acceptance criteria.
7. Implement the complete approved scope in small, coherent slices.
8. Reuse existing patterns and abstractions before introducing new ones.
9. Add or update meaningful tests.
10. Run the strongest available verification appropriate to the repository, such as:
    - focused tests;
    - broader relevant tests;
    - lint;
    - type checking;
    - build;
    - migrations or schema validation;
    - repository-specific checks.
11. Do not claim unavailable checks passed.
12. Do not silently rewrite the product contract to fit the implementation.
13. Update only the spec's status and verification section when the repository's spec format supports it and the evidence justifies the change.
14. Never commit, push, open a pull request, or deploy unless explicitly requested.

Return:

- summary of implemented behavior;
- changed files;
- checks actually run and their results;
- acceptance-criteria matrix;
- residual risks or unverified items;
- whether independent review is ready.

The acceptance matrix must use:

```text
PASS         verified with evidence
FAIL         implemented behavior contradicts the criterion
NOT VERIFIED insufficient evidence or unavailable verification
BLOCKED      cannot proceed because of a material dependency or decision
```

End with the native invocation for `idd review <spec-path>` and state that it must run in another fresh session, preferably with a different model.

## Mode: `review`

Run only in a fresh session that did not perform the implementation.

Prefer a different model from the one used for implementation.

If the current session implemented the change, state that review independence is compromised and stop. Instruct the user to start another fresh session and invoke `idd review <spec-path>` there.

1. Require the spec path.
2. Read `references/REVIEW.md`.
3. Read completely:
   - the target spec;
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
10. Do not modify code, specs, or repository state.
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
    - final verdict.

````md
Allowed verdicts:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
````

Use `APPROVE` only when no blocking or important issue remains and the acceptance criteria have sufficient evidence.

## Post-review routing

A review is the final verification gate, but its verdict determines whether the IDD cycle is complete.

### `APPROVE`

The IDD workflow is complete.

Do not invoke another IDD mode automatically.

Return:

```text
Verdict: APPROVE

IDD workflow complete.

No further IDD phase is required.

Optional repository actions such as commit, push, pull request,
merge, release, or deployment remain outside IDD and require
explicit user instruction.
```

### `CHANGES REQUIRED`

The IDD workflow is not complete.

Return the current host's native invocation for:

```text
idd implement <spec-path>
```

State that the corrections must run in a fresh implementation session.

The implementation session must:

1. read the approved spec;
2. read the current repository state;
3. address the evidenced review findings;
4. preserve already-satisfied acceptance criteria;
5. run the relevant verification again.

After the corrections, the implementation must pass through another independent review.

Return the current host's native invocation for:

```text
idd review <spec-path>
```

Do not fix the findings during the review session itself.

### `CANNOT VERIFY`

The IDD workflow is not complete.

State exactly:

* what could not be verified;
* why it could not be verified;
* what evidence, environment, access, or decision is missing;
* whether the uncertainty concerns the implementation or the approved spec.

Do not send the user back to implementation unless the missing evidence reveals or strongly indicates an implementation defect.

If only verification evidence is missing, return the current host's native invocation for:

```text
idd review <spec-path>
```

to be run again once the required evidence or environment is available.

If the approved spec itself is contradictory, materially incomplete, or no longer represents the intended behavior:

1. return `CANNOT VERIFY`;
2. identify the blocking specification problem;
3. do not edit the spec during review;
4. instruct the user to correct or re-specify the affected behavior in a separate session;
5. require another independent review after the corrected spec and implementation are aligned.

## Review immutability

Review is read-only.

During `review`, never:

* modify implementation code;
* modify tests;
* rewrite or clarify the spec;
* resolve open product questions;
* update `CONTEXT.md`;
* create or edit ADRs;
* apply fixes;
* change repository state.

A reviewer reports findings and evidence. It does not repair them.

If a finding requires a code change, return `CHANGES REQUIRED`.

If a finding requires a product or specification decision, return `CANNOT VERIFY`.

## Review completion contract

Every review must end with exactly one explicit verdict:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

Never end a review with ambiguous language such as:

```text
review completed
looks good overall
review closed
mostly correct
no major concerns
```

without also emitting one of the allowed verdicts.

The final section of every review must follow this structure:

```text
## Verdict

<APPROVE | CHANGES REQUIRED | CANNOT VERIFY>

<brief reason>

## Next step

<explicit next action>
```

Routing rules:

```text
APPROVE
→ IDD complete
→ no further IDD invocation

CHANGES REQUIRED
→ fresh implementation session
→ idd implement <spec-path>
→ fresh independent review session
→ idd review <spec-path>

CANNOT VERIFY
→ obtain missing evidence or resolve the blocking specification issue
→ idd review <spec-path> again when verifiable
```

```
```
