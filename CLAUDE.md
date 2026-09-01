# CLAUDE.md

@AGENTS.md

## Claude Code specifics

`AGENTS.md` above is canonical and tool-agnostic. This section covers only what is particular
to running it in Claude Code.

- **Agents.** The model-routing table in `AGENTS.md` is implemented by `.claude/agents/`.
  Route by opening the matching agent, not by choosing a model ad hoc.
- **The conductor.** `/atlas` is this repo's own command, hand-written in
  `.claude/commands/atlas.md`. It is the session talking to you. No subagent can run it — see
  `AGENTS.md` § *The conductor* and `docs/adr/1002-*`.
- **Plugin scope — installed and working.** `claude plugin details mattpocock-skills` reports
  `Skills (25)`; confirmed 2026-09-01. Nothing here needs doing. What follows is the diagnosis
  to run *if* that count is ever 0, because the failure it describes is silent.

  `mattpocock-skills` is *enabled* per-project in `.claude/settings.json`, but **enabling is not
  installing.** The install is recorded separately, in
  `~/.claude/plugins/installed_plugins.json`, against the `projectPath` it was installed from.
  This repo inherited Atlas's `settings.json` without that record, so from the repo's creation
  until 2026-08-31 the plugin read as enabled while its skills never loaded — and no session
  restart fixed it, because the only record pointed at `~/Coding/atlas`. If the skills go missing
  from a session, check that file for an entry whose `projectPath` is this repo. If there is
  none:

  ```bash
  claude plugin install mattpocock-skills@claude-plugins-official --scope project
  ```

  from the repo root, then restart the session. Diagnose from that file, not from the fact that
  `.claude/settings.json` lists the plugin — that is the symptom that misleads.

  **Do not use a flagged skill as the canary.** `to-tickets`, `triage`, `handoff` and
  `grill-with-docs` are absent from an agent's `Skill` roster *even on a healthy install* — the
  `disable-model-invocation` flag is what removes them, not a broken plugin — so an agent testing
  for one there concludes the plugin is broken every time. Test with an unflagged skill instead:
  `mattpocock-skills:tdd`, `:code-review`, `:research`, `:diagnosing-bugs`. If those are in the
  roster, the plugin loaded. `claude plugin details mattpocock-skills` answers it without a
  session at all.
- **Skills this repo owns.** `.claude/skills/` holds `grill`, which both grills run through —
  ADR-1009 has why it exists rather than `grill-with-docs`. Project skills carry no
  `disable-model-invocation` flag and load without a session restart: verified 2026-09-01, the
  file appeared in the live session's skill list on write. Whether a **subagent** sees one is
  not verified — `docs/process.md` §10 has the prompt that proves it.

  Reachability of the *plugin's* skills is a frontmatter flag a plugin update can move, and
  nothing in CI checks it. §10 has the one-liner that prints the whole picture; run it rather
  than trusting any table, this file included.
- **OpenSpec commands.** `/opsx:*` are generated into `.claude/commands/opsx/` by
  `openspec update` — do not hand-edit them.
- **Scratch.** `CLAUDE.local.md` and `.claude/settings.local.json` are gitignored. Anything
  another agent must know goes in a tracked file, never in local settings.
- **Rule 6 applies here.** Editing this file, `.claude/settings.json`, or the plugin set is
  work for the session talking to the human. Do not delegate it to a subagent.
