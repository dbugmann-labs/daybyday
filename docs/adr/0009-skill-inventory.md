# 0009. Install the skills plugin whole; four skills are never invoked

- Status: accepted
- Date: 2026-08-22
- Deciders: Diego Bugmann

## Context

Four skills in `mattpocock-skills` overlap with OpenSpec and would break the process if used:
`to-spec` duplicates `/opsx:propose` and publishes requirements prose to the issue tracker,
violating ADR-0002; `implement` duplicates `/opsx:apply` and its "commit your work to the
current branch" step bypasses review and CI; `wayfinder` and
`improve-codebase-architecture` are premature at one concurrent Story and no codebase.

Claude Code has no per-skill disable mechanism. `claude plugin disable` operates at plugin
granularity, there is no `disabledSkills` setting, and deleting skill directories from the
installed copy is reverted by `claude plugin update`. That would normally force a fork.

## Decision

Install the plugin whole from the official marketplace at project scope, so the repository
declares its own dependency in `.claude/settings.json`. Do not fork and do not prune. List
the four skills in `AGENTS.md` as **never invoke**.

## Consequences

- Updates remain a one-command operation with no upstream tracking burden.
- The four skills carry `disable-model-invocation: true` in their own frontmatter, so they
  cannot fire on their own; only an explicit invocation by name reaches them. `tdd` and
  `code-review`, the two we want firing automatically, are the model-invocable ones. The split
  covers the kill list, but it is not exactly right: `grill-with-docs` carries the flag too, and
  the process depends on it. See ADR-1009.
- Enforcement is therefore documentation plus a mechanical guarantee against accidental
  triggering, which is sufficient. It is not a guarantee against deliberate misuse.
- Verified from the plugin manifest: it declares 25 skills and **no hooks, no MCP servers and
  no commands**. The trust surface is text loaded into agent context, not code executed on
  agent events.

## Alternatives considered

**Fork the repo and strip the four skills.** Durable, but creates a permanent manual
upstream-tracking burden. Rejected once the frontmatter flags made it unnecessary.
**Vendor a curated subset via `npx skills add`.** Rejected for the same reason.

## Corrections

**2026-09-01.** The last sentence of the second consequence read "The split happens to be exactly
right." It is corrected to record that `grill-with-docs` also carries the flag, with a pointer to
ADR-1009. This is not a change of mind: the decision — install whole, do not fork, list four
skills as never invoke — is untouched, and ADR-1009 wraps the flagged skill rather than forking,
which is this ADR's rule holding rather than bending. The sentence was a factual claim about the
plugin's frontmatter that was checked against four skills and generalised to twenty-five.
