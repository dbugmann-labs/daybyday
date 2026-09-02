/**
 * `pnpm run status` — where is this Story, and whose turn is it?
 *
 * The process has nine stages and five gates (docs/process.md §4) — numbered 0–9, with no
 * Stage 3 since the grill was folded into Stage 4 — and, until this existed, no way to ask
 * which one you were in. Reconstructing it by hand meant correlating eight
 * signals across three systems: the branch, the change folder, `openspec validate`, the
 * `G4: approved` comment, scenario coverage, the tasks list, the issue tree and the PR.
 * Nobody working four to eight hours a week holds that between sessions, and this repo's
 * own rule is verify, do not remember.
 *
 * Off a story branch it reports the tracker and, under it, `docs/backlog.md` — the half of the
 * work that has no issue yet. ADR-1010.
 *
 * **This is a projection, exactly like `docs/graph.mmd`.** It reads the systems of record
 * and derives a stage; it is never an input, writes nothing, and no check consumes it. The one
 * thing it does write is `origin/main` itself: measuring how far a PR has fallen behind needs
 * a fetch, which moves a remote-tracking ref and no system of record.
 * Deleting it would cost information, not correctness. That is deliberate — a status command
 * that anything depended on would be a sixth gate wearing a helpful face.
 *
 * **What it cannot see.** Stage 7 leaves no artifact: nothing on disk or in the tracker
 * records that a review ran, so a delta whose scenarios are all covered reports "review, then
 * archive" and stops guessing. Adding a `G7:` marker to make it observable was considered and
 * rejected — G4 is the gate worth a machine-readable signature; a second one buys a status
 * line and costs a convention. The output says so rather than pretending otherwise.
 */
import { execFileSync } from 'node:child_process'
import { existsSync, readFileSync } from 'node:fs'
import path from 'node:path'

import { readBacklog, type Backlog, type Want } from './lib/backlog.ts'
import { currentBranch, deltaCapabilities, git, locateChange, parseBranch, repoSlug, type ChangeLocation } from './lib/ci.ts'
import { changeDigest, findMarkers, markerBody } from './lib/g4.ts'
import { scenarioCoverage } from './lib/coverage.ts'
import { fetchIssues, type GraphIssue } from './generate-graph.ts'

// ---------------------------------------------------------------------------
// Facts — everything observable about a Story, gathered before anything is judged.
// ---------------------------------------------------------------------------

export type ChangeFacts = {
  dir: string
  archived: boolean
  validates: boolean
  /** First line of the validator's complaint, when it has one. */
  validationError: string | null
  /** `design.md` has an Open Questions section with something written under it ("None." counts). */
  openQuestionsAnswered: boolean
  /** A `## Questions for you` section in design.md — spec-author asking, waiting on a relay. */
  questionRoundOpen: boolean
  /** `design.md` names a seam. Required by the Definition of Ready; absent from the openspec template. */
  seamNamed: boolean
  capabilities: string[]
  /** What a G4 marker on this folder signs — see scripts/lib/g4.ts. */
  digest: string
  scenarios: { total: number; covered: number; next: string | null }
  tasks: { total: number; done: number }
}

/**
 * The pull request a Story is read through. Both human gates are read as a diff, so a Story
 * with no PR, or a PR that no longer sits on top of `main`, is a gate the human would be
 * answering about a merge that will not happen.
 */
export type PrFacts = {
  number: number
  url: string
  draft: boolean
  /** Commits on `origin/main` that the branch does not have. `null` when origin/main is unknown. */
  behindMain: number | null
}

export type StoryFacts = {
  issue: number
  changeId: string
  /** null when no change folder exists yet — the Story has been cut but nothing written down. */
  change: ChangeFacts | null
  /**
   * The G4 marker, and whether it signs the change folder as it now stands. An approval that
   * covers text the folder has since moved past is not an approval of what would merge
   * (ADR-1007), so the two facts travel together.
   */
  approval: { by: string; at: string; digest: string | null; signsCurrent: boolean } | null
  /** null when the branch has no pull request yet. */
  pr: PrFacts | null
}

export type Owner = 'you' | 'agent' | 'nobody'
export type Action = { label: string; command: string }

export type StoryStatus = {
  stage: number
  stageName: string
  owner: Owner
  /** Who does the next step, when an agent does it. */
  actor: string | null
  /** One line: why work stops here. */
  blocker: string
  actions: Action[]
  /** What happens once the blocker clears. */
  next: string
  /** Something status is structurally unable to determine, stated rather than guessed. */
  unobservable: string | null
}

// ---------------------------------------------------------------------------
// Derivation — pure, and the only part with rules in it.
// ---------------------------------------------------------------------------

/**
 * Both human gates are read as a pull request: G4 as the change folder's diff, G7 as the whole
 * Story's. So before either one is put to the human, the PR has to exist and has to sit on top
 * of `main`. Staleness is not cosmetic — a delta's ADDED/MODIFIED claims are written against
 * the specs as they are, and `main` moving underneath a branch can invalidate them without
 * touching a file in it.
 *
 * Returns the step that has to happen first, or `null` when the PR is fit to be read.
 */
export function prNotReady(f: StoryFacts, stage: number, stageName: string, actor: string, next: string): StoryStatus | null {
  const branch = `story/${f.issue}-${f.changeId}`

  if (f.pr === null) {
    return {
      stage,
      stageName,
      owner: 'agent',
      actor,
      blocker: 'The branch has no pull request, so the gate has no diff to be read as. Open it as a draft — draft is what tells CI the Story is not finished yet.',
      actions: [
        { label: 'Push', command: `git push -u origin ${branch}` },
        { label: 'Open', command: `gh pr create --draft --base main --title '${f.changeId}' --body 'Closes #${f.issue}'` },
      ],
      next,
      unobservable: null,
    }
  }

  if (f.pr.behindMain === null || f.pr.behindMain > 0) {
    const behind =
      f.pr.behindMain === null
        ? 'The PR cannot be compared with `main` — `origin/main` is not fetched here.'
        : `The PR is ${f.pr.behindMain} commit(s) behind \`main\`.`
    return {
      stage,
      stageName,
      owner: 'agent',
      actor,
      blocker: `${behind} Refresh it before the gate: a diff against a stale base is a decision about a merge that will not happen.`,
      actions: [
        { label: 'Refresh', command: 'git fetch origin && git rebase origin/main' },
        { label: 'Push', command: `git push --force-with-lease origin ${branch}` },
        { label: 'Note', command: 'a conflict in the delta or in openspec/specs/ is a stop — main moved under this Story (rule 5)' },
      ],
      next,
      unobservable: null,
    }
  }

  return null
}

/**
 * The stage a Story is in, derived from facts alone. First matching rule wins, so the order
 * below is the pipeline order and reads as one: nothing is approved before its open questions
 * are closed and it validates, no code before G4, no archive before the delta is satisfied.
 *
 * There is no Stage 3. The grill is the first step of Stage 4 rather than a stage, so a Story
 * with unanswered questions is a Stage 4 that is not finished, not a stage of its own — whether
 * the questions are the agent's, waiting on a relay, or the section it left empty.
 */
export function deriveStoryStatus(f: StoryFacts): StoryStatus {
  const c = f.change

  if (c === null) {
    return {
      stage: 4,
      stageName: 'Propose',
      owner: 'agent',
      actor: 'spec-author',
      blocker: `No change folder for "${f.changeId}". There is nothing written down to approve.`,
      actions: [
        { label: 'Run', command: `run the spec-author subagent on Story #${f.issue}` },
        { label: 'It writes', command: `openspec/changes/${f.changeId}/{proposal,design,tasks}.md + specs/` },
      ],
      next: 'G4 — you read the proposal and the delta, and sign it.',
      unobservable: null,
    }
  }

  if (c.archived) {
    return {
      stage: 9,
      stageName: 'Merge',
      owner: 'agent',
      actor: 'janitor',
      blocker: 'The change is archived. The branch is finished and waiting to merge.',
      actions: [
        { label: 'Verify', command: 'pnpm run verify && pnpm run checks' },
        ...(f.pr?.draft === true ? [{ label: 'Ready', command: `gh pr ready ${f.pr.number} — the full check list only binds once it is out of draft` }] : []),
        { label: 'Merge', command: `gh pr merge --squash` },
        { label: 'Then', command: 'settle the parent Feature and Epic, and `pnpm run graph`' },
      ],
      next: 'The PR closes the Story. Nothing else is outstanding.',
      unobservable: null,
    }
  }

  if (!c.validates) {
    return {
      stage: 4,
      stageName: 'Propose',
      owner: 'agent',
      actor: 'spec-author',
      blocker: `The change folder does not validate${c.validationError === null ? '.' : `: ${c.validationError}`}`,
      actions: [
        { label: 'Reproduce', command: `pnpm exec openspec validate ${f.changeId} --strict` },
        { label: 'Fix', command: 'spec-author owns the change folder — hand it back' },
      ],
      next: 'Once it validates, G4 is the next stop and it is yours.',
      unobservable: null,
    }
  }

  if (c.questionRoundOpen) {
    return {
      stage: 4,
      stageName: 'Propose — question round',
      owner: 'you',
      actor: null,
      blocker: '`design.md` carries a `## Questions for you` section. spec-author could not settle something and cannot ask you itself, so the questions are waiting on a relay.',
      actions: [
        { label: 'Read', command: `${path.join(c.dir, 'design.md')} — the round, and the delta it was written against` },
        ...(f.pr === null ? [] : [{ label: 'Diff', command: `${f.pr.url} — the folder was written on the recommended answers` }]),
        { label: 'Answer', command: 'answer by number; then spec-author folds them in and deletes the section' },
        { label: 'Note', command: 'a stop, not a gate — no marker, nothing checks it (ADR-1006)' },
      ],
      next: 'G4, once the round is settled. Answering and approving can be one sitting.',
      unobservable: null,
    }
  }

  if (!c.openQuestionsAnswered) {
    return {
      stage: 4,
      stageName: 'Propose — open questions',
      owner: 'you',
      actor: null,
      blocker: '`design.md` leaves its Open Questions section empty. A question left open here becomes a scenario someone invents later.',
      actions: [
        { label: 'Read', command: path.join(c.dir, 'design.md') },
        { label: 'Answer', command: 'your answers go under `## Open Questions`; "None." is a valid and required answer' },
      ],
      next: 'G4 — the proposal is only worth reading once the questions are closed.',
      unobservable: null,
    }
  }

  if (!c.seamNamed) {
    return {
      stage: 4,
      stageName: 'Propose',
      owner: 'agent',
      actor: 'spec-author',
      blocker: '`design.md` names no seam, so the Definition of Ready fails and acceptance tests have nowhere to attach.',
      actions: [
        { label: 'Add', command: `### The seam — under Decisions in ${path.join(c.dir, 'design.md')}` },
        { label: 'Note', command: 'the openspec design template has no seam section; it is added by hand (AGENTS.md)' },
      ],
      next: 'G4, once one exported function or entry point is named.',
      unobservable: null,
    }
  }

  if (f.approval === null) {
    const pr = prNotReady(f, 4, 'Propose', 'spec-author', 'G4 — you read the PR and sign it.')
    if (pr !== null) return pr

    return {
      stage: 4,
      stageName: 'Propose — G4',
      owner: 'you',
      actor: null,
      blocker: 'The change folder is ready and unapproved. No code may be written until you have read it and signed it.',
      actions: [
        { label: 'Read', command: `${f.pr?.url ?? 'the draft PR'} — the change folder as a diff` },
        { label: 'Read', command: path.join(c.dir, 'proposal.md') },
        ...c.capabilities.map((cap) => ({
          label: 'Read',
          command: `${path.join(c.dir, 'specs', cap, 'spec.md')}  (${c.scenarios.total} scenario(s))`,
        })),
        { label: 'Approve', command: `gh issue comment ${f.issue} --body '${markerBody(c.digest, '<name>')}'` },
      ],
      next: `Stage 5 — the implementer writes one failing test for "${c.scenarios.next ?? 'the first scenario'}".`,
      unobservable: null,
    }
  }

  if (!f.approval.signsCurrent) {
    return {
      stage: 4,
      stageName: 'Propose — G4 again',
      owner: 'you',
      actor: null,
      blocker:
        f.approval.digest === null
          ? `The marker on #${f.issue} predates the approval digest, so it records that ${f.approval.by} was asked but not what they read.`
          : `The change folder has changed since ${f.approval.by} approved it, so the approval on #${f.issue} covers text that is no longer what would merge.`,
      actions: [
        {
          label: 'Read',
          command: `${f.pr?.url ?? 'the draft PR'} — ${f.approval.digest === null ? 'the change folder as it stands' : 'what moved since the approval'}`,
        },
        { label: 'Approve', command: `gh issue comment ${f.issue} --body '${markerBody(c.digest, '<name>')}'` },
        ...(f.approval.digest === null
          ? []
          : [{ label: 'Or', command: 'revert the change folder to the version that was approved' }]),
      ],
      next: 'The stage this Story had reached. CI check 5 blocks the merge until a marker signs the folder.',
      unobservable: null,
    }
  }

  if (c.scenarios.total === 0) {
    return {
      stage: 4,
      stageName: 'Propose',
      owner: 'agent',
      actor: 'spec-author',
      blocker: 'The delta declares no scenarios, so there is nothing for a test to be named after.',
      actions: [{ label: 'Fix', command: 'every requirement needs at least one `#### Scenario:`, edge cases included' }],
      next: 'Re-approve at G4 once the delta describes behaviour.',
      unobservable: null,
    }
  }

  const { total, covered, next } = c.scenarios

  if (covered < total) {
    const first = covered === 0
    return {
      stage: first ? 5 : 6,
      stageName: first ? 'Red' : 'Green + next',
      owner: 'agent',
      actor: 'implementer',
      blocker: `${covered}/${total} scenario(s) covered. One scenario per red-green cycle — never all of them at once.`,
      actions: [
        { label: 'Next', command: `"${next}"` },
        { label: 'Write', command: 'exactly one acceptance test with that title verbatim, at the seam in design.md' },
        { label: 'Loop', command: 'pnpm run test:watch' },
      ],
      next: covered + 1 === total ? 'Stage 7 — review, once this last scenario is green.' : `Stage 6 again — ${total - covered - 1} more scenario(s) after this one.`,
      unobservable: null,
    }
  }

  if (c.tasks.done < c.tasks.total) {
    return {
      stage: 6,
      stageName: 'Green + next',
      owner: 'agent',
      actor: 'implementer',
      blocker: `Every scenario is covered but ${c.tasks.total - c.tasks.done} of ${c.tasks.total} tasks.md box(es) are unticked. The archive refuses to run until they are.`,
      actions: [
        { label: 'Read', command: path.join(c.dir, 'tasks.md') },
        { label: 'Note', command: 'tick a box only when the thing is done — `openspec validate --archived` checks the boxes, not the work' },
      ],
      next: 'Stage 7 — review.',
      unobservable: null,
    }
  }

  const pr = prNotReady(f, 7, 'Review', 'implementer', 'G7 — review, on the diff that will actually merge.')
  if (pr !== null) return pr

  return {
    stage: 7,
    stageName: 'Review',
    owner: 'you',
    actor: 'reviewer',
    blocker: `All ${total} scenario(s) covered and every task ticked. The Story is finished and unreviewed.`,
    actions: [
      { label: 'Read', command: `${f.pr?.url ?? 'the PR'} — the whole Story as one diff` },
      { label: 'Run', command: 'the reviewer subagent — standards, and fidelity to the approved delta' },
      { label: 'Read', command: 'its findings; the implementer fixes them, the reviewer never edits' },
      { label: 'Then', command: `the janitor archives: /opsx:archive as the last commit on this branch` },
    ],
    next: 'Stage 8 — archive, then Stage 9 — merge.',
    unobservable: 'Whether a review has already run. Stage 7 leaves no artifact, so this line appears until the change is archived.',
  }
}

// ---------------------------------------------------------------------------
// Gathering — everything below here touches the filesystem, git, or GitHub.
// ---------------------------------------------------------------------------

function section(markdown: string, heading: RegExp): string | null {
  const lines = markdown.split('\n')
  const start = lines.findIndex((l) => heading.test(l))
  if (start === -1) return null
  const level = /^(#+)/.exec(lines[start]!)?.[1]?.length ?? 2
  const body: string[] = []
  for (const line of lines.slice(start + 1)) {
    const next = /^(#+)\s/.exec(line)
    if (next && next[1]!.length <= level) break
    body.push(line)
  }
  return body.join('\n').trim()
}

export function gatherChange(loc: ChangeLocation): ChangeFacts {
  const designPath = path.join(loc.dir, 'design.md')
  const design = existsSync(designPath) ? readFileSync(designPath, 'utf8') : ''

  const tasksPath = path.join(loc.dir, 'tasks.md')
  const tasks = existsSync(tasksPath) ? readFileSync(tasksPath, 'utf8') : ''
  const boxes = [...tasks.matchAll(/^\s*-\s\[( |x|X)\]/gm)]

  let validates = true
  let validationError: string | null = null
  try {
    execFileSync('pnpm', ['exec', 'openspec', 'validate', loc.changeId, '--strict', '--no-interactive'], {
      encoding: 'utf8',
      stdio: 'pipe',
    })
  } catch (err) {
    validates = false
    const out = err as { stdout?: string; stderr?: string }
    const text = `${out.stdout ?? ''}${out.stderr ?? ''}`.trim()
    validationError = text.split('\n').find((l) => l.trim() !== '')?.trim() ?? null
  }

  const cov = scenarioCoverage(loc)

  return {
    dir: loc.dir,
    archived: loc.archived,
    digest: changeDigest(loc.dir),
    validates,
    validationError,
    // Emptiness is observable; whether an answer is any good is not. A section reading "None."
    // is answered, and judging that claim is what G4 is for.
    openQuestionsAnswered: (section(design, /^#+\s*open questions\b/i) ?? '') !== '',
    // Present only while a round is outstanding: spec-author deletes it when the answers land.
    // So its existence is the signal, and nothing has to parse the questions themselves.
    questionRoundOpen: (section(design, /^#+\s*questions for you\b/i) ?? '') !== '',
    seamNamed: (section(design, /^#+\s*the seam\b/i) ?? '') !== '',
    capabilities: deltaCapabilities(loc),
    scenarios: { total: cov.total, covered: cov.covered, next: cov.missing[0]?.title ?? null },
    tasks: { total: boxes.length, done: boxes.filter((b) => b[1] !== ' ').length },
  }
}

/**
 * The PR for this branch, and how far `main` has moved since it was last rebased. The
 * behind-count is measured locally against `origin/main` after a fetch rather than read from
 * GitHub, because `gh` reports mergeability as a lazily computed field that is frequently
 * `UNKNOWN` on the first read. No PR, no token or no network all read as "no PR": the failure
 * mode of guessing otherwise is a gate presented on a diff nobody can open.
 */
export function gatherPr(branch: string): PrFacts | null {
  let pr: { number: number; url: string; isDraft: boolean }
  try {
    const raw = execFileSync('gh', ['pr', 'view', branch, '--json', 'number,url,isDraft,state'], {
      encoding: 'utf8',
      stdio: 'pipe',
    })
    const parsed = JSON.parse(raw) as { number: number; url: string; isDraft: boolean; state: string }
    if (parsed.state !== 'OPEN') return null
    pr = parsed
  } catch {
    return null
  }

  let behindMain: number | null
  try {
    execFileSync('git', ['fetch', '--quiet', 'origin', 'main'], { stdio: 'pipe' })
    const count = Number(git(['rev-list', '--count', 'HEAD..origin/main']))
    behindMain = Number.isNaN(count) ? null : count
  } catch {
    behindMain = null
  }

  return { number: pr.number, url: pr.url, draft: pr.isDraft, behindMain }
}

/**
 * `digest` is the change folder's approval digest, or null when there is no folder to hash.
 * A marker carrying it is an approval of what is on disk; any other marker — an older digest,
 * or the pre-ADR-1007 form with none — recorded a decision about different text, and says so.
 */
export function gatherApproval(
  repo: string,
  issue: number,
  digest: string | null,
): { by: string; at: string; digest: string | null; signsCurrent: boolean } | null {
  try {
    const raw = execFileSync('gh', ['api', '--paginate', `/repos/${repo}/issues/${issue}/comments`], {
      encoding: 'utf8',
      stdio: 'pipe',
    })
    const markers = findMarkers(JSON.parse(raw) as Parameters<typeof findMarkers>[0])
    if (markers.length === 0) return null
    const signing = digest === null ? undefined : markers.find((m) => m.digest === digest)
    const shown = signing ?? markers[markers.length - 1]!
    return { by: shown.by, at: shown.at, digest: shown.digest, signsCurrent: signing !== undefined }
  } catch {
    // No network, no token, or no such issue. Treat as unapproved: the failure mode of a
    // status command that guesses "approved" is somebody writing code before the gate.
    return null
  }
}

// ---------------------------------------------------------------------------
// Rendering
// ---------------------------------------------------------------------------

const OWNER_BANNER: Record<Owner, string> = {
  you: '▸ WAITING ON YOU',
  agent: '▸ waiting on an agent',
  nobody: '▸ nothing outstanding',
}

export function renderStory(branchName: string, f: StoryFacts, s: StoryStatus): string {
  const out: string[] = ['', `  ${branchName}`, '']
  const actor = s.owner === 'agent' && s.actor !== null ? ` — ${s.actor}` : ''
  out.push(`  Stage ${s.stage} — ${s.stageName}`)
  out.push(`  ${OWNER_BANNER[s.owner]}${s.owner === 'agent' ? actor : ''}`)
  out.push('')
  for (const line of wrap(s.blocker, 76)) out.push(`  ${line}`)
  out.push('')
  const width = Math.max(...s.actions.map((a) => a.label.length))
  for (const a of s.actions) out.push(`    ${a.label.padEnd(width)}  ${a.command}`)
  out.push('')
  out.push(`    Then      ${s.next}`)
  if (s.unobservable !== null) {
    out.push('')
    for (const line of wrap(`Status cannot see: ${s.unobservable}`, 76)) out.push(`  ${line}`)
  }
  out.push('')
  out.push(`  Derived from: change folder ${f.change === null ? 'absent' : f.change.dir}` +
    (f.change === null ? '' : `, validates=${f.change.validates}, scenarios ${f.change.scenarios.covered}/${f.change.scenarios.total}, tasks ${f.change.tasks.done}/${f.change.tasks.total}`) +
    `, G4 ${f.approval === null ? 'absent' : `by ${f.approval.by}${f.approval.signsCurrent ? '' : ' (stale)'}`}` +
    `, PR ${f.pr === null ? 'none' : `#${f.pr.number}${f.pr.draft ? ' (draft)' : ''}${f.pr.behindMain === null ? '' : `, ${f.pr.behindMain} behind main`}`}`)
  out.push('')
  return out.join('\n')
}

function wrap(text: string, width: number): string[] {
  const words = text.split(/\s+/)
  const lines: string[] = []
  let line = ''
  for (const w of words) {
    if (line === '') line = w
    else if (line.length + 1 + w.length <= width) line += ` ${w}`
    else {
      lines.push(line)
      line = w
    }
  }
  if (line !== '') lines.push(line)
  return lines
}

/**
 * `git worktree list --porcelain` prints a stanza per worktree: a `worktree <path>` line and,
 * unless it is detached, a `branch refs/heads/<name>` line. Mapping branch to path is what lets
 * the tree print `cd <path>` for a Story someone has already taken a worktree for, instead of a
 * checkout git would refuse — a branch checked out elsewhere cannot be checked out here.
 */
export function parseWorktrees(porcelain: string): Map<string, string> {
  const found = new Map<string, string>()
  let path: string | null = null
  for (const line of porcelain.split('\n')) {
    if (line.startsWith('worktree ')) path = line.slice('worktree '.length)
    else if (line.startsWith('branch refs/heads/') && path !== null) {
      found.set(line.slice('branch refs/heads/'.length), path)
    } else if (line === '') path = null
  }
  return found
}

/**
 * Off a story branch there is no single Story to report on, so the question becomes "what is
 * outstanding across the tracker, and which of it is mine?". Derived from issue state and the
 * sub-issue edges alone — one GraphQL request, no per-issue calls — because a session starting
 * on `main` wants the shape of the work, not the detail of one Story.
 */
export function renderTree(
  issues: GraphIssue[],
  branches: ReadonlySet<string> = new Set(),
  worktrees: ReadonlyMap<string, string> = new Map(),
  backlog: Backlog | null = null,
): string {
  const open = issues.filter((i) => i.state === 'OPEN' && i.type !== null)
  const kids = (n: number) => issues.filter((i) => i.parent === n)
  const openKids = (n: number) => kids(n).filter((i) => i.state === 'OPEN')

  const out: string[] = ['', '  Not on a story branch — here is what is outstanding.', '']

  const waiting: string[] = []

  if (open.length === 0) {
    out.push('  No open Epic, Feature or Story. The next step is an Epic, and it starts with you.', '')
    out.push(...renderBacklog(backlog, waiting))
    out.push(...renderWaiting(waiting))
    return out.join('\n')
  }

  for (const epic of open.filter((i) => i.type === 'Epic')) {
    out.push(`  Epic #${epic.number} — ${epic.title.replace(/^EPIC:\s*/i, '')}`)
    const features = kids(epic.number).filter((i) => i.type === 'Feature')
    if (features.length === 0) {
      out.push('    (no Feature yet — G1 is yours: name one capability and its slug)')
      waiting.push(`define a Feature under Epic #${epic.number}`)
    }
    for (const feat of features) {
      const stories = kids(feat.number).filter((i) => i.type === 'Task')
      const live = stories.filter((s) => s.state === 'OPEN')
      const state =
        stories.length === 0
          ? 'no Story yet — G2 is yours: decompose it'
          : live.length === 0
            ? 'every Story closed — ready to close'
            : `${live.length} Story(ies) in flight`
      out.push(`    Feature #${feat.number} — ${feat.title.replace(/^FEAT:\s*/i, '')}  [${state}]`)
      if (stories.length === 0) waiting.push(`decompose Feature #${feat.number} into Stories`)
      for (const s of live) {
        // Every branch is worked in its own worktree (hard rule 8), so none of these commands
        // is a `git checkout` in this clone. Three cases: the worktree exists and you walk to
        // it; the branch exists without one, which is a worktree waiting to be re-attached;
        // or neither exists, which is the Stage 4 cut. Commands in docs/story-mechanics.md.
        const branch = `story/${s.number}-${s.title}`
        const dir = `../daybyday-${s.title}`
        const path = worktrees.get(branch)
        out.push(`      Story #${s.number} — ${s.title}`)
        out.push(
          path !== undefined
            ? `        cd ${path} && pnpm run status`
            : branches.has(branch)
              ? `        git worktree add ${dir} ${branch} && cd ${dir} && pnpm install`
              : `        git fetch origin && git worktree add ${dir} -b ${branch} origin/main && cd ${dir} && git branch --unset-upstream && pnpm install`,
        )
      }
    }
    if (openKids(epic.number).length === 0 && kids(epic.number).length > 0) {
      out.push('    (every Feature closed — this Epic is ready to close)')
    }
    out.push('')
  }

  out.push(...renderBacklog(backlog, waiting))
  out.push(...renderWaiting(waiting))
  return out.join('\n')
}

function renderWaiting(waiting: readonly string[]): string[] {
  if (waiting.length === 0) return []
  return ['  ▸ WAITING ON YOU', ...waiting.map((w) => `      ${w}`), '']
}

/**
 * The backlog, as one block under the tree.
 *
 * It is here rather than on a story branch because it answers the same question the tree does
 * — what is outstanding, and which of it is mine — for the half of the work that has no issue
 * yet. Printing it beside an open Story would be noise: a Story in flight is not the moment to
 * be told a want has gone stale.
 *
 * **A stale want is put in WAITING ON YOU deliberately.** ADR-1010's whole finding was that the
 * parking lot's staleness rule never ran because nothing surfaced it. A count that appears only
 * when you remember to run `/atlas backlog` reproduces exactly that failure one level up.
 */
function renderBacklog(backlog: Backlog | null, waiting: string[]): string[] {
  if (backlog === null) return []

  const { wants, decided, passes, lastPass, fresh, stale } = backlog
  const groomed = passes.length === 0 ? 'never groomed' : `${passes.length} pass(es), last ${lastPass}`

  if (wants.length === 0) {
    return [`  Backlog — empty, ${decided} decided (${groomed})`, '', '      /atlas idea <want>', '']
  }

  const out = [`  Backlog — ${wants.length} want(s), ${decided} decided (${groomed})`]
  // With no pass behind it every want is "fresh", which the count above has already said.
  if (lastPass !== null && fresh.length > 0) {
    out.push(`      ${fresh.length} captured since ${lastPass}: ${ids(fresh)}`)
  }
  if (stale.length > 0) {
    out.push(`      ${stale.length} survived two passes — promote or drop: ${ids(stale)}`)
    waiting.push(`groom the backlog — ${stale.length} want(s) have survived two passes: ${ids(stale)}`)
  }
  out.push('', '      /atlas backlog', '')
  return out
}

/** Ids, truncated: a status line is a prompt to open the file, not a substitute for reading it. */
function ids(wants: readonly Want[]): string {
  const shown = wants.slice(0, 6).map((w) => w.id)
  return wants.length > shown.length ? `${shown.join(', ')} +${wants.length - shown.length} more` : shown.join(', ')
}

// ---------------------------------------------------------------------------

if (import.meta.filename === process.argv[1]) {
  const asJson = process.argv.includes('--json')
  const branch = parseBranch(currentBranch())

  if (branch.kind === 'story') {
    const loc = locateChange(branch.changeId)
    const facts: StoryFacts = {
      issue: branch.issue,
      changeId: branch.changeId,
      change: loc === null ? null : gatherChange(loc),
      approval: gatherApproval(repoSlug(), branch.issue, loc === null ? null : changeDigest(loc.dir)),
      pr: gatherPr(branch.raw),
    }
    const status = deriveStoryStatus(facts)
    console.log(asJson ? JSON.stringify({ branch: branch.raw, facts, status }, null, 2) : renderStory(branch.raw, facts, status))
    process.exit(0)
  }

  const issues = fetchIssues(repoSlug())
  const branches = new Set(
    git(['for-each-ref', '--format=%(refname:short)', 'refs/heads'])
      .split('\n')
      .filter((b) => b !== ''),
  )
  const worktrees = parseWorktrees(git(['worktree', 'list', '--porcelain']))
  const backlog = readBacklog(git(['rev-parse', '--show-toplevel']))
  console.log(
    asJson
      ? JSON.stringify({ branch: branch.raw, issues, branches: [...branches], worktrees: [...worktrees], backlog }, null, 2)
      : renderTree(issues, branches, worktrees, backlog),
  )
}
