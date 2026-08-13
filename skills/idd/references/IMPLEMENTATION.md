# Implementing from a spec

The approved spec is the behavioral contract. The repository is the technical reality. Implementation must satisfy both without silently changing either.

## Before editing

1. Read the complete spec and any parent/child references.
2. Read applicable `AGENTS.md`, `CONTEXT.md`, ADRs, and repository documentation.
3. Inspect current code, tests, schemas, contracts, and recent patterns in the affected area.
4. Extract:
   - objectives and non-objectives;
   - rules and invariants;
   - acceptance criteria;
   - required verification;
   - rollout or compatibility constraints.
5. Check for blockers:
   - status is `DRAFT`;
   - unresolved blocking question;
   - spec contradicts an accepted ADR or current external contract;
   - required secret, environment, service, or data is unavailable;
   - requested behavior would require an unstated product decision.

Stop on a material blocker and explain it precisely. Do not guess.

## Implementation discipline

- Work in small coherent slices that preserve a runnable repository.
- Reuse existing abstractions and pipelines where the spec requires or the repository clearly establishes them.
- Do not broaden scope under “while we are here”.
- Do not weaken types, validation, authorization, privacy, or error handling to make the feature pass.
- Treat retries, duplicates, ordering, and concurrency explicitly when relevant.
- Preserve backward compatibility unless the spec explicitly changes it.
- Add comments only where intent cannot be made clear through structure and names.

## Tests

Choose the strongest meaningful feedback loop for the change:

- domain/unit tests for rules and invariants;
- integration tests for persistence, queues, APIs, and external seams;
- contract tests for compatibility;
- UI/component or end-to-end tests for observable workflows;
- regression test for a bug fix.

Do not add tests that only mirror implementation details.

## Verification

Run repository-prescribed commands first. Otherwise inspect package/build configuration and run the applicable set:

- focused tests;
- broader relevant test suite;
- typecheck;
- lint/format validation;
- build;
- migrations or schema validation in a safe environment;
- manual smoke check when automation cannot observe the result.

Never hide a failing check. Distinguish:

- passed;
- failed because of this change;
- failed for a pre-existing reason;
- not run and why.

## Completion report

Return:

1. **Implemented scope** — concise description and changed areas.
2. **Acceptance matrix**:

| Criterion | Status | Evidence |
|---|---|---|
| AC1 | PASS/FAIL/NOT VERIFIED | test, file, or observed behavior |

3. **Checks run** — exact commands and results.
4. **Residual risks or unavailable verification**.
5. **Out-of-scope items intentionally untouched**.
6. **Next command** — `/skill:idd review <spec-path>` in a new session with another model.

Only mark the spec `DONE` when all material criteria pass and required checks succeed. Otherwise use `VALIDATING` or leave the existing status unchanged.
