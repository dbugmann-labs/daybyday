import { describe, expect, it } from 'vitest'
import { parseBacklog } from '../scripts/lib/backlog.ts'
import { deriveStoryStatus, parseWorktrees, renderTree, type ChangeFacts, type StoryFacts } from '../scripts/status.ts'
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
    grillDone: false,
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
  it('hands an open residual round back to you, inside Stage 4', () => {
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

  // Stage 4 now starts with the grill, and the grill is the conductor's — a subagent cannot
  // hold an interview. So a Story with no change folder at all is not yet spec-author's turn.
  it('reports a missing change folder as the grill, and hands it to you', () => {
    const s = deriveStoryStatus(facts({ change: null }))
    expect(s.stage).toBe(4)
    expect(s.owner).toBe('you')
    expect(s.actions.some((a) => a.command.includes('/atlas grill'))).toBe(true)
  })

  // A folder holding only grill.md fails `openspec validate` because it has no delta yet — that
  // is expected, not broken, so it must not be reported as a validation failure to be fixed.
  it('hands a folder holding only the grill to spec-author, not back as a broken folder', () => {
    const s = deriveStoryStatus(
      facts({ change: change({ grillDone: true, validates: false, validationError: 'Change must have at least one delta' }) }),
    )
    expect(s.owner).toBe('agent')
    expect(s.actor).toBe('spec-author')
    expect(s.blocker).not.toContain('Change must have at least one delta')
  })

  // The one ordering a later edit could silently break: a grill-only folder legitimately fails
  // `openspec validate` (no delta yet), so if the validation rule ever moved ahead of this one,
  // status would send the human to fix a delta that spec-author has not written yet.
  it('checks the grill-only folder before the validation failure it would otherwise trip', () => {
    const s = deriveStoryStatus(facts({ change: change({ grillDone: true, validates: false }) }))
    expect(s.actor).toBe('spec-author')
    expect(s.blocker).toContain('grill')
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

describe('parseWorktrees', () => {
  // The porcelain form is the only stable one; the human-readable listing pads columns and
  // brackets the branch, which is a parse waiting to break.
  it('maps each branch to the worktree holding it, ignoring a detached one', () => {
    const found = parseWorktrees(
      [
        'worktree /Users/x/Coding/daybyday',
        'HEAD 1af8802',
        'branch refs/heads/main',
        '',
        'worktree /Users/x/Coding/daybyday-add-schedule-rules',
        'HEAD 5a09e2f',
        'branch refs/heads/story/12-add-schedule-rules',
        '',
        'worktree /Users/x/Coding/daybyday-detached',
        'HEAD 67d364c',
        'detached',
        '',
      ].join('\n'),
    )
    expect(found.get('main')).toBe('/Users/x/Coding/daybyday')
    expect(found.get('story/12-add-schedule-rules')).toBe('/Users/x/Coding/daybyday-add-schedule-rules')
    expect(found.size).toBe(2)
  })
})

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

  it('walks you to the worktree a Story is already checked out in', () => {
    const out = renderTree(
      WITH_STORY,
      new Set(['story/12-add-schedule-rules']),
      new Map([['story/12-add-schedule-rules', '/Users/x/Coding/daybyday-add-schedule-rules']]),
    )
    expect(out).toContain('cd /Users/x/Coding/daybyday-add-schedule-rules && pnpm run status')
  })

  // A branch with no worktree is a worktree waiting to be re-attached, not an invitation to
  // check it out here: hard rule 8 gives every branch its own working tree.
  it('re-attaches a worktree for a branch that has none', () => {
    const out = renderTree(WITH_STORY, new Set(['story/12-add-schedule-rules']))
    expect(out).toContain('git worktree add ../daybyday-add-schedule-rules story/12-add-schedule-rules')
    expect(out).not.toContain('git checkout story/12-add-schedule-rules')
  })

  // Branches are cut at Stage 4, so most open Stories have none. Printing `git checkout` for
  // one of those hands the human a command that errors — and this file exists to hand over
  // commands that run.
  it('offers to cut the worktree when a Story has no branch yet', () => {
    const out = renderTree(WITH_STORY)
    expect(out).toContain('git worktree add ../daybyday-add-schedule-rules -b story/12-add-schedule-rules origin/main')
    expect(out).toContain('--unset-upstream')
    expect(out).not.toContain('git checkout -b')
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

  // "Here is what is outstanding" is the header, and a closed Feature is not outstanding. It
  // used to render anyway, and — having no open Story left — advertised itself as ready to
  // close, which is a close that already happened. Feature #26 did exactly this after Story
  // #42 merged and closed it.
  it('leaves a closed Feature out of the tree', () => {
    const out = renderTree([
      issue({ number: 1, title: 'EPIC: Daily commitments', type: 'Epic' }),
      issue({ number: 26, title: 'FEAT: commitment', type: 'Feature', state: 'CLOSED', parent: 1 }),
      issue({ number: 42, title: 'add-commitment-type', type: 'Task', state: 'CLOSED', parent: 26 }),
      issue({ number: 53, title: 'FEAT: record', type: 'Feature', parent: 1 }),
    ])
    expect(out).not.toContain('Feature #26')
    expect(out).not.toContain('ready to close')
    expect(out).toContain('Feature #53')
  })

  // Hiding closed Features must not make an Epic that has finished some look like an Epic that
  // has never had one — those want opposite things from the human.
  it('does not ask for a Feature under an Epic whose Features have all closed', () => {
    const out = renderTree([
      issue({ number: 1, title: 'EPIC: Daily commitments', type: 'Epic' }),
      issue({ number: 26, title: 'FEAT: commitment', type: 'Feature', state: 'CLOSED', parent: 1 }),
    ])
    expect(out).not.toContain('G1 is yours')
    expect(out).toContain('every Feature closed')
  })

  it('says plainly that an empty tracker starts with the human', () => {
    expect(renderTree([])).toContain('starts with you')
  })

  // The backlog is the half of the work that has no issue yet, so it belongs under the tree
  // rather than beside a Story. ADR-1010: the parking lot failed because nothing opened it,
  // and a count you only see when you remember to ask reproduces that one level up.
  const WANTS = `# Backlog

## Wants

### B-001 — see my weight as a line over months
*Captured 2026-08-28.*

### B-002 — add to a running total
*Captured 2026-09-20.*

## Decided

- 2026-08-31 — reading 3x a week → Story #11.

## Grooming passes

- 2026-09-10 — pass one.
- 2026-09-30 — pass two.
`

  it('reports the backlog under the tree, with the command to groom it', () => {
    const out = renderTree(WITH_STORY, new Set(), new Map(), parseBacklog(WANTS))
    expect(out).toContain('Backlog — 2 want(s), 1 decided (2 pass(es), last 2026-09-30)')
    expect(out).toContain('/atlas backlog')
  })

  // A want waiting to be groomed is a queue entry, not a debt: one cluster a pass is the
  // intended throughput, so an ungroomed want must never read as something owed.
  it('never puts a want in WAITING ON YOU, however long it has sat there', () => {
    const out = renderTree(WITH_STORY, new Set(), new Map(), parseBacklog(WANTS))
    expect(out).toContain('Backlog — 2 want(s)')
    expect(out).not.toContain('groom the backlog')
  })

  it('names what has been captured since the last pass', () => {
    const out = renderTree(WITH_STORY, new Set(), new Map(), parseBacklog(WANTS.replace('- 2026-09-30 — pass two.\n', '')))
    expect(out).toContain('1 captured since 2026-09-10: B-002')
  })

  it('reports an ungroomed backlog as never groomed', () => {
    const out = renderTree(WITH_STORY, new Set(), new Map(), parseBacklog(WANTS.split('## Grooming passes')[0]!))
    expect(out).toContain('never groomed')
  })

  it('points an empty backlog at the capture command, not the grooming one', () => {
    const out = renderTree(WITH_STORY, new Set(), new Map(), parseBacklog('# Backlog\n\n## Wants\n\n## Decided\n'))
    expect(out).toContain('Backlog — empty')
    expect(out).toContain('/atlas idea <want>')
  })

  // Every existing caller passes three arguments. A repo with no backlog file at all — and
  // every test above this one — must render exactly as before.
  it('says nothing about a backlog when there is none', () => {
    expect(renderTree(WITH_STORY)).not.toContain('Backlog')
  })
})
