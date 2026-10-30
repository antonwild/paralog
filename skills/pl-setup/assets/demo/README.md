# Demo vault

Three weeks of work of **Alex Rivera**, a project manager, from 2026-09-28 to 2026-10-16. All names, projects and numbers are made up.

## What is inside

| Note | Shows |
|---|---|
| `0_Daily/` | 15 daily notes with dictated Brain Dumps (one is half German), the Summary and the properties that `/pl-daily` wrote. `Journal.base` shows them as a table in Obsidian. 2026-10-08 has a sent recap, 2026-10-09 a sent weekly update. **2026-10-15 and 2026-10-16 are not processed yet** — try it yourself. 2026-10-15 starts with the `## Today` plan that `/pl-daily` wrote the evening before. |
| [[Project Phoenix]] | An active project: timeline, decisions, open items and a timeline chart. Its meetings: [[Phoenix Kickoff 2026-09-29]] (one-off) and [[Phoenix Weekly]] (with a sent recap, see [[2026-10-08]]). |
| [[Invoice Automation]] | A completed project in `4_Archive`, with its closing summary. |
| [[Vendor Management]] | An area with an open `#for-manager` question. |
| [[1on1 Manager]] | The 1:1 with a saved prep from 2026-10-06. |
| [[Career - Wins]] | 1 Milestone and 4 Wins, collected by `/pl-daily`, most linked to a goal. |
| [[Career - Goals]] | 3 goals for 2026 (one reached) and the expectations of the next level. |
| `3_Resources/` | [[Glossary]], [[Where to Find]], [[Teams]], [[Rules & Policies]], [[Commands]], [[How-Tos]] — filled from the dictation. |

## Get it

In a new, empty folder:

```bash
mkdir ~/paralog-demo && cd ~/paralog-demo
npx skills add antonwild/paralog      # or: <paralog clone>/install.sh ~/paralog-demo
claude                                # then run: /pl-setup demo
```

`/pl-setup demo` copies this vault into the folder, makes it a git repository and adds the auto-commit hook. Then open the folder in Obsidian (*Open folder as vault*) and start with [[Project Phoenix]] or [[Career - Wins]]. Any Markdown editor works too.

## Try the commands

The demo's "today" is 2026-10-16. Give the date where a command needs it.

| Try | What you see |
|---|---|
| `/pl-daily 2026-10-15`, then `/pl-daily 2026-10-16` | The two open dumps get filed. It asks before it creates the new items (e.g. the demo for the sales team leads). The first run also writes `## Today` into 2026-10-16: the recap for Phoenix Weekly and `/pl-week` for Friday. |
| `/pl-evidence Did we agree to start Phoenix with the sales team?` | On 2026-10-15 Tom doubts it. The answer quotes the kickoff on 2026-09-29. |
| `/pl-prep manager 1:1` | Wins and project updates since the last prep, plus the open contract extension `#for-manager`. |
| `/pl-week` (say the week is 2026-10-12 to 2026-10-16) | The weekly update. First it asks to fill in the two open days. |
| `/pl-prep year-end review` | Progress per goal: one reached, one with a Milestone ahead, and the other wins. |
| `/pl-prep promotion` | Evidence for each line of *Next level*, and the gaps (nothing yet for mentoring). |
| `/pl-daily 2026-10-19` | Guided mode: a day with no dump. It interviews you, with follow-ups from the open items. |
| `/pl-recap Phoenix Weekly 2026-10-15` | An email draft of the third weekly (after `/pl-daily 2026-10-15`). |
| `/pl-handover Project Phoenix` | One page for a deputy. |
| `/pl-timeline Project Phoenix` | The timeline chart, rebuilt. |
| `/pl-check` | The vault check. The script finds no problems; projects with no news for 30 days show as stale. |

Commit times in the copy are the time you copied it, so `/pl-evidence` shows today as "written down".
