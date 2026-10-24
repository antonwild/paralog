#!/bin/bash
# Derives the daily note properties from the vault (rules section 12). Read-only: changes nothing.
# Used by pl-daily (write them), pl-check (fill older notes), check.sh (find drift),
# and pl-week, pl-prep, pl-evidence (find the days and notes to read).
#
#   props.sh <vault> <YYYY-MM-DD>...   prints the derived properties of each day as YAML lines
#   props.sh <vault> --tsv             all days, one "<date>\t<key>\t<value>" line per value (for check.sh)
#   props.sh <vault> --topics          the topics already in use, most used first (reuse them)
#   props.sh <vault> --days FROM TO    one line per day: state, counts, summary, links (skills read this first)
#   props.sh <vault> --check           processed daily notes whose properties are missing or wrong (for check.sh)
#
# Derived: projects, meetings, areas  notes with an entry that starts with the day's date link
#          decisions                  entries under "## Decisions" (each decision lives in one Decisions section)
#          wins, milestones           entries under "## Wins" and "## Milestones" (Career - Wins)
#          for_manager                task lines with #for-manager whose first date link is the day
# Not derived: summary and topics. The agent writes them.

set -u
if [ $# -lt 2 ] || [ ! -f "$1/_system/rules.md" ]; then
  echo "Usage: props.sh <vault-folder> <YYYY-MM-DD>... | --tsv | --topics | --days FROM TO | --check"
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

# Compares the properties of processed daily notes with the vault. One "props <file>: <problem>" line each.
verify() {
  local expected; expected="$(mktemp)"
  index | summarise > "$expected"
  find 0_Daily -type f -name '*.md' -print0 2>/dev/null | xargs -0 awk -F'\t' '
  function finish(   k, n, i, v, parts, item, want) {
    if (f == "" || !processed || day == "") return
    if (!(("summary") in has) && !(("projects") in has) && !(("decisions") in has)) {
      print "props " f ": processed, but has no properties yet"; return
    }
    v = val["summary"]; gsub(/^["\047]+|["\047]+$/, "", v)
    if (!("summary" in has) || v == "") print "props " f ": no summary"
    split("projects meetings areas topics decisions wins milestones for_manager", keys, " ")
    for (i = 1; i <= 8; i++) if (!(keys[i] in has)) print "props " f ": no " keys[i]
    for (k in expect) {                                     # expected links that are missing
      split(k, parts, SUBSEP)
      if (parts[1] != day) continue
      if (parts[2] ~ /^(decisions|wins|milestones|for_manager)$/) continue
      if (!((parts[2] SUBSEP parts[3]) in got)) print "props " f ": " parts[2] " misses " parts[3]
    }
    for (k in got) {                                     # links that are not in the vault
      split(k, parts, SUBSEP)
      if (parts[1] == "topics") continue
      if (!((day SUBSEP parts[1] SUBSEP parts[2]) in expect)) print "props " f ": " parts[1] " has " parts[2] ", but no entry of this day is in that note"
    }
    split("decisions wins milestones for_manager", counts, " ")
    for (i = 1; i <= 4; i++) {
      k = counts[i]; want = (day SUBSEP k) in num ? num[day SUBSEP k] : 0
      if ((k in has) && val[k] + 0 != want) print "props " f ": " k " is " (val[k] + 0) ", the vault has " want
    }
    n = 0
    for (k in got) {
      split(k, parts, SUBSEP)
      if (parts[1] != "topics") continue
      n++
      if (parts[2] !~ /^[a-z0-9]+(-[a-z0-9]+)*$/) print "props " f ": topic \"" parts[2] "\" is not lowercase-with-dashes"
    }
    if (n > 5) print "props " f ": " n " topics, at most 5"
  }
  NR == FNR {
    if ($2 ~ /^(decisions|wins|milestones|for_manager)$/) num[$1 SUBSEP $2] = $3
    else expect[$1 SUBSEP $2 SUBSEP $3] = 1
    next
  }
  FNR == 1 {
    finish(); f = FILENAME; day = ""; processed = 0; key = ""
    delete has; delete val; delete got
    fm = ($0 == "---"); next
  }
  !fm { next }
  $0 == "---" { fm = 0; next }
  /^[ \t]+- / {                                         # item of a block list
    if (key == "") next
    item = $0; sub(/^[ \t]+- [ \t]*/, "", item); gsub(/^["\047]|["\047][ \t]*$/, "", item)
    if (item != "") got[key SUBSEP item] = 1
    next
  }
  /^[A-Za-z_]+:/ {
    key = $0; sub(/:.*/, "", key)
    v = $0; sub(/^[A-Za-z_]+:[ \t]*/, "", v); sub(/[ \t]+$/, "", v)
    has[key] = 1; val[key] = v
    if (key == "date") day = v
    if (key == "processed" && v == "true") processed = 1
    if (v ~ /^\[.*\]$/) {                               # inline list: [a, "b"]
      v = substr(v, 2, length(v) - 2); n = split(v, items, ",")
      for (i = 1; i <= n; i++) { item = items[i]; gsub(/^[ \t"\047]+|[ \t"\047]+$/, "", item); if (item != "") got[key SUBSEP item] = 1 }
    }
    if (v != "") key = ""                                 # a block list follows only an empty value
    next
  }
  END { finish() }' "$expected"
  rm -f "$expected"
}

if [ "$1" = "--check" ]; then
  verify
  exit 0
fi

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

if [ "$1" = "--days" ]; then
  from="${2:-}"; to="${3:-}"
  case "$from$to" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) ;;
    *) echo "Usage: props.sh <vault-folder> --days YYYY-MM-DD YYYY-MM-DD"; exit 2 ;;
  esac
  DAYS="$(mktemp)"; STALE="$(mktemp)"
  # every date from FROM to TO with its weekday (civil calendar math, no date command needed)
  awk -v from="$from" -v to="$to" '
    function jdn(y, m, d,   a) { a = int((14 - m) / 12); y += 4800 - a; m += 12 * a - 3
      return d + int((153 * m + 2) / 5) + 365 * y + int(y / 4) - int(y / 100) + int(y / 400) - 32045 }
    function civil(j,   a, b, c, d, e, m) { a = j + 32044; b = int((4 * a + 3) / 146097); c = a - int(146097 * b / 4)
      d = int((4 * c + 3) / 1461); e = c - int(1461 * d / 4); m = int((5 * e + 2) / 153)
      return sprintf("%04d-%02d-%02d", 100 * b + d - 4800 + int(m / 10), m + 3 - 12 * int(m / 10), e - int((153 * m + 2) / 5) + 1) }
    BEGIN {
      split("Mon Tue Wed Thu Fri Sat Sun", wd, " ")
      split(from, f, "-"); split(to, t, "-")
      for (j = jdn(f[1] + 0, f[2] + 0, f[3] + 0); j <= jdn(t[1] + 0, t[2] + 0, t[3] + 0); j++) print civil(j) "\t" wd[j % 7 + 1]
    }' > "$DAYS"
  verify | sed -E 's/^props ([^:]*):.*/\1/' | sort -u > "$STALE"
  echo "# date | day | state | decisions wins milestones for_manager | summary | projects | meetings | areas | topics"
  echo "# state: ok = filed, properties match the vault | stale = filed, properties missing or wrong: read the note"
  echo "#        todo = Brain Dump not filed yet | empty = note without a Brain Dump | none = no note (work days only)"
  find 0_Daily -type f -name '*.md' -print0 2>/dev/null | xargs -0 awk -F'\t' -v stalefile="$STALE" -v daysfile="$DAYS" '
    function list(k) { return (k in v) ? v[k] : "" }
    function finish() {
      if (f == "" || day == "") return
      file[day] = f; done_[day] = processed; dump[day] = hasdump
      for (k in v) val[day SUBSEP k] = v[k]
    }
    BEGIN { while ((getline l < stalefile) > 0) stale[l] = 1 }
    FNR == 1 {
      finish(); f = FILENAME; day = ""; processed = 0; hasdump = 0; key = ""; sect = ""; delete v
      fm = ($0 == "---"); next
    }
    fm && $0 == "---" { fm = 0; next }
    fm && /^[ \t]+- / {
      if (key == "") next
      it = $0; sub(/^[ \t]+- [ \t]*/, "", it); gsub(/^["\047]|["\047][ \t]*$/, "", it); gsub(/\[\[|\]\]/, "", it)
      v[key] = (v[key] == "" ? it : v[key] ", " it); next
    }
    fm && /^[A-Za-z_]+:/ {
      key = $0; sub(/:.*/, "", key)
      x = $0; sub(/^[A-Za-z_]+:[ \t]*/, "", x); sub(/[ \t]+$/, "", x)
      if (key == "date") day = x
      if (key == "processed" && x == "true") processed = 1
      if (x ~ /^\[.*\]$/) { x = substr(x, 2, length(x) - 2); gsub(/["\047]|\[\[|\]\]/, "", x); gsub(/,[ \t]*/, ", ", x) }
      else gsub(/^["\047]|["\047]$/, "", x)
      v[key] = x
      if (x != "" || key !~ /^(projects|meetings|areas|topics)$/) key = ""
      next
    }
    fm { next }
    /^## / { sect = $0; next }
    sect ~ /^## Brain Dump/ && $0 !~ /^[ \t]*$/ && $0 !~ /^[ \t]*<!--.*-->[ \t]*$/ { hasdump = 1 }
    END {
      finish()
      while ((getline l < daysfile) > 0) {
        split(l, p, "\t"); d = p[1]; wd = p[2]
        if (!(d in file)) { if (wd != "Sat" && wd != "Sun") print d " | " wd " | none"; continue }
        if (done_[d]) state = (file[d] in stale) ? "stale" : "ok"
        else state = dump[d] ? "todo" : "empty"
        if (state == "todo" || state == "empty") { print d " | " wd " | " state; continue }
        c = (val[d SUBSEP "decisions"] + 0) " " (val[d SUBSEP "wins"] + 0) " " (val[d SUBSEP "milestones"] + 0) " " (val[d SUBSEP "for_manager"] + 0)
        print d " | " wd " | " state " | " c " | " val[d SUBSEP "summary"] " | " val[d SUBSEP "projects"] " | " val[d SUBSEP "meetings"] " | " val[d SUBSEP "areas"] " | " val[d SUBSEP "topics"]
      }
    }'
  rm -f "$DAYS" "$STALE"
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
