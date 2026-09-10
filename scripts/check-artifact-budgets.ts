/**
 * Artifact budgets — advisory (ADR-1047, docs/research/2026-09-09-concise-specs.md).
 *
 * This repo is adopting length budgets for a Story's own artifacts — proposal.md, design.md,
 * tasks.md, and the prose of every delta requirement — so that a human reading a change folder
 * at a gate is reading something sized for a 4–8 hour week, not a document that grew because
 * nothing measured it. The budgets themselves live in `openspec/config.yaml`'s `rules`, where
 * `spec-author` reads them while drafting. That file is prose for an agent, not a machine-
 * readable contract: the OpenSpec CLI never parses `rules` back out to enforce it, so nothing
 * there catches an overrun after the fact. The numbers below are duplicated from it on purpose,
 * because this is the only place that can check them once the artifact is written. Keep the two
 * in sync by hand — nothing currently asserts they agree.
 *
 * This never blocks. A budget is a shape to notice, not a rule the pipeline is trusted to have
 * gotten right yet, so a change over budget still proposes, still gates at G4, still merges.
 * Unlike the other checks in `scripts/`, this one is not one of docs/process.md §7's numbered
 * CI checks and carries no failure mode at all — it always exits 0, in CI and locally alike.
 */
import { existsSync, readFileSync, readdirSync } from 'node:fs'
import path from 'node:path'

import { currentBranch, deltaCapabilities, locateChange, parseBranch, skip, type ChangeLocation } from './lib/ci.ts'
import { deltaScenarios } from './lib/coverage.ts'

const CHECK = 'artifact budgets'

const REQUIREMENT_WORDS_MAX = 150
const REQUIREMENT_WORDS_THIN = 40
const PROPOSAL_LINES_MAX = 60
const DESIGN_LINES_MAX = 150
const TASKS_BASE_LINES = 80

/** One line per overrun — same one-line shape as pass/skip/note, flagged as a warning. */
function warn(check: string, detail: string): void {
  console.log(`⚠ ${check} — ${detail}`)
}

function lineCount(text: string): number {
  return text.split('\n').length
}

function wordCount(text: string): number {
  const trimmed = text.trim()
  return trimmed === '' ? 0 : trimmed.split(/\s+/).length
}

/** Warns once if `file`, relative to the change folder, is over `budget` lines. Missing files are silent — this check only measures what was written. */
function checkLines(dir: string, file: string, budget: number, note: string): number {
  const full = path.join(dir, file)
  if (!existsSync(full)) return 0
  const lines = lineCount(readFileSync(full, 'utf8'))
  if (lines <= budget) return 0
  warn(CHECK, `${file}: ${lines} lines, budget ${budget}${note}`)
  return 1
}

type RequirementBlock = { title: string; source: string; words: number; scenarioCount: number }

/**
 * Every `### Requirement:` block in the delta, with the word count of its prose — everything
 * between the heading and the first `#### Scenario:` under it — and how many scenarios the
 * whole block carries, which decides whether a short block is "thin" or simply small.
 */
function deltaRequirementBlocks(loc: ChangeLocation): RequirementBlock[] {
  const blocks: RequirementBlock[] = []
  for (const capability of deltaCapabilities(loc)) {
    const dir = path.join(loc.dir, 'specs', capability)
    if (!existsSync(dir)) continue
    for (const entry of readdirSync(dir, { recursive: true, withFileTypes: true })) {
      if (!entry.isFile() || !entry.name.endsWith('.md')) continue
      const file = path.join(entry.parentPath, entry.name)
      const lines = readFileSync(file, 'utf8').split('\n')
      let i = 0
      while (i < lines.length) {
        const heading = /^###\s+Requirement:\s*(.+?)\s*$/.exec(lines[i]!)
        if (!heading) {
          i++
          continue
        }
        const title = heading[1]!
        let j = i + 1
        let firstScenario = -1
        let scenarioCount = 0
        while (j < lines.length && !/^###\s+Requirement:/.test(lines[j]!)) {
          if (/^####\s+Scenario:/.test(lines[j]!)) {
            if (firstScenario === -1) firstScenario = j
            scenarioCount++
          }
          j++
        }
        const proseLines = firstScenario === -1 ? lines.slice(i + 1, j) : lines.slice(i + 1, firstScenario)
        blocks.push({ title, source: file, words: wordCount(proseLines.join(' ')), scenarioCount })
        i = j
      }
    }
  }
  return blocks
}

const branch = parseBranch(currentBranch())
if (branch.kind !== 'story') {
  skip(CHECK, `branch "${branch.raw}" is not a story branch`)
  process.exit(0)
}

const loc = locateChange(branch.changeId)
if (loc === null) {
  skip(CHECK, `no change folder for "${branch.changeId}" — nothing to measure`)
  process.exit(0)
}

let warnings = 0

warnings += checkLines(loc.dir, 'proposal.md', PROPOSAL_LINES_MAX, '')

warnings += checkLines(loc.dir, 'design.md', DESIGN_LINES_MAX, '')

const scenarioCount = deltaScenarios(loc).length
warnings += checkLines(loc.dir, 'tasks.md', scenarioCount + TASKS_BASE_LINES, ` (${TASKS_BASE_LINES} + ${scenarioCount} scenario(s))`)

for (const block of deltaRequirementBlocks(loc)) {
  const rel = path.relative(loc.dir, block.source)
  if (block.words > REQUIREMENT_WORDS_MAX) {
    warn(CHECK, `${rel} — "${block.title}": ${block.words} words, budget ${REQUIREMENT_WORDS_MAX}`)
    warnings++
  } else if (block.words < REQUIREMENT_WORDS_THIN && block.scenarioCount > 1) {
    warn(CHECK, `${rel} — "${block.title}": ${block.words} words, thin (< ${REQUIREMENT_WORDS_THIN}) across ${block.scenarioCount} scenarios`)
    warnings++
  }
}

console.log(`${warnings} budget warning(s), advisory — see ADR-1047`)
process.exit(0)
