#!/bin/bash
# Mechanical checks for a paralog vault. Used by the pl-check skill. Read-only: changes nothing.
#
#   check.sh <vault>
#
# Output: one line per problem, "<check> <file>: <problem>". Exit 1 if there are problems, else 0.
# Checks:  type     notes in the PARA folders without a type property
#          folders  folder names with spaces
#          links    [[links]] to notes that do not exist (date links are ignored)
#          meetings project meetings outside their project's Meetings folder
#          tasks    Tasks plugin setup, only with tasks_plugin: on (rules section 11)
# Judgment checks (duplicate tasks, stale items, personal data) are left to the agent.

set -u
if [ $# -ne 1 ] || [ ! -f "$1/_system/rules.md" ]; then
  echo "Usage: check.sh <vault-folder>   (a vault set up with /pl-setup)"
  exit 2
fi
cd "$1" || exit 2

OUT="$(mktemp)"; NAMES="$(mktemp)"
trap 'rm -f "$OUT" "$NAMES"' EXIT

PARA="0_Daily 1_Projects 2_Areas 3_Resources 4_Archive"
# shellcheck disable=SC2086
notes() { find $PARA Dashboards -type f -name '*.md' -print0 2>/dev/null; }
DATE_RE='^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$'

# 1. type: every note in the PARA folders has a type in its frontmatter
# shellcheck disable=SC2086
find $PARA -type f -name '*.md' -print0 2>/dev/null | xargs -0 awk '
  function finish() { if (f != "" && !has) print "type " f ": no type property" }
  FNR == 1 { finish(); f = FILENAME; has = 0; fm = ($0 == "---"); next }
  fm && $0 == "---" { fm = 0; next }
  fm && /^type:[ \t]*[^ \t]/ { has = 1 }
  END { finish() }' >> "$OUT"

# 2. folders: no spaces in folder names
# shellcheck disable=SC2086
find $PARA -mindepth 1 -type d -name '* *' 2>/dev/null | sed 's/^\(.*\)$/folders \1: folder name has spaces/' >> "$OUT"

# 3. links: every [[link]] points to a file in the vault (Obsidian matches by name, case-insensitive)
find . -type f ! -path './.git/*' ! -path './.obsidian/*' ! -path './.claude/*' ! -path './.agents/*' ! -path './.trash/*' \
  | sed 's#.*/##' | awk '{ n = tolower($0); print n; sub(/\.md$/, "", n); print n }' > "$NAMES"
notes | xargs -0 awk -v date_re="$DATE_RE" '
  NR == FNR { known[$0] = 1; next }
  FNR == 1 { fence = 0 }
  /^[ \t>]*```/ { fence = !fence; next }
  fence { next }
  {
    line = $0
    gsub(/`[^`]*`/, "", line)                       # no links inside inline code
    while (match(line, /\[\[[^]]+\]\]/)) {
      link = substr(line, RSTART + 2, RLENGTH - 4)
      line = substr(line, RSTART + RLENGTH)
      sub(/[|#^].*$/, "", link); sub(/\\$/, "", link); sub(/^.*\//, "", link)
      gsub(/^[ \t]+|[ \t]+$/, "", link)
      if (link == "" || link ~ date_re || link ~ /\{\{/) continue
      key = FILENAME SUBSEP link
      if (!(tolower(link) in known) && !(key in seen)) {
        seen[key] = 1
        print "links " FILENAME ": [[" link "]] has no note"
      }
    }
  }' "$NAMES" >> "$OUT"

# 4. meetings: a project meeting lives in <project folder>/Meetings/
grep -rl --include='*.md' '^type: meeting' 1_Projects 2_Areas 4_Archive 2>/dev/null | while IFS= read -r meeting; do
  project="$(sed -n 's/^project:[ \t]*"*\[\[\([^]|]*\).*/\1/p' "$meeting" | head -1)"
  [ -z "$project" ] && continue
  project_file="$(find 1_Projects 4_Archive -type f -name "$project.md" 2>/dev/null | head -1)"
  [ -z "$project_file" ] && continue                  # missing project: reported by the links check
  case "$meeting" in
    "$(dirname "$project_file")/Meetings/"*) ;;
    *) echo "meetings $meeting: not in the Meetings folder of [[$project]] ($(dirname "$project_file")/Meetings/)" ;;
  esac
done >> "$OUT"

# 5. tasks: only with the Tasks plugin
if grep -q '^tasks_plugin: on' _system/config.md 2>/dev/null; then
  # tasks query blocks need "hide toolbar"
  notes | xargs -0 awk '
    FNR == 1 { q = 0 }
    /^[ \t>]*```tasks/ { q = 1; hide = 0; start = FNR; next }
    q && /hide toolbar/ { hide = 1 }
    q && /^[ \t>]*```[ \t]*$/ { if (!hide) print "tasks " FILENAME ": tasks query (line " start ") has no \"hide toolbar\""; q = 0 }' >> "$OUT"

  # task lines live in the daily notes; open tasks there carry #task
  # shellcheck disable=SC2086
  find 1_Projects 2_Areas 3_Resources Dashboards -type f -name '*.md' -print0 2>/dev/null |
    xargs -0 grep -HnE '^[[:space:]>]*- \[.\] .*#task' 2>/dev/null |
    sed -E 's/^([^:]*):([0-9]+):.*/tasks \1: task line outside a daily note (line \2)/' >> "$OUT"
  find 0_Daily -type f -name '*.md' -print0 2>/dev/null |
    xargs -0 grep -HnE '^[[:space:]>]*- \[ \] ' 2>/dev/null | grep -v '#task' |
    sed -E 's/^([^:]*):([0-9]+):.*/tasks \1: open task without #task (line \2)/' >> "$OUT"

  # notes with "## Open Items" need a task_tag and the tasks query; collect all task_tags
  TAGS="$(mktemp)"
  # shellcheck disable=SC2086
  find 1_Projects 2_Areas -type f -name '*.md' -print0 2>/dev/null | xargs -0 awk -v tags="$TAGS" '
    function finish() {
      if (f == "" || !open) return
      if (tag == "") print "tasks " f ": has ## Open Items but no task_tag"
      if (!query) print "tasks " f ": ## Open Items is not a tasks query"
    }
    FNR == 1 { finish(); f = FILENAME; tag = ""; open = 0; query = 0; after = 0; fm = ($0 == "---"); next }
    fm && $0 == "---" { fm = 0; next }
    fm && /^task_tag:/ { tag = $0; sub(/^task_tag:[ \t]*/, "", tag); gsub(/["#]/, "", tag); if (tag != "") print tag > tags }
    /^## Open Items/ { open = 1; after = 1; next }
    after && /^[ \t]*$/ { next }
    after { if ($0 ~ /^```tasks/) query = 1; after = 0 }
    END { finish() }' >> "$OUT"

  # tags like #project/... must match a task_tag
  find 0_Daily -type f -name '*.md' -print0 2>/dev/null |
    xargs -0 grep -HoE '#(project|area|meeting)/[A-Za-z0-9/_-]+' 2>/dev/null | sort -u |
    while IFS= read -r hit; do
      file="${hit%%:#*}"; tag="${hit#*:#}"
      grep -qxF "$tag" "$TAGS" || echo "tasks $file: tag #$tag matches no note's task_tag"
    done >> "$OUT"
  rm -f "$TAGS"
fi

sort -u "$OUT"
[ -s "$OUT" ] && exit 1
exit 0
