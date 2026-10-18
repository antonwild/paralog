---
name: pl-prep
description: Prepare a meeting from the Obsidian PARA vault — the 1:1 with the manager (wins, project updates, open #for-manager items), or any recurring meeting or project ("prep the steering committee"). Also writes half-year or year-end reviews. Without a target it first asks what to prepare. Use when the user runs /pl-prep, or asks to prepare a 1:1, a meeting, a manager update, a status summary or a performance review.
---

# Prep — meeting preparation

Build a short, factual prep the user can present. Every point comes from the vault and links to its source.

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`. Note `manager_meeting_note` and `prep_lookback_days`.

## Step 1 — Target, mode and time window

**Nothing given** (`/pl-prep` alone) → first ask what to prepare, with the interactive question tool (rules section 8):
- `Manager 1:1 (Recommended)` → manager, meeting mode.
- `Year-end review` → manager, review mode, the current calendar year.
- `Half-year review` → manager, review mode, the current half-year (January–June or July–December).
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

**Window:** what the user says ("last week"), else since the last `## Prep` in the target note, else the last `prep_lookback_days` days. An entry is in the window when its leading `[[YYYY-MM-DD]]` falls inside it.

## Step 2 — Collect

**Manager:**
1. **Milestones and Wins** in `2_Areas/Career - Wins.md` inside the window.
2. **Project progress:** each project's `**Current:**` line plus Timeline and Decisions entries inside the window. Also projects archived inside the window.
3. **Needs input:** every open task with `#for-manager` anywhere in the vault (any date). Also blockers in the window that need the manager's approval or help.
4. The open tasks of the meeting note (rules section 2, rule 5).

**Meeting or project:**
1. **Updates:** entries inside the window in the target note, or in the projects linked from it.
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

**Review mode** (manager only) — built on Milestones. Group Wins into 3–5 themes; never list single Wins.

```markdown
### Review 2026 — prepared [[2026-12-10]]

**Milestones**
- 2026-11-03 — Phase 1 of [[Project Phoenix]] live for 400 sales users. *My part:* led data migration and cutover.

**Timeline** — chart of the Milestones and completed projects (rules section 10), title `Review 2026`.

**Themes from smaller wins**
- Unblocking other teams — fixed 4 blocking bugs in 3 teams (e.g. [[2026-10-17]]).

**Projects completed**
- [[Project Phoenix]] — completed 2026-12-01.
```

Rules:
- Facts only. Use the impact written in the vault. Do not inflate it.
- **No checkboxes.** Plain bullets (`- `), never `- [ ]`. The task already lives in its own note (rules section 2).

## Step 4 — Save and show

1. Insert the prep into the target note under `## Prep`, **newest on top**. If the note has no `## Prep`, add it above `## Log` or `## Timeline`. If the manager meeting note does not exist, create it with the `pl-new-note` skill (meeting, no project).
2. Show the prep in chat.
3. Remind the user in one line: dictate the answers in the next daily dump, and `/pl-daily` closes the resolved items.
