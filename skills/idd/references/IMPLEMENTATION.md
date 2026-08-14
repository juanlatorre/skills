# Implementing from a spec

The approved spec is the behavioral contract. The repository is the technical reality. Implementation must satisfy both without silently changing either.

## Entry gate

1. Read the complete spec and any parent/index references.
2. Read applicable `AGENTS.md`, `CONTEXT.md`, ADRs, and repository documentation.
3. Inspect current code, tests, schemas, contracts, and recent patterns in the affected area.
4. Extract objectives, non-objectives, invariants, acceptance criteria, required verification, and rollout constraints.
5. Confirm the spec is `READY`.
6. Re-check scale. Stop and route to `split` if the flat spec contains independently implementable/reviewable outcomes or will not fit reliably in one implementation and review cycle.
7. In Git, resolve the handoff directory with:

   ```sh
   REVIEW_DIR="$(git rev-parse --path-format=absolute --git-path idd/reviews)"
   SPEC_KEY="$(printf '%s' "$ACTIVE_SPEC" | git hash-object --stdin)"
   REVIEW_HANDOFF="$REVIEW_DIR/$SPEC_KEY.md"
   ```

   Never assume `.git` is a directory. Read `REVIEW_HANDOFF` before broad exploration.

Stop on a material blocker:

- unresolved product decision;
- contradiction with an accepted ADR, domain rule, or external contract;
- required secret, service, environment, or data is unavailable;
- implementation requires materially broader behavior than the approved contract.

A valid explicit `implement` invocation is authorization to work. Do not ask whether to begin or continue when no blocker exists.

## Choose the implementation kind

### Initial implementation

Use when no open review handoff exists. Implement the complete bounded scope and prove its acceptance criteria.

### Corrective implementation

Use when a matching `CHANGES REQUIRED` handoff exists.

1. Read the full ledger first.
2. Extract every open `BLOCKING` and `IMPORTANT` finding ID.
3. Inspect only the code needed to understand those findings and their affected seams.
4. Fix the open findings and directly caused regressions.
5. Preserve already-satisfied criteria and settled product decisions.
6. Do not restart implementation discovery, refactor unrelated code, or search for optional improvements.
7. Append to the handoff:
   - finding IDs addressed;
   - corrective files/areas;
   - focused checks and outcomes;
   - unresolved finding IDs or blockers.

If a finding exposes a contradiction or an oversized slice, stop and route to targeted definition or `split` instead of accumulating patches.

## Implementation discipline

- Work in small coherent slices that preserve a runnable repository.
- Reuse existing abstractions and pipelines when the contract or repository establishes them.
- Do not broaden scope under “while we are here”.
- Do not weaken validation, types, authorization, privacy, or failure handling to make tests pass.
- Treat retries, duplicates, ordering, transactions, and concurrency explicitly when relevant.
- Preserve compatibility unless the spec explicitly changes it.
- Add comments only when names and structure cannot make intent clear.

## Tests and evidence

Choose tests that prove observable behavior:

- domain/unit tests for rules and invariants;
- integration tests for persistence, jobs, APIs, and external seams;
- contract tests for compatibility;
- UI/component/end-to-end tests for user workflows;
- a regression test for each corrected defect when practical.

Do not add tests that merely mirror implementation details.

During development:

1. run focused tests for the current slice;
2. run broader tests for affected subsystems;
3. run type, lint, build, migration, schema, or manual checks when relevant;
4. reserve an expensive repository-wide suite for the stable candidate unless repository instructions require it earlier.

Evidence is valid only for the code state it exercised. Record enough state—HEAD, changed paths, or a diff fingerprint—to determine whether earlier evidence remains valid. Reuse valid evidence when relevant code and configuration are unchanged. A new session alone is not a reason to rerun an expensive check.

For corrective implementation, run focused checks for the finding IDs and affected seams. The subsequent independent corrective review decides whether the final global gate is ready.

Never hide a failing check. Distinguish:

- passed;
- failed because of this change;
- failed for a pre-existing reason;
- unavailable or not run, with reason.

## Completion report

Return:

1. implemented scope and changed files/areas;
2. for corrective work, a finding-ID-to-fix matrix;
3. acceptance matrix:

   | Criterion | Status | Evidence |
   |---|---|---|
   | AC1 | PASS/FAIL/NOT VERIFIED/BLOCKED | test, file, or behavior |

4. exact checks and outcomes;
5. residual risks and unavailable verification;
6. intentionally untouched out-of-scope items;
7. exact fresh independent `idd review <ACTIVE_SPEC>` command.

A successful implementation ends at logical state `IMPLEMENTED`, never `DONE`. Do not rewrite the spec merely to store execution state.
