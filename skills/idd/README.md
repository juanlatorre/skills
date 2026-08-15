<div align="center">

# IDD

**Inshallah Driven Development**

A stateful, spec-driven workflow for shipping software with AI coding agents.

[![skills.sh](https://skills.sh/b/juanlatorre/skills)](https://skills.sh/juanlatorre/skills)

</div>

## What changed in 4.0

IDD 4 turns the skill from a chain of commands into a resumable workflow.

The normal UX is now:

```text
idd start <idea>
→ answer real product decisions
→ IDD auto-advances deterministic planning steps
→ fresh-session boundary

idd continue
→ implement exact active unit
→ local candidate checkpoint
→ fresh-session boundary

idd continue
→ independently review exact candidate
→ APPROVE / correction loop / next child
```

You no longer need to remember the active spec path, child number, review base, candidate SHA, or which phase comes next.

## Core ideas

### Destination

Every managed workflow has a low-resolution definition of success that fixes scope.

### Workflow map

Execution state lives in Git metadata, not in specs or hand-maintained README progress text.

### Frontier

For LARGE work, IDD computes which child specs are actually ready from dependencies, DONE state, and active claims.

### Fog

In-scope work that is visible but not sharp enough to become a child yet stays as fog instead of being prematurely sliced.

### Claims

A child is claimed before implementation so concurrent sessions/subagents do not duplicate work.

### Candidate lineage

```text
one child
→ one candidate lineage
→ one independent review lineage
```

Reviews operate on exact commits, not on an ambiguous working tree.

## Workflow

```text
TRIVIAL
→ direct
→ focused verification
→ DONE

NORMAL
→ grill or grill-docs
→ READY spec
→ planning checkpoint
→ candidate implementation checkpoint
→ independent review
→ DONE

LARGE
→ grill-docs
→ parent spec
→ split sharp children + record fog
→ planning checkpoint
→ child candidate/review lineages
→ integrate approved children
→ integrated parent review
→ DONE
```

## Install

Interactive:

```bash
npx skills add juanlatorre/skills --skill idd -g
```

Pi:

```bash
npx skills add juanlatorre/skills --skill idd --agent pi --global --yes
```

Claude Code:

```bash
npx skills add juanlatorre/skills --skill idd --agent claude-code --global --yes
```

Codex:

```bash
npx skills add juanlatorre/skills --skill idd --agent codex --global --yes
```

Update:

```bash
npx skills update idd --global
```

## Recommended usage

Examples below use Pi syntax.

### Start a workflow

```text
/skill:idd start Add recurring bookings for trainers.
```

IDD routes automatically and enters `grill` or `grill-docs` as appropriate. When the host supports structured questions, grilling uses interactive choices.

After decisions are confirmed, IDD writes the spec automatically in the same planning session. If work is LARGE, it can split it before implementation.

At the first fresh-session boundary, IDD stops with:

```text
/skill:idd continue
```

### Continue

Open a fresh session and run:

```text
/skill:idd continue
```

IDD loads the active workflow, reconciles it against Git, and executes the one valid next action.

You use the same command after:

- planning → implementation;
- candidate → review;
- CHANGES REQUIRED → corrective implementation;
- corrective candidate → corrective review;
- approved child → next ready child;
- all children complete → integrated parent review.

### Inspect state

```text
/skill:idd status
```

Shows:

```text
Destination
Workflow status
Active spec/child
Frontier
Fog
Claims
Candidate lineage
Open review findings
Next deterministic action
```

## Explicit modes

Advanced users can still invoke phases directly:

| Mode | Purpose |
|---|---|
| `route` | Classify size/domain impact |
| `direct` | Localized trivial change |
| `grill` | Close decisions in a stable domain |
| `grill-docs` | Close decisions while maintaining context/ADRs |
| `spec` | Write a repository-grounded contract |
| `split` | Decompose LARGE work into sharp child outcomes |
| `implement` | Implement one bounded reviewable unit |
| `review` | Independently review an exact candidate lineage |

Aliases:

```text
grill-me        → grill
grill-with-docs → grill-docs
```

## Local checkpoint commits

Managed `start`/`continue` workflows use local Git commits at stable boundaries:

```text
planning checkpoint
candidate checkpoint
corrective candidate checkpoint
integration checkpoint when needed
```

These commits are workflow mechanics. They never authorize push, PR creation, merge, release, deployment, tags, or remote mutations.

IDD refuses to create a checkpoint that would absorb unrelated user changes or mix two independently reviewable children.

## LARGE work

Static docs describe the delivery contract:

```text
docs/specs/<parent>.md
docs/specs/<parent>/
├── README.md
├── 01-<outcome>.md
├── 02-<outcome>.md
└── ...
```

Dynamic execution state is not manually duplicated there. It lives in Git metadata.

A child spec stays `READY` even after implementation; DONE is workflow state established by independent APPROVE.

## Subagents

Single-agent is the default.

Subagents are opt-in and only used for:

- `split` analysis;
- isolated implementation;
- read-only review lenses.

Never for `route`, `direct`, `grill`, `grill-docs`, or `spec`.

Examples:

```text
Use subagents for this workflow.
Use subagents for this implementation.
Use subagents for split and review.
Do not use subagents.
```

Parallel child implementation must use isolated worktrees/branches or equivalent isolation.

## Why the workflow state lives in Git metadata

Specs should not become status dashboards. README files should not say “next child 03” and then go stale. Review output should not be the only place that remembers what passed.

IDD separates responsibilities:

| Artifact | Responsibility |
|---|---|
| Spec | Behavioral contract |
| CONTEXT / ADR | Durable domain knowledge |
| Workflow JSON | Operational state and next action |
| Git candidate commits | Exact implementation states |
| Review ledger | Open material findings |

This is what makes `idd continue` deterministic.

## Package structure

```text
idd/
├── SKILL.md
├── README.md
├── LICENSE
├── THIRD_PARTY_NOTICES.md
├── agents/
│   └── openai.yaml
├── evals/
│   └── evals.json
├── references/
│   ├── WORKFLOW.md
│   ├── CHECKPOINTS.md
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

## Credits

Parts of the grilling/domain-modeling discipline and wayfinding concepts are adapted from Matt Pocock's skills under the MIT License. See `THIRD_PARTY_NOTICES.md`.

## License

Distributed under the included [MIT License](LICENSE). Third-party portions remain subject to included notices.
