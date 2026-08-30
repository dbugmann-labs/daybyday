/**
 * CI check 4 — scenario coverage (docs/process.md §7 and §8).
 *
 * Every "#### Scenario:" in the change's delta must have an acceptance test
 * whose title matches it verbatim. Scenarios drive tests; they never generate
 * them. This runs only at PR time, when the change is finished, so it can never
 * push anyone into transcribing all scenarios into tests up front — which is
 * the horizontal slicing the tdd skill rightly calls an anti-pattern.
 *
 * The repository holds two languages doing unrelated jobs (ADR 1001): Swift for
 * the product, TypeScript for this tooling. A scenario is covered by a test in
 * either, so titles are gathered from both and unioned before matching.
 *
 * TypeScript titles come from `vitest list` rather than from grepping source,
 * so nesting and template literals are read the way vitest itself reads them.
 * Matching is on the leaf title, which lets acceptance tests sit inside a
 * describe() block.
 *
 * Swift titles are read from the source text instead, and `scripts/lib/swift-tests.ts`
 * explains at length why that is the sound choice there and not here. The short
 * version: no Swift tool reports the `@Test("...")` display name without going
 * through unpublished internals, and the compiler guarantees the display name
 * is a literal, so the text is the truth. It also means this check never builds
 * Swift and so keeps running on the Linux job.
 *
 * The discovery itself lives in `scripts/lib/coverage.ts`, shared with
 * `pnpm run status`, so that "covered" means one thing to the check that blocks
 * a merge and to the command that reports progress.
 */
import { currentBranch, fail, inCI, locateChange, note, parseBranch, pass, skip } from './lib/ci.ts'
import { scenarioCoverage } from './lib/coverage.ts'

const CHECK = 'scenario coverage'
const branch = parseBranch(currentBranch())

if (branch.kind !== 'story') {
  skip(CHECK, `branch "${branch.raw}" is not a story branch`)
  process.exit(0)
}

const loc = locateChange(branch.changeId)
if (loc === null) {
  fail(CHECK, [`No change folder for "${branch.changeId}".`])
}

const { total, covered, missing, seen } = scenarioCoverage(loc)

if (total === 0) {
  skip(CHECK, `delta for "${branch.changeId}" declares no scenarios`)
  process.exit(0)
}

// Locally, a part-covered delta is the expected state: hard rule 3 says one scenario per
// red-green cycle. Failing here would push toward transcribing every scenario at once, which
// is the horizontal slicing that rule exists to prevent. In CI the change is finished, so it binds.
if (missing.length > 0 && !inCI) {
  note(CHECK, `${covered}/${total} scenario(s) covered — next: "${missing[0]!.title}"`)
  process.exit(0)
}

if (missing.length > 0) {
  fail(CHECK, [
    `${missing.length} of ${total} scenario(s) have no test with a matching title:`,
    '',
    ...missing.map((s) => `missing: "${s.title}"\n    from: ${s.source}`),
    '',
    'An acceptance test title must equal its scenario title verbatim.',
    'In Swift that is the @Test("...") display name; in TypeScript the leaf it() title.',
    'Take these one at a time — one scenario per red-green cycle (AGENTS.md rule 3).',
    `Tests seen: ${seen}`,
  ])
}

pass(CHECK, `all ${total} scenario(s) have a matching test (${seen})`)
