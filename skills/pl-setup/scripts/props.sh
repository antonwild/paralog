#!/bin/bash
# Derives the daily note properties from the vault (rules section 12). Read-only: changes nothing.
# Used by pl-daily (write them), pl-check (fill older notes) and check.sh (find drift).
#
#   props.sh <vault> <YYYY-MM-DD>...   prints the derived properties of each day as YAML lines
#   props.sh <vault> --tsv             all days, one "<date>\t<key>\t<value>" line per value (for check.sh)
#   props.sh <vault> --topics          the topics already in use, most used first (reuse them)
#
# Derived: projects, meetings, areas  notes with an entry that starts with the day's date link
#          decisions                  entries under "## Decisions" (each decision lives in one Decisions section)
#          wins, milestones           entries under "## Wins" and "## Milestones" (Career - Wins)
#          for_manager                task lines with #for-manager whose first date link is the day
# Not derived: summary and topics. The agent writes them.

set -u
if [ $# -lt 2 ] || [ ! -f "$1/_system/rules.md" ]; then
  echo "Usage: props.sh <vault-folder> <YYYY-MM-DD>... | --tsv | --topics"
  exit 2
fi
cd "$1" || exit 2
shift

index() {
  find 0_Daily 1_Projects 2_Areas 4_Archive -type f -name '*.md' -print0 2>/dev/null | xargs -0 awk '
    FNR == 1 {
      name = FILENAME; sub(/^.*\//, "", name); sub(/\.md$/, "", name)
      type = ""; head = ""; fence = 0; fm = ($0 == "---"); next
    }
    fm && $0 == "---" { fm = 0; next }
    fm { if ($0 ~ /^type:/) { type = $0; sub(/^type:[ \t]*/, "", type); gsub(/["\047 \t]/, "", type) }; next }
    /^[ \t>]*```/ { fence = !fence; next }
    fence { next }
    /^## / { head = $0; sub(/[ \t]+$/, "", head); next }

    # task lines: #for-manager counts on the first date link of the line
    /^[ \t>]*- \[.\] / {
      if ($0 ~ /#for-manager/ && match($0, /\[\[[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\]\]/))
        print substr($0, RSTART + 2, 10) "\tfor_manager\t1"
      next
    }

    # log entries: a list line that starts with a date link (not in daily notes)
    type != "daily" && match($0, /^[ \t]*- \[\[[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\]\]/) {
      d = substr($0, RSTART + RLENGTH - 12, 10)
      if (type == "project") print d "\tprojects\t[[" name "]]"
      else if (type == "meeting") print d "\tmeetings\t[[" name "]]"
      else if (type == "area" && name != "Career - Wins" && name != "Career - Goals") print d "\tareas\t[[" name "]]"
      if (head == "## Decisions") print d "\tdecisions\t1"
      else if (head == "## Wins") print d "\twins\t1"
      else if (head == "## Milestones") print d "\tmilestones\t1"
    }'
}

# Sums the counts, removes duplicate links, sorts
summarise() {
  awk -F'\t' '
    $2 ~ /^(decisions|wins|milestones|for_manager)$/ { n[$1 "\t" $2] += $3; next }
    { print }
    END { for (k in n) print k "\t" n[k] }' | sort -u
}

if [ "$1" = "--topics" ]; then
  find 0_Daily -type f -name '*.md' -print0 2>/dev/null | xargs -0 awk '
    FNR == 1 { fm = ($0 == "---"); key = ""; next }
    !fm { next }
    $0 == "---" { fm = 0; next }
    /^[A-Za-z_]+:/ {
      key = $0; sub(/:.*/, "", key)
      v = $0; sub(/^[A-Za-z_]+:[ \t]*/, "", v)
      if (key == "topics" && v ~ /^\[.+\]$/) { gsub(/[][" \047]/, "", v); n = split(v, t, ","); for (i = 1; i <= n; i++) print t[i] }
      next
    }
    key == "topics" && /^[ \t]+- / { v = $0; sub(/^[ \t]+- [ \t]*/, "", v); gsub(/["\047 \t]/, "", v); if (v != "") print v }' |
    sort | uniq -c | sort -k1,1nr -k2 | awk '{ print $2 " (" $1 ")" }'
  exit 0
fi

if [ "$1" = "--tsv" ]; then
  index | summarise
  exit 0
fi

TSV="$(index | summarise)"
for day in "$@"; do
  printf '%s\n' "$TSV" | awk -F'\t' -v day="$day" '
    $1 == day { if ($2 ~ /^(projects|meetings|areas)$/) list[$2] = list[$2] "  - \"" $3 "\"\n"; else n[$2] = $3 }
    END {
      print "# " day
      split("projects meetings areas", lists, " ")
      for (i = 1; i <= 3; i++) {
        k = lists[i]
        if (list[k] == "") print k ": []"; else printf "%s:\n%s", k, list[k]
      }
      split("decisions wins milestones for_manager", counts, " ")
      for (i = 1; i <= 4; i++) print counts[i] ": " (n[counts[i]] + 0)
    }'
done
