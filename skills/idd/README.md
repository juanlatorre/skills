<div align="center">

# IDD

**Inshallah Driven Development**

A stateful, spec-driven workflow for planning or shipping software with AI coding agents.

[![skills.sh](https://skills.sh/b/juanlatorre/skills)](https://skills.sh/juanlatorre/skills)

</div>

## What changed in 4.1

IDD now separates **planning** from **delivery** without adding another command maze.

Once approved executable work exists, IDD offers exactly two dispositions:

```text
EXECUTE
→ keep going through implementation + independent review

ISSUES
→ publish the approved plan as issues
→ park execution
```

There is no third disposition.

The managed UX remains intentionally small:

```text
/skill:idd start <idea | spec | issue>
/skill:idd continue
/skill:idd status
```

## Start with an idea

```text
/skill:idd start Add recurring bookings for trainers.
```

IDD routes, grills decisions, writes the spec, splits LARGE work, and then asks once:

```text
How do you want to continue?

● Execute now
○ Take it to issues
```

If you already said “implement it now” or “take it to issues, do not implement”, IDD remembers that intent and does not ask again.

## EXECUTE

The existing IDD 4 workflow stays intact:

```text
planning
→ planning checkpoint
→ fresh implementation
→ candidate checkpoint
→ fresh independent review
→ corrections when needed
→ DONE
```

After planning, new sessions normally need only:

```text
/skill:idd continue
```

IDD remembers the active spec, child, base/candidate SHAs, findings, claims, frontier, and next deterministic action in Git metadata.

## ISSUES

When you choose issues, IDD creates a stable planning checkpoint and publishes **thin tracker issues that point to the approved specs**.

NORMAL work:

```text
READY spec
→ one implementation issue
→ PLANNED
```

LARGE work:

```text
parent spec + split
→ parent/index issue
   ├── child issue 01
   ├── child issue 02
   └── child issue 03
→ dependencies / parent-child relationships when supported
→ PLANNED
```

Fog is not turned into fake issues before it is sharp enough to spec.

IDD does not copy the full spec into issues. Responsibilities stay separate:

| Artifact | Responsibility |
|---|---|
| Spec | Behavioral contract |
| CONTEXT / ADR | Durable domain knowledge |
| Issue | Visible planned/assignable delivery unit |
| Workflow JSON | Operational state and next action |
| Git checkpoint | Exact candidate state |
| Review ledger | Open material findings |

### Work an issue later

```text
/skill:idd start #123
```

or:

```text
/skill:idd start https://github.com/org/repo/issues/123
```

If the issue was created by IDD, `start` resolves the linked workflow/spec, claims the issue when supported, and begins that exact unit. It does **not** ask EXECUTE vs ISSUES again.

While that issue is active, fresh sessions use:

```text
/skill:idd continue
```

After independent `APPROVE`, IDD can complete/close the active issue and parks again instead of auto-starting another backlog item.

`continue` on a parked ISSUES workflow does not secretly start work. It reports the planned issues and waits for an explicit `start <issue>`.

## LARGE work

IDD 4 keeps the Wayfinder-inspired concepts introduced in 4.0:

- **Destination** — low-resolution definition of success.
- **Frontier** — READY, unblocked, unclaimed children.
- **Fog** — in-scope work not sharp enough to spec yet.
- **Claims** — prevent duplicate concurrent work.
- **Candidate lineage** — one child, one reviewable Git lineage.

The core invariant is:

```text
one child
→ one claim
→ one candidate lineage
→ one independent review lineage
→ DONE
```

Parallel implementation requires isolated worktrees/branches.

## Optional subagents

IDD is single-agent by default.

Subagents are opt-in and only supported in:

```text
split
implement
review
```

Never in grilling or spec authoring.

Examples:

```text
Use subagents for this implementation.
Use subagents for split and review in this workflow.
Do not use subagents.
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

## Explicit modes

Advanced users can still invoke bounded phases directly:

| Mode | Purpose |
|---|---|
| `start` | Start from an idea, READY spec, or issue |
| `continue` | Resume the active managed execution lineage |
| `status` | Inspect reconciled workflow state |
| `route` | Classify size/domain impact |
| `direct` | Localized trivial change |
| `grill` | Close decisions in a stable domain |
| `grill-docs` | Close decisions and maintain domain docs/ADRs |
| `spec` | Write the repository-grounded contract |
| `split` | Create vertical children + dependencies + fog |
| `implement` | Produce one isolated candidate |
| `review` | Independently verify one exact candidate lineage |

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
│   ├── ISSUES.md
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
