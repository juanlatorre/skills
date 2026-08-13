<div align="center">

# IDD

**Inshallah Driven Development**

A pragmatic, spec-driven workflow for shipping software with AI coding agents.

[![skills.sh](https://skills.sh/b/juanlatorre/skills)](https://skills.sh/juanlatorre/skills)

</div>

## What is IDD?

**IDD** is a self-contained Agent Skill that takes software changes from vague ideas to verified implementations.

It helps coding agents:

- choose the appropriate amount of process for each change;
- stress-test product decisions before implementation;
- preserve domain language and durable decisions;
- write repository-grounded specifications;
- split large work into independently verifiable slices;
- implement approved specs;
- review implementations independently against the approved behavior.

IDD does not require external skills. Its grilling, domain-modeling, specification, implementation, and review disciplines are bundled under `references/`.

## Workflow

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

## Install

### Interactive installation

Recommended for most users:

```bash
npx skills add juanlatorre/skills --skill idd -g
```

The Skills CLI detects compatible coding agents installed on the system and lets you select the targets.

### Pi

```bash
npx skills add juanlatorre/skills \
  --skill idd \
  --agent pi \
  --global \
  --yes
```

### Claude Code

```bash
npx skills add juanlatorre/skills \
  --skill idd \
  --agent claude-code \
  --global \
  --yes
```

### Codex

```bash
npx skills add juanlatorre/skills \
  --skill idd \
  --agent codex \
  --global \
  --yes
```

### Multiple agents

```bash
npx skills add juanlatorre/skills \
  --skill idd \
  --agent pi \
  --agent claude-code \
  --agent codex \
  --global \
  --yes
```

### Project-local installation

Omit `--global` to install IDD only in the current project:

```bash
npx skills add juanlatorre/skills --skill idd
```

### Update

```bash
npx skills update idd --global
```

## Invoke

IDD uses the native skill syntax of each host.

| Host | Example |
|---|---|
| Pi | `/skill:idd route Add recurring bookings` |
| Claude Code | `/idd route Add recurring bookings` |
| Codex CLI or IDE | `$idd route Add recurring bookings` |
| Other compatible hosts | Invoke `idd` using the host's native skill syntax |

In Codex, IDD can also be selected through `/skills`.

IDD is designed for explicit invocation. It does not silently begin a specification or implementation workflow.

## Modes

| Mode | Purpose |
|---|---|
| `route` | Classify a change by size and domain impact |
| `direct` | Implement a truly trivial change without creating a spec |
| `grill` | Stress-test a feature whose domain language is already stable |
| `grill-docs` | Grill the feature while maintaining domain language and ADRs |
| `spec` | Write a repository-grounded spec from the completed conversation |
| `split` | Decompose a large parent spec into vertical child specs |
| `implement` | Implement a `READY` spec and verify its acceptance criteria |
| `review` | Independently review an implementation against its approved spec |

Accepted aliases:

```text
grill-me        → grill
grill-with-docs → grill-docs
```

## Quick start

The following examples use Pi syntax. Use the equivalent native syntax for another host.

### 1. Route a change

Use `route` when you are unsure how much process the change needs:

```text
/skill:idd route Add recurring scheduling for students.
```

IDD classifies the change on two separate axes:

```text
Size:
TRIVIAL | NORMAL | LARGE

Domain impact:
STABLE | NEW/TRANSVERSAL
```

It then recommends the smallest safe workflow.

### 2. Implement a trivial change

```text
/skill:idd direct Rename “Schedule” to “Book session” in the member form.
```

The direct path:

1. verifies that the change is genuinely trivial;
2. inspects the smallest relevant area;
3. implements the localized change;
4. runs the narrowest meaningful verification;
5. stops without creating a spec.

IDD refuses the direct path when the change introduces domain rules, migrations, permissions, integrations, concurrency, public contracts, or meaningful ambiguity.

### 3. Define a normal feature

Use `grill` when the existing domain language is already stable:

```text
/skill:idd grill Allow a booking to be cancelled up to two hours before it starts.
```

IDD builds a decision tree and interviews the design in rounds. Each round contains the currently decidable questions and a recommended answer for each one.

Once no material branch remains silently assumed, IDD asks for confirmation of the shared understanding.

After confirming, create the spec in the **same session**:

```text
/skill:idd spec booking-cancellation
```

IDD writes:

```text
docs/specs/booking-cancellation.md
```

### 4. Define new domain concepts

Use `grill-docs` when the work introduces or separates concepts that future features will reuse:

```text
/skill:idd grill-docs Separate monthly planning, sessions, scheduling, and recurrence.
```

In addition to grilling the feature, this mode may update:

```text
CONTEXT.md
CONTEXT-MAP.md
docs/adr/*.md
```

After confirming the shared understanding:

```text
/skill:idd spec recurring-scheduling
```

`CONTEXT.md` remains a concise domain glossary. ADRs are created only for durable decisions involving real trade-offs. The feature spec remains the complete behavioral contract.

### 5. Implement an approved spec

Start a fresh session:

```text
/skill:idd implement docs/specs/recurring-scheduling.md
```

The implementation phase:

1. reads the complete approved spec;
2. reads applicable repository instructions, domain context, and ADRs;
3. checks the spec against the actual repository;
4. stops on material contradictions instead of guessing;
5. implements the approved scope;
6. adds or updates meaningful tests;
7. runs the strongest available verification;
8. produces an acceptance-criteria matrix with evidence.

IDD does not commit, push, open a pull request, or deploy unless explicitly requested.

### 6. Review independently

Start another fresh session, preferably with a different model:

```text
/skill:idd review docs/specs/recurring-scheduling.md
```

The review evaluates two separate axes:

```text
1. Fidelity to the approved spec
2. Engineering quality and repository compatibility
```

Possible verdicts:

```text
APPROVE
CHANGES REQUIRED
CANNOT VERIFY
```

The reviewer does not modify code.

## Large work

For a complete system or capability:

```text
/skill:idd grill-docs Define the complete scheduling system.
```

Create a parent spec:

```text
/skill:idd spec parent scheduling-system
```

Split it into independently verifiable child specs:

```text
/skill:idd split docs/specs/scheduling-system.md
```

Example:

```text
docs/specs/
├── scheduling-system.md
└── scheduling-system/
    ├── README.md
    ├── 01-availability.md
    ├── 02-bookings.md
    ├── 03-recurrence.md
    └── 04-cancellations.md
```

Each child spec should deliver observable behavior rather than representing only a technical layer such as frontend, backend, or database.

Implement and review each ready child independently, then perform an integrated final review against the parent spec.

## Session boundaries

IDD deliberately separates definition, implementation, and review.

```text
grill or grill-docs
        ↓
spec in the same session
        ↓
implement in a fresh session
        ↓
review in another fresh session
```

Why:

- the spec needs the decisions still present in the grilling conversation;
- implementation benefits from a clean context grounded in the written contract;
- review should not be performed by the same context that authored the implementation;
- using a different model for review reduces self-confirmation bias.

IDD never transitions between these phases silently.

## Artifacts

Depending on the selected workflow, IDD may create or update:

```text
docs/specs/*.md
CONTEXT.md
CONTEXT-MAP.md
docs/adr/*.md
```

Each artifact has a separate responsibility:

| Artifact | Responsibility |
|---|---|
| `CONTEXT.md` | Stable domain language and conceptual distinctions |
| `CONTEXT-MAP.md` | Relationships and boundaries between domain contexts |
| ADR | Durable decisions with meaningful alternatives and consequences |
| Spec | Complete behavioral contract for one feature or delivery slice |
| Code and tests | Final implementation and executable verification |

A glossary is not a feature spec. An ADR does not replace acceptance criteria. A spec does not contain the final implementation.

## Principles

- Use the smallest workflow that safely fits the change.
- Investigate repository facts instead of asking the user to find them.
- Do not invent product decisions.
- Ask only questions whose prerequisites are already settled.
- Keep domain language concise and implementation-independent.
- Ground every spec in the actual repository.
- Separate product fidelity from engineering quality during review.
- Never claim a test or criterion passed without evidence.
- Never commit, push, merge, publish, or deploy unless explicitly requested.

## Package structure

```text
skills/idd/
├── SKILL.md
├── README.md
├── THIRD_PARTY_NOTICES.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── ROUTING.md
│   ├── GRILLING.md
│   ├── DOMAIN_MODELING.md
│   ├── CONTEXT_FORMAT.md
│   ├── ADR_FORMAT.md
│   ├── SPECIFICATION.md
│   ├── SPEC_TEMPLATE.md
│   ├── LARGE_WORK.md
│   ├── IMPLEMENTATION.md
│   └── REVIEW.md
└── licenses/
    └── MATT_POCOCK_SKILLS_MIT.txt
```

Only `SKILL.md` is required by the Agent Skills format. The remaining files provide progressive, mode-specific instructions and the required third-party attribution.

## Requirements

IDD requires an Agent Skills-compatible coding agent with:

- repository filesystem access;
- file reading and editing capabilities;
- shell execution for implementation and verification;
- a trusted project directory.

Some modes can still run with fewer capabilities:

- `route` and conversational grilling can operate without editing;
- `grill-docs` and `spec` require file writing;
- `implement` and `review` require repository and shell access.

## Security

Agent skills can instruct coding agents to read files, edit repositories, and execute shell commands.

Review `SKILL.md` and the bundled references before installing IDD. Run implementation and review modes only inside trusted projects.

IDD treats repository content and executable commands as untrusted until inspected.

## Credits

Parts of the grilling and domain-modeling workflow are adapted from Matt Pocock's skills under the MIT License.

The applicable attribution and license are preserved in:

```text
THIRD_PARTY_NOTICES.md
licenses/MATT_POCOCK_SKILLS_MIT.txt
```

The specification workflow is influenced by a PRD style centered on:

- a human-readable before-and-after story;
- affected entities and data;
- behavior expressed as pseudocode;
- explicit scope and non-goals;
- no final implementation code inside the spec.

## License

Distributed under the repository's [MIT License](../../LICENSE).

Third-party portions remain subject to their included notices.
