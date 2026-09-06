# 1029. The UI smoke layer is a chore, and it is XCTest

- Status: accepted — the lane was the owner's decision on 2026-09-06, taken against this record's
  recommendation that a Story could not carry it; everything below it is this record's own and is
  accepted by the chore PR that carries it
- Date: 2026-09-06
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

- **The `swift` job grows a third step** and about four minutes: 3m45s on `macos-26`, against 50s
  on this machine. A UI test spends most of that booting a simulator clone and installing the app,
  not testing — the test case itself is 25s there and 7s here. The job went from about 90 seconds
  to about five minutes.

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
