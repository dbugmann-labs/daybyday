import { readFileSync } from 'node:fs'
import { describe, expect, it } from 'vitest'

import { parseBacklog } from '../scripts/lib/backlog.ts'

// ADR-1010's finding was that the parking lot's staleness rule never ran, because nothing
// recorded that a round had happened and so nothing could count one. These tests are about
// that count and nothing else: a want's `survived` is the number of grooming passes dated
// after it was captured, and two is the forced choice.

function backlog(wants: string, passes = '', decided = ''): string {
  return `# Backlog\n\n## Wants\n\n${wants}\n\n## Decided\n\n${decided}\n\n## Grooming passes\n\n${passes}\n`
}

const B1 = `### B-001 — see my weight as a line over months\n*Captured 2026-08-28.*\n\n- **Trigger** — evening.\n`
const B2 = `### B-002 — add to a running total\n*Captured 2026-09-20.*\n\n- **Trigger** — after eating.\n`

describe('parseBacklog', () => {
  it('reads a want, its id and the date it was captured', () => {
    const { wants } = parseBacklog(backlog(B1))
    expect(wants).toEqual([{ id: 'B-001', heading: 'see my weight as a line over months', captured: '2026-08-28', survived: 0 }])
  })

  // "Captured 2026-08-28, migrated 2026-09-02" is the shape every entry inherited from the
  // parking lot carries. The first date is the honest one: it is how long the want has been
  // sitting there, which is what the staleness rule is about.
  it('takes the first date on the meta line, so a migrated entry keeps its original age', () => {
    const migrated = `### B-003 — carry my history to a new phone\n*Captured 2026-08-28, migrated 2026-09-02.*\n`
    expect(parseBacklog(backlog(migrated)).wants[0]?.captured).toBe('2026-08-28')
  })

  it('counts only the passes a want actually sat through', () => {
    const { wants } = parseBacklog(backlog(`${B1}\n${B2}`, '- 2026-09-10 — pass one.\n- 2026-09-30 — pass two.\n'))
    expect(wants.find((w) => w.id === 'B-001')?.survived).toBe(2)
    expect(wants.find((w) => w.id === 'B-002')?.survived).toBe(1)
  })

  it('makes two passes the forced choice, and one not', () => {
    const { stale } = parseBacklog(backlog(`${B1}\n${B2}`, '- 2026-09-10 — pass one.\n- 2026-09-30 — pass two.\n'))
    expect(stale.map((w) => w.id)).toEqual(['B-001'])
  })

  it('calls everything fresh while the backlog has never been groomed', () => {
    const { fresh, lastPass, stale } = parseBacklog(backlog(`${B1}\n${B2}`))
    expect(lastPass).toBeNull()
    expect(fresh).toHaveLength(2)
    expect(stale).toHaveLength(0)
  })

  it('counts as fresh only what was captured after the last pass', () => {
    const { fresh } = parseBacklog(backlog(`${B1}\n${B2}`, '- 2026-09-10 — pass one.\n'))
    expect(fresh.map((w) => w.id)).toEqual(['B-002'])
  })

  it('counts the Decided ledger without confusing it for wants', () => {
    const { wants, decided } = parseBacklog(backlog(B1, '', '- 2026-08-31 — reading 3x a week → Story #11.\n- 2026-08-30 — weekday sets → shipped.\n'))
    expect(decided).toBe(2)
    expect(wants).toHaveLength(1)
  })

  // A projection must never be the reason a human cannot find out where a Story is, so a want
  // whose meta line carries no date is dropped rather than defaulted. Defaulting it to today
  // would make it fresh for ever — the one reading that never forces a decision.
  it('skips an entry with no date rather than inventing one', () => {
    const undated = `### B-004 — something someone typed by hand\n*Captured, at some point.*\n`
    expect(parseBacklog(backlog(`${B1}\n${undated}`)).wants.map((w) => w.id)).toEqual(['B-001'])
  })

  it("parses this repository's own backlog", () => {
    const { wants, decided } = parseBacklog(readFileSync('docs/backlog.md', 'utf8'))
    expect(wants.length).toBeGreaterThan(0)
    expect(decided).toBeGreaterThan(0)
    expect(wants.every((w) => /^B-\d+$/.test(w.id) && /^\d{4}-\d{2}-\d{2}$/.test(w.captured))).toBe(true)
  })
})
