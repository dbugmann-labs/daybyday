/**
 * Builds DayByDay for a physical iPhone and installs it over whatever is already there.
 * `pnpm run phone`, optionally with a device name or identifier: `pnpm run phone -- 'Diego's iPhone'`.
 *
 * **This is the only way a new version reaches the phone.** There is no App Store here and no
 * TestFlight — TestFlight needs a paid Apple Developer Program membership, and this project signs
 * with a free personal team (ADR-1025, `docs/running-the-app.md` § *On your own phone*). Merging a
 * PR changes nothing on the device until this runs.
 *
 * **It installs over the top, which is what keeps the record.** The ticks live at
 * `<Application Support>/DayByDay/record.json` inside a container iOS keys to the bundle
 * identifier, so reinstalling the same identifier keeps every one of them. *Deleting* the app from
 * the Home screen deletes the container and the whole record with it, silently and with no undo.
 * Never tell someone to delete and reinstall as a fix.
 *
 * **A free personal team expires the build after seven days**, whether or not anything shipped.
 * The app stops launching and this script is the fix; it also resets the seven days. The record
 * survives that, because it lives in the container rather than in the build.
 *
 * Not a check and not run by CI: it needs a paired phone and a signing identity, neither of which
 * exists on a runner. `docs/running-the-app.md` carries the same commands written out longhand,
 * for when this script is the thing that is broken.
 */
import { execFileSync } from 'node:child_process'
import { mkdtempSync, readFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import path from 'node:path'

const PROJECT = 'src/DayByDay/DayByDay.xcodeproj'
const SCHEME = 'DayByDay'
const BUNDLE_ID = 'com.dbugmann.daybyday'

/**
 * One device as `devicectl list devices --json-output` reports it. Only the envelope
 * (`result.devices`, `info.outcome`) has been seen against the real tool — with no phone paired,
 * `result.devices` came back `[]` — so the per-device fields below are read defensively and every
 * one of them is optional. Correct this type against a real payload rather than trusting it.
 */
type Device = {
  identifier?: string
  deviceProperties?: { name?: string }
  hardwareProperties?: { platform?: string }
}

function run(command: string, args: string[]): string {
  return execFileSync(command, args, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'inherit'] })
}

function die(lines: string[]): never {
  console.error(`✗ ${lines[0]}\n`)
  for (const line of lines.slice(1)) console.error(`  ${line}`)
  console.error('')
  process.exit(1)
}

/** Every iOS device `devicectl` can see, named as a person would recognise it. */
function pairedDevices(): { name: string; identifier: string }[] {
  const out = path.join(mkdtempSync(path.join(tmpdir(), 'daybyday-')), 'devices.json')
  run('xcrun', ['devicectl', 'list', 'devices', '--json-output', out])

  const payload = JSON.parse(readFileSync(out, 'utf8')) as { result?: { devices?: Device[] } }
  const devices = payload.result?.devices ?? []

  return devices
    .filter((d) => (d.hardwareProperties?.platform ?? 'iOS').startsWith('iOS'))
    .map((d) => ({ name: d.deviceProperties?.name ?? '(unnamed)', identifier: d.identifier ?? '' }))
    .filter((d) => d.identifier !== '')
}

/** The device to install onto: the one asked for, or the only one there. */
function chooseDevice(asked: string | undefined): string {
  // An explicit name or identifier is passed through untouched — `devicectl` accepts either, and
  // resolving it here would only add a way to be wrong about a device this script cannot see.
  if (asked !== undefined && asked !== '') return asked

  const devices = pairedDevices()

  if (devices.length === 0) {
    die([
      'No paired iPhone.',
      'Connect it by cable, unlock it, and answer "Trust This Computer".',
      '',
      'A free personal team cannot register a device any other way: adding one at',
      'developer.apple.com needs a paid membership, whatever Xcode\'s error suggests.',
      'docs/running-the-app.md § On your own phone.',
    ])
  }

  if (devices.length > 1) {
    die([
      `${devices.length} devices are paired, so name the one you mean:`,
      '',
      ...devices.map((d) => `pnpm run phone -- '${d.name}'`),
    ])
  }

  console.log(`▸ device — ${devices[0]!.name}`)
  return devices[0]!.identifier
}

/** Where `xcodebuild` says it put the .app, rather than where anyone assumes it did. */
function builtApp(destination: string): string {
  const settings = run('xcodebuild', [
    '-project', PROJECT,
    '-scheme', SCHEME,
    '-destination', destination,
    '-showBuildSettings',
  ])

  const read = (key: string): string | null => {
    const match = new RegExp(`^\\s*${key} = (.+)$`, 'm').exec(settings)
    return match === null ? null : match[1]!.trim()
  }

  const dir = read('BUILT_PRODUCTS_DIR')
  const name = read('FULL_PRODUCT_NAME')

  if (dir === null || name === null) {
    die(['xcodebuild reported no BUILT_PRODUCTS_DIR or FULL_PRODUCT_NAME.', 'Nothing was installed.'])
  }

  return path.join(dir, name)
}

const device = chooseDevice(process.argv[2])
const destination = 'generic/platform=iOS'

console.log('▸ building for the device — signing runs here, and is where a stale profile shows up')
run('xcodebuild', ['-project', PROJECT, '-scheme', SCHEME, '-destination', destination, 'build'])

const app = builtApp(destination)
console.log(`▸ installing — ${app}`)
run('xcrun', ['devicectl', 'device', 'install', 'app', '--device', device, app])

console.log('▸ launching')
run('xcrun', ['devicectl', 'device', 'process', 'launch', '--device', device, BUNDLE_ID])

console.log('')
console.log(`✓ ${BUNDLE_ID} is on the phone, and every tick it already held is still there.`)
console.log('  Run this again after any merge — nothing reaches the phone until you do — and')
console.log('  again within seven days, when a free team\'s signature expires and it stops opening.')
