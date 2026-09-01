# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the
codebase.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root: the project's shared vocabulary, process and domain both.
- **`docs/adr/`**: the ADRs touching the area you are about to work in. `docs/adr/README.md`
  indexes them.

If either is missing, **proceed silently** — do not flag the absence or suggest creating one
upfront. They are written lazily, when a term or a decision actually gets settled, by the
`domain-modeling` skill reached through this repo's `grill` skill.

## Layout

This repo is **single-context**: one `CONTEXT.md` and one `docs/adr/`, both at the root. The
multi-context layout — a root `CONTEXT-MAP.md` pointing at per-context `CONTEXT.md` files, with
context-scoped `src/<context>/docs/adr/` — is **not in use**. Per `docs/adr/0001-monorepo.md`,
this repo becomes a workspace only if the product later splits into several deployables; adopt
`CONTEXT-MAP.md` then, not before.

## Use the glossary's vocabulary

When your output names a domain concept — an issue title, a spec requirement, a change id, a
scenario name, a test name — use the term as `CONTEXT.md` defines it, and do not drift to
synonyms the glossary explicitly avoids. A concept that is not in the glossary yet is a signal:
either you are inventing language the project does not use (reconsider), or there is a real gap
(raise it in the grill, which is what maintains the file).

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently
overriding:

> _Contradicts ADR-0007 (public repo, free org), but worth reopening because…_
