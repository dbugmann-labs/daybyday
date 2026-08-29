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
 */
import { execFileSync } from 'node:child_process'
import { mkdtempSync, readFileSync, readdirSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import path from 'node:path'
import { currentBranch, deltaCapabilities, fail, inCI, locateChange, note, parseBranch, pass, skip } from './lib/ci.ts'
import { SWIFT_SKIP_DIRS, swiftTestTitles } from './lib/swift-tests.ts'

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

type Scenario = { title: string; source: string }
const scenarios: Scenario[] = []

for (const capability of deltaCapabilities(loc)) {
  const dir = path.join(loc.dir, 'specs', capability)
  for (const entry of readdirSync(dir, { recursive: true, withFileTypes: true })) {
    if (!entry.isFile() || !entry.name.endsWith('.md')) continue
    const file = path.join(entry.parentPath, entry.name)
    for (const line of readFileSync(file, 'utf8').split('\n')) {
      const m = /^####\s+Scenario:\s*(.+?)\s*$/.exec(line)
      if (m) scenarios.push({ title: m[1]!, source: file })
    }
  }
}

if (scenarios.length === 0) {
  skip(CHECK, `delta for "${branch.changeId}" declares no scenarios`)
  process.exit(0)
}

/** Leaf titles vitest reports, which is every TypeScript test title in the repo. */
function vitestTitles(): string[] {
  const tmp = mkdtempSync(path.join(tmpdir(), 'atlas-scenarios-'))
  const out = path.join(tmp, 'tests.json')
  try {
    execFileSync('pnpm', ['exec', 'vitest', 'list', `--json=${out}`], { stdio: 'ignore' })
    const listed = JSON.parse(readFileSync(out, 'utf8')) as { name: string; file: string }[]
    return listed.map((t) => t.name.split(' > ').at(-1)!)
  } finally {
    rmSync(tmp, { recursive: true, force: true })
  }
}

/**
 * Every `.swift` file in the working tree. The Swift package's location is not
 * pinned here on purpose — no Swift exists yet, and guessing a layout now would
 * put a second, weaker definition of it in a check rather than in the package
 * manifest where it belongs.
 */
function swiftSources(dir: string): string[] {
  const found: string[] = []
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name)
    if (entry.isDirectory()) {
      if (!SWIFT_SKIP_DIRS.has(entry.name)) found.push(...swiftSources(full))
    } else if (entry.name.endsWith('.swift')) found.push(full)
  }
  return found
}

const swiftFiles = swiftSources('.')
const swiftTitles = swiftFiles.flatMap((f) => swiftTestTitles(readFileSync(f, 'utf8')))
const tsTitles = vitestTitles()

const titles = new Set([...tsTitles, ...swiftTitles])
const seen = `${tsTitles.length} TypeScript, ${swiftTitles.length} Swift across ${swiftFiles.length} .swift file(s)`
const missing = scenarios.filter((s) => !titles.has(s.title))

const covered = scenarios.length - missing.length

// Locally, a part-covered delta is the expected state: hard rule 3 says one scenario per
// red-green cycle. Failing here would push toward transcribing every scenario at once, which
// is the horizontal slicing that rule exists to prevent. In CI the change is finished, so it binds.
if (missing.length > 0 && !inCI) {
  note(CHECK, `${covered}/${scenarios.length} scenario(s) covered — next: "${missing[0]!.title}"`)
  process.exit(0)
}

if (missing.length > 0) {
  fail(CHECK, [
    `${missing.length} of ${scenarios.length} scenario(s) have no test with a matching title:`,
    '',
    ...missing.map((s) => `missing: "${s.title}"\n    from: ${s.source}`),
    '',
    'An acceptance test title must equal its scenario title verbatim.',
    'In Swift that is the @Test("...") display name; in TypeScript the leaf it() title.',
    'Take these one at a time — one scenario per red-green cycle (AGENTS.md rule 3).',
    `Tests seen: ${seen}`,
  ])
}

pass(CHECK, `all ${scenarios.length} scenario(s) have a matching test (${seen})`)
