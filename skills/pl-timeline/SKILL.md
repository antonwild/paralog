---
name: pl-timeline
description: Draw a timeline chart (Mermaid, timeline LR, no custom theme) of a project, area, meeting or topic from the dated entries in the Obsidian PARA vault, and save it in the note under ## Timeline Chart. Use when the user runs /pl-timeline, or asks for a timeline, a chart or diagram of the history, "show me how the project went", or a visual overview of dates and decisions.
---

# Timeline — chart of the dated entries

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`. The chart format is in rules section 10. Follow it exactly.

**Style:** write everything (notes, emails, replies in chat) in the writing style of rules section 2a, in every language: short sentences, common words, active voice.

## Step 1 — Target and window

**Target:** a project, area or meeting note, or a topic. Match the name against note names and `aliases`, including `4_Archive`. If unclear, ask with the interactive question tool (rules section 8).

**Never a person.** A timeline of a colleague's work is an evaluation of that person (rules section 6). Say no in one line and offer the timeline of a shared project instead.

**Window:** what the user says ("since August", "this year"). Default: everything.

## Step 2 — Collect

- **Project:** `## Timeline`, `## Decisions`, and the `Log` and `Decisions` of its `Meetings` notes. Milestones and Wins for the project from `2_Areas/Career - Wins.md`. Planned dates from the `**Current:**` line and Open Items, only if they have an exact date.
- **Area, meeting:** its `## Log` and `## Decisions`.
- **Topic:** entries anywhere in the vault that mention it (search like the `pl-evidence` skill, Step 2).

Keep only entries with a leading `[[YYYY-MM-DD]]` inside the window. The same event in two notes counts once.

## Step 3 — Draw

Build the chart as in rules section 10: `timeline LR`, no theme line, one `section` per month, max 10 dates, max 8 words per event.

## Step 4 — Save and show

1. **Project, area or meeting:** replace the `## Timeline Chart` section of the note (create it directly above `## Timeline` or `## Log`). Add the "Generated" line below the chart. Never write into `4_Archive` notes — show the chart in chat only and say why.
2. **Topic:** show it in chat only. Ask once with the interactive question tool whether to save it into one of the related notes.
3. Show the chart in chat, and in one line how many entries were left out (if any).
