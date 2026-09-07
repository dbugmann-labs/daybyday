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
 * Signing is passed here rather than committed to `project.pbxproj`, and the reason is measured
 * rather than assumed. The project sets `CODE_SIGN_IDENTITY = ""` — which is Xcode's *Do Not Code
 * Sign* and outranks `CODE_SIGNING_ALLOWED`/`CODE_SIGNING_REQUIRED` — so a plain
 * `xcodebuild -destination 'generic/platform=iOS' build` succeeds and yields a bundle `codesign`
 * reports as `code object is not signed at all`, which `devicectl` then refuses to install. Setting
 * the identity in the project alone does not fix it either: `CODE_SIGNING_ALLOWED = NO` still
 * suppresses the signing step. Both were checked on 2026-09-06.
 *
 * Keeping all three on the command line means CI's simulator build stays exactly as it is —
 * unsigned, needing no certificate and no profile on a runner (`.github/workflows/ci.yml`, the UI
 * smoke job) — while the device path opts in explicitly. Command-line build settings outrank the
 * project, which is what makes that work.
 *
 * `DAYBYDAY_TEAM_ID` overrides the team for anyone who is not the owner.
 */
const TEAM_ID = process.env['DAYBYDAY_TEAM_ID'] ?? '4QZ29N6GN2'
const SIGNING = [
  'CODE_SIGNING_ALLOWED=YES',
  'CODE_SIGNING_REQUIRED=YES',
  'CODE_SIGN_STYLE=Automatic',
  'CODE_SIGN_IDENTITY=Apple Development',
  `DEVELOPMENT_TEAM=${TEAM_ID}`,
]

/**
 * One device as `devicectl list devices --json-output` reports it. Read off a real payload on
 * 2026-09-07, from a paired iPhone 15 Pro on iOS 26.6.1, rather than guessed — but every field
 * stays optional, because a tool whose stdout is explicitly unstable can move them.
 *
 * **`identifier` and `udid` are two names for the same phone and are not interchangeable.**
 * `identifier` is CoreDevice's own UUID (`859C354E-…`) and is what every `devicectl` subcommand
 * takes. `udid` is the hardware identifier (`00008130-…`) and is what `xcodebuild -destination
 * id=` takes. Passing one where the other belongs fails in a way that names neither.
 */
type Device = {
  identifier?: string
  deviceProperties?: { name?: string; developerModeStatus?: string; ddiServicesAvailable?: boolean }
  hardwareProperties?: { platform?: string; udid?: string }
}

/** The phone this run is talking to, in both of the names it answers to. */
type Phone = { name: string; identifier: string; udid: string }

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
function pairedDevices(): Phone[] {
  const out = path.join(mkdtempSync(path.join(tmpdir(), 'daybyday-')), 'devices.json')
  run('xcrun', ['devicectl', 'list', 'devices', '--json-output', out])

  const payload = JSON.parse(readFileSync(out, 'utf8')) as { result?: { devices?: Device[] } }
  const devices = payload.result?.devices ?? []

  return devices
    .filter((d) => (d.hardwareProperties?.platform ?? 'iOS').startsWith('iOS'))
    .map((d) => ({
      name: d.deviceProperties?.name ?? '(unnamed)',
      identifier: d.identifier ?? '',
      udid: d.hardwareProperties?.udid ?? '',
    }))
    .filter((d) => d.identifier !== '' && d.udid !== '')
}

/** The device to install onto: the one asked for, or the only one there. */
function chooseDevice(asked: string | undefined): Phone {
  const devices = pairedDevices()

  // An explicit argument is *resolved* rather than passed through. `devicectl` would accept a bare
  // name, but the build needs this phone's udid as well, and only the listing can supply it.
  if (asked !== undefined && asked !== '') {
    const match = devices.find((d) => d.name === asked || d.identifier === asked || d.udid === asked)
    if (match === undefined) {
      die([
        `No paired iPhone matches "${asked}".`,
        devices.length === 0 ? 'Nothing is paired at all.' : 'What is paired:',
        ...devices.map((d) => `  ${d.name}  ${d.identifier}  ${d.udid}`),
      ])
    }
    console.log(`▸ device — ${match.name}`)
    return match
  }

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
  return devices[0]!
}

/**
 * Says what is wrong with the phone before the build does, because the build says it badly.
 *
 * Both of these surfaced on 2026-09-07 getting the app onto its first real phone, and neither was
 * legible from where it landed: Developer Mode off, and then the developer disk image unable to
 * mount because the phone was locked. Each of them reached the terminal as *"Your team has no
 * devices from which to generate a provisioning profile"*, pointing at a developer.apple.com page
 * a free account cannot use. An hour went into the wrong question twice.
 *
 * Best effort, and deliberately never fatal: the two fields were read off a real payload, but
 * `devicectl`'s output is documented as unstable, so a rename here must not stop a build that
 * would otherwise work.
 */
function warnAboutThePhone(phone: Phone): void {
  const out = path.join(mkdtempSync(path.join(tmpdir(), 'daybyday-')), 'details.json')
  try {
    run('xcrun', ['devicectl', 'device', 'info', 'details', '--device', phone.identifier, '--json-output', out])
  } catch {
    return
  }

  let properties: Device['deviceProperties']
  try {
    properties = (JSON.parse(readFileSync(out, 'utf8')) as { result?: Device }).result?.deviceProperties
  } catch {
    return
  }

  if (properties?.developerModeStatus === 'disabled') {
    console.log('! Developer Mode is off on this phone, and the build below will fail because of it.')
    console.log('  Settings → Privacy & Security → Developer Mode, then restart the phone.')
  }

  if (properties?.ddiServicesAvailable === false) {
    console.log('! The developer disk image is not mounted, and the build below will fail because of it.')
    console.log('  Almost always the phone being locked — unlock it and leave the screen on.')
  }
}

/** Where `xcodebuild` says it put the .app, rather than where anyone assumes it did. */
function builtApp(destination: string): string {
  const settings = run('xcodebuild', [
    '-project', PROJECT,
    '-scheme', SCHEME,
    '-destination', destination,
    ...SIGNING,
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

const phone = chooseDevice(process.argv[2])
warnAboutThePhone(phone)

/**
 * **This phone, by udid — never `generic/platform=iOS`.** The generic destination was what this
 * script shipped with, and it could not put the app on a phone at all: with no particular device
 * named, automatic signing has no udid to register, so every failure — Developer Mode off, a
 * locked phone, no phone — came out as *"Your team has no devices from which to generate a
 * provisioning profile"* and a link to a page a free account cannot use. Aimed here, the same
 * build reported the real reason each time and then succeeded. Do not put the generic destination
 * back to make some other build work; add a destination instead.
 */
const destination = `platform=iOS,id=${phone.udid}`

console.log('▸ building for the device — signing runs here, and is where a stale profile shows up')
run('xcodebuild', [
  '-project', PROJECT,
  '-scheme', SCHEME,
  '-destination', destination,
  ...SIGNING,
  // Lets Xcode register a freshly connected phone and issue the profile without the GUI.
  '-allowProvisioningUpdates',
  'build',
])

const app = builtApp(destination)
console.log(`▸ installing — ${app}`)
run('xcrun', ['devicectl', 'device', 'install', 'app', '--device', phone.identifier, app])

/** Blocks the thread for `ms`. Everything else here is synchronous; a retry has to be too. */
function pause(ms: number): void {
  Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms)
}

/**
 * Launches, once retried.
 *
 * **The first launch straight after an install fails often enough to be the normal case**, and
 * recovers on a second attempt seconds later — seen on 2026-09-07 against a phone that had already
 * trusted the certificate, where the retry succeeded outright. Reporting the first failure would
 * have sent someone to Settings to fix something that was not broken, which is the same class of
 * mistake as the generic destination above.
 *
 * A launch that fails twice is worth a word, and it is still not a failure of this script: the app
 * is installed by then. The likeliest cause on a phone that has never run this certificate is the
 * untrusted-developer gate, which is a tap on the phone and nothing to do with the build.
 */
console.log('▸ launching')
const launch = (): void =>
  run('xcrun', ['devicectl', 'device', 'process', 'launch', '--device', phone.identifier, BUNDLE_ID]) as unknown as void

try {
  launch()
} catch {
  pause(3000)
  try {
    launch()
  } catch {
    console.log('')
    console.log('! Installed, and on the phone — iOS just would not open it from here.')
    console.log('  If this phone has never run a build of yours: Settings → General →')
    console.log('  VPN & Device Management → Developer App → Trust. Otherwise tap the icon;')
    console.log('  a locked or sleeping phone refuses a remote launch and nothing is wrong.')
    process.exit(0)
  }
}

console.log('')
console.log(`✓ ${BUNDLE_ID} is on the phone, and every tick it already held is still there.`)
console.log('  Run this again after any merge — nothing reaches the phone until you do — and')
console.log('  again within seven days, when a free team\'s signature expires and it stops opening.')
