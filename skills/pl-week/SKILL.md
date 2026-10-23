---
name: pl-week
description: Draft the weekly update email for the manager from the Obsidian PARA vault — what got done, decisions, next week, what needs the manager, risks. First checks which days of the week have no notes yet. Use when the user runs /pl-week, or asks for a weekly update, weekly report, weekly status or "what did I do this week".
---

# Week — weekly update for the manager

A short email every Friday: the manager sees progress without asking, and the user builds a written record week by week.

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`.

## Step 1 — Window

Default: Monday of the current week to today. If today is Monday, the previous week (Monday–Friday). If the user names a week ("last week", "week 41"), use it. An entry is in the window when its leading `[[YYYY-MM-DD]]` falls inside it.

## Step 2 — Gaps first

Check the work days (Monday–Friday) of the window up to today:
- **No daily note**, or a daily note with an empty Brain Dump → the day is missing.
- A daily note with `processed: false` and a Brain Dump → not filed yet.

If there are gaps, ask once with the interactive question tool (rules section 8): `Fill in first (Recommended)` / `Write the update anyway`. On fill in: run the `pl-daily` skill for each day, oldest first (guided mode if the day has no dump), then continue here.

## Step 3 — Collect

1. **Done:** Milestones and Wins in `2_Areas/Career - Wins.md` inside the window. Then the Timeline entries of the active projects inside the window, and projects archived inside the window.
2. **Decisions** inside the window: project `Decisions`, meeting `Decisions`.
3. **Next week:** open tasks with a deadline in the 7 days after the window (rules section 2, rule 5, or section 11), and planned dates from the projects' `**Current:**` lines in that time.
4. **Needs your input:** every open task with `#for-manager` anywhere in the vault (any date).
5. **Risks:** blockers and delays named in the window.

## Step 4 — Write the draft

Follow the writing style (rules section 2a). For the manager: no `[[links]]`, no tags. 3–6 bullets under **Done**; leave out empty sections.

**Language** — like `pl-recap`: one language in `email_languages` → use it. Several → ask; recommend the language of the last weekly update, else the first in the list.

```markdown
**To:** my manager
**Subject:** Weekly update, week 41 (2026-10-05 to 2026-10-09)

Hi,

here is my week:

**Done**
- Invoice Automation is live. The first run processed 300 invoices automatically.
- Phoenix: data export for sales ready, one week ahead of plan.

**Decisions**
- Phoenix go-live phase 1: 2026-12-01.

**Next week**
- Phoenix: data mapping review with Sales Ops.

**Need your input**
- Budget for two extra Salesforce licenses.

**Risks**
- Old CRM contract ends 2026-12-31. Support moves later.

Best,
Alex
```

- Only facts from the vault. Use the impact as written. Do not inflate.
- Week number: ISO week. Sign with `my_name`. If it is empty, ask once and tell the user to add it to the config.
- **Internal items:** never put private notes or anything about colleagues beyond their work role into the email. If unsure about an item, ask: `Leave out (Recommended)` / `Include`.

## Step 5 — Save and show

1. Add the draft to today's daily note under `## Weekly Update` (create the heading at the end if missing), as `### Week 41 — draft`. If the heading already holds a draft, add the new one below it with a `---` line between them (rules section 2, rule 10).
2. Show the draft in chat, ready to copy.
3. Tell the user in one line which active projects had no entry for 14 days, if any. Not in the email.
4. When the user says it was sent (now or in a later dump), log it in the `manager_meeting_note` `## Log`: `- [[<date sent>]] — **Weekly update sent:** <subject>.` and change `— draft` to `— sent <date>`.

## Never

- Never send anything. The user copies the draft.
- Never write about a colleague's performance (rules section 6).
