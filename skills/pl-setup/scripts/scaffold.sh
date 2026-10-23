#!/bin/bash
# Builds or updates a paralog vault from the files in ../assets. Used by the pl-setup skill.
#
#   scaffold.sh <vault>            first install: creates what is missing, never overwrites
#   scaffold.sh <vault> --check    lists what an update would change. Changes nothing.
#   scaffold.sh <vault> --update   also replaces framework files (rules, templates, AGENTS.md, hook)
#   --tasks                        use the Tasks plugin files even if the config does not say so yet
#   scaffold.sh <vault> --demo     copies the demo vault (../assets/demo) into an empty folder, then installs
#
# Framework files belong to paralog and are replaced on --update (old versions stay in the vault's git history).
# Your files (config, Career - Wins, Career - Goals, resources, Journal.base, Tasks.md) are only created, never overwritten.
# Exception on --update: a file still exactly as shipped for the other tasks_plugin setting follows the switch.
# New config keys are added to your config with their default value; existing values are never changed.
#
# Output, one line each: created | updated | differs | missing | newkey | added-key | warn

set -e

VAULT=""; MODE=install; TASKS=""
for arg in "$@"; do
  case "$arg" in
    --check)  MODE=check ;;
    --update) MODE=update ;;
    --demo)   MODE=demo ;;
    --tasks)  TASKS=1 ;;
    -*)       VAULT="" ; break ;;
    *)        VAULT="$arg" ;;
  esac
done
if [ -z "$VAULT" ] || [ ! -d "$VAULT" ]; then
  echo "Usage: scaffold.sh <vault-folder> [--check | --update | --demo] [--tasks]"
  exit 1
fi
VAULT="$(cd "$VAULT" && pwd)"
ASSETS="$(cd "$(dirname "$0")/../assets" && pwd)"
CONFIG="$VAULT/_system/config.md"

# Demo: only into an empty folder (installed skills, git and macOS files do not count). Then a normal install.
if [ "$MODE" = demo ]; then
  other="$(find "$VAULT" -mindepth 1 -maxdepth 1 ! -name .claude ! -name .agents ! -name .git ! -name skills-lock.json ! -name .DS_Store | head -1)"
  if [ -n "$other" ]; then
    echo "The demo needs an empty folder. Found: ${other#"$VAULT"/}"
    exit 1
  fi
  cp -R "$ASSETS/demo/." "$VAULT/"
  echo "created demo vault"
  MODE=install
fi

grep -q "^tasks_plugin: on" "$CONFIG" 2>/dev/null && TASKS=1

# The source of a file: the Tasks plugin version if the plugin is on and one exists, else the normal one
src() {
  if [ -n "$TASKS" ] && [ -e "$ASSETS/tasks/$1" ]; then echo "$ASSETS/tasks/$1"; else echo "$ASSETS/vault/$1"; fi
}

cd "$ASSETS/vault"
FRAMEWORK_FILES=(AGENTS.md CLAUDE.md .gitignore .claude/settings.json .claude/hooks/auto-commit.sh
                 _system/rules.md _system/templates/*.md)
USER_FILES=("_system/config.md" "2_Areas/Career - Wins.md" "2_Areas/Career - Goals.md" "2_Areas/Meetings/1on1 Manager.md"
            "3_Resources/Glossary.md" "3_Resources/Where to Find.md" "3_Resources/Rules & Policies.md"
            "3_Resources/Commands.md" "3_Resources/How-Tos.md" "3_Resources/Teams.md" "Journal.base")
[ -n "$TASKS" ] && USER_FILES+=("Tasks.md")

# 1. PARA folders
if [ "$MODE" != check ]; then
  mkdir -p "$VAULT/.obsidian" "$VAULT/.claude/hooks" "$VAULT/0_Daily" "$VAULT/1_Projects" \
           "$VAULT/2_Areas/Meetings" "$VAULT/3_Resources" "$VAULT/4_Archive" "$VAULT/_system/templates"
fi

# 2. Framework files
for rel in "${FRAMEWORK_FILES[@]}"; do
  from="$(src "$rel")"
  # A link here (e.g. a hand-made install): replace it with a real file, never write through it
  if [ -L "$VAULT/$rel" ] && [ "$MODE" != check ]; then rm -f "$VAULT/$rel"; fi
  if [ ! -e "$VAULT/$rel" ]; then
    if [ "$MODE" = check ]; then echo "missing $rel"; else cp "$from" "$VAULT/$rel"; echo "created $rel"; fi
  elif ! cmp -s "$from" "$VAULT/$rel"; then
    case "$MODE" in
      check)  echo "differs $rel" ;;
      update) cp "$from" "$VAULT/$rel"; echo "updated $rel" ;;
    esac
  fi
done
[ -e "$VAULT/.claude/hooks/auto-commit.sh" ] && chmod +x "$VAULT/.claude/hooks/auto-commit.sh"

# The other variant of a file (normal <-> Tasks plugin), if both exist
other() {
  [ -e "$ASSETS/tasks/$1" ] || return 1
  if [ -n "$TASKS" ]; then echo "$ASSETS/vault/$1"; else echo "$ASSETS/tasks/$1"; fi
}

# 3. Your files: created when missing, never overwritten.
#    Exception: a file still exactly as shipped for the other Tasks plugin setting was never edited,
#    so it follows the switch (e.g. "1on1 Manager" gets the tasks query).
for rel in "${USER_FILES[@]}"; do
  if [ ! -e "$VAULT/$rel" ]; then
    if [ "$MODE" = check ]; then echo "missing $rel"; else cp "$(src "$rel")" "$VAULT/$rel"; echo "created $rel"; fi
  elif [ "$MODE" != install ] && alt="$(other "$rel")" && cmp -s "$alt" "$VAULT/$rel"; then
    if [ "$MODE" = check ]; then echo "differs $rel"; else cp "$(src "$rel")" "$VAULT/$rel"; echo "updated $rel"; fi
  fi
done

# 4. New config keys: copy the key and its comment lines from the default config into yours
if [ -f "$CONFIG" ]; then
  block=""; n=0
  while IFS= read -r line; do
    n=$((n + 1))
    if [ "$line" = "---" ]; then [ $n -gt 1 ] && break; continue; fi
    case "$line" in
      "#"*) block="$block$line"$'\n' ;;
      [a-z]*:*)
        key="${line%%:*}"
        if ! grep -q "^$key:" "$CONFIG"; then
          if [ "$MODE" = check ]; then
            echo "newkey $key"
          else
            tmp="$(mktemp)"; printf '%s%s\n' "$block" "$line" > "$tmp"
            awk -v f="$tmp" '/^---$/ { c++; if (c == 2) while ((getline l < f) > 0) print l } { print }' \
              "$CONFIG" > "$CONFIG.new" && mv "$CONFIG.new" "$CONFIG"
            rm -f "$tmp"
            echo "added-key $key"
          fi
        fi
        block="" ;;
      *) block="" ;;
    esac
  done < "$ASSETS/vault/_system/config.md"
fi

# 5. Obsidian settings: daily notes in 0_Daily with our template, templates folder
OBS="$VAULT/.obsidian"
if [ -e "$OBS/daily-notes.json" ]; then
  grep -q '"folder": *"0_Daily"' "$OBS/daily-notes.json" ||
    echo "warn Obsidian daily notes do not go to 0_Daily. Settings → Daily notes: folder 0_Daily, template _system/templates/Daily."
elif [ "$MODE" = check ]; then
  echo "missing .obsidian/daily-notes.json"
else
  echo '{ "folder": "0_Daily", "format": "YYYY-MM-DD", "template": "_system/templates/Daily" }' > "$OBS/daily-notes.json"
  echo "created .obsidian/daily-notes.json"
fi
if [ -e "$OBS/templates.json" ]; then
  grep -q '"folder": *"_system/templates"' "$OBS/templates.json" ||
    echo "warn Obsidian templates folder is not _system/templates. Settings → Templates: folder _system/templates."
elif [ "$MODE" = check ]; then
  echo "missing .obsidian/templates.json"
else
  echo '{ "folder": "_system/templates" }' > "$OBS/templates.json"
  echo "created .obsidian/templates.json"
fi
for plugin in daily-notes templates; do
  if grep -q "\"$plugin\": *false" "$OBS/core-plugins.json" 2>/dev/null; then
    echo "warn Obsidian core plugin \"$plugin\" is off. Turn it on in Settings → Core plugins."
  fi
done
if [ -n "$TASKS" ] && ! grep -q '"globalFilter": *"#task"' "$OBS/plugins/obsidian-tasks-plugin/data.json" 2>/dev/null; then
  echo "warn Tasks plugin: install it in Obsidian, then set Settings → Tasks → Global filter to #task."
fi
exit 0
