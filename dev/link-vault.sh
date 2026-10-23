#!/bin/bash
# For paralog development: keeps test vaults in sync with this repo.
#
#   dev/link-vault.sh <vault>      links the skills into the vault and adds it to the post-commit hook of this repo
#   dev/link-vault.sh --list       shows the linked vaults
#   dev/link-vault.sh --remove [<vault>]   unlinks one vault, or all of them and removes the hook
#
# After every commit here, the hook links new skills into each vault, runs "scaffold.sh <vault> --update" and commits
# exactly the files it created or changed there ("paralog <hash>"). A vault pushes only if git_push: on in its config.
# The hook and the list (.git/paralog-vaults) live in .git, so they are local to your clone and never shipped.

set -e
REPO="$(cd "$(dirname "$0")/.." && pwd)"
HOOK="$REPO/.git/hooks/post-commit"
LIST="$REPO/.git/paralog-vaults"

# Vaults linked by an older version of this script: the hook had one VAULT="..." line
if [ ! -f "$LIST" ] && [ -f "$HOOK" ]; then
  sed -n 's/^VAULT="\(.*\)"$/\1/p' "$HOOK" > "$LIST"
fi

case "$1" in
  --list)
    cat "$LIST" 2>/dev/null; exit 0 ;;
  --remove)
    if [ -n "$2" ]; then
      target="$(cd "$2" && pwd)"
      grep -vxF "$target" "$LIST" > "$LIST.new" || true; mv "$LIST.new" "$LIST"
      echo "unlinked $target"
      [ -s "$LIST" ] && exit 0
    fi
    rm -f "$HOOK" "$LIST"; echo "removed $HOOK"; exit 0 ;;
esac
if [ -z "$1" ] || [ ! -f "$1/_system/rules.md" ]; then
  echo "Usage: dev/link-vault.sh <vault>   (the vault must be set up with /pl-setup first)"
  echo "       dev/link-vault.sh --list | --remove [<vault>]"
  exit 1
fi
VAULT="$(cd "$1" && pwd)"

"$REPO/install.sh" "$VAULT" >/dev/null
grep -qxF "$VAULT" "$LIST" 2>/dev/null || echo "$VAULT" >> "$LIST"

cat > "$HOOK" <<HOOK
#!/bin/bash
# paralog dev sync (installed by dev/link-vault.sh). Vaults: $LIST
while IFS= read -r VAULT; do
  [ -f "\$VAULT/_system/rules.md" ] || continue
  (
    "$REPO/install.sh" "\$VAULT" >/dev/null                    # links new skills
    out="\$("$REPO/skills/pl-setup/scripts/scaffold.sh" "\$VAULT" --update)"
    echo "\$out" | grep -v '^warn' | sed "s#^#\$(basename "\$VAULT"): #"
    cd "\$VAULT" && git rev-parse --git-dir >/dev/null 2>&1 || exit 0
    # commit exactly the files the update created or changed, nothing else of the vault
    files=()
    while IFS= read -r path; do files+=("\$path"); done < <(echo "\$out" | sed -nE 's/^(created|updated) //p; s/^added-key .*/_system\/config.md/p' | sort -u)
    [ \${#files[@]} -eq 0 ] && exit 0
    git add -- "\${files[@]}"
    git diff --cached --quiet && exit 0
    git commit -q -m "\$(date '+%Y-%m-%d %H:%M') | paralog \$(git -C "$REPO" rev-parse --short HEAD)" -- "\${files[@]}"
    grep -q "^git_push: on" _system/config.md && git remote | grep -q . && git push -q 2>/dev/null
    exit 0
  )
done < "$LIST"
exit 0
HOOK
chmod +x "$HOOK"
echo "linked skills into $VAULT. Synced after each commit: $(paste -sd ' ' "$LIST")"
