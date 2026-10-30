---
name: pl-handover
description: Write a one-page handover for a project or area from the Obsidian PARA vault — status, next steps, open items, key decisions, contacts and where to find things. Use when the user runs /pl-handover, goes on vacation, leaves a project or the company, or asks for a handover, a deputy briefing or a "what you need to know" document.
---

# Handover — one page for whoever takes over

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`.

**Style:** write everything (notes, emails, replies in chat) in the writing style of rules section 2a, in every language: short sentences, common words, active voice.

## Step 1 — Scope

What to hand over: one project or area, or **all active projects** (e.g. for vacation). Match names against note names and `aliases`. If unclear, ask with the interactive question tool (rules section 8). Ask the reader's name only if the user wants the handover addressed to someone.

## Step 2 — Collect (per project or area)

From the note and the vault:
- **Goal** — from `## Overview` / `## Purpose`.
- **Status** — the `**Current:**` line and the last 3 Timeline entries.
- **Next steps and open items** — the open tasks of the note (rules section 2, rule 5), with owner and deadline if recorded.
- **Key decisions** — the 5 most important, with dates. Newest first. Include decisions from the `Meetings` notes.
- **Meetings** — the project's active meetings: name, cadence, who attends.
- **Who to ask** — per topic, the team from `3_Resources/Teams.md` that owns it, linked as `[[Teams]]`. Add a person only if the entries name them as the current owner of an open item. Topic first. Never guess a team: if no row fits, write the topic with "team unknown". Nothing else about people (rules section 6).
- **Where to find** — rows in `3_Resources/Where to Find.md`, `Commands` and `How-Tos` that mention the project.
- **Risks and open questions** — open `#for-manager` items, blockers, unclear points.

## Step 3 — Write

Follow the writing style (rules section 2a). One page per project at most. The reader does not know the project — no internal shorthand.

```markdown
## Handover: Project Phoenix — [[2026-10-17]]

**Goal:** Replace the old CRM for the sales team.
**Status:** Phase 1 go-live planned for 2026-12-01.

**Next steps**
- Send the project plan to Sarah Miller — by 2026-10-20.

**Key decisions**
- 2026-10-17 — Rollout in phases, sales team first.

**Who to ask** (see [[Teams]])
- Sales rollout — Sales Ops.
- Data cleanup — Data Platform; open task owned by Tom Becker.
- Vendor contract — team unknown.

**Meetings**
- [[Phoenix Weekly]] — weekly, with Sarah Miller and Tom Becker.

**Where to find**
- Customer master data: CRM export folder on the team drive.

**Risks / open questions**
- Budget for extra licenses not approved yet.
```

- Facts only. If something is not recorded, write `Not recorded` — never fill gaps.
- **Timeline:** add a timeline chart (rules section 10) of the key dates under a `**Timeline**` line, at the end of the handover. It renders in Obsidian; for an email, the user exports it as an image.
- For the reader outside the vault, links are fine in Obsidian; tell the user to remove `[[ ]]` if they paste it into an email.

## Step 4 — Save and show

1. Insert the handover into the project or area note under `## Handover`, **newest on top**, with a `---` line between it and the older handover (rules section 2, rule 10). Add the heading above `## Timeline` or `## Log` if missing.
2. Show it in chat, ready to copy. For several projects, show them one after another.
3. Add to the top of the Timeline/Log (newest first, rules section 2, rule 11): `- [[<today>]] — **Handover written.**`
