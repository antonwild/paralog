---
name: pl-daily
description: Process a daily brain dump (often a voice dictation transcript, in any language) into the Obsidian PARA vault. Saves the raw text to the daily note, then files events, decisions, wins, tasks and resources into the right project, area and resource notes with [[links]]. Use when the user runs /pl-daily, pastes a transcript of their day, or asks to process or sort today's (or another day's) notes.
---

# Daily — brain dump to PARA

Turn a messy brain dump into dated, linked entries in the right notes. Work from the vault root.

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md` first. Follow them exactly. They define folders, entry formats, naming and the people policy (section 6).

**Version check:** compare `paralog_version` in `_system/rules.md` with the same line in `../pl-setup/assets/vault/_system/rules.md` (next to this skill's folder). If the skill's version is newer, tell the user in one line at the end: "paralog was updated — run `/pl-setup` to update the vault." Skip this if the file is not there.

## Step 1 — Find the daily note

1. **Date:** use the date the user gives ("yesterday", "2026-10-15"); otherwise today.
2. **Location:** read `.obsidian/daily-notes.json`. Use its `folder` and `format` (moment.js format, default `YYYY-MM-DD`). If the file is missing, use `0_Daily/YYYY-MM-DD.md`.
3. If the note does not exist, create it from `_system/templates/Daily.md` and fill in the `{{date:...}}` placeholders yourself (moment.js formats; text in `[ ]` is literal, so `{{date:[tasks]}}` becomes `tasks`). Leave `{{query.…}}` placeholders as they are — the Tasks plugin fills them.
4. **If the user pasted the transcript in chat:** append it to `## Brain Dump` **exactly as given** (no corrections). If the Brain Dump already has content, first add a line `**Added HH:MM**` and then the new text.
5. If the Brain Dump is empty and nothing was pasted, ask the user for the dump and stop. (With `tasks_plugin: on`: hand-written tasks under `## Tasks` count as input too.)

## Step 2 — Know what exists

List every note in `1_Projects` (including each project's `Meetings`), `2_Areas` (including `Meetings`), `3_Resources` with its name and `aliases`, plus the team names in `3_Resources/Teams.md`. This is your match list. Do not look in `4_Archive` unless the dump clearly refers to archived work.

## Step 3 — Extract

Read the whole Brain Dump. The dictation may be in any language or mixed, and may have filler words, false starts and misheard names. Pull out every item and classify it (formats in rules section 3):

- **Meeting** — a meeting took place or was scheduled. Every meeting has its own note (rules section 1, Meetings): match an existing one, or propose a new one.
- **Event** — something else happened (progress, problem, conversation).
- **Decision** — something agreed or decided.
- **Win** — something the user achieved or contributed to.
- **Milestone** — a big, rare achievement (go-live, project done, impact beyond the team). Use rules section 3a; when in doubt it is a Win.
- **Task** — something still to do. Mark with `#for-manager` if it needs the manager. With `tasks_plugin: on`, also note the due date, scheduled date and priority if the dump says them (rules section 11).
- **Resolved task** — the dump answers an existing open task (e.g. "my manager approved the budget").
- **Resource** — a term, link, location, rule, command or how-to the user wants to keep. Also a lasting fact about a team ("Procurement approves vendor contracts") → a row in `Teams`. Goes into one of the collection notes from rules section 7 — as a table row or code block, no date.
- **Names** — people involved go into the entries as plain text, never as links (rules section 6). Never create a note about a person.

With `tasks_plugin: on`, also read the task lines under `## Tasks` that the user typed by hand. They are tasks of this day.

Assign each item to one or more target notes (a decision about Project X with Sarah goes to the project's Decisions, with *Who:* Sarah Miller). Items that fit nowhere stay only in the daily Summary.

## Step 4 — Avoid duplicates

The user may run `/pl-daily` several times a day. Before writing, search the target notes for `[[<this date>]]`. Do not add an item that is already filed for this date. With `tasks_plugin: on`, also check the daily note's `## Tasks`.

## Step 5 — Ask before creating (one question, batched)

For each new note needed whose type is in `ask_before_creating` (config), for each uncertain match ("the vendor thing" → `Vendor Migration`?), for each name you cannot spell for sure ("Sara" or "Sarah"?), and for each item that might be a Milestone but is not clearly one, collect a proposal. Ask **once**, as one list, for example:

> I want to create:
> 1. Project **Vendor Migration** — from "we kicked off the vendor switch"
> Is "the vendor thing" the same as [[Vendor Migration]]?
> Is "Sara" spelled "Sarah", as in earlier entries?
> Log "first invoice processed by the new tool" as a **Milestone** or a **Win**?

**Ask with the interactive question tool (`AskUserQuestion` in Claude Code), never in plain chat text** — see rules section 8: one question per proposal, max 4 per call, recommended option first. Only agents without such a tool ask in plain text and wait. If the user declines a note, keep the item in the daily Summary only.

## Step 6 — Write

1. Create the approved notes with the `pl-new-note` skill's rules (templates in `_system/templates`, unique names, aliases).
2. Append each item to its target note under the right heading (`Timeline`/`Log`, `Decisions`, `Open Items`, `Wins`), in the formats from the rules. Wins go to `2_Areas/Career - Wins.md` → `## Wins`; milestones go to `## Milestones` in the same note. Each item is either a Win or a Milestone, never both. Also add a Timeline entry in the related project.
   Meeting items go to the meeting note's `## Log` (one entry per occurrence), its `Decisions` and `Open Items`. Important results (decisions, milestones) also get one line in the project `Timeline`.
   **Tasks:** as in rules section 2, rule 5. With `tasks_plugin: on`, follow the table *What skills do with tasks* in rules section 11 (new tasks and hand-typed tasks).
3. If the user says an earlier win was bigger than logged ("that was actually a big deal"), promote it as described in rules section 3a.
4. Tick resolved tasks (`- [x] … → result ([[date]])`, rules section 2, rule 7). With `tasks_plugin: on`, use rules section 11.
5. Update a project's `**Current:**` status line only if the dump clearly changes the status.
6. Add confirmed misspellings of a note name to that note's `aliases`.

## Step 7 — Fill the daily Summary

Under `## Summary` in the daily note write (replace the placeholder comment; on a re-run, append to the existing Summary):

```markdown
**In short:** 1–2 short sentences about the day.

**Filed**
- [[Project Phoenix]] — go-live decision, 1 task
- [[1on1 Manager]] — budget question #for-manager
- [[Career - Wins]] — Win: export bug fix

**Not filed / unclear**
- "the thing with the Q3 numbers" — no matching project, unclear what it refers to
```

Then set `processed: true` in the daily note's frontmatter.

## Step 8 — Report

Tell the user in a few lines: what was filed where, what was created, what stayed unclear. Do not repeat the whole dump.

## Never

- Never edit the Brain Dump text.
- Never invent facts, names, dates or impact to fill gaps.
- Never delete or rewrite old log entries.
- Never write to `4_Archive` (ask the user whether to unarchive instead).
