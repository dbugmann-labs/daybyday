/**
 * Scenario and acceptance-test discovery, shared by CI check 4 and `pnpm run status`.
 *
 * Both answer the same question — which `#### Scenario:` in a change's delta has a test
 * carrying its title verbatim — and they must answer it identically. Check 4 blocks a merge
 * on it; status tells a human how far through a Story they are. Two definitions of "covered"
 * would let status report a Story finished that CI then rejects, which is precisely the kind
 * of double bookkeeping docs/process.md §1 exists to prevent.
 *
 * The reasoning behind reading Swift titles from source and TypeScript titles from `vitest
 * list` lives in scripts/check-scenario-coverage.ts and scripts/lib/swift-tests.ts.
 */
import { execFileSync } from 'node:child_process'
import { mkdtempSync, readFileSync, readdirSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import path from 'node:path'

import { deltaCapabilities, type ChangeLocation } from './ci.ts'
import { SWIFT_SKIP_DIRS, swiftTestTitles } from './swift-tests.ts'

export type Scenario = { title: string; source: string }

/** Every `#### Scenario:` heading in a change's delta, in file then document order. */
export function deltaScenarios(loc: ChangeLocation): Scenario[] {
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
  return scenarios
}

/**
 * Every `.swift` file in the working tree. The Swift package's location is not pinned here on
 * purpose — no Swift exists yet, and guessing a layout now would put a second, weaker
 * definition of it in a check rather than in the package manifest where it belongs.
 */
export function swiftSources(dir: string): string[] {
  const found: string[] = []
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name)
    if (entry.isDirectory()) {
      if (!SWIFT_SKIP_DIRS.has(entry.name)) found.push(...swiftSources(full))
    } else if (entry.name.endsWith('.swift')) found.push(full)
  }
  return found
}

/** Leaf titles vitest reports, which is every TypeScript test title in the repo. */
export function vitestTitles(): string[] {
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

export type TestTitles = { titles: Set<string>; seen: string }

/** Acceptance-test titles from both languages, unioned, with a line describing what was read. */
export function acceptanceTestTitles(): TestTitles {
  const swiftFiles = swiftSources('.')
  const swift = swiftFiles.flatMap((f) => swiftTestTitles(readFileSync(f, 'utf8')))
  const ts = vitestTitles()
  return {
    titles: new Set([...ts, ...swift]),
    seen: `${ts.length} TypeScript, ${swift.length} Swift across ${swiftFiles.length} .swift file(s)`,
  }
}

export type Coverage = { total: number; covered: number; missing: Scenario[]; seen: string }

/** How much of a change's delta already has name-matched acceptance tests. */
export function scenarioCoverage(loc: ChangeLocation): Coverage {
  const scenarios = deltaScenarios(loc)
  const { titles, seen } = acceptanceTestTitles()
  const missing = scenarios.filter((s) => !titles.has(s.title))
  return { total: scenarios.length, covered: scenarios.length - missing.length, missing, seen }
}
