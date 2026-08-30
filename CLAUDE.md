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
- **Plugin scope.** `mattpocock-skills` is enabled per-project in `.claude/settings.json`. Its
  skills load only in a session started from the repo root, and a fresh install needs a session
  restart before they are invocable.
- **OpenSpec commands.** `/opsx:*` are generated into `.claude/commands/opsx/` by
  `openspec update` — do not hand-edit them.
- **Scratch.** `CLAUDE.local.md` and `.claude/settings.local.json` are gitignored. Anything
  another agent must know goes in a tracked file, never in local settings.
- **Rule 6 applies here.** Editing this file, `.claude/settings.json`, or the plugin set is
  work for the session talking to the human. Do not delegate it to a subagent.
