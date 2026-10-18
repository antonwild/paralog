# Changelog

The version is `paralog_version` in `skills/pl-setup/assets/vault/_system/rules.md`.
Bump it when a release changes framework files (rules, templates, AGENTS.md, hook), so `/pl-daily` tells users to run `/pl-setup`.

## 0.1.0 — 2026-10-18

First release.

- **Skills:** `pl-setup`, `pl-daily`, `pl-prep`, `pl-recap`, `pl-evidence`, `pl-handover`, `pl-timeline`, `pl-archive`, `pl-check`, and the internal `pl-new-note`.
- **Install** with `npx skills add antonwild/paralog`, or `install.sh` from a clone. `/pl-setup` builds and updates the vault.
- **Vault checks** as code (`pl-setup/scripts/check.sh`), used by `/pl-check`.
- **Optional Tasks plugin** integration (rules section 11).
- **Git:** auto-commit hook for Claude Code; push is opt-in (`git_push`).
- **Your own work:** entries are about your projects, meetings, decisions and wins. A `Teams` note records what each team owns and what to ask them about.
