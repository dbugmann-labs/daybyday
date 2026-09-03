# Running the app

The keystrokes that put DayByDay on screen. `docs/story-mechanics.md` is the same kind of file for
a Story's git; this one is for looking at the thing. Everything here was run on this machine on
2026-09-03 and copied out of the terminal rather than written from memory — `docs/retrospective.md`
§5 is the four documented commands that could never have worked, every one of them recalled.

**What you are looking at is the app shell**, and it decides nothing: `CONTEXT.md` § *App shell*,
ADR-1019. It draws what `DayByDayKit` already answers, from a hardcoded copy of the day-one week,
and it persists nothing. There is no ticking, no navigation and no store behind it yet — those are
Stories #71 and #72 and the open question about where a store is opened.

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
xcrun simctl launch 'iPhone 17' com.example.DayByDay
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

## Looking without looking

A screenshot, which is how an agent proves the thing drew rather than merely built:

```bash
xcrun simctl io 'iPhone 17' screenshot /tmp/day-view.png
```

## Putting it away

```bash
xcrun simctl terminate 'iPhone 17' com.example.DayByDay
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
