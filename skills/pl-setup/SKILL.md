---
name: pl-setup
description: Set up a new paralog vault (PARA folders, rules, templates, config, Obsidian settings, git), create the demo vault, or update an existing one after paralog was updated. Asks the setup questions (name, languages, Tasks plugin, git). Use when the user runs /pl-setup or /pl-setup demo, wants to try paralog with sample data, installs paralog, wants to set up or update the vault, change the Tasks plugin setting, or is told that paralog was updated.
---

# Setup — create or update the vault

The vault is the folder the agent was opened in (the working directory). This skill's folder holds `scripts/scaffold.sh` and the vault files in `assets/`. In Claude Code, the skill folder is the "Base directory" shown when the skill loads.

Ask every question with the interactive question tool (`AskUserQuestion` in Claude Code), never in plain chat text. Recommended option first. For free-text answers (name), offer `Skip for now` and let the user type the value as the free answer. Follow the writing style: short, simple English.

## Step 1 — New, demo or update?

- The user asks for the **demo** (`/pl-setup demo`, "try it with sample data") → go to *Demo* below.
- `_system/rules.md` exists → **update**, go to Step 5.
- Else → **new vault**, go to Step 2.
- If the folder has notes but no `_system/rules.md`: say that paralog adds folders and files but never overwrites notes. Ask `Set up here (Recommended)` / `Stop`.

## Step 2 — Setup questions (new vault)

Ask in one round (one call, max 4 questions):
1. Your name (signs recap emails).
2. Language of your notes — `English (Recommended)`, `German`, other as free answer.
3. Languages of your emails — `Same as notes (Recommended)`, `English and German`, other as free answer. The first one is the default.
4. Do you use Obsidian with the Tasks plugin? — options `No`: "Tasks stay as plain checkbox lists in the notes. Works in every editor." / `Yes`: "Obsidian only. Tasks live in the daily notes with tags and dates; notes and `Tasks.md` show live task lists. Needs the Tasks community plugin. Other editors show these lists as code blocks." No general recommendation: if `.obsidian/plugins/obsidian-tasks-plugin/` exists, put `Yes (Recommended)` first; otherwise put `No` first without a recommendation.

## Step 3 — Build the vault

1. Run `bash "<skill folder>/scripts/scaffold.sh" "<vault>"`. Add `--tasks` if the user uses the Tasks plugin.
2. Write the answers into the frontmatter of `_system/config.md` with the file edit tool: `my_name`, `note_language`, `email_languages` (a list, e.g. `[English, German]`), `tasks_plugin: on|off`. Leave skipped values as they are.

## Step 4 — Git (new vault)

paralog uses git commits to show when a note was written (`/pl-evidence`).
1. If the vault is not a git repository, ask: `Make it a git repository (Recommended)` / `No git`. On yes: `git init`, then `git add -A && git commit -m "<YYYY-MM-DD HH:MM> | paralog setup"`.
2. Pushing: off by default (`git_push: off`). Ask only if the repository has a remote: `Commit only on this computer (Recommended)` / `Push every commit`. In the description of the push option write: "Only use a remote your company allows for work notes." On push, set `git_push: on`.
3. Without git, say in one line that `/pl-evidence` then has no commit times.

Go to Step 6.

## Demo

The demo vault holds three weeks of made-up work (`assets/demo/README.md`). It needs an empty folder.

1. Run `bash "<skill folder>/scripts/scaffold.sh" "<vault>" --demo`. If it says the folder is not empty, tell the user to make a new empty folder, open the agent there and run `/pl-setup demo` again. Stop.
2. Make it a git repository without asking (it is sample data, so `/pl-evidence` has commit times): `git init`, then `git add -A && git commit -m "<YYYY-MM-DD HH:MM> | paralog demo"`. Never add a remote.
3. Report in a few lines: the demo is ready; open the folder in Obsidian (*Open folder as vault*) and start with `README.md`, which lists the commands to try. The demo's "today" is 2026-10-16. Stop here — skip Steps 2–6.

## Step 5 — Update (existing vault)

1. Run `bash "<skill folder>/scripts/scaffold.sh" "<vault>" --check`.
2. Nothing listed (or only `warn` lines) → say "The vault is up to date." and go to Step 6.
3. Show the list in short form: files that changed (`differs`), files that are new (`missing`), new settings (`newkey`). For changed `_system/rules.md`, read both versions and say in 1–3 lines what changed.
4. Ask: `Update (Recommended)` / `Skip`. In the description write: "Framework files are replaced. Your notes and settings stay. Old versions stay in git history." If the vault has no git, say instead that old versions are lost, and recommend `Skip` for templates the user changed.
5. On update: run the script with `--update`. New config keys are added with their default value; tell the user each new key in one line with what it does.
6. **Daily properties (new in 0.2.0):** if `bash "<skill folder>/scripts/check.sh" "<vault>"` prints lines with `has no properties yet`, say in one line: "Your older daily notes have no properties yet. Run `/pl-check` to fill them in, then open `Journal.base` in Obsidian."
7. **Tasks plugin switched:** if the user changed `tasks_plugin` in the config since the last update, the update brings the matching templates. Notes still exactly as paralog created them (e.g. a new `1on1 Manager`) switch too. Notes with your content keep their old `## Open Items`. Suggest `/pl-check` to bring them in line.

## Step 6 — Report

1. Show the `warn` lines of the script in plain words (Obsidian settings, plugins). Each one is a step for the user in Obsidian. Skip them if the user does not use Obsidian.
2. Tell the user in a few lines what was created or updated.
3. New vault, next steps:
   - Open the folder in Obsidian (*Open folder as vault*, recommended: links, Tasks plugin) or in any Markdown editor. Restart Obsidian if it was open.
   - Optional: install the **Calendar** community plugin to click a day and open its daily note.
   - Open today's daily note, dictate the day under `## Brain Dump`, then run `/pl-daily`.
   - All settings are in `_system/config.md`.

## Never

- Never overwrite a note, the config or `Tasks.md`. Only the script writes framework files.
- Never turn on `git_push` without the user's answer.
