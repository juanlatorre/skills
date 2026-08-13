#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

required=(
  SKILL.md
  README.md
  VERSION
  THIRD_PARTY_NOTICES.md
  licenses/MATT_POCOCK_SKILLS_MIT.txt
  references/ROUTING.md
  references/GRILLING.md
  references/DOMAIN_MODELING.md
  references/CONTEXT_FORMAT.md
  references/ADR_FORMAT.md
  references/SPECIFICATION.md
  references/SPEC_TEMPLATE.md
  references/LARGE_WORK.md
  references/IMPLEMENTATION.md
  references/REVIEW.md
)

missing=0
for item in "${required[@]}"; do
  if [ -f "$ROOT/$item" ]; then
    printf 'OK      %s\n' "$item"
  else
    printf 'MISSING %s\n' "$item"
    missing=1
  fi
done

name="$(awk '
  BEGIN { in_frontmatter=0 }
  NR==1 && $0=="---" { in_frontmatter=1; next }
  in_frontmatter && $0=="---" { exit }
  in_frontmatter && $1=="name:" { sub(/^name:[[:space:]]*/, ""); print; exit }
' "$ROOT/SKILL.md")"

version="$(tr -d '[:space:]' < "$ROOT/VERSION")"

if [ "$name" != "idd" ]; then
  echo "INVALID skill name: $name" >&2
  missing=1
fi

if ! grep -q "version: \"$version\"" "$ROOT/SKILL.md"; then
  echo "VERSION mismatch between VERSION and SKILL.md" >&2
  missing=1
fi

if [ "$missing" -ne 0 ]; then
  exit 1
fi

echo
echo "idd $version is complete and self-contained."
echo "External grilling/domain-modeling skills are not required."
