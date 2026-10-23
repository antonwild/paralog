---
name: pl-archive
description: Archive a finished or inactive project or area in the Obsidian PARA vault, or bring an archived one back. Writes a closing summary, sets the status and moves it to 4_Archive without breaking links. Use when the user says a project ended, is done or cancelled, a meeting series stopped, or asks to archive, close, clean up or unarchive something.
---

# Archive

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`.

## Step 1 — Find the target

Match the user's words against note names and `aliases` in `1_Projects`, `2_Areas` (incl. `Meetings`) and `3_Resources`. If more than one note could match, or none, ask. Never archive `Career - Wins`, `Career - Goals`, `_system` or daily notes.

**A project meeting** is not archived alone: set `status: ended` in the meeting note, append `- [[<today>]] — Series ended.` to its Log, and stop. It moves with its project later.

## Step 2 — Check and confirm

Ask every question below with the interactive question tool (`AskUserQuestion` in Claude Code), never in plain chat text — see rules section 8.

1. List the open tasks of the note (rules section 2, rule 5). If there are any, ask the user what to do with each group: **keep** (archive anyway), **close** (tick as `- [x] … → dropped at archive ([[today]])`; with `tasks_plugin: on` as in rules section 11), or **move** to another note.
2. Confirm in one line: "Archive **Project Phoenix** (status: completed)? It moves to `4_Archive/`." Status is `completed`, `cancelled` or `inactive` — ask if not clear.

## Step 3 — Close it

1. Add a `## Closing Summary` section directly under the `# Title`, written only from facts in the note:
   ```markdown
   ## Closing Summary
   - **Archived:** [[2026-10-17]] — completed
   - **Outcome:** What was achieved (or why it stopped).
   - **Key decisions:** The 2–4 most important, with their dates.
   - **My contributions:** Linked from [[Career - Wins]] where they exist.
   ```
2. In the frontmatter set `status: <completed|cancelled|inactive>` and `archived: <today>`.
3. Append to the Timeline/Log: `- [[<today>]] — **Archived** (<status>).`
4. Write or replace the `## Timeline Chart` section (rules section 10), with the archive date as the last event. The chart shows the whole history at a glance.
5. Move it: a project's whole folder `1_Projects/<Folder-Name>/` → `4_Archive/<Folder-Name>/`; its `Meetings` folder moves with it. Set `status: ended` in its meeting notes. An area, resource or general meeting file → `4_Archive/<Name>.md`. Keep the name exactly the same, so all `[[links]]` still work.
6. Add a line to today's daily note Summary: `- Archived [[<Name>]]`.
7. If the status is `completed` and `Career - Wins` has no Milestone for this project yet, ask the user if they want one (e.g. "Project Phoenix completed — log as a Milestone?"). Write it only from facts in the note.

## Unarchive

If the user wants it back: move it to its original folder (project → `1_Projects/<Folder-Name>/`, area → `2_Areas/`, general meeting → `2_Areas/Meetings/`), set `status: active`, remove `archived`, keep the Closing Summary, and append `- [[<today>]] — Reactivated.`

## Report

Tell the user what moved where and what happened to the open tasks.
