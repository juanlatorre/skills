# Domain-modeling discipline

Actively sharpen the project's domain model while the feature is being defined. This is not merely reading a glossary; it changes the shared language and records rare durable decisions.

## Locate the context

Most repositories use one root context:

```text
/
├── CONTEXT.md
├── docs/adr/
└── src/
```

If `CONTEXT-MAP.md` exists, treat the repository as multi-context. Read the map and update the context that owns the current topic. System-wide decisions belong in the system-wide ADR location; context-specific decisions belong with that context when the repository establishes such a convention.

Create files lazily. Do not create an empty glossary or ADR directory.

## During grilling

### Challenge the glossary

When the user's language conflicts with an existing canonical term, surface the conflict immediately and ask which meaning is intended.

### Sharpen fuzzy language

When a word is vague or overloaded, propose distinct canonical terms. Explain the boundary using a concrete scenario.

### Stress-test relationships

Use examples and edge cases to test whether concepts are actually distinct, who owns them, and how they change over time.

### Cross-reference the repository

When the user states how the domain works, inspect relevant code, schemas, tests, and documentation. If the repository disagrees, present the contradiction as a decision; do not silently prefer either source.

### Update `CONTEXT.md` inline

When a term is resolved, update the glossary during the session rather than batching everything at the end. Follow `CONTEXT_FORMAT.md`.

`CONTEXT.md` is a glossary only. It must not become:

- a feature spec;
- an implementation plan;
- a schema catalog;
- a list of configurable values;
- a chronological scratchpad.

### Create ADRs sparingly

An ADR qualifies only when all three conditions hold:

1. **Hard to reverse** — changing it later has meaningful cost.
2. **Surprising without context** — a future reader may reasonably try to “fix” it.
3. **Real trade-off** — genuine alternatives existed and one was selected for reasons worth preserving.

Once the user accepts such a decision, write the ADR using `ADR_FORMAT.md`. Otherwise, keep it in the feature spec or conversation.

_Adapted from Matt Pocock's `domain-modeling` skill, MIT licensed. See `THIRD_PARTY_NOTICES.md`._
