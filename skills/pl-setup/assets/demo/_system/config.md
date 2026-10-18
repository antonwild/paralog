---
type: system
# Your name, used to sign emails (/pl-recap)
my_name: "Alex Rivera"
# Language the processed notes are written in (dictation may be any language)
note_language: English
# Languages you write emails in (/pl-recap), e.g. [English, German, French]. The first is the default.
email_languages: [English, German]
# Before creating these note types, the pl-daily skill asks you first.
# Remove a type from the list to let it be created automatically.
ask_before_creating: [project, area, meeting, resource]
# on  = you use the Obsidian Tasks plugin: tasks live in daily notes with #task, tags and dates,
#       and notes show them in live lists. See rules section 11.
#       Obsidian only: other editors show the live lists as code blocks.
# off = plain checkboxes in the project notes (works in every editor)
tasks_plugin: off
# The area note where 1:1 preps are saved
manager_meeting_note: "1on1 Manager"
# How far back /pl-prep looks, in days (if there is no earlier prep)
prep_lookback_days: 14
# on  = every commit is pushed to the git remote. Use only a remote your company allows.
# off = commits stay on this computer
git_push: off
---
# Config

Your personal settings. Edit the values in the properties above.
See [[rules]] for how the vault works.
