<div align="center">

# Agent Skills

Reusable, agent-agnostic workflows for shipping software with AI.

[![skills.sh](https://skills.sh/b/juanlatorre/skills)](https://skills.sh/juanlatorre/skills)

</div>

## IDD — Inshallah Driven Development

**IDD** is a stateful, spec-driven workflow that can either **ship approved work now** or **publish it as issues for later delivery**.

```text
IDEA / SPEC / ISSUE
        ↓
      start
        ↓
route → grill → spec → split if LARGE
        ↓
   ┌───────────────┐
   │ delivery mode │
   └───────┬───────┘
       ┌───┴───┐
       ▼       ▼
   EXECUTE   ISSUES
       │       │
 implement   tracker
       │       │
  review     PLANNED
       │
     DONE
```

Managed usage is intentionally small:

```text
/skill:idd start <idea | spec | issue>
/skill:idd continue
/skill:idd status
```

If planning is sent to issues, work resumes later with:

```text
/skill:idd start <issue ref/url>
```

The underlying phase modes (`grill`, `spec`, `split`, `implement`, `review`, etc.) remain available for advanced/explicit use.

## Install

```bash
npx skills add juanlatorre/skills --skill idd -g
```

Pi:

```bash
npx skills add juanlatorre/skills --skill idd -a pi -g -y
```

Claude Code:

```bash
npx skills add juanlatorre/skills --skill idd -a claude-code -g -y
```

Codex:

```bash
npx skills add juanlatorre/skills --skill idd -a codex -g -y
```

See [`skills/idd/README.md`](skills/idd/README.md) for the complete workflow.

## License

Distributed under the [MIT License](LICENSE). Third-party portions remain subject to their included notices.
