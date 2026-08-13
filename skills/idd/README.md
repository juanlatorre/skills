# IDD — Inshallah Driven Development

**IDD** is a self-contained software delivery workflow designed for Pi. It combines change routing, product grilling, domain documentation, repository-grounded specs, implementation, decomposition of large work, and independent review.

## Install

### Global installation for Pi

```bash
npx skills add juanlatorre/skills --skill idd -a pi -g -y
```

Pi installs global skills under:

```text
~/.pi/agent/skills/idd/
```

Restart Pi after the first installation, then run:

```text
/skill:idd
```

### Project-local installation

Run this from the target repository:

```bash
npx skills add juanlatorre/skills \
  --skill idd \
  --agent pi \
  --yes
```

The skill will be installed under:

```text
.pi/skills/idd/
```

### Update

```bash
npx skills update idd --global
```

## Workflow

```text
TRIVIAL
→ direct implementation
→ verification

NORMAL + stable domain
→ grill
→ one spec
→ implementation
→ review with another model

NORMAL + new/transversal domain
→ grill-docs
→ one spec
→ implementation
→ review with another model

LARGE
→ grill-docs
→ parent spec
→ child specs
→ multiple implementations
→ integrated final review
```

## Modes

```text
route       classify size and domain impact
direct      implement a trivial change without a spec
grill       interview the design for a stable domain
grill-docs  interview and maintain CONTEXT.md / ADRs when warranted
spec        write a PRD/spec from the current conversation
split       decompose a parent spec into vertical child specs
implement   implement a READY spec
review      review the diff against the spec without editing code
```

Accepted aliases:

```text
grill-me        → grill
grill-with-docs → grill-docs
```

## Typical usage

### Route an idea

```text
/skill:idd route Add recurring scheduling for students.
```

### Normal feature, stable domain

```text
/skill:idd grill Allow a booking to be cancelled up to two hours before it starts.
```

After reaching shared understanding, in the same session:

```text
/skill:idd spec booking-cancellation
```

In a fresh session, potentially with another model:

```text
/skill:idd implement docs/specs/booking-cancellation.md
```

In another fresh session and preferably another model:

```text
/skill:idd review docs/specs/booking-cancellation.md
```

### Feature with new or transversal domain language

```text
/skill:idd grill-docs Separate monthly planning, sessions, scheduling, and recurrence.
```

This mode may update:

```text
CONTEXT.md
docs/adr/*.md
```

Then produce the feature spec in the same session:

```text
/skill:idd spec recurring-scheduling
```

### Large feature

```text
/skill:idd grill-docs Define the complete scheduling system.
/skill:idd spec parent scheduling-system
/skill:idd split docs/specs/scheduling-system.md
```

Implement and review each child spec, then perform a final integrated review against the parent spec.

## Included references

The skill is self-contained and does not require external skills:

```text
references/GRILLING.md
references/DOMAIN_MODELING.md
references/CONTEXT_FORMAT.md
references/ADR_FORMAT.md
references/SPECIFICATION.md
references/SPEC_TEMPLATE.md
references/LARGE_WORK.md
references/IMPLEMENTATION.md
references/REVIEW.md
references/ROUTING.md
```

## Manual installation fallback

The `scripts/install.sh` helper remains available for environments where the Skills CLI cannot be used:

```bash
./scripts/install.sh --global
```

## Credits and license

Parts of the grilling and domain-modeling workflow are adapted from Matt Pocock's skills under the MIT License. See `THIRD_PARTY_NOTICES.md` and `licenses/MATT_POCOCK_SKILLS_MIT.txt`.
