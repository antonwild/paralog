---
name: pl-evidence
description: Answer "what was decided / said / done, when and by whom?" from the Obsidian PARA vault, with dated sources, verbatim quotes from the daily brain dumps and git commit times that show when each note was written. Read-only. Use when the user runs /pl-evidence, needs facts or proof for a discussion, asks "what did we decide about…", "when did…", "who said…", "did I ever tell…", or wants a timeline of a topic.
---

# Evidence — facts with sources

Find everything the vault knows about a question and present it so it is easy to check: **dated, sourced, quoted, timestamped**. This skill is **read-only** — never change, fix or add anything in the vault.

## Step 0 — Load the rules

Read `_system/rules.md` and `_system/config.md`.

## Step 1 — Understand the question

Work out the **topic** (project, decision, thing), the **time range** if given ("last month", "since the kickoff"), and the **kind of answer** (a decision, who said what, when something happened, whether something was communicated).

**About a decision, not a person.** Questions about a specific decision, agreement or event are fine, also "who said X?". A question about a person's work or behaviour in general ("what did Max do this year?", "how often was Max late?") is an evaluation: say no in one line (rules section 6).

If the question is too vague to search (e.g. "that thing from last week"), ask with the interactive question tool (`AskUserQuestion` in Claude Code, rules section 8), offering the most likely topics as options.

## Step 2 — Search wide

1. **Names:** resolve projects and meetings through note names and `aliases`. Search people's names as plain text, with spelling variants ("Sarah", "Sara", "Sarah Miller").
2. **Keywords:** search with several words for the topic, including synonyms and translations into the languages the user dictates in (look at the Brain Dumps): e.g. "share / teilen / hand over / give the code".
3. **Where to search — everything, including `4_Archive`:**
   - `## Brain Dump` sections of daily notes — the **primary source**, the user's own words on that day.
   - `Timeline`, `Log`, `Decisions`, `Open Items` in projects, areas and meetings (`Meetings` folders).
   - `2_Areas/Career - Wins.md`, `2_Areas/Career - Goals.md` and the 1:1 notes (`## Prep`).
   - With `tasks_plugin: on`: also as in rules section 11.
4. Keep every hit with its file and date (the `[[YYYY-MM-DD]]` at the start of the entry).

## Step 3 — Get the git timestamp

For each source daily note, find when it was first committed — this shows *when it was written down*:

```bash
git log --diff-filter=A --format="%h %ad" --date=format:"%Y-%m-%d %H:%M" -- "0_Daily/2026-10-17.md"
```

For a specific line, find the commit that added it (oldest result = last line):

```bash
git log -S "extra licenses" --format="%h %ad" --date=format:"%Y-%m-%d %H:%M" -- "<file>"
```

Check whether that commit was pushed: `git branch -r --contains <hash>` (shows e.g. `origin/main` if pushed). If the vault is not a git repo, or a file is not committed yet, say so — do not skip it silently.

A commit time comes from the user's computer clock (rules section 9). Present it as "written down", never as proof.

## Step 4 — Answer

Reply in chat, in `note_language`, in this shape:

```markdown
**Answer:** Not decided yet. On 2026-10-15 you noted that the extra license budget
needs your manager's approval. There is no later entry.

**Evidence** (oldest first)
1. **2026-10-15** — Open question: budget for two extra licenses. Flagged #for-manager.
   - Your words: "I need to ask my manager if we can get budget for two extra licenses." ([[2026-10-15]])
   - Filed in: [[Project Phoenix]] → Open Items
   - Written down: 2026-10-15 18:02, commit `a1b2c3d`, pushed ✅

**Not found**
- No record that the question was raised with the manager yet.
```

Rules:
- **Quotes are verbatim**, copied exactly from the Brain Dump, in the original language. If that is not `note_language`, add a translation in brackets.
- **Only what the vault says.** Never fill gaps with assumptions. If something is not recorded, list it under **Not found** — that is a valid and important answer.
- **Contradictions:** if entries disagree (e.g. two different go-live dates), show both with their dates. Never pick one silently.
- **Who:** name the people exactly as the entry does. "We decided" stays "we" — do not guess who "we" was.
- Separate **facts** (what was recorded) from **open/unclear** points.
- Oldest first, so the answer reads as a timeline.
- **Timeline chart:** if the evidence has at least 3 dates, add a chart (rules section 10) after **Evidence**. In chat only — this skill never writes.

## Step 5 — Offer next steps

If useful, offer (with the interactive question tool) to: search a wider time range or related topics, or run `/pl-prep` if open `#for-manager` items came up. Do not write anything to the vault.
