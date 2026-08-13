# ADR format

ADRs normally live in `docs/adr/` and use sequential numbering:

```text
0001-short-slug.md
0002-another-decision.md
```

Follow an existing repository convention when one is already established.

## Minimal template

```md
# <Short decision title>

<One to three sentences describing the context, the accepted decision, and why it was selected.>
```

That is enough for most ADRs.

Optional sections may be added only when they provide real value:

- status (`proposed`, `accepted`, `deprecated`, or `superseded by ADR-NNNN`);
- considered options;
- non-obvious consequences.

## Numbering

Scan the target ADR directory for the highest existing number and increment it. Create the directory only when the first qualifying ADR is accepted.

## Qualifying decisions

Typical examples include:

- architectural shape or bounded-context ownership;
- integration style between contexts;
- technology choices with meaningful lock-in;
- durable authority or data-boundary decisions;
- deliberate deviations from an obvious approach;
- constraints not visible in code;
- rejected alternatives likely to be proposed again.

Do not create an ADR for an easy-to-reverse implementation detail or an obvious choice without a real alternative.

_Adapted from Matt Pocock's `ADR-FORMAT.md`, MIT licensed. See `THIRD_PARTY_NOTICES.md`._
