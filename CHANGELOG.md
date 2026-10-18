# Changelog

The version is `paralog_version` in `skills/pl-setup/assets/vault/_system/rules.md`.
Bump it when a release changes framework files (rules, templates, AGENTS.md, hook), so `/pl-daily` tells users to run `/pl-setup`.

## 0.1.0 — 2026-10-18

First release.

- **Skills:** `pl-setup`, `pl-daily`, `pl-prep`, `pl-recap`, `pl-week`, `pl-evidence`, `pl-handover`, `pl-timeline`, `pl-archive`, `pl-check`, and the internal `pl-new-note`.
- **Install** with `npx skills add antonwild/paralog`, or `install.sh` from a clone. `/pl-setup` builds and updates the vault.
- **Vault checks** as code (`pl-setup/scripts/check.sh`), used by `/pl-check`.
- **Optional Tasks plugin** integration (rules section 11).
- **Git:** auto-commit hook for Claude Code; push is opt-in (`git_push`).
- **Your own work:** entries are about your projects, meetings, decisions and wins. A `Teams` note records what each team owns and what to ask them about.
- **Demo vault:** `/pl-setup demo` in an empty folder creates three weeks of a made-up project manager's work, with two open days to try `/pl-daily`.
- **Guided daily mode:** without a dump, `/pl-daily` asks a few short questions.
- **Goals:** `Career - Goals` (rules section 3b). Wins link to goals; reviews show the progress per goal; `/pl-prep promotion` builds a promotion case.
