# Agent Instructions

This is an Obsidian vault for documenting work: daily brain dumps, projects, meetings, decisions and wins, organized with the PARA method.

**Before writing anything, read `_system/rules.md` and `_system/config.md`.**

## Folders
- `0_Daily` — one note per day (Obsidian daily notes). `## Today` is the plan for the day, written by `pl-daily` the evening before (rules section 13). `## Brain Dump` is raw and never edited by agents. With `tasks_plugin: on`, `## Tasks` holds all task lines (rules section 11).
- `1_Projects` — one folder per project, work with an end. Project meetings in `<project>/Meetings/`.
- `2_Areas` — ongoing responsibilities, `Career - Wins`, `Career - Goals`. General meetings (no project) in `2_Areas/Meetings/`.
- `3_Resources` — reference material in a few collection notes (rules section 7). No notes about people.
- `4_Archive` — finished work, only via the `pl-archive` skill.
- `_system` — rules, config, templates.
- `Journal.base` — Obsidian Bases table of the daily notes and their properties (rules section 12). The user's file: agents do not write here.
- `Tasks.md` — only with `tasks_plugin: on`: the live list of all open tasks. Agents do not write here.

## Skills
- `pl-setup` — set up or update the vault (folders, rules, templates, config).
- `pl-daily` — process a brain dump into the vault. Without a dump, it interviews the user. At the end, it writes `## Today` into the next work day's note.
- `pl-check` — check the vault for problems (duplicate tasks, broken links, stale items) and offer fixes.
- `pl-new-note` — internal: creates a project, area, meeting or resource note. Used by `pl-daily`.
- `pl-archive` — archive or unarchive a project or area.
- `pl-prep` — prepare a meeting: asks first (manager 1:1, year-end review, half-year review, promotion case, other). Any meeting or project. Reviews show progress per goal.
- `pl-recap` — draft a follow-up email after a meeting: decisions, action items, open questions.
- `pl-week` — draft the weekly update email for the manager. Checks first which days have no notes.
- `pl-handover` — one-page handover of a project or area (vacation, leaving).
- `pl-timeline` — Mermaid timeline chart of a project, area, meeting or topic (rules section 10).
- `pl-evidence` — answer "what was decided / said, when, by whom" with dated sources, quotes and git commit times. Read-only.

## Most important rules
1. Never edit the Brain Dump. Logs are append-only.
2. Every entry starts with `[[YYYY-MM-DD]]` linking to its daily note.
3. Facts only — never invent names, dates or numbers. Ask when unsure.
4. **Your own work only.** No notes about people. Colleagues appear only as plain-text names inside work entries. Never count, rank or report on people. See rules section 6.
5. **Write as little as possible, in simple words, in every language.** Short sentences, common words, active voice, one fact per line. See rules section 2a.
6. **Daily properties:** a processed daily note gets the properties of rules section 12. Never a property about people.
7. **Tasks plugin optional:** if `tasks_plugin: on` in the config, tasks follow rules section 11.
8. **Ask with the interactive question tool** (`AskUserQuestion` in Claude Code), never in plain chat text. See rules section 8.
9. Git: Claude Code commits automatically (hook). Other agents commit after writing. Push only with `git_push: on`. See rules section 9.
