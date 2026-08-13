# Grilling discipline

Interview the user until both sides reach a shared understanding. The purpose is to close product and design decisions before specification or implementation.

## Design tree

Map the discussion as a **design tree**: every decision branches into the decisions that depend on it.

Work the tree in **rounds**. The **frontier** contains every unresolved decision whose prerequisites are already settled. Ask the whole frontier in one round; do not ask a question whose answer depends on another question still open in the same round.

Every question must use this format:

```md
❓ **Q1 — <question title>**: <question body, concrete choices, trade-offs, and a scenario when useful>

➡️ **Recommendation:** <recommended answer and why>
```

Number questions continuously within the current round. Keep a round small enough to answer carefully, but do not force artificial one-question turns when several decisions are genuinely independent.

## After each answer round

1. Restate each decision in normative, observable language.
2. Mark any answer that remains provisional or ambiguous.
3. Update the design tree.
4. Recompute the frontier.
5. Ask only the newly available frontier.

Use concrete scenarios to expose hidden ambiguity. Challenge answers that conflict with earlier decisions, repository facts, accepted ADRs, or stated invariants.

## Facts versus decisions

Finding facts is the agent's responsibility. Use repository search, shell commands, documentation, connected tools, or subagents when available. Do not ask the user for facts that can be discovered safely.

The user's responsibility is to make product and trade-off decisions. Never convert the agent's recommendation into an accepted decision without the user's answer.

Do not block unrelated frontier questions while investigating a fact. Only defer the branches that depend on that fact.

## Completion

The session is complete when the frontier is empty: every material branch has been visited and nothing important remains silently assumed.

At closure:

- summarize decisions and their consequences;
- distinguish facts, assumptions, and unresolved non-blockers;
- state explicit non-goals;
- ask the user to confirm shared understanding;
- do not create a spec or act on the result until the user confirms and explicitly invokes the next mode.

## Prohibitions

During grilling, do not:

- write production code;
- start implementation;
- create a full spec prematurely;
- ask broad questions that hide multiple independent decisions;
- ask about technology before product behavior when technology is not itself the decision;
- invent an answer merely because it is technically convenient.

_Adapted from Matt Pocock's `grilling` skill, MIT licensed. See `THIRD_PARTY_NOTICES.md`._
