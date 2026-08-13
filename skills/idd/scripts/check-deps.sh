#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
echo "check-deps.sh is kept as a compatibility alias; idd 2.x has no external skill dependencies."
exec "$SCRIPT_DIR/check.sh"
