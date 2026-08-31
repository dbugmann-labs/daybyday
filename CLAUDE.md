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
- **Plugin scope.** `mattpocock-skills` is *enabled* per-project in `.claude/settings.json`, but
  **enabling is not installing.** The install is recorded separately, in
  `~/.claude/plugins/installed_plugins.json`, against the `projectPath` it was installed from.
  This repo inherited Atlas's `settings.json` without that record, so for a time the plugin read
  as enabled while its skills silently never loaded — and no session restart fixed it, because
  the only record pointed at `~/Coding/atlas`. **That is fixed.** The file now carries a second
  entry whose `projectPath` is this repo, and the plugin's skills do load. If they stop loading
  again, check for that entry, and if it has gone:

  ```bash
  claude plugin install mattpocock-skills@claude-plugins-official --scope project
  ```

  from the repo root, then restart the session. Diagnose from that file, not from the fact that
  `.claude/settings.json` lists the plugin — that is the symptom that misleads.

  **`/to-tickets` is not the canary.** It, and every other skill declaring
  `disable-model-invocation: true`, is absent from an agent's `Skill` roster *even when the
  plugin is installed correctly* — the flag is what removes it, not a broken install. An agent
  that tests for it there will always conclude the plugin is broken. Test with the skills that
  are **not** flagged instead: `mattpocock-skills:tdd`, `:code-review`, `:research`,
  `:diagnosing-bugs`. If those are in the roster, the plugin loaded.
- **OpenSpec commands.** `/opsx:*` are generated into `.claude/commands/opsx/` by
  `openspec update` — do not hand-edit them.
- **Scratch.** `CLAUDE.local.md` and `.claude/settings.local.json` are gitignored. Anything
  another agent must know goes in a tracked file, never in local settings.
- **Rule 6 applies here.** Editing this file, `.claude/settings.json`, or the plugin set is
  work for the session talking to the human. Do not delegate it to a subagent.
