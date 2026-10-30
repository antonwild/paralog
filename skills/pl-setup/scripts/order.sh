#!/bin/bash
# Checks and fixes the order of log sections: newest first (rules section 2, rule 11).
#
#   order.sh <vault>                  read-only: one "order <file>: <problem>" line per section in the wrong order (for check.sh)
#   order.sh <vault> --fix [file...]  sorts those sections newest first: all notes, or only the files given
#
# Sections: ## Timeline, ## Log, ## Decisions, ## Wins, ## Milestones in 1_Projects, 2_Areas and 4_Archive.
# An entry is a list line that starts with a date link, with the indented lines below it. The fix only moves
# entries and month headings. It never changes a word. Entries with the same date get the reverse order
# (they were appended oldest first). A section with other content (plain text, entries without a date)
# is not sorted. The script names it, and the user sorts it by hand.

set -u
if [ $# -lt 1 ] || [ ! -f "$1/_system/rules.md" ]; then
  echo "Usage: order.sh <vault-folder> [--fix [file...]]"
  exit 2
fi
cd "$1" || exit 2
shift
MODE=check
if [ "${1:-}" = "--fix" ]; then MODE=fix; shift; fi

files() {
  if [ $# -gt 0 ]; then printf '%s\0' "$@"
  else find 1_Projects 2_Areas 4_Archive -type f -name '*.md' -print0 2>/dev/null
  fi
}

STATUS=0
while IFS= read -r -d '' f; do
  [ -f "$f" ] || continue
  out="$(awk -v mode="$MODE" -v file="$f" '
    { line[++n] = $0 }

    function is_log_head(s) { return s ~ /^## (Timeline|Log|Decisions|Wins|Milestones)[ \t]*$/ }

    # Parses the section body (lines a..b). Returns 1 if it can be sorted.
    function parse(a, b,    i, s) {
      nm = 0; ne = 0; cur = 0; pre = ""
      for (i = a; i <= b; i++) {
        s = line[i]
        if (s ~ /^### [0-9][0-9][0-9][0-9]-[0-9][0-9][ \t]*$/) { mon[++nm] = s; cur = nm; continue }
        if (s ~ /^- (\[.\] )?\[\[[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\]\]/) {
          ne++; ent[ne] = s; em[ne] = cur
          match(s, /\[\[[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\]\]/); ed[ne] = substr(s, RSTART + 2, 10)
          continue
        }
        if (s ~ /^[ \t]+[^ \t]/ && ne > 0 && i > 1 && line[i-1] !~ /^[ \t]*$/) { ent[ne] = ent[ne] "\n" s; continue }
        if (s ~ /^[ \t]*$/) continue
        if (s ~ /^<!--.*-->[ \t]*$/ && ne == 0 && nm == 0) { pre = pre s "\n"; continue }
        return 0
      }
      if (nm > 0) for (i = 1; i <= ne; i++) if (em[i] == 0) return 0   # entries above the first month heading
      return 1
    }

    # 1 if the section already reads newest first
    function ordered(    i) {
      for (i = 2; i <= nm; i++) if (mon[i] > mon[i-1]) return 0
      for (i = 2; i <= ne; i++) if (em[i] == em[i-1] && ed[i] > ed[i-1]) return 0
      return 1
    }

    # Prints the sorted body: months newest first, entries in each month newest first
    function emit(    order, k, i, j, t, m, mo, first) {
      for (i = 1; i <= nm; i++) mo[i] = i
      for (i = 2; i <= nm; i++) { t = mo[i]; for (j = i - 1; j >= 1 && mon[mo[j]] < mon[t]; j--) mo[j+1] = mo[j]; mo[j+1] = t }
      k = 0
      for (i = ne; i >= 1; i--) order[++k] = i            # reverse first: same dates keep reverse order
      for (i = 2; i <= ne; i++) { t = order[i]; for (j = i - 1; j >= 1 && ed[order[j]] < ed[t]; j--) order[j+1] = order[j]; order[j+1] = t }
      printf "%s", pre
      if (nm == 0) { for (i = 1; i <= ne; i++) print ent[order[i]]; return }
      first = 1
      for (m = 1; m <= nm; m++) {
        if (!first) print ""
        first = 0
        print mon[mo[m]]
        for (i = 1; i <= ne; i++) if (em[order[i]] == mo[m]) print ent[order[i]]
      }
    }

    END {
      i = 1; fence = 0
      while (i <= n) {
        s = line[i]
        if (s ~ /^[ \t>]*```/) fence = !fence
        if (fence || !is_log_head(s)) { if (mode == "fix") print s; i++; continue }
        for (e = i + 1; e <= n && line[e] !~ /^##? /; e++) ;
        b = e - 1
        trail = (b > i && line[b] ~ /^[ \t]*$/)
        while (b > i && line[b] ~ /^[ \t]*$/) b--
        ok = parse(i + 1, b)
        if (mode == "check") {
          if (!ok) { if (ne > 0) print "order " file ": " s " cannot be sorted automatically (text without a date, or entries above the first month heading). Sort it newest first by hand." }
          else if (!ordered()) print "order " file ": " s " is not newest first"
        } else {
          print s
          if (ok && !ordered()) emit()
          else for (j = i + 1; j <= b; j++) print line[j]
          if (trail) print ""
        }
        i = e
      }
    }' "$f")"
  if [ "$MODE" = check ]; then
    [ -n "$out" ] && { echo "$out"; STATUS=1; }
  else
    if [ "$out" != "$(cat "$f")" ]; then printf '%s\n' "$out" > "$f"; echo "sorted $f"; fi
  fi
done < <(files "$@")
exit $STATUS
