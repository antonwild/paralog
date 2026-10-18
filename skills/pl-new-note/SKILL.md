---
name: pl-new-note
description: Create a new project, area, meeting or resource note in the Obsidian PARA vault from the vault templates, with a unique name and aliases. Use when the pl-daily or pl-prep skill needs a new note, or when the user asks to create, start or add a new project, meeting, area or resource note. Never a note about a person (rules section 6).
user-invocable: false
---

# New note

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`. Never create a note about a person: say no in one line and point to rules section 6.

## Step 1 — Decide type and name

| Type | Path | Template |
|---|---|---|
| project | `1_Projects/<Folder-Name>/<Name>.md` | `_system/templates/Project.md` |
| area | `2_Areas/<Name>.md` | `_system/templates/Area.md` |
| meeting (one project) | `1_Projects/<Folder-Name>/Meetings/<Name>.md` | `_system/templates/Meeting.md` |
| meeting (no project) | `2_Areas/Meetings/<Name>.md` | `_system/templates/Meeting.md` |
| resource | `3_Resources/<Name>.md` (no subfolders) | `_system/templates/Resource.md` — but first check rules section 7: most resources belong in an existing collection note |

If the type is not clear, use the folder table in the rules (has an end → project; a meeting → meeting; ongoing responsibility → area; something to look up → resource). For a meeting, find its project (rules section 1, Meetings); ask if unclear. If still unclear, ask with the interactive question tool (`AskUserQuestion` in Claude Code, see rules section 8).

Name: Title Case, no dates, no `/ \ : # ^ [ ] |`. One-off meetings: date at the end (`Vendor Workshop 2026-10-20`).

`<Folder-Name>` = the name with spaces replaced by dashes (`Project Phoenix` → `1_Projects/Project-Phoenix/Project Phoenix.md`). Folders never contain spaces.

## Step 2 — Check for duplicates

Search the **whole vault** (including `4_Archive`) for a note with the same name or a matching alias. If one exists, do not create a new one: tell the user and offer to use the existing note (or unarchive it).

## Step 3 — Create

1. Copy the template. Replace `{{title}}` with the name and `{{date:YYYY-MM-DD}}` with today's date.
2. Fill in what is known (goal, stakeholders, role, cadence, ...). Leave unknown fields empty. Never guess.
3. Add short names to `aliases` (e.g. `Project Phoenix` → `[Phoenix]`).
4. For a meeting: set `project: "[[Project Name]]"` (empty if none) and `cadence` (e.g. `daily`, `weekly`; empty for one-off). A one-off meeting that already happened gets `status: ended`.
5. With `tasks_plugin: on`: set `task_tag` (rules section 11).
6. If the note is created from a daily dump, add a first log entry: `- [[<date>]] — Created. <one line of context>`.

## Step 4 — Report

Tell the user the path of the new note.
