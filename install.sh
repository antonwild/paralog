#!/bin/bash
# Installs the paralog skills into a vault folder, without npx.
# Use this if "npx skills add" is not available (e.g. no npm access at work).
#
#   ./install.sh <vault>          link the skills (changes in this repo apply right away)
#   ./install.sh <vault> --copy   copy them instead (Windows, or if the repo may move)
#
# Then open your agent in the vault and run /pl-setup. It builds or updates the vault.

set -e

VAULT="$1"
MODE="$2"
REPO="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$VAULT" ]; then
  echo "Usage: ./install.sh <vault-folder> [--copy]"
  exit 1
fi
mkdir -p "$VAULT"

# Claude Code reads .claude/skills, most other agents (Codex, Cursor, ...) read .agents/skills
for dir in .claude/skills .agents/skills; do
  mkdir -p "$VAULT/$dir"
  find "$VAULT/$dir" -maxdepth 1 -type l ! -exec test -e {} \; -delete   # remove broken links (renamed skills)
  for skill in "$REPO"/skills/*/; do
    name="$(basename "$skill")"
    if [ "$MODE" = "--copy" ]; then
      rm -rf "${VAULT:?}/$dir/$name"
      cp -R "${skill%/}" "$VAULT/$dir/$name"
    else
      # a copied skill (e.g. from npx skills) is a real folder: replace it, or ln would link inside it
      [ -d "$VAULT/$dir/$name" ] && [ ! -L "$VAULT/$dir/$name" ] && rm -rf "${VAULT:?}/$dir/$name"
      ln -sfn "${skill%/}" "$VAULT/$dir/$name"
    fi
  done
  echo "installed skills into $dir"
done

echo
echo "Next: open your agent (e.g. Claude Code) in $VAULT and run /pl-setup."
