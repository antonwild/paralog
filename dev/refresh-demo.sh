#!/bin/bash
# For paralog development: brings the demo vault (skills/pl-setup/assets/demo) up to date with the
# framework files, then checks it. Run it when a release changes vault files.
#
#   dev/refresh-demo.sh

set -e
REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEMO="$REPO/skills/pl-setup/assets/demo"
"$REPO/skills/pl-setup/scripts/scaffold.sh" "$DEMO" --update | grep -v '^warn' || true
rm -rf "$DEMO/.claude"     # the hook is added when a user creates the demo (/pl-setup demo)
"$REPO/skills/pl-setup/scripts/check.sh" "$DEMO" && echo "demo is up to date and clean"
