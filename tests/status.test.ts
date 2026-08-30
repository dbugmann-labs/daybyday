import { describe, expect, it } from 'vitest'
import { deriveStoryStatus, renderTree, type ChangeFacts, type StoryFacts } from '../scripts/status.ts'
import type { GraphIssue } from '../scripts/generate-graph.ts'

// `pnpm run status` tells a human whose turn it is. Two properties make it worth trusting, and
// both are easy to lose in a later edit: it never reports "waiting on an agent" while G4 is
// unsigned — that would invite code before the gate, which is the one thing the whole process
// exists to prevent — and it names the next scenario rather than the whole delta, because a
// status line listing four scenarios is an invitation to write four tests (AGENTS.md rule 3).

function change(over: Partial<ChangeFacts> = {}): ChangeFacts {
  return {
    dir: 'openspec/changes/add-schedule-rules',
    archived: false,
    validates: true,
    validationError: null,
    openQuestionsAnswered: true,
    seamNamed: true,
    capabilities: ['schedule'],
    scenarios: { total: 4, covered: 0, next: 'a commitment every 3 days is due on the anchor day' },
    tasks: { total: 6, done: 0 },
    ...over,
  }
}

function facts(over: Partial<StoryFacts> = {}): StoryFacts {
  return {
    issue: 12,
    changeId: 'add-schedule-rules',
    change: change(),
    approval: { by: 'diegobugmann', at: '2026-08-29T10:00:00Z' },
    ...over,
  }
}

describe('deriveStoryStatus', () => {
  it('stops at G4 and calls it yours when no approval is recorded', () => {
    const s = deriveStoryStatus(facts({ approval: null }))
    expect(s.stage).toBe(4)
    expect(s.owner).toBe('you')
    expect(s.actions.some((a) => a.command.includes("G4: approved"))).toBe(true)
  })

  // The ordering that matters most: a Story can be fully written, valid, seamed and still
  // unapproved. Every later rule must sit behind the approval check or status will hand work
  // to an implementer that hard rule 1 forbids from starting.
  it('never hands work to an agent while G4 is unsigned', () => {
    for (const over of [
      { scenarios: { total: 4, covered: 2, next: 'x' } },
      { scenarios: { total: 4, covered: 4, next: null } },
      { tasks: { total: 6, done: 6 } },
    ]) {
      const s = deriveStoryStatus(facts({ approval: null, change: change(over) }))
      expect(s.owner).toBe('you')
      expect(s.stage).toBe(4)
    }
  })

  it('asks for the grill when design.md leaves Open Questions empty', () => {
    const s = deriveStoryStatus(facts({ change: change({ openQuestionsAnswered: false }) }))
    expect(s.stage).toBe(3)
    expect(s.owner).toBe('you')
  })

  it('fails the Definition of Ready when design.md names no seam', () => {
    const s = deriveStoryStatus(facts({ change: change({ seamNamed: false }) }))
    expect(s.owner).toBe('agent')
    expect(s.actor).toBe('spec-author')
    expect(s.blocker).toContain('seam')
  })

  it('reports a missing change folder as the propose step, not as an error', () => {
    const s = deriveStoryStatus(facts({ change: null }))
    expect(s.stage).toBe(3)
    expect(s.actor).toBe('spec-author')
  })

  it('names exactly one next scenario, never the whole delta', () => {
    const s = deriveStoryStatus(facts({ change: change({ scenarios: { total: 4, covered: 1, next: 'the second one' } }) }))
    expect(s.stage).toBe(6)
    expect(s.actions.filter((a) => a.label === 'Next')).toHaveLength(1)
    expect(s.actions.find((a) => a.label === 'Next')!.command).toBe('"the second one"')
  })

  it('calls the first cycle Red and every later one Green', () => {
    expect(deriveStoryStatus(facts({ change: change({ scenarios: { total: 4, covered: 0, next: 'a' } }) })).stage).toBe(5)
    expect(deriveStoryStatus(facts({ change: change({ scenarios: { total: 4, covered: 3, next: 'd' } }) })).stage).toBe(6)
  })

  it('holds at Stage 6 when every scenario is covered but a task box is unticked', () => {
    const s = deriveStoryStatus(
      facts({ change: change({ scenarios: { total: 4, covered: 4, next: null }, tasks: { total: 6, done: 5 } }) }),
    )
    expect(s.stage).toBe(6)
    expect(s.blocker).toContain('unticked')
  })

  it('reaches review only when the delta and the task list are both satisfied', () => {
    const s = deriveStoryStatus(
      facts({ change: change({ scenarios: { total: 4, covered: 4, next: null }, tasks: { total: 6, done: 6 } }) }),
    )
    expect(s.stage).toBe(7)
    expect(s.owner).toBe('you')
  })

  // Stage 7 leaves no artifact, so status cannot tell a reviewed Story from an unreviewed one.
  // Saying so is the requirement; silently guessing either way is the defect.
  it('declares that it cannot see whether a review has run', () => {
    const s = deriveStoryStatus(
      facts({ change: change({ scenarios: { total: 4, covered: 4, next: null }, tasks: { total: 6, done: 6 } }) }),
    )
    expect(s.unobservable).toContain('review')
  })

  it('treats an archived change as finished work waiting to merge', () => {
    const s = deriveStoryStatus(facts({ change: change({ archived: true }) }))
    expect(s.stage).toBe(9)
    expect(s.actor).toBe('janitor')
  })

  it('sends an invalid change folder back to spec-author rather than to the human', () => {
    const s = deriveStoryStatus(facts({ change: change({ validates: false, validationError: 'missing scenario' }) }))
    expect(s.owner).toBe('agent')
    expect(s.blocker).toContain('missing scenario')
  })
})

function issue(over: Partial<GraphIssue> & Pick<GraphIssue, 'number'>): GraphIssue {
  return { title: `issue ${over.number}`, state: 'OPEN', type: 'Task', parent: null, ...over }
}

describe('renderTree', () => {
  it('names a Feature with no Story as yours to decompose', () => {
    const out = renderTree([
      issue({ number: 1, title: 'EPIC: Daily commitments', type: 'Epic' }),
      issue({ number: 6, title: 'FEAT: schedule', type: 'Feature', parent: 1 }),
    ])
    expect(out).toContain('G2 is yours')
    expect(out).toContain('WAITING ON YOU')
    expect(out).toContain('decompose Feature #6')
  })

  const WITH_STORY: GraphIssue[] = [
    issue({ number: 1, title: 'EPIC: Daily commitments', type: 'Epic' }),
    issue({ number: 6, title: 'FEAT: schedule', type: 'Feature', parent: 1 }),
    issue({ number: 12, title: 'add-schedule-rules', type: 'Task', parent: 6 }),
  ]

  it('gives the exact command to switch to a Story whose branch exists', () => {
    const out = renderTree(WITH_STORY, new Set(['story/12-add-schedule-rules']))
    expect(out).toContain('git checkout story/12-add-schedule-rules && pnpm run status')
  })

  // Branches are cut at Stage 4, so most open Stories have none. Printing `git checkout` for
  // one of those hands the human a command that errors — and this file exists to hand over
  // commands that run.
  it('offers to cut the branch when a Story does not have one yet', () => {
    const out = renderTree(WITH_STORY)
    expect(out).toContain('git checkout -b story/12-add-schedule-rules origin/main')
    expect(out).toContain('--unset-upstream')
    expect(out).not.toContain('git checkout story/12-add-schedule-rules &&')
  })

  it('says an Epic with no Feature is waiting on G1', () => {
    const out = renderTree([issue({ number: 1, title: 'EPIC: Daily commitments', type: 'Epic' })])
    expect(out).toContain('G1 is yours')
  })

  it('points out a Feature whose Stories have all closed', () => {
    const out = renderTree([
      issue({ number: 1, title: 'EPIC: Daily commitments', type: 'Epic' }),
      issue({ number: 6, title: 'FEAT: schedule', type: 'Feature', parent: 1 }),
      issue({ number: 12, title: 'add-schedule-rules', type: 'Task', state: 'CLOSED', parent: 6 }),
    ])
    expect(out).toContain('ready to close')
  })

  it('says plainly that an empty tracker starts with the human', () => {
    expect(renderTree([])).toContain('starts with you')
  })
})
