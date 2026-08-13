# `CONTEXT.md` format

## Structure

```md
# <Context name>

<One or two sentences describing what this context is and why it exists.>

## Language

**Order**:
A request from a customer to receive defined goods or services.
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment issued under the billing rules of this context.
_Avoid_: Bill, payment request
```

## Rules

- Pick one canonical word when several words compete.
- Keep each definition to one or two sentences.
- Define what the concept **is**, not its implementation or complete behavior.
- Include only domain-specific concepts, not general programming vocabulary.
- List misleading synonyms under `_Avoid_`.
- Group terms under subheadings only when natural clusters emerge.

## Single and multiple contexts

For one domain, use a root `CONTEXT.md`.

For multiple bounded contexts, use a root `CONTEXT-MAP.md` that links each context and summarizes relationships:

```md
# Context Map

## Contexts

- [Scheduling](./src/scheduling/CONTEXT.md) — owns availability and bookings
- [Billing](./src/billing/CONTEXT.md) — owns invoices and payments

## Relationships

- **Scheduling → Billing**: emits a chargeable-service event after attendance is confirmed.
```

When no context files exist, create a root `CONTEXT.md` only after the first term is actually resolved.

_Adapted from Matt Pocock's `CONTEXT-FORMAT.md`, MIT licensed. See `THIRD_PARTY_NOTICES.md`._
