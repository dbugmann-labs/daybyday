/**
 * `docs/backlog.md` as data, for `pnpm run status`.
 *
 * ADR-1010's diagnosis of the parking lot was that nothing ever opened the file: its exit rule
 * and its staleness rule were sentences, and no command could observe that an entry had gone
 * stale because nothing recorded that a round had happened. `/atlas backlog` fixes half of
 * that — a grooming pass is now a thing that happens. This fixes the other half: the pass
 * count is written down, so status can surface a stale want without being asked.
 *
 * **A projection, like the rest of `status.ts`.** Nothing consumes this and no check reads it.
 * A backlog file that does not parse is reported as unreadable rather than throwing, because
 * the systems of record are the issue tracker and the change folders — a hand-edited heading
 * must never be able to stop a human finding out where a Story is.
 */
import { existsSync, readFileSync } from 'node:fs'
import path from 'node:path'

export type Want = {
  /** `B-014`. */
  id: string
  heading: string
  /** ISO date from the entry's italic line — the first one, so "captured X, migrated Y" is X. */
  captured: string
  /** Grooming passes dated after `captured`. Two is the forced choice. */
  survived: number
}

export type Backlog = {
  wants: Want[]
  /** Lines in the *Decided* ledger: everything that has left, however it left. */
  decided: number
  /** Grooming pass dates, ascending. */
  passes: string[]
  lastPass: string | null
  /** Captured since the last pass — new since you last looked. */
  fresh: Want[]
  /** Survived two passes or more. `/atlas backlog` presents these as promote-or-drop. */
  stale: Want[]
}

const ISO = /\d{4}-\d{2}-\d{2}/

/** Everything under one `## ` heading, up to the next one. */
function section(md: string, heading: string): string {
  const lines = md.split('\n')
  const start = lines.findIndex((l) => l.trim() === `## ${heading}`)
  if (start === -1) return ''
  const rest = lines.slice(start + 1)
  const end = rest.findIndex((l) => l.startsWith('## '))
  return (end === -1 ? rest : rest.slice(0, end)).join('\n')
}

export function parseBacklog(md: string): Backlog {
  const passes = [...section(md, 'Grooming passes').matchAll(new RegExp(`^-\\s+(${ISO.source})`, 'gm'))]
    .map((m) => m[1]!)
    .sort()
  const lastPass = passes.at(-1) ?? null

  const wants: Want[] = []
  const body = section(md, 'Wants')
  // The heading carries the id; the italic line under it carries the date. An entry missing
  // either is skipped rather than guessed at — a half-parsed want would be counted as fresh
  // for ever, which is the one reading that never forces a decision.
  const entries = [...body.matchAll(/^### (B-\d+)\s+—\s+(.+?)\s*$\n+\*([^*]+)\*/gm)]
  for (const [, id, heading, meta] of entries) {
    const captured = meta!.match(ISO)?.[0]
    if (captured === undefined) continue
    wants.push({
      id: id!,
      heading: heading!,
      captured,
      survived: passes.filter((p) => p > captured).length,
    })
  }

  const decided = [...section(md, 'Decided').matchAll(/^-\s+\S/gm)].length

  return {
    wants,
    decided,
    passes,
    lastPass,
    fresh: lastPass === null ? wants : wants.filter((w) => w.captured > lastPass),
    stale: wants.filter((w) => w.survived >= 2),
  }
}

/** `null` when there is no backlog file — a repo that has not started one is not an error. */
export function readBacklog(root: string): Backlog | null {
  const file = path.join(root, 'docs', 'backlog.md')
  if (!existsSync(file)) return null
  return parseBacklog(readFileSync(file, 'utf8'))
}
