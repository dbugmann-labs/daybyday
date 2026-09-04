# Running the app

The keystrokes that put DayByDay on screen. `docs/story-mechanics.md` is the same kind of file for
a Story's git; this one is for looking at the thing. Everything here was run on this machine on
2026-09-03 and copied out of the terminal rather than written from memory — `docs/retrospective.md`
§5 is the four documented commands that could never have worked, every one of them recalled.

**What you are looking at is the app shell**, and it decides nothing: `CONTEXT.md` § *App shell*,
ADR-1019. It draws what `DayByDayKit` already answers, from a hardcoded copy of the day-one week.

**It ticks, and it keeps what you tick.** `add-tick-from-row` (#71) landed the tap,
`add-day-screen` (#91) put a record behind it at `DayScreen.recordPlace`, and `add-screen-date`
(#107) gave the day its own name. Close the app and reopen it and yesterday's ticks are still
there. What it still cannot do is **move between days**: `DayView.previousDay(of:in:)` and
`nextDay(of:in:)` exist, but `DayScreen` does not expose them, so the shell only ever draws today.
That is `add-screen-navigation` (#93), and it is a Story rather than a chore because reaching
those methods is a delta against `openspec/specs/day-screen/spec.md`.

Everything above the paragraph you are reading was true on 2026-09-03 and stopped being true four
Stories later. **Re-read this file against `git log` before trusting it**, and fix it in the chore
you noticed it in — a stale runbook is `docs/retrospective.md` §5's failure wearing a different
coat.

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

**Signing was done once, in the Xcode GUI, and is committed.** `DEVELOPMENT_TEAM = 4QZ29N6GN2`
sits in both build configurations, and the Apple Development certificate for
`diego.bugmann@hotmail.com` is in this machine's keychain. `security find-identity -v -p
codesigning` should print one valid identity; if it prints `0 valid identities found` you are on a
different machine, and the steps that produced it were:

1. **Xcode → Settings → Accounts → +** and sign in with the Apple ID. A free one is enough.
2. Open `src/DayByDay/DayByDay.xcodeproj` **from the worktree you are working in**, select the
   **DayByDay** target → **Signing & Capabilities**, tick *Automatically manage signing*, and pick
   the team.

**Signing in does not create the certificate**; step 2 does, as a side effect of being asked to
sign. Doing only step 1 leaves `find-identity` at zero, which reads as the sign-in having failed
and has not.

**Step 2 also rewrites `project.pbxproj`** — `objectVersion` 77 down to 70 and three sections
reordered, about twenty lines. That is Xcode normalising a hand-written file to the form it
round-trips, it is committed as such, and reverting it only reproduces the diff on the next GUI
open.

**A free Apple ID expires the build after seven days.** The app stops launching and needs the
install run again; the record survives, because it lives in the app's container rather than in the
build. Nothing warns you first. A paid Apple Developer account is what removes the weekly step,
and it is not needed to run the trial.

**A personal team needs a device before it can make a provisioning profile.** With none
registered, Xcode reports *"Your team has no devices from which to generate a provisioning
profile"* and *"No profiles for 'com.dbugmann.daybyday' were found"*. Both are the same missing
phone rather than two problems, and neither blocks a **simulator** build — that needs no profile,
which is why the app still builds and runs with the errors on screen. Plug the phone in, unlock it,
answer *Trust This Computer*, and Xcode registers the device and issues the profile by itself.

Then, with the phone plugged in and unlocked:

```bash
xcrun devicectl list devices
```

That prints the identifier to use below; `No devices found.` means the phone is not paired, not
that anything is broken — unlock it and answer *Trust This Computer*. Build against the device
rather than the simulator, then install and launch:

```bash
xcodebuild -project src/DayByDay/DayByDay.xcodeproj \
  -scheme DayByDay \
  -destination 'generic/platform=iOS' \
  build

APP=$(xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay \
        -destination 'generic/platform=iOS' -showBuildSettings 2>/dev/null \
      | awk -F' = ' '/ BUILT_PRODUCTS_DIR/{d=$2} / FULL_PRODUCT_NAME/{n=$2} END{print d"/"n}')

xcrun devicectl device install app --device <identifier> "$APP"
xcrun devicectl device process launch --device <identifier> com.dbugmann.daybyday
```

**The first launch fails on an untrusted developer**, which is the free account and not a defect:
on the phone, **Settings → General → VPN & Device Management → Developer App**, trust the
certificate, and launch again.

**The `devicectl` subcommands and flags above were checked against `--help` on 2026-09-03; the
sequence has never been run end to end.** No device was paired and the machine held no signing
identity, so `xcrun devicectl list devices` printed `No devices found.` and no build was ever
signed. `AGENTS.md` says to verify rather than remember, and this is the honest state of it: the
first person to plug a phone in should correct whatever is wrong here and delete this paragraph.

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

Nothing. CI's `swift` job discovers `Package.swift` files and runs `swift test`; an `.xcodeproj`
adds no manifest, so the app target is not built by CI at all. That is deliberate and ADR-1019
names the step that would change it — a compile-only step proves nothing about drawing, which is
the gap `docs/open-questions.md` § *No UI smoke layer* already records and defers.
