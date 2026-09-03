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
- **If the plugin's skills go missing.** `claude plugin details mattpocock-skills` answers it
  without a session and should report `Skills (25)`. **Enabling is not installing:**
  `.claude/settings.json` enables `mattpocock-skills` per-project, but the install is recorded
  separately in `~/.claude/plugins/installed_plugins.json`, against the `projectPath` it was
  installed from. A record pointing elsewhere reads as enabled while no skill ever loads, and no
  session restart fixes it — this repo ran that way from its creation until 2026-08-31, on a
  record inherited from Atlas. So diagnose from that file, never from the fact that
  `.claude/settings.json` lists the plugin; if it holds no entry for this repo, run this from
  the repo root and restart:

  ```bash
  claude plugin install mattpocock-skills@claude-plugins-official --scope project
  ```

  **Never use a flagged skill as the canary.** `to-tickets`, `triage`, `handoff` and
  `grill-with-docs` are absent from an agent's `Skill` roster *even on a healthy install* — the
  `disable-model-invocation` flag removes them, not a broken plugin — so testing for one there
  reports the plugin broken every time. Test with `mattpocock-skills:tdd`, `:code-review`,
  `:research` or `:diagnosing-bugs` instead.
- **Skills this repo owns.** `grill` is the only hand-written one, and both grills run through
  it (ADR-1009). `.claude/skills/` also holds six `openspec-*` directories generated alongside
  `.claude/commands/opsx/`; they duplicate the `/opsx:*` commands this process routes through
  and nothing here invokes them, so `.claude/settings.local.json` turns them off. That file is
  gitignored, so a fresh clone sees all seven again. Project skills carry no
  `disable-model-invocation` flag and load without a restart; whether a **subagent** sees one is
  unverified. Plugin reachability is a frontmatter flag an update can move, and nothing in CI
  checks it. `docs/process.md` §10 has both the one-liner that prints the real picture and the
  prompt that settles the subagent question — run them rather than trusting any table, this
  file included.
- **OpenSpec commands.** `/opsx:*` are generated into `.claude/commands/opsx/` by
  `openspec update` — do not hand-edit them.
- **Scratch.** `CLAUDE.local.md` and `.claude/settings.local.json` are gitignored. Anything
  another agent must know goes in a tracked file, never in local settings.
- **Rule 6 applies here.** Editing this file, `.claude/settings.json`, or the plugin set is
  work for the session talking to the human. Do not delegate it to a subagent.
