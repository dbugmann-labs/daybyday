# 1019. The app shell is a chore, and it runs in the iOS Simulator

- Status: accepted — the first two decisions were the owner's at the Feature grill on 2026-09-02;
  the third, what the target is called, is this record's own recommendation and is accepted by the
  chore PR that carries it
- Date: 2026-09-02
- Amended: 2026-09-04 — a bounded exception: shell work that exists only to make a Story usable
  may ride that Story's branch instead of a `chore/` one. The guard on what the shell may contain
  is unchanged.
- Deciders: Diego Bugmann

## Context

DayByDay has no app. `src/DayByDayKit` is a pure library and nothing in the repository launches or
draws: `swift test` is the only way any of it has ever been run. Eight archived changes stand
behind it — the four schedule shapes, the commitment, the tick and its history, the store, and
`add-day-view` (#70, merged as `4671c4f`) — and `DayView` is the point at which the engine can
answer, for one calendar date, what that date asks of you and what you did about it. The owner
asked for a running app they can launch from their laptop and look at.

There is nothing left to specify to get one. `DayView.rows` already gives a name and a kept flag
per commitment, in the order it was handed them; `CONTEXT.md` § *Day view* is explicit that it
orders nothing of its own and counts nothing. What stands between that and a running app is a
build target, a project file, a launch command and a SwiftUI body that reads `rows` — none of
which carries a requirement, because none of them can be got wrong in a way a test would catch.
`docs/open-questions.md` § *No UI smoke layer* says so in as many words: acceptance tests attach at
a seam inside `DayByDayKit`, so nothing automated proves SwiftUI draws, and a row left blank by a
misspelled binding passes CI today and would pass it after this.

`docs/open-questions.md` has also carried an open technical decision since the package was created:
*what the app target is called*. Where the package lives is settled; the target that draws the
screens does not exist and is unnamed.

**Everything below was measured on this machine on 2026-09-02**, on macOS 26.6.2 (25G83), Xcode 26.6
(17F113) and Swift 6.3.3, against a throwaway project outside the repository:

- A `.xcodeproj` can be written by hand and built with no Xcode GUI. `objectVersion = 77` is what
  Xcode 26.6's own shipped project templates carry, and `PBXFileSystemSynchronizedRootGroup` — the
  folder reference that makes a target contain a directory rather than an enumerated file list —
  works in a hand-written file: a Swift source with no `PBXBuildFile` entry anywhere was found and
  compiled. The whole project is one text file of 216 lines. `xcodebuild` wrote no `.xcscheme`; it
  derives the scheme from the target.
- With `GENERATE_INFOPLIST_FILE = YES` there is no `Info.plist` in the tree either. The generated
  one carried `CFBundleName = DayByDay`, taken from `PRODUCT_NAME = $(TARGET_NAME)`.
- **Before the simulator runtime was installed, `xcodebuild` could not build through a scheme, and
  the reason was the runtime rather than the SDK.** `xcodebuild -showsdks` already listed
  `iphonesimulator26.5`, but `xcrun simctl list runtimes` was empty, and a scheme build stopped at
  destination resolution:

  ```
  xcodebuild: error: Found no destinations for the scheme 'Probe' and action build.
  ```

  `-showdestinations` named the cause: `error:iOS 26.5 is not installed. Please download and
  install the platform from Xcode > Settings > Components.` A **target** build bypasses destination
  resolution and succeeded without the runtime, producing a universal arm64 + x86_64 `.app`. So a
  missing runtime blocks running and the scheme route, not compiling.
- **`xcodebuild -downloadPlatform iOS` then fetched *iOS 26.5 Simulator (23F77) (arm64)*, 8.52 GB**,
  and after it installed the whole path was verified end to end on the probe project: a scheme
  build against both `-destination 'generic/platform=iOS Simulator'` and
  `-destination 'platform=iOS Simulator,name=iPhone 17'`, then `xcrun simctl boot`,
  `simctl install` and `simctl launch`, with a screenshot showing the app drawing one row — the
  name of a commitment that came out of `DayView.rows` for a real calendar date, through the real
  `DayByDayKit`. Installing the runtime also created eleven simulator devices, iPhone 17 through
  iPad, that had not existed before.
- The library reaches the app as a local package: `XCLocalSwiftPackageReference` with
  `relativePath = ../DayByDayKit` resolved from a hand-written project, and `DayByDayKit` compiled
  and linked statically into the app binary. `Package.swift` needed no change and still declares no
  `platforms:` — the kit compiled at its own default floor,
  `-target arm64-apple-ios12.0-simulator`, under an app whose `IPHONEOS_DEPLOYMENT_TARGET` is 26.0.
- With `CODE_SIGNING_ALLOWED = NO` the simulator build needs no signing identity and no Apple
  Developer Program membership.
- **A SwiftPM executable target importing SwiftUI does build and does open a window on macOS**, and
  it takes six seconds. It is also not an app: `lsappinfo` reports it as
  `type="BackgroundOnly"` with `bundleID=[ NULL ]`, `Bundle.main.bundleIdentifier` is `nil`, and
  `FileManager`'s application-support directory resolves to the bare `~/Library/Application
  Support` with no container of its own.
- **CI does not see an `.xcodeproj` at all.** The `swift` job in `.github/workflows/ci.yml`
  discovers work by `find . -name Package.swift`; run over the probe layout it returned exactly one
  manifest, the kit's. An app target adds none. GitHub's `macos-26` runner image ships Xcode 26.6
  with iOS 26.2, 26.4 and 26.5 simulator runtimes already installed, so the 8.52 GB is a local cost
  and not a CI one.

## Decision

**Three things, taken together.**

**1. The shell is a chore, not a Feature.** It gets a `chore/` branch, no Story, no change folder
and no G4, because it introduces no requirement. Every behaviour it exhibits is already specified
and tested behind the `DayByDayKit` seam; what the chore adds is a target, a project file, a launch
command and a body that reads `DayView.rows`. `docs/process.md` §5 reserves the `chore/` lane for
work with no behaviour change, and the honest tension is that a running app is visibly new. The
line that resolves it, and the guard on the lane:

> **The shell may contain no line that could be wrong in a way a test would catch.** An order, a
> formatting rule, a refusal, a choice of where something is stored — the moment any of those is
> in the shell, it has stopped being a shell, and it owes a Story and a G4 like anything else.

Concretely, the shell is dataless. It builds a `DayView` in memory and draws `row.name`. It does
not open a `RecordStore`, does not choose the directory that store lives in, does not tick and does
not navigate between dates. Ticking belongs to the row and therefore to `day-screen` (#27), which
`CONTEXT.md` already says; so does the date being displayed.

**Amended 2026-09-04, at the grill of `add-commitments-screen` (#104), question 12.** Shell work
whose *only* purpose is to make a Story usable may ride that Story's branch rather than a `chore/`
one. Decided against the grill's own recommendation and taken as the owner's preference: they want
the Story working at G7, rather than reviewing a screen nothing can navigate to and then opening a
second branch to reach it.

**The guard above does not move an inch.** The exception is about which branch the SwiftUI arrives
on, and about nothing else. The shell still may contain no line that could be wrong in a way a test
would catch; every refusal, order, default and place in #104 is behind the `DayByDayKit` seam with
its own requirement and its own scenario, which is why the exception costs so little. What it does
cost is real and is stated so that it is not repeated by habit: the G4 marker signs a change folder
whose branch will also carry a `CommitmentsView.swift` that no gate reads as a requirement, and the
digest cannot tell the two apart.

**The conditions, all three of which must hold.** The shell change is the immediate consumer of the
Story landing in the same PR; it introduces no behaviour the kit does not already specify; and it
is named in that change's `tasks.md` as its own section, so a reviewer sees it as a distinct thing
rather than as part of the delta.

**The return to the rule** is the next shell change that fails any of those three — anything the
shell wants that is not the direct consumer of a Story in the same PR goes back on a `chore/`
branch, and this amendment is not a general licence to put SwiftUI in Story PRs. If a second Story
claims the exception, that is the signal that the rule has quietly changed and this record should
be revisited rather than stretched again.

**2. It runs in the iOS Simulator.** Not as a macOS window, and not as both. `CONTEXT.md`
§ *An iPhone, in your hand* is the reason: a phone product looked at on a laptop acquires
laptop-shaped decisions, and the whole value of a shell is that the owner judges what they see.
The simulator is the cheapest thing that is a phone — the same SwiftUI, the same 402-point-wide
screen an iPhone 17 has, the same Home screen — and it launches from the laptop the owner is
already sitting at.

**3. The target is called `DayByDay`.** Target, scheme and product name, at
`src/DayByDay/DayByDay.xcodeproj` beside `src/DayByDay/DayByDay/` for its sources, one directory up
from `src/DayByDayKit`. This settles `docs/open-questions.md` § *What the app target is called*.

The argument is that the suffix already carries the whole distinction. `DayByDayKit` is the part
with requirements; the part without them is what is left, and what is left is the product. The name
is also load-bearing rather than cosmetic: `PRODUCT_NAME = $(TARGET_NAME)` makes the target name
the bundle name, which is the label under the icon on the Home screen — verified above — so every
other candidate is a name plus an override putting `DayByDay` back.

The **bundle identifier is deliberately not settled here.** It is a harder decision than the target
name, because changing it after the app has been installed once orphans the store the record lives
in, and it wants the owner's own domain. It falls to the first Story that puts the app on the
phone.

## Consequences

- **CI does not build the app, and this ADR does not make it.** The cost of changing that is one
  step on the `macos-26` runner the `swift` job already uses —
  `xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay -destination
  'generic/platform=iOS Simulator' build` — and no runtime download, because the image ships three.
  It is left out because a compile-only step proves the shell compiles and nothing about drawing,
  which is the gap `docs/open-questions.md` already records. Add it the first time the shell holds
  anything the kit does not, which is also the first time it could break without anyone noticing.
- **8.52 GB has to be on the machine before anything runs**, once. It is the simulator *runtime*;
  the iOS Simulator SDK was already there. It is now installed on this machine, so the price is
  paid; it will be charged again on a new machine, and again whenever Xcode moves to an iOS version
  whose runtime is not already local. Until it lands, `xcodebuild` builds the app through `-target`
  and refuses through `-scheme`, with the two errors quoted above — so a red `Found no destinations`
  means a missing platform and never a broken project file.
- **The project file is maintained by hand and it is about two hundred lines**, which is only
  tolerable because
  `PBXFileSystemSynchronizedRootGroup` means adding a Swift file needs no edit to it at all. That
  is what keeps a generator — XcodeGen, Tuist — from earning its place, and it removes the usual
  reason an Xcode project is miserable on a branch: there is nothing per-file to conflict over.
  If a later change makes the file churn on every Story, that is the trigger to reconsider a
  generator, and not before.
- **`.gitignore` needs a `build/` line.** It has `.build/` and `.swiftpm/` and not `build/`, and a
  target build with no `-derivedDataPath` writes `build/` into both `src/DayByDay/` **and**
  `src/DayByDayKit/`. `xcodebuild` also creates
  `DayByDay.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/configuration`, empty; opening the
  project in Xcode will add `xcuserdata` beside it.
- **`swift test` and the `swift` CI job are untouched.** The kit keeps its own manifest, the app
  adds none, discovery still finds exactly one, and ADR-1017's "nothing is added to `Package.swift`"
  still holds — no platform floor, no dependency.
- **The 99 USD of ADR-1001 is not due yet.** A simulator build needs no signing identity. The
  Developer Program becomes a bill the day the app first goes on the phone, and the ADR's judgement
  that it is mandatory rather than optional is unchanged; only its timing is now known.
- **The *No UI smoke layer* gap is not closed, and one of its three costs is now paid.** That gap
  named an ADR, an `xcodebuild` job against a simulator, and a change to CI check 4. This ADR is
  the first, and the second now has a project to point at. Check 4 still cannot see an XCTest
  method name, so the gap stands.
- **`docs/open-questions.md` is narrowed on one point and this ADR does not edit it.** It records
  that "whichever Story creates the app target chooses the place" the store is opened under
  `Library/Application Support/`. On this decision the *chore* creates the target and chooses
  nothing, because choosing is exactly what a shell may not do; the obligation stays with the first
  Story that persists a tick from the app, realistically `day-screen` (#27). That line needs
  rewording to say Story rather than target.
- **The launch command does not live here.** Four build, boot, install and launch invocations
  stand between a clean checkout and a screen, and `docs/adr/README.md` is explicit that an ADR is
  the wrong place for a command: this record fixes the shape, and the chore that implements it owes
  the operative steps a home under `docs/`, next to `docs/story-mechanics.md`, where they are
  expected to move.
- **The shell is the thing the owner will ask to change first**, and most of what they ask for will
  not be a shell change. A row that reads better, an order, a date to move between: each is a
  requirement, and the guard above is what keeps them from being typed into the shell on a `chore/`
  branch because the file is already open.

## Alternatives considered

**A SwiftPM executable target drawing a macOS window** — the cheap answer, and it works: measured
above, it builds in six seconds with `swift build`, opens a 900×450 window, needs no `.xcodeproj`,
no 8.52 GB and no Xcode beyond the toolchain, and CI would build it for free because the existing
`swift` job discovers `Package.swift`. That saving is real and is why it was weighed rather than
dismissed. It is rejected on two measured facts and one principle. The facts: an unbundled SwiftPM
executable is `BackgroundOnly` with a `nil` bundle identifier, so it has no Home screen presence,
no icon, no menu bar and no application-support container of its own — which is the one place
ADR-1017's record is allowed to live. The principle is `CONTEXT.md` § *An iPhone, in your hand*: a
window on a laptop is precisely the surface that principle exists to keep decisions off. It would
have bought a running thing today at the price of judging a phone app on a desk.

**One `.xcodeproj` serving both iOS and macOS destinations** — rejected because it doubles the
destinations every later change has to be looked at on, in exchange for a second look nobody asked
for. SwiftUI that compiles for both is written for neither, and the product has one platform by
ADR-1001, which rejected every cross-platform option on the ground that the second platform is
hypothetical.

**Running on the phone instead of the simulator** — the real target, and eventually the only one
that matters. Rejected for now because it costs the 99 USD immediately, needs the device paired and
provisioned, and answers no question the simulator does not. It is a step this shell makes possible
rather than an alternative to it.

**Generating the project with XcodeGen or Tuist** — a YAML file and a tool instead of 216 lines of
`pbxproj`. Rejected because the problem generators solve is the per-file churn that
`PBXFileSystemSynchronizedRootGroup` already removes, and because it is a third-party dependency
and a build step in a repository that has neither for the Swift side. Reconsider if the project
file starts changing on every Story.

**Making the shell a Feature with a capability spec** — rejected because its requirements would be
untestable by construction. ADR-0005 maps every scenario one-to-one onto an acceptance test, and
nothing in this repository can assert that SwiftUI drew anything; the scenarios would either fail
CI check 4 or be satisfied by tests asserting something else. A spec whose scenarios do not mean
what they say is worse than no spec, because the next reader believes it.
