---
name: pl-check
description: Check the Obsidian PARA vault for problems — duplicate open tasks, broken links, missing properties, folder names with spaces, misplaced meetings, stale tasks and projects, personal data about colleagues, Tasks plugin setup — and offer to fix them. Use when the user runs /pl-check, or asks to check, clean up, lint or tidy the vault. A good habit once a week.
---

# Check — find problems in the vault

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`.

## Step 1 — Run the check script

Run `bash "<skills folder>/pl-setup/scripts/check.sh" "<vault>"` (the `pl-setup` skill sits next to this skill's folder). It is read-only and prints one line per problem: `<check> <file>: <problem>`. Exit code 0 means no problems.

| Script check | What it finds |
|---|---|
| `type` | Notes in the PARA folders without a `type` property. |
| `folders` | Folder names with spaces (rules section 4). |
| `links` | `[[links]]` to notes that do not exist. Date links are ignored. |
| `meetings` | Project meetings outside their project's `Meetings` folder (rules section 1). |
| `tasks` | Only with `tasks_plugin: on`: the checks in rules section 11, *Checks*. |

If the script is not there (another agent setup), do these checks by reading the vault.

## Step 2 — Judgment checks

These need reading, not a script (not in `4_Archive`):

1. **Duplicate open tasks** — the same task open in two notes.
2. **Stale items** — open tasks older than 30 days; active projects with no new entry for 30 days (suggest `/pl-archive`).
3. **Personal data** — opinions, private life, health or performance of a colleague, in any note; names or members in `Teams` (rules section 6). Fix: remove it with a correction entry; the old text stays in git history.

## Step 3 — Report and fix

Report **only problems found**, one line each, grouped by check, in plain words. If all is fine, say so in one line.

Offer to fix them with the interactive question tool (rules section 8): one question per group, e.g. `Fix all (Recommended)` / `Let me choose` / `Skip`. Stale items: only list them. Never fix anything without the user's answer. After fixing, run the script again and report what is left.

Fixes follow the writing rules: never edit a Brain Dump, never delete log entries. A fix in a log is a new correction entry (rules section 2, rule 2).
