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
    questionRoundOpen: false,
    seamNamed: true,
    capabilities: ['schedule'],
    digest: 'c0ffee123456',
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
    approval: { by: 'diegobugmann', at: '2026-08-29T10:00:00Z', digest: 'c0ffee123456', signsCurrent: true },
    pr: { number: 21, url: 'https://github.com/dbugmann-labs/daybyday/pull/21', draft: true, behindMain: 0 },
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

  it('offers an approve command carrying the digest of what would be approved', () => {
    const s = deriveStoryStatus(facts({ approval: null, change: change({ digest: 'c0ffee123456' })  }))
    expect(s.actions.some((a) => a.command.includes('G4: approved c0ffee123456'))).toBe(true)
  })

  // An approval is a decision about text, and the text can move after the decision. Status has
  // to stop for that as hard as it stops for no approval at all, or the conductor walks a Story
  // it thinks is signed into an implementer, and CI check 5 discovers it at the merge instead.
  it('stops again when the change folder moved after it was approved', () => {
    const stale = { by: 'diegobugmann', at: '2026-08-29T10:00:00Z', digest: 'aaaaaaaaaaaa', signsCurrent: false }
    const s = deriveStoryStatus(facts({ approval: stale, change: change({ scenarios: { total: 4, covered: 4, next: null } }) }))
    expect(s.stage).toBe(4)
    expect(s.owner).toBe('you')
    expect(s.actions.some((a) => a.command.includes('G4: approved c0ffee123456'))).toBe(true)
  })

  it('says a pre-digest marker records no text rather than claiming the folder moved', () => {
    // ADR-0014's form, which is what every Story approved before ADR-1007 carries. Reporting
    // it as drift would send the human looking for a change nobody made.
    const s = deriveStoryStatus(
      facts({ approval: { by: 'diegobugmann', at: '2026-08-29T10:00:00Z', digest: null, signsCurrent: false } }),
    )
    expect(s.owner).toBe('you')
    expect(s.blocker).toContain('predates')
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

      const stale = deriveStoryStatus(
        facts({ approval: { by: 'diegobugmann', at: '2026-08-29T10:00:00Z', digest: null, signsCurrent: false }, change: change(over) }),
      )
      expect(stale.owner).toBe('you')
      expect(stale.stage).toBe(4)
    }
  })

  // The grill is a step inside Stage 4, not a stage of its own, so an unanswered question is a
  // Stage 4 that is not finished. It is still the human's to answer.
  it('hands unanswered Open Questions back to you, inside Stage 4', () => {
    const s = deriveStoryStatus(facts({ change: change({ openQuestionsAnswered: false }) }))
    expect(s.stage).toBe(4)
    expect(s.owner).toBe('you')
  })

  // A round is spec-author asking, and no subagent can ask. If this ever reports an agent as
  // the owner, the questions sit in design.md unread and G4 gets signed over the top of them.
  it('hands an open question round back to you, inside Stage 4', () => {
    const s = deriveStoryStatus(facts({ change: change({ questionRoundOpen: true }) }))
    expect(s.stage).toBe(4)
    expect(s.owner).toBe('you')
    expect(s.blocker).toContain('Questions for you')
  })

  // The round is the human's whether or not the rest of the folder is finished, so it is
  // reported ahead of the seam check — which would otherwise hand the Story back to an agent.
  it('reports the round before a missing seam', () => {
    const s = deriveStoryStatus(facts({ change: change({ questionRoundOpen: true, seamNamed: false }) }))
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
    expect(s.stage).toBe(4)
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

  // Both human gates are read as a diff. A gate presented without one asks the human to hold
  // the change folder in their head; a gate presented on a stale one asks them about a merge
  // that will not happen. Neither is put to them — the branch is made readable first.
  it('opens the draft PR before putting G4 to the human', () => {
    const s = deriveStoryStatus(facts({ approval: null, pr: null }))
    expect(s.stage).toBe(4)
    expect(s.owner).toBe('agent')
    expect(s.actions.some((a) => a.command.includes('gh pr create --draft'))).toBe(true)
  })

  it('refreshes a PR that main has moved past before either gate', () => {
    const behind = { number: 21, url: 'https://example.invalid/21', draft: true, behindMain: 3 }
    const atG4 = deriveStoryStatus(facts({ approval: null, pr: behind }))
    expect(atG4.owner).toBe('agent')
    expect(atG4.blocker).toContain('3 commit(s) behind')

    const atG7 = deriveStoryStatus(
      facts({ pr: behind, change: change({ scenarios: { total: 4, covered: 4, next: null }, tasks: { total: 6, done: 6 } }) }),
    )
    expect(atG7.stage).toBe(7)
    expect(atG7.owner).toBe('agent')
    expect(atG7.actions.some((a) => a.command.includes('--force-with-lease'))).toBe(true)
  })

  // Offline, the count is unknown. Rebasing a branch that is already current costs nothing;
  // presenting a gate on a diff nobody has compared with main costs the gate.
  it('refreshes rather than guesses when main cannot be compared', () => {
    const s = deriveStoryStatus(facts({ approval: null, pr: { number: 21, url: 'https://example.invalid/21', draft: true, behindMain: null } }))
    expect(s.owner).toBe('agent')
    expect(s.blocker).toContain('not fetched')
  })

  it('puts the PR first among the things to read at G4', () => {
    const s = deriveStoryStatus(facts({ approval: null }))
    expect(s.owner).toBe('you')
    expect(s.actions[0]?.command).toContain('/pull/21')
  })

  it('takes the PR out of draft before the merge', () => {
    const s = deriveStoryStatus(facts({ change: change({ archived: true }) }))
    expect(s.actions.some((a) => a.command.startsWith('gh pr ready 21'))).toBe(true)
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
