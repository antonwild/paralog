#!/bin/bash
# Auto-commit for the vault: runs after Claude finishes a turn (Claude Code "Stop" hook).
# Commits every change with a timestamp. Pushes only with "git_push: on" in _system/config.md.
# The commits are the timestamp trail: they show WHEN something was written down.

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}" || exit 0
[ -f _system/rules.md ] || exit 0                   # not a paralog vault -> do nothing
git rev-parse --git-dir >/dev/null 2>&1 || exit 0   # not a git repo -> do nothing

# Nothing changed -> nothing to do
[ -z "$(git status --porcelain)" ] && exit 0

git add -A
# Message: timestamp + the changed note names (max 5), e.g. "2026-10-17 21:47 | 2026-10-17, Glossary"
files=$(git diff --cached --name-only | sed 's#.*/##; s#\.md$##' | head -5 | paste -sd ',' - | sed 's/,/, /g')
git commit -q -m "$(date '+%Y-%m-%d %H:%M') | $files" || exit 0

# Push only if turned on and a remote exists; errors (e.g. offline) are ignored, the next run pushes again
if grep -q "^git_push: on" _system/config.md 2>/dev/null && git remote | grep -q .; then
  git push -q 2>/dev/null
fi
exit 0
