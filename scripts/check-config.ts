/**
 * `openspec/config.yaml` says what it means to say — structural, plus budget drift (ADR-1047).
 *
 * That file is the only channel by which this repo's artifact budgets reach `spec-author`: the
 * CLI injects `context` into every artifact's instructions and `rules.<artifact>` into that one
 * artifact's, and `/opsx:propose`, `/opsx:update`, `/opsx:apply` and `/opsx:archive` all read
 * what comes back. Nothing validates it. `openspec validate --all --strict` exits 0 on a config
 * whose rules are silently gone, because it validates changes and specs, not the config, and the
 * CLI's own two complaints reach stderr of `openspec instructions` — a subagent's scrollback that
 * no human reads. Both failures were reproduced against `@fission-ai/openspec` 1.10.0:
 *
 * - **A list entry that is not a string.** A bare `word: word` under `rules.<artifact>` is a YAML
 *   mapping, and the CLI drops that artifact's rules — *all* of them, the valid siblings in the
 *   same list included — warning `Rules for '<artifact>' must be an array of strings, ignoring
 *   this artifact's rules`. The other artifacts render normally, so the file looks healthy.
 * - **An artifact id that matches no artifact.** `spec:` for `specs:` costs the whole specs
 *   ruleset with no effect anywhere a human looks.
 *
 * Either one means `spec-author` drafts under no budget at all while every other signal stays
 * green, so they exit 1 here rather than warn. Budget *drift* — a number in `scripts/lib/budgets.ts`
 * that no longer appears in the rule stating it — only warns: which copy is wrong is a judgement,
 * and ADR-1047 is explicit that this apparatus stops short of blocking a merge over a count.
 *
 * Parsed with `yaml`, the same parser and the same version range the CLI itself uses, so this
 * check cannot disagree with the tool about what the file says.
 */
import { existsSync, readFileSync } from 'node:fs'
import path from 'node:path'

import { parse as parseYaml } from 'yaml'

import {
  DESIGN_LINES_MAX,
  PROPOSAL_LINES_MAX,
  REQUIREMENT_WORDS_MAX,
  REQUIREMENT_WORDS_THIN,
  TASKS_BASE_LINES,
} from './lib/budgets.ts'
import { fail, note, pass } from './lib/ci.ts'

const CHECK = 'openspec config'

/** The CLI's own ceiling on `context`, from `MAX_CONTEXT_SIZE` in its `project-config.js`. */
const MAX_CONTEXT_BYTES = 50 * 1024

/** Operation ids the CLI accepts under `operations`, from its `OPERATION_IDS`. */
const OPERATION_IDS = ['apply', 'archive']

/**
 * Each budget as it must read in the rule that states it. The pattern is deliberately coupled to
 * the wording: it is the coupling that makes a silent edit to one copy visible in the other.
 */
const BUDGET_WORDINGS: { artifact: string; label: string; pattern: RegExp }[] = [
  { artifact: 'proposal', label: `proposal.md ${PROPOSAL_LINES_MAX} lines`, pattern: new RegExp(`\\b${PROPOSAL_LINES_MAX} lines\\b`) },
  { artifact: 'design', label: `design.md ${DESIGN_LINES_MAX} lines`, pattern: new RegExp(`\\b${DESIGN_LINES_MAX} lines\\b`) },
  { artifact: 'tasks', label: `tasks.md ${TASKS_BASE_LINES} lines`, pattern: new RegExp(`\\b${TASKS_BASE_LINES} lines\\b`) },
  {
    artifact: 'specs',
    label: `requirement prose ${REQUIREMENT_WORDS_THIN} to ${REQUIREMENT_WORDS_MAX} words`,
    pattern: new RegExp(`\\b${REQUIREMENT_WORDS_THIN} to ${REQUIREMENT_WORDS_MAX}\\b`),
  },
]

function configPath(): string | null {
  for (const name of ['config.yaml', 'config.yml']) {
    const candidate = path.join('openspec', name)
    if (existsSync(candidate)) return candidate
  }
  return null
}

/**
 * Artifact ids of the configured schema, read from the schema itself rather than hardcoded, so a
 * forked or project-local schema is checked against its own artifacts. Returns null when the
 * schema cannot be located, which downgrades the unknown-key check rather than inventing ids.
 */
function artifactIds(schema: string): string[] | null {
  const candidates = [
    path.join('openspec', 'schemas', schema, 'schema.yaml'),
    path.join('node_modules', '@fission-ai', 'openspec', 'schemas', schema, 'schema.yaml'),
  ]
  for (const candidate of candidates) {
    if (!existsSync(candidate)) continue
    const parsed: unknown = parseYaml(readFileSync(candidate, 'utf8'))
    const artifacts = (parsed as { artifacts?: unknown })?.artifacts
    if (!Array.isArray(artifacts)) continue
    const ids = artifacts.map((a: unknown) => (a as { id?: unknown })?.id).filter((id): id is string => typeof id === 'string')
    if (ids.length > 0) return ids
  }
  return null
}

const file = configPath()
if (file === null) {
  fail(CHECK, ['No openspec/config.yaml (or .yml).', 'Every artifact budget reaches spec-author through that file; without it there are none.'])
}

const raw = readFileSync(file, 'utf8')
let parsed: unknown
try {
  parsed = parseYaml(raw)
} catch (error) {
  fail(CHECK, [`${file} is not valid YAML.`, error instanceof Error ? error.message.split('\n')[0]! : String(error)])
}

if (parsed === null || typeof parsed !== 'object' || Array.isArray(parsed)) {
  fail(CHECK, [`${file} does not parse to a YAML mapping.`])
}
const config = parsed as Record<string, unknown>

const problems: string[] = []

const schema = config['schema']
if (typeof schema !== 'string' || schema.trim() === '') {
  problems.push('schema: missing or not a non-empty string — the CLI falls back to its built-in default.')
}

const context = config['context']
if (context !== undefined) {
  if (typeof context !== 'string') {
    problems.push('context: not a string — the CLI ignores it, and every artifact loses it.')
  } else {
    const bytes = Buffer.byteLength(context, 'utf8')
    if (bytes > MAX_CONTEXT_BYTES) {
      problems.push(`context: ${(bytes / 1024).toFixed(1)}KB, over the CLI's ${MAX_CONTEXT_BYTES / 1024}KB ceiling — it is dropped whole.`)
    }
  }
}

/** Rule text per artifact, for the drift pass. Only populated for artifacts that parsed cleanly. */
const ruleText = new Map<string, string>()

const rules = config['rules']
if (rules === undefined) {
  problems.push('rules: absent — no artifact carries a budget.')
} else if (rules === null || typeof rules !== 'object' || Array.isArray(rules)) {
  problems.push('rules: not a mapping — the CLI ignores the whole block.')
} else {
  const known = typeof schema === 'string' ? artifactIds(schema) : null
  if (known === null) {
    note(CHECK, `schema "${String(schema)}" not found on disk; artifact ids unchecked`)
  }
  for (const [artifact, value] of Object.entries(rules as Record<string, unknown>)) {
    if (known !== null && !known.includes(artifact)) {
      problems.push(`rules.${artifact}: matches no artifact in schema "${String(schema)}" (${known.join(', ')}) — these rules reach nothing.`)
      continue
    }
    if (!Array.isArray(value)) {
      problems.push(`rules.${artifact}: not a list — the CLI ignores this artifact's rules.`)
      continue
    }
    const offenders = value.map((entry, i) => ({ entry, i })).filter(({ entry }) => typeof entry !== 'string')
    if (offenders.length > 0) {
      const where = offenders.map(({ i }) => `#${i + 1}`).join(', ')
      problems.push(
        `rules.${artifact}: ${offenders.length} entr${offenders.length === 1 ? 'y is' : 'ies are'} not a string (${where}) — ` +
          `the CLI drops ALL ${value.length} of this artifact's rules. A bare "word: word" is a YAML mapping; fold it with >- or quote it.`
      )
      continue
    }
    ruleText.set(artifact, (value as string[]).join('\n'))
  }
}

const operations = config['operations']
if (operations !== undefined) {
  if (operations === null || typeof operations !== 'object' || Array.isArray(operations)) {
    problems.push('operations: not a mapping — the CLI ignores the whole block.')
  } else {
    for (const [id, value] of Object.entries(operations as Record<string, unknown>)) {
      if (!OPERATION_IDS.includes(id)) {
        problems.push(`operations.${id}: not an operation the CLI knows (${OPERATION_IDS.join(', ')}) — this guidance reaches nothing.`)
        continue
      }
      if (value === null || typeof value !== 'object' || Array.isArray(value)) {
        problems.push(`operations.${id}: not a mapping — the CLI ignores it.`)
        continue
      }
      const guidance = (value as Record<string, unknown>)['guidance']
      if (guidance === undefined) continue
      if (!Array.isArray(guidance) || guidance.some((entry) => typeof entry !== 'string')) {
        problems.push(`operations.${id}.guidance: not a list of strings — the CLI ignores this operation's guidance.`)
      }
    }
  }
}

if (problems.length > 0) {
  fail(CHECK, [`${file} — ${problems.length} problem(s):`, '', ...problems.map((p) => `• ${p}`)])
}

let drift = 0
for (const { artifact, label, pattern } of BUDGET_WORDINGS) {
  const text = ruleText.get(artifact)
  if (text === undefined) continue
  if (!pattern.test(text)) {
    console.log(`⚠ ${CHECK} — rules.${artifact} no longer states ${label} (scripts/lib/budgets.ts); one of the two has drifted`)
    drift++
  }
}

pass(CHECK, `${file} parses, ${ruleText.size} artifact ruleset(s) reach the CLI`)
if (drift > 0) console.log(`${drift} budget drift warning(s), advisory — see ADR-1047`)
process.exit(0)
