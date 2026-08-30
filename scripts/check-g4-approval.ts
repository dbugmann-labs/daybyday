/**
 * CI check 5 — G4 approval recorded (docs/process.md §4, ADR-0014, ADR-1007).
 *
 * G4 is the gate the whole requirement set rests on: no implementation before a human has
 * decided the proposal is right. A human need not type the comment — they may tell an agent
 * "approved" and have it relay — but the decision must be theirs, and it must be recorded on
 * the Story issue before the work merges.
 *
 * The marker is the exact line `G4: approved`, not the bare word. A bare "approved" appears
 * incidentally in ordinary prose, so any agent writing "waiting for the approved comment"
 * would forge a gate read by grep. The marker exists to be unforgeable by accident.
 *
 * It also carries an `approved-digest:` line, and this check recomputes it: the marker then
 * says what was approved, not merely that someone was asked. A change folder edited after the
 * gate — a scenario softened once it proved awkward — no longer merges under an approval that
 * covered different text (ADR-1007).
 *
 * This cannot prove a human made the decision — nothing can, since agents act through the
 * owner's token. It proves the decision was recorded, and now that it was recorded against
 * this text, which turns two silent omissions into a red build.
 */
import { execFileSync } from 'node:child_process'
import { currentBranch, fail, locateChange, parseBranch, pass, repoSlug, skip } from './lib/ci.ts'
import { changeDigest, findMarkers, markerBody, type IssueComment } from './lib/g4.ts'

const CHECK = 'G4 approval recorded'

const branch = parseBranch(currentBranch())
if (branch.kind !== 'story') {
  skip(CHECK, `branch "${branch.raw}" is not a story branch`)
  process.exit(0)
}

const located = locateChange(branch.changeId)
if (located === null) {
  fail(CHECK, [
    `No change folder for "${branch.changeId}", so there is nothing an approval could cover.`,
    'A story branch is cut at Stage 4, after the change folder is written and committed.',
  ])
}

const digest = changeDigest(located.dir)
const record = `gh issue comment ${branch.issue} --body '${markerBody(digest, '<name>')}'`

const repo = repoSlug()
let comments: IssueComment[]
try {
  const raw = execFileSync(
    'gh',
    ['api', '--paginate', `/repos/${repo}/issues/${branch.issue}/comments`],
    { encoding: 'utf8' },
  )
  comments = JSON.parse(raw) as IssueComment[]
} catch (err) {
  fail(CHECK, [
    `Could not read comments on issue #${branch.issue}.`,
    'CI needs `issues: read` permission and GH_TOKEN in the environment.',
    String(err),
  ])
}

const markers = findMarkers(comments)

if (markers.length === 0) {
  fail(CHECK, [
    `Issue #${branch.issue} carries no G4 approval.`,
    '',
    'A human must decide the proposal is right before this merges. Once they have, record it:',
    '',
    `  ${record}`,
    '',
    'Never write that marker on a Story issue for any other reason, and never originate the',
    'decision yourself. Relaying a human decision is fine; inventing one is forging the gate.',
  ])
}

const signed = markers.find((m) => m.digest === digest)

if (signed !== undefined) {
  pass(CHECK, `#${branch.issue} approved by ${signed.by} at ${signed.at}, digest ${digest}`)
  process.exit(0)
}

const undigested = markers.filter((m) => m.digest === null)

if (undigested.length === markers.length) {
  fail(CHECK, [
    `Issue #${branch.issue} is approved, but the marker predates the approval digest and so`,
    'records only that a human was asked — not what they were asked about (ADR-1007).',
    '',
    'Ask them to confirm the change folder as it now stands, then record it:',
    '',
    `  ${record}`,
  ])
}

fail(CHECK, [
  `${located.dir} has changed since it was approved.`,
  '',
  ...markers.map((m) => `  approved ${m.digest ?? '(no digest)'} by ${m.by} at ${m.at}`),
  `  on disk  ${digest}`,
  '',
  'The approval on the issue covers text that is no longer what would merge. Either revert the',
  'change folder to what was approved, or put the new version to the human and record their',
  'answer as a second marker:',
  '',
  `  ${record}`,
  '',
  'Do not record it yourself. The digest is what makes the marker worth something.',
])
