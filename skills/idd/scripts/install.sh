#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
MODE="${1:---global}"

case "$MODE" in
  --global)
    TARGET_PARENT="$HOME/.pi/agent/skills"
    ;;
  --project)
    TARGET_PARENT="$(pwd)/.pi/skills"
    ;;
  *)
    echo "Usage: $0 [--global|--project]" >&2
    exit 2
    ;;
esac

TARGET="$TARGET_PARENT/idd"
mkdir -p "$TARGET_PARENT"

if [ "$SOURCE_DIR" = "$TARGET" ]; then
  echo "idd is already installed at $TARGET"
  exit 0
fi

if [ -e "$TARGET" ]; then
  BACKUP="${TARGET}.backup-$(date +%Y%m%d-%H%M%S)"
  mv "$TARGET" "$BACKUP"
  echo "Existing installation moved to: $BACKUP"
fi

cp -R "$SOURCE_DIR" "$TARGET"
chmod +x "$TARGET/scripts/"*.sh 2>/dev/null || true

echo "Installed idd at: $TARGET"
echo "No external skills are required."
echo "Restart Pi, then run: /skill:idd"
