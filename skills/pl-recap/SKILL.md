---
name: pl-recap
description: Draft a short follow-up email after a meeting, with the decisions, action items (owner, deadline) and open questions — taken from the daily brain dump and the vault. Sending it gets written confirmation from the others. Use when the user runs /pl-recap, or asks for meeting minutes, a follow-up, a summary email or a recap of a meeting.
---

# Recap — follow-up email after a meeting

A recap the others receive in writing is strong evidence: if nobody objects, the content is confirmed.

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`.

**Style:** write everything (notes, emails, replies in chat) in the writing style of rules section 2a, in every language: short sentences, common words, active voice.

## Step 1 — Find the meeting

Use the meeting the user names, from today's daily note unless a date is given. Read the Brain Dump, the **meeting note** (in `2_Areas/Meetings/` or the project's `Meetings/` folder) and the entries filed for that date (`[[YYYY-MM-DD]]`) in the related project notes. Include the tasks of that day for the meeting or its project (rules section 2, rule 5). Take the attendees from the meeting note's **Who** line.

If the day has several meetings and the user named none, ask which one with the interactive question tool (rules section 8).

## Step 2 — Check what is missing

A good recap needs, for each action item, an **owner** and a **deadline**. Collect what the vault does not say. Ask for it in **one** interactive question round (max 4 questions; options like `Me`, `Sarah Miller`, `Leave open`). Never guess an owner or a date.

**Internal items** — never put `#for-manager` items, personal notes or anything meant only for the user into the email without asking. If there are any, ask per item: `Leave out (Recommended)` / `Include`.

If `my_name` in the config is empty, ask for the name once and tell the user to add it to the config.

**Language** — take it from `email_languages` in the config. One language → use it, no question. Several → ask: the options are the configured languages; recommend the language of the last recap in this meeting note, else the first in the list. The user can always type another language.

## Step 3 — Write the draft

Follow the writing style (rules section 2a). Write for the attendees — no `[[links]]`, no internal tags.

```markdown
**To:** Sarah Miller, Tom Becker
**Subject:** Recap: CRM Migration kickoff, 2026-10-17

Hi all,

thanks for the meeting. Here is what we agreed:

**Updates** (only for status meetings, e.g. a standup)
- Data export for sales is ready.

**Decisions**
- Rollout in phases. Sales team first, because the data cleanup for support takes longer.
- Go-live phase 1: 2026-12-01.

**Action items**
- Alex: send the project plan to Sarah — by 2026-10-20.
- Tom: start the data cleanup for sales — by 2026-10-31.

**Open questions**
- Budget for two extra Salesforce licenses — I will clarify this with my manager.

Please reply if anything is missing or wrong.

Best,
Alex
```

- Only facts from the dump and the vault. Leave out empty sections.
- Sign with `my_name` from the config.
- Always end with the "reply if anything is wrong" line — that turns silence into confirmation.

## Step 4 — Save and show

1. Add the draft to the daily note under `## Recaps` (create the heading at the end if missing), as `### <Meeting> — draft`. If the heading already holds a recap, add the new one above it with a `---` line between them (rules section 2, rule 10: newest on top).
2. Show the draft in chat, ready to copy. End with one line `Next: …` if the vault shows a clear next step (rules section 13), e.g. "Next: `/pl-recap Vendor Workshop 2026-10-28` — also no recap yet."
3. When the user says it was sent (now or in a later dump), log it in the meeting note's `## Log`: `- [[<date sent>]] — **Recap sent** to Sarah Miller, Tom Becker: <subject>.` and change `— draft` to `— sent <date>`.
