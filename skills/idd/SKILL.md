---
name: idd
description: Inshallah Driven Development (IDD), a self-contained software delivery workflow for Pi. It routes changes, grills product decisions, maintains domain language and ADRs when needed, writes repository-grounded PRD/specs, decomposes large work, implements approved specs, and performs independent spec reviews. Invoke explicitly with route, direct, grill, grill-docs, spec, split, implement, or review.
compatibility: Requires Pi or another Agent Skills-compatible coding agent with read, write, edit, and shell access inside a trusted project. No external skills are required.
disable-model-invocation: true
metadata:
  author: Juan Latorre
  version: "2.0.0"
---

# IDD — Inshallah Driven Development

A controlled path from an idea to verified code, with enough discipline to verify the result and no more process than the change requires.

## Invocation contract

The first argument is the mode:

```text
/skill:idd route <change or idea>
/skill:idd direct <small, explicit change>
/skill:idd grill <plan, decision, or feature>
/skill:idd grill-docs <plan, decision, or feature>
/skill:idd spec <slug or destination path>
/skill:idd split <parent spec path>
/skill:idd implement <spec path>
/skill:idd review <spec path> [base branch or commit]
```

Accepted aliases:

```text
grill-me        → grill
grill-with-docs → grill-docs
```

If the mode is missing or unknown, show the modes above and stop.

## Global rules

1. Use the user's language. Preserve canonical terms from `CONTEXT.md`, context maps, and accepted ADRs.
2. Read all applicable `AGENTS.md` files and repository instructions before changing files.
3. Never silently transition from grilling to specification, from specification to implementation, or from implementation to review.
4. `grill` and `grill-docs` may span several turns. Every other mode completes one bounded operation and stops.
5. Never commit, push, open issues, merge, or alter remote state unless explicitly requested.
6. Never claim a command, test, check, criterion, or behavior passed unless it was actually verified.
7. Do not invent product decisions. Investigate facts from the repository or environment; put decisions and trade-offs to the user.
8. Prefer the smallest workflow that safely fits the change.
9. No mode requires another installed skill. The required disciplines are bundled under `references/`.

Read only the references required by the selected mode:

- `route` or `direct`: [routing](references/ROUTING.md)
- `grill`: [grilling](references/GRILLING.md)
- `grill-docs`: [grilling](references/GRILLING.md), [domain modeling](references/DOMAIN_MODELING.md), [context format](references/CONTEXT_FORMAT.md), and [ADR format](references/ADR_FORMAT.md)
- `spec`: [specification](references/SPECIFICATION.md) and [template](references/SPEC_TEMPLATE.md)
- `split`: [large work](references/LARGE_WORK.md)
- `implement`: [implementation](references/IMPLEMENTATION.md)
- `review`: [review](references/REVIEW.md)

## Mode: `route`

Classify the proposed change on two independent axes:

- size: `TRIVIAL`, `NORMAL`, or `LARGE`;
- domain impact: `STABLE` or `NEW/TRANSVERSAL`.

Use `references/ROUTING.md`. Inspect the repository only when classification genuinely depends on it. Do not modify files and do not implement.

Return:

```text
Size:
Domain impact:
Reason:
Recommended flow:
Next command:
```

The recommended flow must be one of:

```text
TRIVIAL
→ direct implementation
→ verification

NORMAL + STABLE DOMAIN
→ idd grill
→ one spec
→ implementation in a clean session
→ review in another model/session

NORMAL + NEW/TRANSVERSAL DOMAIN
→ idd grill-docs
→ one spec
→ implementation in a clean session
→ review in another model/session

LARGE
→ idd grill-docs
→ parent spec
→ child specs
→ multiple implementations
→ integrated final review
```

Express every next command as `/skill:idd <mode> ...`.

## Mode: `direct`

Use only for a truly trivial change. Re-check the classification before editing.

If the task introduces domain rules, schema changes, permissions, external integrations, migrations, concurrency, irreversible behavior, or meaningful ambiguity, do not implement it. Return the correct route instead.

Otherwise:

1. Inspect the smallest relevant area of the repository.
2. State the current and expected behavior in one or two lines.
3. Implement the localized change.
4. Run the narrowest meaningful verification, plus mandatory repository checks when practical.
5. Report changed files, checks run, and any unverified risk.

Do not create a spec.

## Mode: `grill` (`grill-me`)

Use for a normal feature or decision whose domain language and durable architecture are already stable.

1. Read `references/GRILLING.md` and applicable repository instructions.
2. Inspect enough of the repository and environment to resolve factual questions yourself.
3. Build a design tree: settled decisions are roots; unresolved decisions are branches; prerequisites determine what can be asked now.
4. Ask the whole current frontier in one numbered round. Every question must include a concrete recommendation.
5. Wait for the user's answers. Then record the decisions, reshape the tree, recompute the frontier, and ask the next round.
6. Do not write code, a spec, tickets, or implementation plans during grilling.
7. When the frontier is empty, present a closure summary containing:
   - decisions reached;
   - confirmed facts;
   - assumptions;
   - remaining non-blocking uncertainty;
   - explicit out-of-scope items.
8. Ask the user to confirm shared understanding. After confirmation, stop and show the next command:

```text
/skill:idd spec <slug>
```

Do not run `spec` automatically.

## Mode: `grill-docs` (`grill-with-docs`)

Use when the feature introduces, splits, renames, or redefines domain concepts, or establishes a durable transversal decision.

1. Follow all rules from `grill`.
2. Also read `references/DOMAIN_MODELING.md`, `CONTEXT_FORMAT.md`, and `ADR_FORMAT.md`.
3. Read existing `CONTEXT-MAP.md`, relevant `CONTEXT.md` files, ADRs, and code before deciding how the domain currently works.
4. Challenge overloaded or conflicting language immediately. Distinguish concepts with concrete scenarios.
5. When a canonical domain term is resolved, update the appropriate `CONTEXT.md` during the session. Keep it a concise glossary without implementation details.
6. Create an ADR only when the decision is hard to reverse, surprising without context, and the result of a real trade-off. The user's acceptance of the decision is required before writing it.
7. Do not duplicate the full feature behavior into `CONTEXT.md` or ADRs; the later spec remains the complete feature contract.
8. At closure, report every documentation file created or changed, then show:

```text
/skill:idd spec <slug>
```

Do not run `spec` automatically.

## Mode: `spec`

This mode should normally run in the same conversation immediately after a completed `grill` or `grill-docs` session, because some decisions exist only in the conversation.

1. Read `references/SPECIFICATION.md` and `references/SPEC_TEMPLATE.md`.
2. Inspect the repository enough to ground the spec in current behavior, existing seams, data, tests, conventions, `CONTEXT.md`, and ADRs.
3. Synthesize the completed conversation; do not restart a broad interview.
4. Write one spec to `docs/specs/<slug>.md` unless the user provides another path. If the arguments begin with `parent`, treat the remaining argument as the slug/path and set size to `LARGE-PARENT`.
5. Use status `READY` only when no material product decision remains unresolved. Otherwise use `DRAFT` and list blockers.
6. Do not write final code, exact implementation bodies, finished screens, or configuration dumps.
7. Stop after writing the spec.

Return a concise completion report containing the path, status, unresolved blockers, and the exact next command for a clean implementation session.

## Mode: `split`

Use for work classified as `LARGE` after a parent spec exists.

1. Read the parent spec completely.
2. Read `references/LARGE_WORK.md`.
3. Inspect the repository and identify vertical, independently verifiable slices.
4. Create child specs under `docs/specs/<parent-slug>/` unless another destination is requested.
5. Add an index describing dependencies, ordering, inherited invariants, and integrated acceptance.
6. Prefer child specs over tracker tickets. Create tracker tickets only when the user explicitly requests them and a tracker is already configured.
7. Do not implement.

## Mode: `implement`

A spec path is required. If omitted, search `docs/specs/`; when exactly one plausible candidate exists, use it and state the choice. Otherwise stop and list candidates.

1. Read `references/IMPLEMENTATION.md`.
2. Read the complete spec, applicable parent spec, `AGENTS.md`, `CONTEXT.md`, linked ADRs, and relevant code/tests.
3. Check readiness and contradictions before editing.
4. Implement the complete approved scope in small, coherent slices.
5. Add or update meaningful tests.
6. Run the strongest available verification appropriate to the repository.
7. Produce an acceptance-criteria matrix with evidence.
8. Update only the spec's status and verification note when all criteria are satisfied; never rewrite product decisions silently.

Stop on material contradictions between the approved behavior and durable project decisions. Do not guess through them.

## Mode: `review`

Run this in a fresh session with a different model whenever practical. If the current session performed the implementation, state that independence is compromised and stop, instructing the user to start a new session.

1. Read `references/REVIEW.md`.
2. Read the complete spec, parent/child specs, `AGENTS.md`, `CONTEXT.md`, ADRs, and the full relevant diff.
3. Review two axes separately:
   - fidelity to the approved spec;
   - engineering quality and compatibility with the repository.
4. Run safe verification commands when useful.
5. Do not modify code.
6. Report only evidenced findings, an acceptance matrix, checks run, residual uncertainty, and a verdict.

Verdicts:

- `APPROVE`
- `CHANGES REQUIRED`
- `CANNOT VERIFY`
