# Running the app

The keystrokes that put DayByDay on screen. `docs/story-mechanics.md` is the same kind of file for
a Story's git; this one is for looking at the thing. Everything here was run on this machine on
2026-09-03 and copied out of the terminal rather than written from memory — `docs/retrospective.md`
§5 is the four documented commands that could never have worked, every one of them recalled.

**What you are looking at is the app shell**: `CONTEXT.md` § *App shell*, ADR-1019. It draws what
`DayByDayKit` already answers and holds no rule of its own. Since this file was first written it
has grown ticking (#71), a date and navigation between days (#92, #93), and a record and a roster
kept under `Library/Application Support/DayByDay/` (#91, #103) — so it does persist now, and a run
leaves state behind on the simulator. `xcrun simctl uninstall 'iPhone 17' com.dbugmann.daybyday` is
how you get a first-launch back.

The shell also no longer *quite* decides nothing, which is a known drift rather than a design:
`docs/open-questions.md` records what it has accumulated.

## Once, before the first run

The Simulator needs a runtime, and Xcode ships without one. This is an 8.52 GB download that runs
unattended and needs no interaction:

```bash
xcodebuild -downloadPlatform iOS
```

`xcrun simctl list runtimes` prints an empty `== Runtimes ==` until it lands and the installed
runtime afterwards. Installing it also creates the simulator devices, which do not exist before
it — `xcrun simctl list devices available` counts eleven here.

## Every time

From the repository root, or from the worktree you are working in:

```bash
xcodebuild -project src/DayByDay/DayByDay.xcodeproj \
  -scheme DayByDay \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

That ends in `** BUILD SUCCEEDED **` and leaves the app under DerivedData rather than in the tree.
Ask `xcodebuild` where instead of guessing, then boot, install and launch:

```bash
APP=$(xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay \
        -destination 'platform=iOS Simulator,name=iPhone 17' -showBuildSettings 2>/dev/null \
      | awk -F' = ' '/ BUILT_PRODUCTS_DIR/{d=$2} / FULL_PRODUCT_NAME/{n=$2} END{print d"/"n}')

xcrun simctl boot 'iPhone 17'
xcrun simctl bootstatus 'iPhone 17' -b
xcrun simctl install 'iPhone 17' "$APP"
xcrun simctl launch 'iPhone 17' com.dbugmann.daybyday
```

**`simctl` does not open a window.** It drives a simulator that is already running as a service, so
after the launch the app is running and there is nothing on your screen. This is the line that puts
it in front of you, and it is the one everybody forgets:

```bash
open -a Simulator
```

`xcrun simctl boot 'iPhone 17'` fails with `Unable to boot device in current state: Booted` when
the device is already up. That is not an error worth reacting to — the rest of the sequence is
fine, and `|| true` is the right way to write it into a script.

## On your own phone

The Simulator is not the product — `CONTEXT.md` § *Product principles* says **an iPhone, in your
hand**, and a week of real use is the only thing that tells you which want matters next. The app's
bundle identifier is `com.dbugmann.daybyday` (ADR-1025), and it must not change once you have
installed even once: the record is kept under a directory the identifier names, so renaming it
orphans everything you have ticked.

**Signing is not in `project.pbxproj`, and that is deliberate.** The committed project is unsigned
— `CODE_SIGN_IDENTITY = ""`, which is Xcode's *Do Not Code Sign* — because CI builds it for the
Simulator on a runner that has no certificate and no profile. `scripts/install-on-phone.ts` passes
the signing settings on the command line instead, where they outrank the project, so the device
path opts in and the CI path is untouched.

**Measured on 2026-09-06, because it is the trap here.** A plain
`xcodebuild -destination 'generic/platform=iOS' build` **succeeds** and produces a bundle that
`codesign -dv` calls `code object is not signed at all`, with no `embedded.mobileprovision` —
`devicectl` then refuses to install it. Setting `CODE_SIGN_IDENTITY` in the project is not enough
on its own either: `CODE_SIGNING_ALLOWED = NO` still suppresses the signing step. It takes all
three, which is what the script passes.

**What you need once, in the Xcode GUI.** A certificate — `security find-identity -v -p codesigning`
should print one valid identity, and prints `0 valid identities found` on a machine that has none:

1. **Xcode → Settings → Accounts → +** and sign in with the Apple ID. A free one is enough.
2. Open `src/DayByDay/DayByDay.xcodeproj` **from the worktree you are working in**, select the
   **DayByDay** target → **Signing & Capabilities**, tick *Automatically manage signing*, and pick
   the team.

**Signing in does not create the certificate**; step 2 does, as a side effect of being asked to
sign. Doing only step 1 leaves `find-identity` at zero, which reads as the sign-in having failed
and has not.

**Step 2 rewrites `project.pbxproj`** — `objectVersion` 77 down to 70 and several sections
reordered. That is Xcode normalising a hand-written file to the form it round-trips. **Do not
commit it**: it drops the `DayByDayUITests` target that ADR-1029's smoke layer needs. `git checkout
-- src/DayByDay/DayByDay.xcodeproj/project.pbxproj` after the GUI has done its work; the signing
you just set up lives in the script, not in the file, so throwing the rewrite away costs nothing.

**A personal team needs a device before it can make a provisioning profile.** With none usable,
the build ends in *"Your team has no devices from which to generate a provisioning profile"* and
*"No profiles for 'com.dbugmann.daybyday' were found"*. Neither blocks a **simulator** build, which
needs no profile. Plug the phone in, unlock it, answer *Trust This Computer*, and
`-allowProvisioningUpdates` lets Xcode register the device and issue the profile without the GUI.

**Do not trust that pair of errors, though — they are what this machine says for every reason a
phone is unusable, and only one of them is the one they name.** Getting the app onto its first real
phone on 2026-09-07 hit three causes in a row and all three arrived as that same text, pointing at
a developer.apple.com page a free account cannot open. In the order they bit:

1. **Developer Mode was off on the phone.** iOS 16 and later refuse development builds until it is
   on: *Settings → Privacy & Security → Developer Mode*, then restart the phone and confirm after
   unlocking. The entry only appears once a Mac has tried to connect for development.
2. **The developer disk image could not mount, because the phone was locked.** `xcrun devicectl
   device info details --device <identifier>` reports `ddiServicesAvailable: false` while
   `developerModeStatus: enabled`, and `xcrun devicectl device info ddiServices --device
   <identifier>` names it outright: *kAMDMobileImageMounterDeviceLocked*. Unlock the phone and
   leave the screen on.
3. **The build was aimed at `generic/platform=iOS`.** That is the one that made the other two
   illegible: with no particular device named, automatic signing has no udid to register, so every
   underlying cause came out as the missing-device error. `pnpm run phone` now builds against
   `platform=iOS,id=<udid>` and the same failures report themselves — *"Developer Mode disabled"*,
   *"The developer disk image could not be mounted on this device"*.

**Ask the phone before believing the build.** These three answer it in one line each:

```bash
xcrun devicectl list devices
xcrun devicectl device info lockState --device <identifier>
xcrun devicectl device info details --device <identifier> | grep -E 'developerMode|ddiServices'
```

**A free Apple ID expires the build after seven days.** The app stops launching and needs the
install run again; the record survives, because it lives in the app's container rather than in the
build. Nothing warns you first. A paid Apple Developer account removes the weekly step and is not
needed to run the trial.

## Putting a new version on it

With the phone plugged in and unlocked, one command builds, installs and launches:

```bash
pnpm run phone
```

It picks the phone when exactly one is paired, and names them when more than one is:

```bash
pnpm run phone -- 'Diego’s iPhone'
```

Someone who is not the owner sets their own team: `DAYBYDAY_TEAM_ID=XXXXXXXXXX pnpm run phone`.

**This is the only way a new version ever reaches the phone.** There is no App Store here and no
TestFlight — TestFlight needs a paid membership. **Merging a PR changes nothing on the device.** If
a week of use starts feeling stale, check that you reinstalled before concluding anything about the
work.

**Run it again within seven days even if nothing shipped.** A free personal team's signature
expires and the app stops opening; this is the fix, and it resets the clock.

**It installs over the top, and that is what keeps your ticks.** The record lives at
`<Application Support>/DayByDay/record.json`, inside a container iOS keys to the bundle identifier,
so reinstalling the same identifier keeps every tick. **Deleting the app from the Home screen
deletes the container and the entire record**, silently and with no undo. Never delete and
reinstall as a fix for anything.

`scripts/install-on-phone.ts` is deliberately not a CI check: it needs a paired phone and a signing
identity, neither of which a runner has. If the script is itself what is broken, this is what it
runs, longhand:

```bash
xcrun devicectl list devices

xcodebuild -project src/DayByDay/DayByDay.xcodeproj \
  -scheme DayByDay \
  -destination 'platform=iOS,id=<udid>' \
  CODE_SIGNING_ALLOWED=YES CODE_SIGNING_REQUIRED=YES CODE_SIGN_STYLE=Automatic \
  CODE_SIGN_IDENTITY='Apple Development' DEVELOPMENT_TEAM=4QZ29N6GN2 \
  -allowProvisioningUpdates \
  build

APP=$(xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay \
        -destination 'platform=iOS,id=<udid>' -showBuildSettings 2>/dev/null \
      | awk -F' = ' '/ BUILT_PRODUCTS_DIR/{d=$2} / FULL_PRODUCT_NAME/{n=$2} END{print d"/"n}')

xcrun devicectl device install app --device <identifier> "$APP"
xcrun devicectl device process launch --device <identifier> com.dbugmann.daybyday
```

**`<identifier>` and `<udid>` are two names for the same phone and are not interchangeable.**
`xcrun devicectl list devices` prints the identifier — CoreDevice's UUID, `859C…` — and every
`devicectl` subcommand takes it. The udid is the hardware one, `00008130-…`, it is what
`xcodebuild -destination id=` takes, and `devicectl list devices --json-output` carries it at
`hardwareProperties.udid`. Passing one where the other belongs fails without naming either.

**The first launch fails on an untrusted developer**, which is the free account and not a defect:
on the phone, **Settings → General → VPN & Device Management → Developer App**, trust the
certificate, and launch again.

**A launch straight after an install also just fails sometimes**, on a phone that trusted the
certificate long ago, and succeeds seconds later. `pnpm run phone` retries once before it says
anything, because reporting the first failure sends you to Settings to fix something that is not
broken.

**What has and has not been run.** All of the above was run for real on 2026-09-07, against a
paired iPhone 15 Pro on iOS 26.6.1: `pnpm run phone` built, signed, installed and launched, and the
app is on the phone. The three causes above were each hit and cleared in that session, and the JSON
field names quoted here were read off real payloads rather than guessed.

**Two things still have not happened**, and neither can be made to happen on demand: the **seven-day
signature expiry**, and a **reinstall over an app holding real ticks** — the promise that a
reinstall keeps the record is argued from where the container lives, not yet observed. Correct this
paragraph the first time either one is.

## Looking without looking

A screenshot, which is how an agent proves the thing drew rather than merely built:

```bash
xcrun simctl io 'iPhone 17' screenshot /tmp/day-view.png
```

## Putting it away

```bash
xcrun simctl terminate 'iPhone 17' com.dbugmann.daybyday
xcrun simctl shutdown 'iPhone 17'
```

Leave nothing booted at the end of an unattended run. `xcrun simctl list devices booted` prints the
devices still up and should come back with no device rows.

## Two things that read as broken and are not

**`error: Found no destinations for the scheme 'DayByDay' and action build.`** The runtime is
missing, not the project file. `xcodebuild -showdestinations` says so in as many words —
`iOS 26.5 is not installed` — and the fix is the download above. A build by `-target` rather than
`-scheme` skips destination resolution entirely and compiles without a runtime, which is why
"it compiles" and "it runs" are separate questions here.

**`build/` appearing in `src/DayByDay/` and `src/DayByDayKit/`.** `xcodebuild` writes there when it
is not given `-derivedDataPath`. It is gitignored (ADR-1019), so this is noise rather than damage.

## What CI does with all this

**It builds the app, and it does not run it.** CI's `swift` job discovers `Package.swift` files and
runs `swift test` — an `.xcodeproj` adds no manifest, so that half still cannot see the app target
— and then compiles the shell explicitly. Nothing installs anything or takes a screenshot; the
commands above are still the only way anyone *sees* the app.

The compile step was added on 2026-09-06 and is deliberately narrow. It answers "does the shell
still compile against the kit" — a renamed symbol, a misspelled binding, a body that no longer
type-checks — which had no answer before, because nothing in CI had ever built `src/DayByDay/`.
ADR-1019 named both the command and its own trigger for adding it, and left it out while the shell
held nothing the kit did not; it now holds four such things.

**Whether SwiftUI *draws* is answered too, since 2026-09-06.** A further step runs the
`DayByDayUITests` bundle against a simulator the workflow discovers from `simctl` rather than
names. It is deliberately thin — it asserts the shell drew, never what it drew — and ADR-1029
carries the reasoning. Run it yourself with:

```bash
device=$(xcrun simctl list devices available --json \
  | python3 -c "import json,sys; ds=json.load(sys.stdin)['devices']; print(next(d['udid'] for rt in sorted(ds, reverse=True) for d in ds[rt] if d['name'].startswith('iPhone')))")

xcodebuild build-for-testing -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay \
  -destination "platform=iOS Simulator,id=${device}" -only-testing:DayByDayUITests \
  -enableCodeCoverage NO COMPILER_INDEX_STORE_ENABLE=NO

xcrun simctl bootstatus "$device" -b

xcodebuild test-without-building -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay \
  -destination "platform=iOS Simulator,id=${device}" -only-testing:DayByDayUITests \
  -parallel-testing-enabled NO -enableCodeCoverage NO
```

That takes **40.2 seconds cold** here — no derived data, every simulator shut down — and ends in
`** TEST SUCCEEDED **`. It does not replace looking at the app: it proves the screen was not
blank, and nothing about whether what is on it is right.

**It is four commands rather than one because of where the time goes, and it is worth knowing
why before anyone simplifies it back.** The single `xcodebuild test` this replaced took 61.3s
here and 5-8½ minutes on CI, and in both cases almost none of that was the test. Measured
2026-09-07:

| | here |
|---|---|
| the old one-liner, cold derived data, cold simulator | 61.3s |
| its test phase, cold simulator, cloned — the default | 47.7s |
| its test phase, cold simulator, **not** cloned | 28.3s |
| its test phase, not cloned and **already booted** | 17.0s |
| the test case itself | 5-8s |

`xcodebuild test` clones the simulator before running a UI test — the log says
`Clone 1 of iPhone 17 Pro` — because the scheme it derives parallelises by default and there is
no `.xcscheme` in the tree to say otherwise. For one test on one device the clone is a boot
bought for nothing, and `-parallel-testing-enabled NO` is what declines it. Splitting `test`
into `build-for-testing` and `test-without-building` is what puts the boot between them, where
`bootstatus -b` can wait for it and be timed. Coverage is off because nothing reads it — the
derived scheme was compiling the kit with `-profile-generate -profile-coverage-mapping` for no
reader.

**On a runner the boot is the whole story, and here it is nearly free.** These simulators have
been booted hundreds of times on this machine, so `bootstatus -b` returns in seconds. On a
`macos-26` runner the device has never been booted since the image was built, and the same
command takes **2m06s** — measured on 2026-09-07 once it was given a step of its own, which is
the first time anybody could see it. That number was always being paid; ADR-1029 booked it as
the UI test being slow, because it was hidden inside `xcodebuild test` along with the clone.

**Do not try to hide it behind `swift test`.** Starting the boot at the top of the job with
`simctl boot` does work — the command returns in about half a second and the boot carries on
inside `CoreSimulatorService`, surviving into later steps — and it buys nothing. Over three runs
`swift test` took 436s, 245s and 384s against a 34-76s baseline, while the smoke step fell by
about the same amount: a runner has no spare capacity to absorb a simulator boot, and all the
overlap achieves is moving the cost into a step that then lies about what it measures.

**Not cloning means the app is left installed on that device**, with whatever it wrote under
`Library/Application Support/DayByDay/`, exactly as `pnpm run phone` leaves it on a phone. The
uninstall line at the top of this file is how you get a first launch back.
