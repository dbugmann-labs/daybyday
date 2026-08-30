import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import path from 'node:path'
import { afterEach, describe, expect, it } from 'vitest'
import { approvedFiles, changeDigest, findMarkers, markerBody, type IssueComment } from '../scripts/lib/g4.ts'

// CI check 5 reads a `G4: approved` marker and recomputes the digest it carries. Both halves
// of that are pinned here, because the gate is the one the whole requirement set rests on and
// a false pass is the failure that matters: a Story merging under an approval of text nobody
// read. The digest has to survive the two things the process does to a change folder after
// approval — a rebase, and the archive rename — while still moving when a requirement does.

const dirs: string[] = []

function changeFolder(files: Record<string, string>, name = 'add-day-of-month-schedule'): string {
  const root = mkdtempSync(path.join(tmpdir(), 'g4-'))
  dirs.push(root)
  const dir = path.join(root, name)
  for (const [rel, body] of Object.entries(files)) {
    const full = path.join(dir, rel)
    mkdirSync(path.dirname(full), { recursive: true })
    writeFileSync(full, body)
  }
  return dir
}

const CHANGE = {
  'proposal.md': '## Why\n\nA commitment on the 1st of the month.\n',
  'design.md': '### The seam\n\n`Schedule.dueDates(in:)`\n',
  'tasks.md': '- [ ] 1.1 the 1st of a 31-day month\n',
  'specs/schedule/spec.md': '#### Scenario: the 1st of a 31-day month\n',
}

afterEach(() => {
  for (const d of dirs.splice(0)) rmSync(d, { recursive: true, force: true })
})

describe('changeDigest', () => {
  it('is the same folder-relative fingerprint wherever the folder sits', () => {
    // `/opsx:archive` moves the change to openspec/changes/archive/<date>-<id>/ as a pure
    // rename — R100 on every file, verified on `chore(archive): add-weekday-set-schedule`.
    // The archive commit is the last one before the merge, which is where check 5 binds, so a
    // digest that moved with the folder would fail every Story at the worst possible moment.
    const active = changeFolder(CHANGE)
    const archived = changeFolder(CHANGE, '2026-08-30-add-day-of-month-schedule')
    expect(changeDigest(archived)).toBe(changeDigest(active))
  })

  it('moves when a scenario in the delta is rewritten', () => {
    const before = changeDigest(changeFolder(CHANGE))
    const after = changeDigest(
      changeFolder({ ...CHANGE, 'specs/schedule/spec.md': '#### Scenario: the 31st of a 30-day month\n' }),
    )
    expect(after).not.toBe(before)
  })

  it('moves when a decision in design.md is rewritten', () => {
    const before = changeDigest(changeFolder(CHANGE))
    const after = changeDigest(changeFolder({ ...CHANGE, 'design.md': '### The seam\n\n`Calendar.next(after:)`\n' }))
    expect(after).not.toBe(before)
  })

  it('ignores tasks.md, which the implementer ticks as it goes', () => {
    const before = changeDigest(changeFolder(CHANGE))
    const after = changeDigest(changeFolder({ ...CHANGE, 'tasks.md': '- [x] 1.1 the 1st of a 31-day month\n' }))
    expect(after).toBe(before)
  })

  it('moves when a capability is added to the delta', () => {
    const before = changeDigest(changeFolder(CHANGE))
    const after = changeDigest(changeFolder({ ...CHANGE, 'specs/reminders/spec.md': '#### Scenario: nudge\n' }))
    expect(after).not.toBe(before)
  })

  it('moves when a file is renamed but its contents are not', () => {
    // Paths are hashed alongside contents, so a delta moved from one capability to another is
    // a different approval even though every byte of prose survives.
    const before = changeDigest(changeFolder(CHANGE))
    const moved = { ...CHANGE, 'specs/reminders/spec.md': CHANGE['specs/schedule/spec.md'] } as Record<string, string>
    delete moved['specs/schedule/spec.md']
    expect(changeDigest(changeFolder(moved))).not.toBe(before)
  })

  it('lists the approved files without tasks.md, in a stable order', () => {
    expect(approvedFiles(changeFolder(CHANGE))).toEqual(['design.md', 'proposal.md', 'specs/schedule/spec.md'])
  })
})

function comment(body: string, login = 'diegobugmann', at = '2026-08-30T09:00:00Z'): IssueComment {
  return { body, user: { login }, created_at: at }
}

describe('findMarkers', () => {
  it('reads the digest out of a marker', () => {
    const found = findMarkers([comment(markerBody('7f3c9a1b2c3d', 'Diego Bugmann'))])
    expect(found).toEqual([{ by: 'diegobugmann', at: '2026-08-30T09:00:00Z', digest: '7f3c9a1b2c3d' }])
  })

  it('finds a pre-digest marker and reports that it signs nothing', () => {
    // ADR-0014's form. It is still a recorded human decision, so it is a marker; what it is
    // not is a decision about any particular text, and check 5 has to be able to say so.
    expect(findMarkers([comment('G4: approved — authorised by Diego')])[0]?.digest).toBeNull()
  })

  it('ignores prose that merely contains the word approved', () => {
    expect(findMarkers([comment('Still waiting on the approved comment before I start.')])).toEqual([])
  })

  it('ignores a marker that is not at the start of a line', () => {
    expect(findMarkers([comment('quoting the rule: G4: approved 7f3c9a1b2c3d')])).toEqual([])
  })

  it('returns every marker, oldest first, so a re-approval does not hide the first one', () => {
    const found = findMarkers([
      comment(markerBody('aaaaaaaaaaaa', 'Diego'), 'diegobugmann', '2026-08-30T09:00:00Z'),
      comment('some other comment'),
      comment(markerBody('bbbbbbbbbbbb', 'Diego'), 'diegobugmann', '2026-08-31T09:00:00Z'),
    ])
    expect(found.map((m) => m.digest)).toEqual(['aaaaaaaaaaaa', 'bbbbbbbbbbbb'])
  })

  it('does not mistake the attribution for a digest', () => {
    expect(findMarkers([comment('G4: approved — authorised by deadbeef')])[0]?.digest).toBeNull()
  })
})
