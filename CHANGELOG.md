# Changelog

The version is `paralog_version` in `skills/pl-setup/assets/vault/_system/rules.md`.
Bump it when a release changes framework files (rules, templates, AGENTS.md, hook), so `/pl-daily` tells users to run `/pl-setup`.

## 0.3.0 — 2026-10-30

- **`## Today` in the daily note:** at the end of each run, `/pl-daily` writes a short plan into the next work day's note: meetings to prepare, recaps and drafts to send, tasks due, and the next commands to run (rules section 13). Read it in the morning. No new command. The section is a generated view: the next run replaces it. Plain bullets only, no checkboxes, never grouped by person.
- **`next` property for meetings:** the date of the next occurrence. `/pl-daily` sets it from the dump ("steering committee next Tuesday") or from a fixed `cadence`. Never guessed (rules section 1, Meetings). Guided mode asks one more question: the meetings of the next work day.
- **`Next:` line:** `/pl-prep`, `/pl-recap` and `/pl-week` end their report with one suggested next step when the vault shows one.
- **Newest first:** `Timeline`, `Log`, `Decisions`, `Wins`, `Milestones`, goal lines and blocks (`Prep`, `Recaps`, `Weekly Update`, a re-run `Summary`) put the newest entry on top, like a CV. Month headings too: the newest month first (rules section 2, rules 2, 10 and 11). The timeline chart still reads oldest first, from left to right.
- **One entry per date:** in `Timeline` and `Log`, all items of one date share one entry: the date line, then one bullet per item. **Created** stays a line of its own (rules section 3).
- **`/pl-check` sorts old logs:** the new check `order` (script `pl-setup/scripts/order.sh`) finds sections with the oldest entry on top. The fix sorts them and only moves lines. Older entries of one date stay separate.
- **Writing style for every language:** rules section 2a now applies to notes, emails and chat in every language, not only English. New rules from Simplified Technical English (ASD-STE100): verbs instead of nouns, keep the certainty of the source, no semicolons, no long noun chains, lists for 3 or more steps. Every skill points to it in Step 0.
- Run `/pl-setup` to update the rules and templates, then `/pl-check` to sort your logs newest first. Existing daily notes and meetings get `## Today` and `next` when `/pl-daily` needs them.

## 0.2.0 — 2026-10-24

- **Daily properties:** `/pl-daily` writes properties into each processed daily note: `summary`, `projects`, `meetings`, `areas`, `topics` and the counts `decisions`, `wins`, `milestones`, `for_manager` (rules section 12). Links and counts are derived from the vault by `pl-setup/scripts/props.sh`. Topics are reused before new ones are added. `summary` never names people.
- **`Journal.base`:** an Obsidian Bases table of the daily notes, with views for all days, the last 14 days, decisions and wins, items for the manager, and days not processed yet. Your file: created once, never overwritten. Needs Obsidian 1.9 or newer.
- **`/pl-check`:** new checks `props` (missing properties, or links and counts that differ from the vault) and `people` (a property that lists people, in any note). The `props` fix also fills older daily notes after the update.
- **Skills use the properties:** `props.sh --days FROM TO` prints one line per day (state, counts, summary, links, topics). `/pl-week`, `/pl-prep` and `/pl-evidence` read it first and open only the notes it points to. The content still comes from the entries, never from `summary` or `topics`. Days with missing or wrong properties are read in full (rules section 12, *Using the properties*).
- **Decisions** go into exactly one `## Decisions` section (rules section 3).
- Run `/pl-setup` to update the rules and get `Journal.base`, then `/pl-check` to fill in older daily notes. The body of your notes does not change.

## 0.1.1 — 2026-10-23

- **Dividers between blocks:** sections with several `###` blocks (`## Prep`, `## Handover`, `## Recaps`, `## Weekly Update`, and a re-run `## Summary`) now separate the blocks with a `---` line (rules section 2, rule 10). `pl-prep`, `pl-handover`, `pl-recap`, `pl-week` and `pl-daily` follow it. Plain Markdown, no Obsidian setup needed. Run `/pl-setup` to update the rules.
- **Month headings:** `Timeline`, `Log`, `Decisions` and `Wins` group entries under `### YYYY-MM` (rules section 2, rule 11). Foldable in Obsidian, listed in the outline.
- **Type word:** log entries such as **1:1**, **Meeting**, **Kickoff**, **Created**, **Recap sent**, **Weekly update sent**, **Handover written** and **Archived** start with their type in bold (rules section 3).
- **Several facts, several lines:** a log entry with more than one fact gets one nested bullet per fact (rules section 3).
- Existing notes are not rewritten. Older entries get their month heading when the next entry of a new month is added.

## 0.1.0 — 2026-10-18

First release.

- **Skills:** `pl-setup`, `pl-daily`, `pl-prep`, `pl-recap`, `pl-week`, `pl-evidence`, `pl-handover`, `pl-timeline`, `pl-archive`, `pl-check`, and the internal `pl-new-note`.
- **Install** with `npx skills add antonwild/paralog`, or `install.sh` from a clone. `/pl-setup` builds and updates the vault.
- **Vault checks** as code (`pl-setup/scripts/check.sh`), used by `/pl-check`.
- **Optional Tasks plugin** integration (rules section 11).
- **Git:** auto-commit hook for Claude Code; push is opt-in (`git_push`).
- **Your own work:** entries are about your projects, meetings, decisions and wins. A `Teams` note records what each team owns and what to ask them about.
- **Demo vault:** `/pl-setup demo` in an empty folder creates three weeks of a made-up project manager's work, with two open days to try `/pl-daily`.
- **Guided daily mode:** without a dump, `/pl-daily` asks a few short questions.
- **Goals:** `Career - Goals` (rules section 3b). Wins link to goals; reviews show the progress per goal; `/pl-prep promotion` builds a promotion case.
