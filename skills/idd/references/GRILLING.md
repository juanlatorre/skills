# Grilling discipline

Interview the user until both sides reach a shared understanding. The purpose is to close product and design decisions before specification or implementation.

Grilling is intentionally single-agent. Do not delegate questioning, domain synthesis, or factual exploration to subagents; the conversation needs one coherent decision tree and one voice.

## Design tree

Map the discussion as a **design tree**: every decision branches into decisions that depend on it.

Work the tree in **rounds**. The decision **frontier** contains every unresolved decision whose prerequisites are already settled. Ask only that frontier; do not ask a question whose answer depends on another question still open in the same round.

Keep rounds small enough to answer carefully. Prefer 1–3 material decisions per round even when the theoretical frontier is larger; group closely related decisions and preserve the remaining frontier for the next round.

## Interactive questioning

When the host exposes `ask_user_question`, `AskUserQuestion`, or an equivalent native structured-question tool, MUST use it for selectable grilling decisions.

For each question:

- isolate one decision;
- explain the consequence or trade-off;
- provide concrete alternatives when real alternatives exist;
- make the recommended option first and mark it `(Recommended)` when supported;
- allow a custom/free-form answer when supported.

Do not render a long Markdown survey when native interactive questioning is available.

If native UI is unavailable or fails, use:

```md
❓ **Q1 — <question title>**: <question body, concrete choices, trade-offs, and a scenario when useful>

➡️ **Recommendation:** <recommended answer and why>
```

## After each answer round

1. Restate each accepted decision in normative, observable language.
2. Mark answers that remain provisional, contradictory, or incomplete.
3. Update the design tree.
4. Recompute the frontier.
5. Ask only the newly available decisions.

Use concrete scenarios to expose hidden ambiguity. Challenge answers that conflict with earlier decisions, repository facts, accepted ADRs, or stated invariants.

## Facts versus decisions

Finding facts is the agent's responsibility. Use repository search, shell commands, documentation, connected tools, and direct environment inspection. Do not ask the user for facts that can be discovered safely.

Do not use subagents during grilling. If a factual investigation is slow, defer only branches that depend on it and continue with unrelated frontier questions when possible.

The user's responsibility is to make product and trade-off decisions. Never convert the agent's recommendation into an accepted decision without the user's answer.

## Completion

The session is complete when every material branch has been visited and nothing important remains silently assumed.

At closure:

- summarize decisions and consequences;
- distinguish facts, assumptions, and unresolved non-blockers;
- state explicit non-goals;
- confirm the workflow destination is still correct;
- ask the user to confirm shared understanding.

After confirmation:

- in a managed `start` workflow, automatically continue to `spec` in the same session when no other decision is required;
- in explicit `grill`/`grill-docs`, stop and return the exact `spec` command.

Do not start implementation during grilling.

## Prohibitions

During grilling, do not:

- write production code;
- start implementation;
- create a full spec prematurely;
- delegate questioning or analysis to subagents;
- ask broad questions that hide multiple independent decisions;
- ask about technology before product behavior when technology is not itself the decision;
- invent an answer merely because it is technically convenient.

_Adapted from Matt Pocock's `grilling` skill, MIT licensed. See `THIRD_PARTY_NOTICES.md`._
