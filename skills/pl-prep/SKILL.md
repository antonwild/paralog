---
name: pl-prep
description: Prepare a meeting from the Obsidian PARA vault — the 1:1 with the manager (wins, project updates, open #for-manager items), or any recurring meeting or project ("prep the steering committee"). Also writes half-year or year-end reviews by goal, and a promotion case. Without a target it first asks what to prepare. Use when the user runs /pl-prep, or asks to prepare a 1:1, a meeting, a manager update, a status summary a performance review or a promotion case.
---

# Prep — meeting preparation

Build a short, factual prep the user can present. Every point comes from the vault and links to its source.

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`. Note `manager_meeting_note` and `prep_lookback_days`.

**Style:** write everything (notes, emails, replies in chat) in the writing style of rules section 2a, in every language: short sentences, common words, active voice.

## Step 1 — Target, mode and time window

**Nothing given** (`/pl-prep` alone) → first ask what to prepare, with the interactive question tool (rules section 8):
- `Manager 1:1 (Recommended)` → manager, meeting mode.
- `Year-end review` → manager, review mode, the current calendar year.
- `Half-year review` → manager, review mode, the current half-year (January–June or July–December).
- `Promotion case` → manager, promotion mode, the last 12 months.
- The user can type anything else (a meeting or project) as the free answer.

If a target or a review is given (`/pl-prep Phoenix Weekly`, `/pl-prep year-end review`), do not ask; start right away.

**Target** — who or what the meeting is with:
- "manager" / "1:1" → the **manager** (`manager_meeting_note`).
- A meeting → its **meeting** note, in `2_Areas/Meetings/` or in a project's `Meetings/` folder (e.g. `[[Daily Standup]]`).
- A person → not a target. Say in one line that paralog prepares meetings and projects, not people, and ask which meeting or project the call is about (rules section 6).
- A project → its **project** note.

Match the name against note names and `aliases`. If unclear, ask with the interactive question tool (rules section 8).

**Mode:**
- **Meeting mode** (default).
- **Review mode** — only for the manager: the user asks for a review, half-year, year-end or performance summary, or the window is longer than 60 days. Default window: the current calendar year (half-year review: the current half-year).
- **Promotion mode** — only for the manager: the user asks for a promotion case. Default window: the last 12 months. Needs `## Next level` in `2_Areas/Career - Goals.md` (rules section 3b). If it is empty, ask the user to paste their company's expectations for the target level there, one line each, and stop.

**Window:** what the user says ("last week"), else since the last `## Prep` in the target note, else the last `prep_lookback_days` days. An entry is in the window when its leading `[[YYYY-MM-DD]]` falls inside it.

## Step 2 — Collect

**Day lines first:** run `bash "<skills folder>/pl-setup/scripts/props.sh" "<vault>" --days <window start> <today>` (the `pl-setup` skill sits next to this skill's folder). It prints one line per day: counts, links and topics (rules section 12, *Using the properties*). Use it to pick the notes and entries to read below. Take the content from the entries, never from `summary` or `topics`. For a `stale` day, read its daily note and search the vault for its date link. If days are `todo`, say in one line that they are not filed yet and suggest `/pl-daily`.

**Manager:**
1. **Milestones and Wins** in `2_Areas/Career - Wins.md` inside the window (the days with `wins` or `milestones` above 0).
2. **Project progress:** each active project's `**Current:**` line. Timeline and Decisions entries inside the window for the projects in the day lines' `projects`, including projects archived inside the window.
3. **Needs input:** every open task with `#for-manager` anywhere in the vault (any date). Also blockers in the window that need the manager's approval or help.
4. The open tasks of the meeting note (rules section 2, rule 5).
5. Review and promotion mode: the goals of the window's year(s) in `2_Areas/Career - Goals.md`, with their status, and which Milestones and Wins link to each (`*Goal:*`).

**Meeting or project:**
1. **Updates:** entries inside the window in the target note, or in the projects linked from it. The days whose `projects` or `meetings` name the target show where they are.
2. **Open items:** the open tasks of the target note (rules section 2, rule 5), and open tasks anywhere that link to the target.
3. **Decisions** inside the window that concern the target.
4. For a project: also the Log and Decisions of its `Meetings` notes. For a project meeting: also its project's `**Current:**` line.

## Step 3 — Write the prep

Follow the writing style (rules section 2a). One line per point. Leave out empty sections.

**Meeting mode:**

```markdown
### [[2026-10-17]] — covering 2026-10-03 to 2026-10-17

**Highlights**
- Fixed the export bug that blocked 3 teams. Release went out on time. ([[2026-10-09]], [[Project Phoenix]])

**Updates**
- [[Project Phoenix]] — on track. Go-live moved to 2026-11-03 (vendor delay).

**Need your input**
- Approval for extra license budget #for-manager ([[2026-10-15]])

**Heads-up**
- Risk: vendor contract renewal still open. ([[2026-10-14]])
```

For the manager: list every Milestone first, then the **3–5 strongest Wins**. Not every Win.
For others: **Highlights** only if there is real progress to show.

**Review mode** (manager only) — built on Milestones and goals. With goals: one block per goal, then the rest as themes. Without goals: 3–5 themes. Never list single Wins. To find themes, start from the `topics` of the days with Wins. Name each theme from the Wins themselves.

```markdown
### Review 2026 — prepared [[2026-12-10]]

**Milestones**
- 2026-11-03 — Phase 1 of [[Project Phoenix]] live for 400 sales users. *My part:* led data migration and cutover.

**Timeline** — chart of the Milestones and completed projects (rules section 10), title `Review 2026`.

**Progress by goal**
- **Replace the old CRM** (active) — Phase 1 live 2026-11-03 (Milestone). 3 Wins, e.g. data mapping for 42 fields ([[2026-10-05]]).
- **Grow as a project lead** (active) — 1 Win: positive feedback from my manager ([[2026-10-06]]).
- **Reduce support tickets** (active) — no recorded progress.

**Other wins, by theme**
- Unblocking other teams — fixed 4 blocking bugs in 3 teams (e.g. [[2026-10-17]]).

**Projects completed**
- [[Project Phoenix]] — completed 2026-12-01.
```

- A goal with no linked entries says `no recorded progress`. Never hide it and never fill it with unlinked Wins.

**Promotion mode** (manager only) — one block per line of `## Next level`, with the strongest evidence first (Milestones, then Wins), each with its date link. Then **Gaps**: expectations with no evidence in the window. Facts only: an expectation is met only by entries that clearly show it.

```markdown
### Promotion case — prepared [[2026-12-10]], covering 2025-12-10 to 2026-12-10

**Leads projects across several teams**
- 2026-11-03 — Milestone: Phase 1 of [[Project Phoenix]] live. Sales Ops, Data Platform and IT Security involved.

**Shows measurable business impact**
- 2026-10-09 — Milestone: [[Invoice Automation]] live. Finance saves about 2 days per month-end close.

**Gaps**
- Mentors other project leads — no entries yet.
```

Rules:
- Facts only. Use the impact written in the vault. Do not inflate it.
- **No checkboxes.** Plain bullets (`- `), never `- [ ]`. The task already lives in its own note (rules section 2).

## Step 4 — Save and show

1. Insert the prep (also a review or promotion case) into the target note under `## Prep`, **newest on top**, with a `---` line between it and the older prep (rules section 2, rule 10). If the note has no `## Prep`, add it above `## Log` or `## Timeline`. If the manager meeting note does not exist, create it with the `pl-new-note` skill (meeting, no project).
2. Show the prep in chat.
3. Remind the user in one line: dictate the answers in the next daily dump, and `/pl-daily` closes the resolved items.
4. End with one line `Next: …` if the vault shows a clear next step (rules section 13), e.g. "Next: `/pl-recap Phoenix Weekly` after the meeting."
