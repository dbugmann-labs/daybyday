# 1029. The UI smoke layer is a chore, and it is XCTest

- Status: accepted — the lane was the owner's decision on 2026-09-06, taken against this record's
  recommendation that a Story could not carry it; everything below it is this record's own and is
  accepted by the chore PR that carries it
- Date: 2026-09-06
- Amended: 2026-09-07 — the cost this record booked was wrong within a day, and the first
  consequence below is rewritten to say what it actually is. Nothing in the Decision moves: the
  lane, the framework and the thin assertion are untouched, and so is the rule that this layer
  asserts the shell drew and never what it drew.
- Deciders: Diego Bugmann

## Context

`docs/open-questions.md` § *No UI smoke layer* has been open since `day-screen`'s G1 on
2026-08-31. Acceptance tests attach at a seam inside `DayByDayKit`, so nothing automated proved
SwiftUI drew anything: a row left blank by a misspelled binding type-checks, passes all 300 tests
behind the seam, and ships.

Two things changed that made it worth closing now rather than deferring again.

**The compile half was paid.** ADR-1019 named an `xcodebuild` step and its own trigger for adding
it; the trigger fired and the step landed on 2026-09-06. It proves the shell builds against the
kit and nothing about drawing, which is exactly the half of the gap it was always going to leave.

**XCUITest had already been proven on this project, twice, and thrown away twice.** While
evidencing `add-commitments-screen`'s (#104) shell walkthrough, a UI test harness was built
outside the repository and driven end to end — `testWalkthrough passed (121.049 seconds)`,
`** TEST SUCCEEDED **`, eight checks against the real shell — and an earlier report that it needed
an Accessibility grant was found to be wrong. It was not committed, correctly: a new Xcode target
is a project-file edit past the bounded shell exception that Story was working under. So the
harness was rebuilt by hand, driven, evidenced at length in `tasks.md` and discarded. #104 alone
did it twice, because the shell moved underneath the first run. That is a recurring per-Story cost
being paid to avoid a one-off one.

**Everything below was measured on this machine on 2026-09-06**, macOS 26.6.2, Xcode 26.6, against
this repository's own `src/DayByDay/DayByDay.xcodeproj` rather than a probe:

- A UI testing bundle target can be hand-written into the existing project file, the same way the
  app target was. It needs a `PBXNativeTarget` of product type
  `com.apple.product-type.bundle.ui-testing`, a `PBXTargetDependency` on the app, a
  `PBXContainerItemProxy`, `TEST_TARGET_NAME = DayByDay` in its build settings, and `TestTargetID`
  in the project's `TargetAttributes`. `xcodebuild -list` then reports both targets, and the
  scheme `xcodebuild` derives runs the tests with no `.xcscheme` in the tree.
- The sources reach it through `PBXFileSystemSynchronizedRootGroup`, exactly as the app's do, so
  **adding a second UI test file needs no project-file edit** — the property ADR-1019 relied on to
  keep a hand-written project tolerable holds for this target too.
- `CODE_SIGNING_ALLOWED = NO` is enough; the UI test bundle needs no signing identity either.
- The smoke test runs in **7 seconds** once built. The whole `xcodebuild test` invocation, cold,
  with no derived data, is **50 seconds**.
- **It goes red for the right reason.** With `Text("Today")` misspelled as `Text("Todayy")` — a
  change that compiles, and that every test behind the seam passes — the run ends
  `** TEST FAILED **`. That is the failure class this layer exists for, and it was demonstrated
  rather than assumed.

## Decision

**Three things.**

**1. It is a chore, not a Story.** `docs/process.md` §5 reserves the `chore/` lane for work with
no behaviour change — "tooling, dependency bumps, docs, CI" — and this is all three. It adds no
requirement, touches no capability spec, and has nothing to put in a change folder. Every Feature
on the tracker maps one-to-one onto a capability spec; there is no capability for *the app is
tested*, and inventing one would put test infrastructure in `openspec/specs/` as though it were
product behaviour, then restate `day-screen`'s existing requirements at a second level. A Story
here would declare no scenarios, which makes CI check 4 skip itself — a hollow Story is worse than
a chore, because the next reader believes it.

This follows ADR-1019 exactly, which is the same shape for the same reason: an ADR standing in for
a delta, which `.claude/agents/implementer.md` already knows how to work from.

**2. It is XCTest, and that is not a preference.** Xcode compiles a UI testing bundle with

```
-module-alias Testing=_Testing_Unavailable
```

so `import Testing` fails outright with `Unable to resolve module dependency:
'_Testing_Unavailable'`. Swift Testing is not merely awkward in a UI test bundle; the build system
switches it off by name. Measured here, not recalled — it is visible in the `SwiftDriver`
invocation for the target.

**3. Therefore CI check 4 does not change, and the gap's third cost was never real.** That cost
was booked on the assumption that UI tests would have to satisfy scenarios, which would need check
4 to see a test name that is not a `@Test("...")` literal. On the chore lane there are no
scenarios to satisfy, so the check never has to see these names at all. `scripts/lib/coverage.ts`
walks every `.swift` file in the tree and extracts `@Test("...")` titles; `WalkthroughUITests.swift`
contains none and contributes nothing. **The lane decision deleted the cost rather than paying it.**

**What the layer asserts is deliberately thin.** It launches the app and checks that the day
screen's fixed controls exist and that the list drew at least one row. It does **not** assert
which commitments are due, in what order, or with what kept flag: those are `day-screen`'s and
`schedule`'s requirements, they are specified, and they are tested behind the seam where they can
be driven without a simulator. A UI test that restated them would be a second, slower, flakier
copy of a suite that already exists, and it would have to change every time the calendar did.

**The rule that keeps it thin:** *this layer asserts that the shell drew, never what it drew.*
Anything that needs to assert *what* is a requirement, and requirements live behind the seam.

## Consequences

- **The `swift` job grows a third step.** This record first costed it at 3m45s on `macos-26`
  against 50s here, and said a UI test spends most of that booting a simulator clone rather than
  testing. The diagnosis was right and the number was not: **it was never a fixed price, and by
  the following day it was 5m10s and 8m36s on two consecutive runs** (34120659274 and
  34116245290). The job's own step logs, timestamped on 2026-09-07, put 19s of that on the build,
  25-40s on the test case, and **260-450s on simulator setup** — all of it serial, all of it
  after the build had finished and the runner had nothing else to do.

  **Amended 2026-09-07. Part of that was a defect and part of it is a price, and the amendment
  that matters is being able to tell them apart.** The job now has a step that does nothing but
  boot the simulator, so its cost is on the page instead of inside the UI test's number:

  - **The defect: `xcodebuild test` was cloning the device** — `Clone 1 of iPhone 17 Pro` in both
    runs' logs — because the scheme `xcodebuild` derives parallelises by default and there is no
    `.xcscheme` in the tree to say otherwise. One test on one device buys nothing from a clone.
    `-parallel-testing-enabled NO` declines it: 47.7s to 28.3s locally, and on the runner the
    test operation fell from 284.6s and 492.4s to 76.1s, 96.5s and 112.6s across three runs.
  - **The price: the cold first boot of the simulator is 115-135s across three runs** and nothing
    here can make it cheaper. A runner's devices have never been booted since the image was built,
    and that was checked rather than assumed: `simctl list devices booted` on `macos-26` prints
    the iOS 26.2, 26.4, 26.5 and tvOS 26.2 runtime headers and no device rows, so there is no warm
    device to prefer. The discovery prefers one anyway, for the day an image ships one. This price
    was always being paid — it is most of what this record originally booked as the UI test being
    slow.
  - **Overlapping the price with `swift test` does not work, and that was tried.** With
    `simctl boot` started at the top of the job the boot does run underneath the other steps —
    the command returns in about half a second and the boot proceeds inside
    `CoreSimulatorService`, surviving the runner's orphan-process cleanup between steps, both
    verified. It buys nothing: over three runs `swift test`, untouched by the change, took 436s,
    245s and 384s against a 34-76s baseline over the eight runs before it, while the smoke step
    fell by about the same amount. **A `macos-26` runner has no spare capacity to absorb a
    simulator boot.** So the boot is serial and visible rather than concurrent and hidden.

  The separate compile step folded into the same `build-for-testing` while this was being done.
  It had been building a universal `x86_64 arm64` binary against `generic/platform=iOS Simulator`
  — 43-48s on the runner, confirmed with `lipo -archs` — and the test step then compiled the same
  sources again for the device it was about to run on. It measured 27s in that shape, against
  43-48s, at the cost of narrowing the check twice — the shell compiled for arm64 only, and with
  testability enabled. **Both narrowings were given back a day later** and the note is left here
  because the reasoning is the interesting part: the fold was only worth its cost while the two
  builds shared a runner, and the split below means the duplicate compile now happens on a second
  machine at the same wall-clock moment. It buys back the universal build for nothing.

  **Amended 2026-09-07, second time: the smoke layer is its own job.** The first amendment left
  the job total honestly open — the defect fixed, the price not, and the `swift` job still five to
  nine minutes whenever the smoke test ran. The lever it named has now been pulled. `ui-smoke` is a
  separate job on its own `macos-26` runner, so the boot is paid on capacity that is not competing
  with anything. Standard runners are free and unlimited on public repositories (ADR 0007), so the
  second machine costs nothing but a checkout. Measured on the chore's own run:

  | | before | after, two runs |
  |---|---|---|
  | `swift` | 7m11s - 12m32s | **1m13s, 1m46s** |
  | `ui-smoke` | — | 4m21s, 7m36s |
  | the whole run, longest job | 7m11s - 10m37s | **4m21s, 7m36s** |

  Two runs and not one, because this record has now twice been wrong by writing down a single
  measurement of a simulator boot. The honest reading of them is that the *required* check is
  unambiguously fixed — `swift` is a minute or two whatever the runner is doing — while the run's
  wall time still varies with the boot, because that is what the boot does. The first run's
  `ui-smoke` broke down as boot 72s, build 82s, test 81s.

  The test step at 81s is the settling effect being taken deliberately: 106-139s was what it cost
  on the runs where the device had been up for minutes, against 189-262s where it had just booted,
  so the boot is placed in front of `build-for-testing` and the build is the settling time.

  **The gate that this does not close, and it is the important sentence in this record.** The
  `main` ruleset's required status checks are `verify` and `swift`, by name. `ui-smoke` is not one
  of them, so **until somebody adds it there a red smoke test does not block a merge** — the job
  goes red, the PR stays mergeable. Adding it is a repository setting, which rule 6 puts with the
  owner rather than an agent, and it has a consequence worth knowing before it is done: a required
  check that a branch's workflow does not define never reports, so every open branch cut before
  this change has to rebase onto `main` before it can merge. This is exactly the shape ADR-0013
  warns about — a guardrail that a table has a row for and nothing enforces.

  **What this record got wrong is worth naming, because the shape recurs.** It measured one cold
  run of a step whose cost is dominated by a simulator boot, wrote the number down as a property
  of the step, and built an argument on it. Simulator boot on a shared runner is variable by
  nature — 260s and 450s in the same week — so a single measurement of it is a sample, not a
  price. Nothing here was recalled rather than run; the error was treating one run as the answer.
  The chore that fixed it repeated the shape once, betting on an overlap that three runs then
  disproved, which is why the disproof is written down above rather than quietly reverted.

  **So it is gated twice, and this is the part of the record most likely to be revisited.** It is
  skipped while a PR is a draft — the idiom checks 4, 5, 8 and 9 already use, and the reason
  `ready_for_review` is in the workflow's trigger list — and skipped again unless the diff reaches
  `src/DayByDay/`, `src/DayByDayKit/Sources/` or the workflow itself. Eight of this repository's
  first 129 commits touched the shell, and a Story pushes tens of times while it is a draft, so
  unconditionally this would be waste on nearly every push. Neither gate weakens the merge: a
  Story leaves draft at Stage 8, a chore PR is never a draft, and the push to `main` is ungated by
  the first condition — so nothing merges without it having run.
- **The step discovers its simulator device** from `simctl` rather than naming one, because the
  runner image's device list moves with Xcode
  and is not ours to pin; the step prints which device it took, so a green run is attributable.
- **`docs/open-questions.md` § *No UI smoke layer* closes**, four Stories and six days after it
  was opened. It moves to *Settled* with this pointer.
- **The per-Story walkthrough cost drops but does not vanish.** A Story that adds a screen still
  has to look at it — `docs/running-the-app.md` is still how anyone sees the app, and a screenshot
  is still how an agent proves it drew. What ends is rebuilding a throwaway harness to prove the
  shell is not blank, and evidencing it at length in a `tasks.md` that then gets archived.
- **This layer will be under-maintained, and that is the accepted risk.** It is the one test in
  the repository that no Story owns, no scenario drives and no gate reads. The guard against it
  rotting into either uselessness or flakiness is the rule above: it asserts that the shell drew,
  never what it drew, so there is very little for the calendar or a requirement change to break.
  If it starts failing for reasons that are not "the shell stopped drawing", that is the trigger
  to reconsider, not to add a `sleep`.
- **A second UI test file is free**, and a second *target* is not. `PBXFileSystemSynchronizedRootGroup`
  covers files; anything needing a new target is another hand-written project edit and another
  decision.
- **The app target's own unit tests are still absent and still not wanted here.** `DayByDayKit` is
  where logic lives and `swift test` is where it is tested; the app target holds a shell that
  decides nothing, and giving it a unit test bundle would invite putting logic there.

## Alternatives considered

**A Story with a `ui-smoke` capability.** Rejected on §5 and on what the delta would have to say.
Its requirements would either restate `day-screen`'s at a second level — the horizontal
duplication ADR-0005's one-scenario-one-test rule exists to prevent — or be untestable statements
about drawing that no scenario could pin. It would also need a new Feature and a new capability
directory for something that is not a product capability. This was put to the owner as a choice
on 2026-09-06 with the chore lane recommended, and the chore lane was chosen.

**Leave it open and keep rebuilding the harness per Story.** The status quo, and it has a real
argument: nothing that ships depends on this test. Rejected on the arithmetic. The harness was
built twice inside one Story; the committed version costs 50 seconds of CI and a project-file
edit made once.

**Snapshot testing instead of XCUITest** — comparing rendered images rather than driving the app.
Rejected because it needs a third-party dependency on a Swift side that has none, because the
views live in the app target rather than in the kit so nothing can construct them from
`swift test`, and because a snapshot suite asserts *what* was drawn, pixel for pixel, which is
precisely what the rule above keeps out of this layer. It would fail on every legitimate change.

**Driving the simulator with `osascript` and System Events**, which an earlier attempt inside #104
reached for. Rejected: it answered `-1719` because Simulator had no window to address, it needs a
window server at all, and XCUITest does the same job through a supported interface with no
Accessibility grant.
