#!/bin/bash
# For paralog development: keeps a test vault in sync with this repo.
#
#   dev/link-vault.sh <vault>      links the skills into the vault and installs a git post-commit hook in this repo
#   dev/link-vault.sh --remove     removes the hook
#
# After every commit here, the hook runs "scaffold.sh <vault> --update" and commits the changed framework files
# in the vault ("paralog <hash>"). The vault pushes only if git_push: on in its config.
# The hook lives in .git/hooks, so it is local to your clone and never shipped.

set -e
REPO="$(cd "$(dirname "$0")/.." && pwd)"
HOOK="$REPO/.git/hooks/post-commit"

if [ "$1" = "--remove" ]; then
  rm -f "$HOOK"; echo "removed $HOOK"; exit 0
fi
if [ -z "$1" ] || [ ! -f "$1/_system/rules.md" ]; then
  echo "Usage: dev/link-vault.sh <vault>   (the vault must be set up with /pl-setup first)"
  echo "       dev/link-vault.sh --remove"
  exit 1
fi
VAULT="$(cd "$1" && pwd)"

"$REPO/install.sh" "$VAULT" >/dev/null

cat > "$HOOK" <<HOOK
#!/bin/bash
# paralog dev sync (installed by dev/link-vault.sh)
VAULT="$VAULT"
"$REPO/skills/pl-setup/scripts/scaffold.sh" "\$VAULT" --update | grep -v '^warn' | sed 's/^/vault: /'
cd "\$VAULT" && git rev-parse --git-dir >/dev/null 2>&1 || exit 0
git add -A -- AGENTS.md CLAUDE.md .gitignore .claude/settings.json .claude/hooks _system Dashboards 2>/dev/null
git diff --cached --quiet && exit 0
git commit -q -m "\$(date '+%Y-%m-%d %H:%M') | paralog \$(git -C "$REPO" rev-parse --short HEAD)" -- AGENTS.md CLAUDE.md .gitignore .claude _system Dashboards
grep -q "^git_push: on" _system/config.md && git remote | grep -q . && git push -q 2>/dev/null
exit 0
HOOK
chmod +x "$HOOK"
echo "linked skills into $VAULT and installed $HOOK"
