/**
 * Runs a Story's walk: drives the simulator through the throwaway `WalkUITests.swift`, exports
 * one screenshot per step into `walk/`, and posts them to the PR. `pnpm run walk` runs and
 * exports; `pnpm run walk -- --post <pr-number>` also posts the comment. ADR-1053;
 * `docs/running-the-app.md` § *The walk* carries the same commands written out longhand, for
 * when this script is the thing that is broken.
 *
 * **The walk test is never committed.** It is one XCUITest method the implementer writes for
 * the Story, at `src/DayByDay/DayByDayUITests/WalkUITests.swift`, which attaches a screenshot
 * named for each box of `tasks.md` § *The walk*. This script refuses to run while anything else
 * in the worktree is uncommitted, because a failing run used to return only after Xcode had
 * collected a sysdiagnose — about ten minutes — and a session killed while it waited lost its
 * work. `-collect-test-diagnostics never` is what turns that wait off; measured 2026-09-15.
 *
 * **From a fresh install, every time.** The app is uninstalled from the simulator before the
 * run so the walk starts on the day-one roster and the same steps give the same pictures.
 *
 * **Posting needs `gh` 2.99.0 or later** for `--attach`, which is `~/.local/bin/gh` on this
 * machine (`AGENTS.md` § *This machine*); the Actions token is refused by that flag, which is
 * why the walk is run here and not in CI.
 */
import { execFileSync, spawnSync } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, copyFileSync } from 'node:fs'
import { homedir, tmpdir } from 'node:os'
import path from 'node:path'

const PROJECT = 'src/DayByDay/DayByDay.xcodeproj'
const SCHEME = 'DayByDay'
const BUNDLE_ID = 'com.dbugmann.daybyday'
const WALK_TEST = 'src/DayByDay/DayByDayUITests/WalkUITests.swift'
const OUT_DIR = 'walk'

function run(command: string, args: string[]): string {
  return execFileSync(command, args, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'inherit'] })
}

function fail(message: string): never {
  console.error(`walk: ${message}`)
  process.exit(1)
}

function gh(): string {
  const local = path.join(homedir(), '.local', 'bin', 'gh')
  return existsSync(local) ? local : 'gh'
}

const args = process.argv.slice(2)
const postAt = args.indexOf('--post')
const prNumber = postAt >= 0 ? args[postAt + 1] : undefined
if (postAt >= 0 && !/^\d+$/.test(prNumber ?? '')) fail('--post takes a PR number')

if (!existsSync(WALK_TEST)) fail(`${WALK_TEST} is not there — write the walk first`)

const dirty = run('git', ['status', '--porcelain'])
  .split('\n')
  .filter((line) => line.trim() !== '')
  .map((line) => line.slice(3))
  .filter((file) => file !== WALK_TEST && file !== `${OUT_DIR}/`)
if (dirty.length > 0) {
  fail(`commit before the run — uncommitted besides the walk test:\n  ${dirty.join('\n  ')}`)
}

const started = Date.now()
const seconds = () => `${Math.round((Date.now() - started) / 1000)}s`

// Discovered, not named: the same choice CI's ui-smoke job makes, newest runtime first, an
// already-booted iPhone preferred.
type Device = { name: string; udid: string; state: string }
const devices = JSON.parse(run('xcrun', ['simctl', 'list', 'devices', 'available', '--json'])).devices as Record<string, Device[]>
const iphones = Object.keys(devices)
  .sort()
  .reverse()
  .flatMap((runtime) => (devices[runtime] ?? []).filter((d) => d.name.startsWith('iPhone')))
const device = iphones.find((d) => d.state === 'Booted') ?? iphones[0]
if (!device) fail('no iPhone simulator is available — docs/running-the-app.md § Once, before the first run')
console.log(`walk: ${device.name} (${device.udid})`)

run('xcrun', ['simctl', 'bootstatus', device.udid, '-b'])
spawnSync('xcrun', ['simctl', 'uninstall', device.udid, BUNDLE_ID], { stdio: 'ignore' })
console.log(`walk: booted and uninstalled, ${seconds()}`)

const destination = `platform=iOS Simulator,id=${device.udid}`
const scratch = mkdtempSync(path.join(tmpdir(), 'daybyday-walk-'))
const bundle = path.join(scratch, 'walk.xcresult')
const log = path.join(scratch, 'xcodebuild.log')

function xcodebuild(step: string, xcodebuildArgs: string[]): boolean {
  const result = spawnSync('xcodebuild', xcodebuildArgs, { encoding: 'utf8', maxBuffer: 256 * 1024 * 1024 })
  const output = `${result.stdout ?? ''}${result.stderr ?? ''}`
  const lines = output.split('\n').filter((line) => /error:|Test Case|TEST /.test(line))
  console.log(lines.map((line) => `  ${line}`).join('\n'))
  console.log(`walk: ${step} ${result.status === 0 ? 'ok' : 'failed'}, ${seconds()} — full log ${log}`)
  execFileSync('sh', ['-c', `cat >> "${log}"`], { input: output })
  return result.status === 0
}

if (
  !xcodebuild('build-for-testing', [
    'build-for-testing',
    '-project', PROJECT,
    '-scheme', SCHEME,
    '-destination', destination,
    '-only-testing:DayByDayUITests',
    '-enableCodeCoverage', 'NO',
    'COMPILER_INDEX_STORE_ENABLE=NO',
  ])
) {
  fail('the build failed; the walk test or the app does not compile')
}

const passed = xcodebuild('test-without-building', [
  'test-without-building',
  '-project', PROJECT,
  '-scheme', SCHEME,
  '-destination', destination,
  '-only-testing:DayByDayUITests/WalkUITests',
  '-parallel-testing-enabled', 'NO',
  '-enableCodeCoverage', 'NO',
  '-collect-test-diagnostics', 'never',
  '-resultBundlePath', bundle,
])

// Export whatever was captured, passed or not: on a failure the pictures up to the step that
// could not be driven are the evidence.
const exported = path.join(scratch, 'attachments')
run('xcrun', ['xcresulttool', 'export', 'attachments', '--path', bundle, '--output-path', exported, '--filter', '*.png'])
type Attachment = { exportedFileName: string; suggestedHumanReadableName: string; timestamp: number }
const manifest = JSON.parse(readFileSync(path.join(exported, 'manifest.json'), 'utf8')) as { attachments: Attachment[] }[]
const attachments = manifest.flatMap((test) => test.attachments).sort((a, b) => a.timestamp - b.timestamp)

rmSync(OUT_DIR, { recursive: true, force: true })
mkdirSync(OUT_DIR)
const pictures = attachments.map((attachment) => {
  // `xcresulttool` appends `_0_<uuid>.png` to the attachment's own name.
  const name = attachment.suggestedHumanReadableName.replace(/_\d+_[0-9A-F-]+\.png$/i, '')
  // A box line may carry a colon or a slash; neither belongs in a file name.
  const file = path.join(OUT_DIR, `${name.replace(/[/:]/g, '-')}.png`)
  copyFileSync(path.join(exported, attachment.exportedFileName), file)
  return { name, file }
})
console.log(`walk: ${pictures.length} picture(s) in ${OUT_DIR}/, ${seconds()}`)
for (const picture of pictures) console.log(`  ${picture.file}`)

if (!passed) fail('a step could not be driven — the runner\'s own error is above; that is a stop, not a retry')
if (pictures.length === 0) fail('the walk passed and attached nothing — no shot() call ran')

const sha = run('git', ['rev-parse', '--short', 'HEAD']).trim()
const body = `The walk — ${pictures.length} pictures from a fresh install on ${device.name}, at ${sha}.`
const attachArgs = pictures.flatMap((picture) => ['--attach', `${picture.file}#${picture.name}`])
if (prNumber) {
  run(gh(), ['pr', 'comment', prNumber, '--body', body, ...attachArgs])
  const url = run(gh(), ['api', `repos/{owner}/{repo}/issues/${prNumber}/comments`, '--jq', '.[-1].html_url']).trim()
  console.log(`walk: posted ${url}`)
} else {
  console.log('walk: to post them, run again with -- --post <pr-number>, or:')
  console.log(`  ${gh()} pr comment <pr> --body '${body}' ${attachArgs.map((a) => (a.startsWith('--') ? a : `'${a}'`)).join(' ')}`)
}
