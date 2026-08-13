<div align="center">

# Agent Skills

Reusable, agent-agnostic workflows for shipping software with AI.

[![skills.sh](https://skills.sh/b/juanlatorre/skills)](https://skills.sh/juanlatorre/skills)

</div>

## Available skills

### `idd` — Inshallah Driven Development

**IDD** is an explicit, spec-driven workflow for taking software changes from vague ideas to verified implementations.

It helps coding agents:

- choose the right amount of process for each change;
- grill product and technical decisions before implementation;
- preserve domain language and durable decisions;
- write repository-grounded specifications;
- split large work into independently verifiable slices;
- implement approved specs;
- perform independent reviews with a fresh model or session.

IDD is self-contained and does not require external skills.

## Workflow

```text
TRIVIAL
→ direct implementation
→ verification

NORMAL + STABLE DOMAIN
→ grill
→ one spec
→ implementation in a fresh session
→ independent review in another session

NORMAL + NEW OR TRANSVERSAL DOMAIN
→ grill-docs
→ one spec
→ implementation in a fresh session
→ independent review in another session

LARGE
→ grill-docs
→ parent spec
→ child specs
→ multiple implementations and reviews
→ integrated final review
```

`grill-docs` is not another size category. It replaces `grill` when the work introduces, separates, renames, or redefines domain concepts, or establishes a durable transversal decision.

## Install

### Interactive installation

Recommended for most users:

```bash
npx skills add juanlatorre/skills --skill idd -g
```

The CLI detects compatible coding agents installed on the system and lets you select the targets.

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

### Pi, Claude Code, and Codex

```bash
npx skills add juanlatorre/skills \
  --skill idd \
  --agent pi \
  --agent claude-code \
  --agent codex \
  --global \
  --yes
```

### All detected compatible agents

```bash
npx skills add juanlatorre/skills \
  --skill idd \
  --agent '*' \
  --global \
  --yes
```

### Project-local installation

Omit `--global` to install IDD only in the current project:

```bash
npx skills add juanlatorre/skills --skill idd
```

### List available skills

```bash
npx skills add juanlatorre/skills --list
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
| Codex CLI / IDE | `$idd route Add recurring bookings` |
| Other compatible hosts | Invoke `idd` using the host's native skill syntax |

In Codex, IDD can also be selected through `/skills`.

IDD is designed for explicit invocation. It does not silently start a specification or implementation workflow.

## Modes

| Mode | Purpose |
|---|---|
| `route` | Classify the change by size and domain impact |
| `direct` | Implement a truly trivial change without creating a spec |
| `grill` | Stress-test a feature whose domain language is already stable |
| `grill-docs` | Grill the feature while maintaining domain language and ADRs |
| `spec` | Write a repository-grounded PRD/spec from the completed conversation |
| `split` | Decompose a large parent spec into vertical child specs |
| `implement` | Implement a `READY` spec and verify its acceptance criteria |
| `review` | Independently review the implementation against the approved spec |

Accepted aliases:

```text
grill-me        → grill
grill-with-docs → grill-docs
```

## Typical usage

The examples below use Pi syntax. Use the equivalent syntax for the current host.

### Route an idea

```text
/skill:idd route Add recurring scheduling for students.
```

Example result:

```text
Size: NORMAL
Domain impact: NEW/TRANSVERSAL

Recommended flow:
grill-docs → spec → implementation → independent review
```

### Define a normal feature

```text
/skill:idd grill Allow a booking to be cancelled up to two hours before it starts.
```

IDD interviews the design in rounds until no material decision remains silently assumed.

After confirming the shared understanding, create the spec in the **same session**:

```text
/skill:idd spec booking-cancellation
```

IDD writes:

```text
docs/specs/booking-cancellation.md
```

### Define new domain concepts

```text
/skill:idd grill-docs Separate monthly planning, sessions, scheduling, and recurrence.
```

This mode may also update:

```text
CONTEXT.md
docs/adr/*.md
```

After confirming the shared understanding:

```text
/skill:idd spec recurring-scheduling
```

### Implement

Start a fresh session, optionally with another model:

```text
/skill:idd implement docs/specs/recurring-scheduling.md
```

The implementation phase:

1. reads the complete approved spec;
2. inspects the repository and existing conventions;
3. checks for contradictions before editing;
4. implements the approved scope;
5. adds or updates tests;
6. runs the strongest available verification;
7. produces an acceptance-criteria matrix with evidence.

### Review

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

## Large work

For a large system or capability:

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

Example result:

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

Each child spec can then be implemented and reviewed independently before the final integrated review.

## Artifacts

Depending on the selected flow, IDD may create or update:

```text
docs/specs/*.md
CONTEXT.md
CONTEXT-MAP.md
docs/adr/*.md
```

Their responsibilities are deliberately separate:

| Artifact | Responsibility |
|---|---|
| `CONTEXT.md` | Stable domain language and conceptual distinctions |
| ADR | Durable architectural or product decisions with real trade-offs |
| Spec | Complete contract for one feature or delivery slice |
| Code and tests | Final implementation and executable verification |

A glossary is not a feature spec, and an ADR does not replace acceptance criteria.

## Principles

- Use the smallest workflow that safely fits the change.
- Investigate repository facts instead of asking the user to find them.
- Do not invent product decisions.
- Keep grilling, specification, implementation, and review as explicit phases.
- Never silently transition between phases.
- Ground every spec in the actual repository.
- Review product fidelity separately from code quality.
- Never claim that a test or criterion passed without evidence.
- Never commit, push, merge, publish, or deploy unless explicitly requested.

## Repository structure

```text
skills/
└── idd/
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
```

## Security

Agent skills can instruct coding agents to read files, edit repositories, and execute shell commands.

Review `SKILL.md`, bundled references before installing IDD. Run implementation and review modes only inside trusted projects.

IDD never commits, pushes, opens pull requests, deploys, or changes remote state unless the user explicitly requests it.

## Credits

Parts of the grilling and domain-modeling workflow are adapted from [Matt Pocock's skills](https://github.com/mattpocock/skills) under the MIT License.

The applicable attribution and license are preserved in:

```text
skills/idd/THIRD_PARTY_NOTICES.md
skills/idd/licenses/MATT_POCOCK_SKILLS_MIT.txt
```

## License

Distributed under the [MIT License](LICENSE).

Third-party portions remain subject to their included notices.
