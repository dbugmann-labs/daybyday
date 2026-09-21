/**
 * Runs a Story's walk: drives the simulator through the throwaway `WalkUITests.swift`, exports
 * one screenshot per step into `walk/`, and posts them to the PR. `pnpm run walk` runs and
 * exports; `pnpm run walk -- --post <pr-number>` also posts the comment, and
 * `pnpm run walk -- --post-only <pr-number>` posts what an earlier run left in `walk/` without
 * running again — for after the pictures have been read. ADR-1053;
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
 * **A retake keeps the pictures it does not retake, and every post goes through `post()`.**
 * `walk/` is not wiped on a run: each exported picture overwrites the file of its name and the
 * rest stay, so a fix round that re-walks two boxes leaves the other pictures in place and
 * `--post-only` posts the whole set again, sized. Each caption says when its picture was taken,
 * so a carried picture is visible on the comment. Before 2026-09-21 a run wiped `walk/`, a
 * partial retake could not be re-posted through this script, and three fix rounds of #296 were
 * posted by hand as Markdown images, which GitHub shows at full width — the size lives only in
 * the `<img width>` this function writes, never in the files.
 *
 * **On a simulator of this worktree's own.** Two Stories walking at once used to share whatever
 * iPhone was booted, and each run uninstalled the other's build from under its test: on
 * 2026-09-15, with three worktrees walking, every overlapping run died about twenty-three
 * seconds after its last step with `Restarting after unexpected exit, crash, or test timeout`
 * and no crash report. So the walk creates `DayByDay walk <worktree directory>` on first use,
 * from the newest runtime's stock iPhone, keeps it booted between runs, and never touches a
 * stock device — `iPhone 17` stays the one `docs/running-the-app.md` runs the app on by hand.
 * The device goes with the worktree: the janitor deletes it at Stage 9, and every walk begins
 * by deleting any walk device whose worktree no longer exists, so a forgotten one is gone by
 * the next run anywhere.
 *
 * **Posting needs `gh` 2.99.0 or later** for `--attach`, which is `~/.local/bin/gh` on this
 * machine (`AGENTS.md` § *This machine*); the Actions token is refused by that flag, which is
 * why the walk is run here and not in CI.
 *
 * **What is posted is full size, shown small, three to a row.** The simulator exports at 3x —
 * 1206 by 2622 — and a Markdown image cannot be given a width, so a full-size picture fills the
 * PR's column and a walk of eighteen is a long scroll. The comment is therefore an HTML table:
 * cells a third of the column each, `<img width="POSTED_WIDTH">` so every picture is the same
 * width whatever its caption says, and the box's line under each. Clicking one opens it full
 * size. `walk/` keeps the originals for the reviewer.
 */
import { execFileSync, spawnSync } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, copyFileSync, statSync } from 'node:fs'
import { homedir, tmpdir } from 'node:os'
import path from 'node:path'

const PROJECT = 'src/DayByDay/DayByDay.xcodeproj'
const SCHEME = 'DayByDay'
const BUNDLE_ID = 'com.dbugmann.daybyday'
const WALK_TEST = 'src/DayByDay/DayByDayUITests/WalkUITests.swift'
const OUT_DIR = 'walk'
// Every walk device is named `DayByDay walk <worktree directory>`; the prefix is how a walk
// tells its own devices from the stock ones when it prunes.
const DEVICE_PREFIX = 'DayByDay walk '
// How wide a posted picture is shown, in pixels, and how many share a row. Three at 300 fit a
// PR comment's column; the owner chose the size on 2026-09-15 after seeing 402 two to a row.
// Change both together.
const POSTED_WIDTH = 300
const PER_ROW = 3

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
const postOnlyAt = args.indexOf('--post-only')
const prNumber = postAt >= 0 ? args[postAt + 1] : postOnlyAt >= 0 ? args[postOnlyAt + 1] : undefined
if ((postAt >= 0 || postOnlyAt >= 0) && !/^\d+$/.test(prNumber ?? '')) fail('--post and --post-only take a PR number')
const postOnly = postOnlyAt >= 0

type Picture = { name: string; file: string }

/** When a picture was taken, from its file's modification time — local time, to the minute. */
function takenAt(file: string): string {
  const t = statSync(file).mtime
  const pad = (n: number): string => String(n).padStart(2, '0')
  return `${t.getFullYear()}-${pad(t.getMonth() + 1)}-${pad(t.getDate())} ${pad(t.getHours())}:${pad(t.getMinutes())}`
}

function post(pictures: Picture[], pr: string): void {
  // Two steps, because `gh` rewrites only a Markdown image reference to its uploaded asset and
  // a Markdown image cannot be given a width: post the full-size pictures as Markdown, read the
  // asset URLs back, then rewrite the comment as an HTML table whose cells are fixed at a third
  // of the column and whose images are `POSTED_WIDTH` wide. Full size is one click away.
  // Copied under short names first: a box's line has spaces and commas, and a Markdown
  // reference with a space in its path is not one `gh` can recognise and rewrite.
  const staged = path.join(OUT_DIR, 'post')
  rmSync(staged, { recursive: true, force: true })
  mkdirSync(staged, { recursive: true })
  const files = pictures.map((picture, i) => {
    const file = path.join(staged, `${String(i + 1).padStart(2, '0')}.png`)
    copyFileSync(picture.file, file)
    return file
  })
  const sha = run('git', ['rev-parse', '--short', 'HEAD']).trim()
  const heading = `**The walk** — ${pictures.length} pictures from a fresh install, posted at ${sha}; each says when it was taken. Click one for full size.`
  const draft = [heading, '', ...pictures.map((picture, i) => `![${picture.name}](./${files[i]})`)].join('\n')
  const attachArgs = pictures.flatMap((picture, i) => ['--attach', `./${files[i]}#${picture.name}`])
  run(gh(), ['pr', 'comment', pr, '--body', draft, ...attachArgs])
  const posted = JSON.parse(run(gh(), ['api', `repos/{owner}/{repo}/issues/${pr}/comments`, '--jq', '.[-1]'])) as { id: number; body: string; html_url: string }
  const urls = [...posted.body.matchAll(/\]\((https:\/\/[^)]+)\)/g)].map((m) => m[1])
  if (urls.length !== pictures.length) fail(`posted ${urls.length} asset URL(s) for ${pictures.length} pictures — comment ${posted.html_url} left as it is`)

  const rows: string[] = []
  for (let i = 0; i < pictures.length; i += PER_ROW) {
    const cells = pictures.slice(i, i + PER_ROW).map(
      (picture, offset) =>
        `<td width="${Math.floor(100 / PER_ROW)}%" align="center" valign="top"><img src="${urls[i + offset]}" width="${POSTED_WIDTH}" alt="${picture.name}"><br><sub>${picture.name} · ${takenAt(picture.file)}</sub></td>`,
    )
    while (cells.length < PER_ROW) cells.push(`<td width="${Math.floor(100 / PER_ROW)}%"></td>`)
    rows.push(`<tr>${cells.join('')}</tr>`)
  }
  const body = `${heading}\n\n<table>${rows.join('')}</table>`
  run(gh(), ['api', '-X', 'PATCH', `repos/{owner}/{repo}/issues/comments/${posted.id}`, '-f', `body=${body}`])
  console.log(`walk: posted ${posted.html_url}`)
}

if (postOnly) {
  const files = existsSync(OUT_DIR) ? readdirSync(OUT_DIR).filter((f) => f.endsWith('.png')).sort() : []
  if (files.length === 0) fail(`nothing in ${OUT_DIR}/ to post — run the walk first`)
  post(files.map((f) => ({ name: f.replace(/\.png$/, ''), file: path.join(OUT_DIR, f) })), prNumber!)
  process.exit(0)
}

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

// This worktree's own device, made on first use and pruned once a worktree is gone. Runtimes
// newest first, as CI's ui-smoke chooses; the device is modelled on that runtime's first stock
// iPhone.
type Device = { name: string; udid: string; state: string; deviceTypeIdentifier: string }
const listed = JSON.parse(run('xcrun', ['simctl', 'list', 'devices', 'available', '--json'])).devices as Record<string, Device[]>
const simulators = Object.keys(listed)
  .sort()
  .reverse()
  .flatMap((runtime) => (listed[runtime] ?? []).map((device) => ({ runtime, device })))

const worktrees = new Set(
  run('git', ['worktree', 'list', '--porcelain'])
    .split('\n')
    .filter((line) => line.startsWith('worktree '))
    .map((line) => path.basename(line.slice('worktree '.length))),
)
for (const { device: stale } of simulators) {
  if (!stale.name.startsWith(DEVICE_PREFIX) || worktrees.has(stale.name.slice(DEVICE_PREFIX.length))) continue
  spawnSync('xcrun', ['simctl', 'delete', stale.udid], { stdio: 'ignore' })
  console.log(`walk: deleted ${stale.name} — its worktree is gone`)
}

const deviceName = `${DEVICE_PREFIX}${path.basename(run('git', ['rev-parse', '--show-toplevel']).trim())}`
let device = simulators.find(({ device: d }) => d.name === deviceName)?.device
if (!device) {
  const stock = simulators.find(({ device: d }) => d.name.startsWith('iPhone'))
  if (!stock) fail('no iPhone simulator to model this worktree\'s on — docs/running-the-app.md § Once, before the first run')
  const udid = run('xcrun', ['simctl', 'create', deviceName, stock.device.deviceTypeIdentifier, stock.runtime]).trim()
  device = { ...stock.device, name: deviceName, udid, state: 'Shutdown' }
  console.log(`walk: created ${deviceName}, an ${stock.device.name} on ${stock.runtime.replace(/^.*SimRuntime\./, '')}`)
}
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

// Not wiped: a retake overwrites the pictures of its own names and keeps the rest, so a fix
// round that re-walks two boxes can post the whole set again through `post()`.
mkdirSync(OUT_DIR, { recursive: true })
const before = new Set(readdirSync(OUT_DIR).filter((f) => f.endsWith('.png')))
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
const kept = [...before].filter((f) => !pictures.some((p) => p.file === path.join(OUT_DIR, f))).sort()
if (kept.length > 0) {
  console.log(`walk: ${kept.length} earlier picture(s) kept in ${OUT_DIR}/ — --post-only posts them too; delete any that are not this Story's`)
  for (const f of kept) console.log(`  ${path.join(OUT_DIR, f)}  taken ${takenAt(path.join(OUT_DIR, f))}`)
}

if (!passed) fail('a step could not be driven — the runner\'s own error is above; that is a stop, not a retry')
if (pictures.length === 0) fail('the walk passed and attached nothing — no shot() call ran')

if (prNumber) {
  post(pictures, prNumber)
} else {
  console.log('walk: read them, then post with: pnpm run walk -- --post-only <pr-number>')
}
