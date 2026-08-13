<div align="center">

# Juan Latorre's Agent Skills

Reusable workflows for AI-driven software development.

[![skills.sh](https://skills.sh/b/juanlatorre/skills)](https://skills.sh/juanlatorre/skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

## Available skills

### `idd` — Inshallah Driven Development

A self-contained delivery workflow for **Pi** that routes work by complexity, grills product decisions, maintains domain language and ADRs when needed, writes repository-grounded specs, implements approved work, and performs independent reviews.

```text
TRIVIAL
→ direct implementation
→ verification

NORMAL + stable domain
→ grill
→ spec
→ implementation
→ independent review

NORMAL + new/transversal domain
→ grill-docs
→ spec
→ implementation
→ independent review

LARGE
→ grill-docs
→ parent spec
→ child specs
→ multiple implementations
→ integrated review
```

## Install

Install `idd` globally for Pi:

```bash
npx skills add juanlatorre/skills --skill idd -a pi -g -y
```

Interactive installation:

```bash
npx skills add juanlatorre/skills
```

List the skills available in this repository:

```bash
npx skills add juanlatorre/skills --list
```

Update an existing global installation:

```bash
npx skills update idd --global
```

## Use with Pi

```text
/skill:idd route <idea or change>
/skill:idd direct <small explicit change>
/skill:idd grill <feature or decision>
/skill:idd grill-docs <feature or decision>
/skill:idd spec <slug or path>
/skill:idd split <parent spec path>
/skill:idd implement <spec path>
/skill:idd review <spec path>
```

See [`skills/idd/README.md`](skills/idd/README.md) for the complete workflow.

## Repository structure

```text
skills/
└── idd/
    ├── SKILL.md
    ├── README.md
    ├── references/
    ├── scripts/
    ├── licenses/
    └── THIRD_PARTY_NOTICES.md
```

## Credits

IDD includes adapted ideas from Matt Pocock's `grilling` and `domain-modeling` skills. The applicable MIT license and attribution are preserved inside the skill directory.

## License

MIT © 2026 Juan Latorre. Third-party portions remain subject to their included notices.
