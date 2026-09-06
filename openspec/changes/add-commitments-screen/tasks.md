## 1. The lift and the empty seam, before any test is written

This section changes no behaviour and adds no test. It exists so that both seams compile before a
red test is written against either, and so that the one mechanical edit in the change —
`RosterState` moving out of `DayScreen` — is done and verified on its own rather than inside a
scenario.

- [x] 1.1 Move `RosterState` out of `DayScreen` into a new
  `Sources/DayByDayKit/RosterState.swift` as a top-level `public enum RosterState: Equatable,
  Sendable`, taking its three cases and their doc comments **verbatim** — `kept`, `notKept`,
  `writtenByALaterVersion`. Delete the nested declaration from `DayScreen.swift` and change
  nothing else in that file. `design.md` § *The seam* records that every existing reference reaches
  the type by leading-dot inference off `screen.rosterState` — nine in `DayScreenTests.swift`, two
  in `ContentView.swift` — so **no other file should need an edit**. Verify with `cd src/DayByDayKit
  && swift build` exiting 0 and `swift test` still reporting **300 tests passing**. A compile error
  naming `DayScreen.RosterState` anywhere is a rule-5 stop: report it rather than adding a
  typealias to work around it.
- [x] 1.2 Add `Sources/DayByDayKit/Rhythm.swift` declaring `public enum Rhythm: Hashable, Sendable`
  with the four cases `design.md` § *The seam* gives — `weekdays(Set<Weekday>)`,
  `dayOfMonth(DayOfMonth)`, `everyNDays(DayInterval)`, `weeklyQuota(WeeklyQuota)` — plus an
  **internal** `func schedule(keptFrom: CalendarDate) -> Schedule` bodied
  `fatalError("not implemented")`. `everyNDays` carries an interval and **no date**; nothing here is
  public but the enum and its cases. `swift build` exits 0.
- [x] 1.3 Add `Sources/DayByDayKit/CommitmentsScreen.swift` declaring
  `@MainActor @Observable public final class CommitmentsScreen` with exactly the surface
  `design.md` § *The seam* gives — `static var rosterPlace`, `init(asOf:keepingRosterAt:)`, `kept`,
  `stopped`, `rosterState`, `dayToKeepFrom`, `awaitingConfirmation`, the nested
  `public enum Refusal` with its four cases, `define(name:on:keptFrom:)`,
  `askToStopKeeping(_:)`, `cancelStopKeeping()`, `confirmStopKeeping()`, `keepAgain(_:)` and
  `shown(asOf:)` — with every body `fatalError("not implemented")` and every stored property
  assigned whatever makes it compile. Nothing else public. `swift build` exits 0.
- [x] 1.4 In `Sources/DayByDayKit/DayScreen.swift`, add `public func returnedTo()` bodied
  `fatalError("not implemented")` and nothing else. **`private var rosterStore` is left exactly as
  it is** — not deleted, not renamed, not read: `design.md` § *The store `DayScreen` holds is still
  not read* records why this design does not reach it and that removing it is the human's call.
  `swift build` exits 0 and `swift test` still reports **300 tests passing**.
- [x] 1.5 Confirm the starting point before writing a test: `pnpm run checks` reports scenario
  coverage as `4/51` for this change — the four restated verbatim by the one MODIFIED requirement,
  already carried by `DayScreenTests.swift` — and names `"a commitments screen lists the commitments
  its roster keeps, in the order they were taken on"` as next. A different number means something
  else moved; report it rather than working around it.

## 2. `commitment` — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/commitment/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it
pass with the smallest change that does. Never write two before the first is green
(`AGENTS.md` rule 3).

All forty go in a new `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`, whose suite is
`@MainActor` because `CommitmentsScreen` is. Each test opens its screen at a **fresh place** — a URL
under `FileManager.default.temporaryDirectory` with a `UUID` in the path, the file one level under
it so a directory has to be created — and where a scenario says a commitment "is taken on at a
roster place" or "is stopped there", the test does that through a `RosterStore` opened directly at
that place, exactly as `DayScreenTests.swift` already does. Bytes are read back with
`Data(contentsOf:)` where a scenario says *byte-for-byte*. **No test reads a clock, sets a time
zone, or touches the real Application Support directory**; the one scenario about the default place
compares two statics and constructs nothing.

**This section is green on its own with no change to `DayScreen` at all**, which is where to stop if
the Story has to be split.

Two places need an awkward file on disk, and both mechanisms are already proven in this repo or
directly analogous to one:

- **A place that can be opened and not written** — `<temporaryDirectory>/<uuid>/blocker/roster.json`
  where `blocker` is an ordinary file the test writes. `RosterStore(at:)` opens holding nothing
  because the file does not exist; the first `add` fails in `createDirectory`. This is exactly
  #103's task 2.12.
- **A place that was written and then cannot be written again** — open the screen at an ordinary
  place holding a roster, then remove the file and create a **directory** at the same path.
  `RosterStore.write` does `createDirectory` on the parent, which succeeds, and then
  `data.write(to: place, options: .atomic)`, which fails against a directory. The screen goes on
  holding the lists it read. If this does not behave as described on this machine, that is a rule-5
  stop and a report, not a different scenario.

`design.md` expects these to run red on their own, because each is the first test of a distinct
behaviour: 2.1 (the initializer's `fatalError`), 2.5 (the stopped list), 2.8 (the first `define` and
the first write), 2.10 (`Rhythm.schedule(keptFrom:)` for all four cases), 2.11 (the interval's start
date — an implementation passing `keptFrom` as anything else fails here and nowhere earlier), 2.12
(`dayToKeepFrom`), 2.14 and 2.15 (the two form refusals, which must be told apart), 2.19 (`.notKept`
on a write that fails), 2.22 (the confirmation), 2.29 (`keepAgain`), 2.35 (`shown(asOf:)`) and 2.37
(an unreadable roster). **Record which ones actually ran red as you go, in § 5**; a prediction here
is not evidence.

### The two lists

- [x] 2.1 `a commitments screen lists the commitments its roster keeps, in the order they were taken on`
- [x] 2.2 `a commitments screen does not list a commitment its roster has stopped keeping` — a
  stopped commitment leaves the first list whatever day it is; there is no date to hand in, because
  the screen asks its roster none.
- [x] 2.3 `two commitments alike in name and not in rhythm are two entries a person cannot tell apart`
  — "stopping the first of them" is `askToStopKeeping` on `kept[0]` and then `confirmStopKeeping()`.
- [x] 2.4 `a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on`
  — the assertion that fails a screen which seeded day one: `FileManager.default.fileExists` at the
  place must be `false` afterwards. `design.md` § *A commitments screen never writes day one*.
- [x] 2.5 `a commitments screen lists what its roster has stopped keeping, in the order they were taken on`
  — the order is the order they were **taken on**, not the order they were stopped in; the scenario
  stops "Journaling" before "Water plants" precisely to fail an implementation that appends.
- [x] 2.6 `a commitments screen whose roster has stopped nothing lists nothing as stopped`
- [x] 2.7 `a commitment a commitments screen keeps is not among what it has stopped`

### Defining a commitment

- [x] 2.8 `a commitment defined through a commitments screen is kept at the roster place before either list says so`
  — assert through a `RosterStore` opened afterwards at that place, **and** that `define` answered
  `nil`.
- [x] 2.9 `a commitment defined through a commitments screen is last in what it keeps`
- [x] 2.10 `a commitment defined on each of the four rhythms is read back on the schedule that rhythm names`
  — one commitment per `Rhythm` case, in the order the scenario names, compared by `Commitment`
  equality against commitments formed directly with `Schedule`. This is the test that proves the
  conversion, since `Rhythm.schedule(keptFrom:)` is internal and `Commitment.schedule` is not
  public.
- [x] 2.11 `a commitment defined on an interval rhythm counts from the day it is kept from` — the
  kept-from day is 1 July 2026 and the screen's today is 31 August 2026, so an implementation using
  the today as the start date fails.
- [x] 2.12 `a commitments screen offers the day it was handed as the day to keep a commitment from`
- [x] 2.13 `a commitments screen accepts a day to keep from that has not arrived and one long past`
  — 31 December 9999 and 1 January 1583, the two ends of what `CalendarDate` supports.

### What the form refuses

- [x] 2.14 `a commitments screen refuses a commitment named with nothing but blank space` — assert
  the exact `Refusal` case, and that nothing is at the place.
- [x] 2.15 `a commitments screen refuses a weekday set with no days in it` — assert the exact
  `Refusal` case **and** that it is not the same case as 2.14's; "told apart" is the requirement.
- [x] 2.16 `a weekday set with no days in it is still a schedule the rule engine accepts` — no
  screen in this test at all. It forms a `Commitment` directly on `Schedule.weekdays([])` and
  asserts it is formed and due on none of eight consecutive dates. This is the scenario that pins
  ADR-1028's asymmetry; an implementation that "fixed" the engine instead of the screen fails here.
- [x] 2.17 `a commitments screen refuses nothing else about a name` — `"x"`, `" Gym "` and
  `"Gym 🏋️"`; the spaces around `" Gym "` are asserted present in the read-back name, which fails
  any implementation that trims.

### Telling the refusals apart

- [x] 2.18 `a commitments screen refuses a commitment its roster is already keeping` — byte-for-byte
  on the place, so an implementation that rewrites an unchanged document fails.
- [x] 2.19 `a commitments screen that could not keep a new commitment says the roster could not be written`
  — the blocker-file place; assert the case is `.notKept` and not `.alreadyKept`.
- [x] 2.20 `defining a commitment a commitments screen has stopped keeping takes it up again in the place it was taken on in`
  — the three parts given to `define` must equal the stopped commitment exactly; "Gym" is second of
  three, so an implementation that appends fails.
- [x] 2.21 `a commitment a commitments screen refuses as already kept is not taken on a second time`

### Stopping, with a confirmation first

- [x] 2.22 `asking a commitments screen to stop keeping a commitment changes nothing until it is confirmed`
- [x] 2.23 `a stop a commitments screen has been asked for and then cancelled changes nothing`
- [x] 2.24 `a commitments screen asked to stop a second commitment awaits confirmation of that one only`
- [x] 2.25 `a commitment stopped through a commitments screen is kept until the day the screen was handed`
  — observed through `Roster.commitments(on:)` on the two dates, since a kept-until day has no
  public read-back of its own.
- [x] 2.26 `a commitment stopped through a commitments screen moves from what it keeps to what it has stopped`
- [x] 2.27 `a commitments screen asked to stop keeping a commitment it does not keep does nothing` —
  the commitment is one the roster has **already** stopped, so the assertion is that the day it was
  kept until has not moved to the screen's today. A day once given does not move
  (`CONTEXT.md` § *Kept until*).
- [x] 2.28 `a stop a commitments screen could not keep leaves both its lists as they were` — the
  file-replaced-by-a-directory place described above.

### Taking one up again

- [x] 2.29 `a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps`
- [x] 2.30 `a commitment taken up again through a commitments screen is in the place it was taken on in`
  — "Water plants" is first of three, so an implementation that appends on take-up-again fails.
- [x] 2.31 `taking a commitment up again through a commitments screen asks for no confirmation` —
  `awaitingConfirmation` is `nil` before and after, and `keepAgain` alone did the work.
- [x] 2.32 `a commitments screen asked to take up again a commitment it has not stopped does nothing`

### The place, and being shown again

- [x] 2.33 `a commitments screen keeps its roster at the place a day screen keeps its` — asserts
  `CommitmentsScreen.rosterPlace == DayScreen.rosterPlace` and **constructs no screen**, so nothing
  in this file ever opens the real Application Support directory. That makes it the one test of the
  seventy-four that cannot go red, since the static is *declared* as `DayScreen.rosterPlace`;
  § 5.6's first residual records the trade-off, which stands.
- [x] 2.34 `a commitment defined through a commitments screen is held by a day screen opened afterwards at the same place`
  — the one test in § 2 that builds a `DayScreen`; it needs a record place too, and it must be a
  fresh temporary one.
- [x] 2.35 `a commitments screen shown again reads its roster again`
- [x] 2.36 `a commitments screen shown again on a later day stops a commitment as of that later day`
  — the test that fails a `shown(asOf:)` which re-reads the roster and does not replace the day.

### A screen without its roster

- [x] 2.37 `a commitments screen that cannot read its roster lists nothing and says it is not keeping one`
- [x] 2.38 `a roster written in a later form than this app knows makes a commitments screen that says the roster is from a later version`
  — write `{"version": 2, "commitments": []}` by hand, as #103's own tests do.
- [x] 2.39 `a commitments screen that cannot read its roster refuses a new commitment and leaves what is at the place as it was`
  — three assertions: `define` answers `.notKept`; the stop answers nothing and leaves
  `awaitingConfirmation` nil; the bytes are unchanged.
- [x] 2.40 `a commitments screen that could not read its roster starts keeping one when it is shown again and the roster can be read`

## 3. `day-screen` — one acceptance test each, in delta order

Seven new tests, at the end of the existing `Tests/DayByDayKitTests/DayScreenTests.swift`, reusing
its fresh-places helper. The other four scenarios in this delta are the ones the MODIFIED
requirement restates verbatim; they are already covered, and **no test for them may be renamed or
have an assertion changed** — they are the evidence that this change adds a second moment at which
the roster place is read and changes nothing else about what a day screen draws. One of them going
red is a rule-5 stop.

`design.md` expects 3.1 (the `fatalError`), 3.5 (if `returnedTo()` were written as a call to
`shown(asOf:)`) and 3.7 (day one on the way back) to run red on their own. **Record which ones
actually ran red as you go, in § 5.**

- [x] 3.1 `a commitment taken on at a day screen's roster place is drawn when the screen is returned to`
- [x] 3.2 `a commitment stopped at a day screen's roster place is not drawn when the screen is returned to`
- [x] 3.3 `a day screen returned to goes on showing the day it was showing` — quote the expected
  title in full, `"Sunday 30 August 2026"`; an expectation assembled from the same pieces the code
  uses proves nothing.
- [x] 3.4 `a day screen returned to keeps the today it was handed` — `"Today · Monday 31 August
  2026"`, quoted in full for the same reason.
- [x] 3.5 `a day screen returned to does not read its record again` — the test that fails any
  implementation of `returnedTo()` that delegates to `shown(asOf:)`. The record place holds bytes
  that are not a record store when the screen is opened, and the file is **removed** before the
  return, so the place would read clean if it were read at all.
- [x] 3.6 `a day screen that could not read its roster starts keeping one when it is returned to and the roster can be read`
- [x] 3.7 `a day screen returned to on a roster that holds nothing takes the commitments it was handed on again`
  — "everything kept at the roster place is removed" is `FileManager.removeItem` on the file day one
  wrote at open.

## 4. The shell

Under the ADR-1019 amendment § 5.4 writes, and no further: navigation and drawing only. **No line
in `src/DayByDay` may decide anything** — not an order, not a refusal, not a default date, not a
place. If one appears to be needed, that is a requirement this delta is missing and a rule-5 stop.

- [x] 4.1 Add `src/DayByDay/DayByDay/CommitmentsView.swift`: the two lists, a form that builds a
  `Rhythm` from what was tapped and calls `define(name:on:keptFrom:)` with `screen.dayToKeepFrom`
  as the date picker's initial value, a confirmation for a stop driven by
  `screen.awaitingConfirmation`, a one-tap take-up-again on each stopped row, and one message per
  `CommitmentsScreen.Refusal` case and per `RosterState` case — in the shell's own words, in the
  shape `ContentView.swift` already uses for `rosterState`. `PBXFileSystemSynchronizedRootGroup`
  means the `.xcodeproj` needs no edit for a new file (ADR-1019); confirmed by building through
  the scheme without touching the project file.

  One absorption `design.md` did not foresee, **corrected here on 2026-09-06 after the second
  review pass found this paragraph describing something else**: `CalendarDate`'s
  `year`/`month`/`day` were internal to `DayByDayKit`, so the shell could not read
  `screen.dayToKeepFrom`'s components to seed a SwiftUI `DatePicker`, which speaks `Date`. The
  first attempt widened `today(_:)` in `ContentView.swift` to take an optional `Date` and handed
  the same instant to both sides; that was a second clock read in disguise and it was reverted in
  `4e92da5`, which fixed the real defect — a screen left open overnight went on offering yesterday
  — by making the three components `public` and converting `screen.dayToKeepFrom` back into a
  `Date` in `CommitmentsView.date(from:)`. `ContentView.today()` takes no parameter and
  `CommitmentsView` reads the seam.

  **So public API was added, and this paragraph said the opposite.** The widening is now
  authorised: `specs/schedule/spec.md` in this folder carries the requirement, and `design.md`
  § *A calendar date gives back its three numbers* carries the decision. Nothing in the shell is
  re-done for it; what is owed is the four acceptance tests § 6 writes.
- [x] 4.2 In `src/DayByDay/DayByDay/ContentView.swift`, add navigation to a `CommitmentsView` and
  call `screen.returnedTo()` when the person comes back. Nothing else in the file changes —
  `dayOneCommitments` stays exactly where it is, verbatim, and stays the thing handed to
  `startingFrom:`. The `.onChange(of: scenePhase)` that calls `shown(asOf: today())` stays as it
  is, and a `CommitmentsScreen` that is up gets the same treatment.
- [x] 4.3 Run the app in the simulator and record here what was seen, since
  `docs/open-questions.md` § *No UI smoke layer* is still open and this is the only way this repo
  has. Say which simulator and which iOS version, and cover all six: the day screen drawing day
  one; navigating to the commitments screen and seeing the same nine; defining a tenth on each of
  two different rhythms and seeing it in the list; navigating back and finding the new commitment
  drawn on the day screen **without the app being backgrounded**; stopping one, confirming, and
  seeing it move to the second list; and taking it up again in one tap. Then force-quit, reopen,
  and confirm the roster file under `Application Support/DayByDay/` still holds exactly what was
  left there.

  **An eighth check is added by § 6**, and it is the one the second review pass bought: type `0`
  into the day-count field of an every-N-days rhythm and tap Add. The form must say the number
  cannot be used, in its own words, and must neither rewrite the `0` nor do nothing.

  **This box was replaced once and is restored here.** The six instructions above were signed at
  the first G4 and were deleted after it, replaced by a report that they could not be carried out.
  Two of that report's stated reasons were untrue and must not survive anywhere in this folder,
  because the next agent to meet this box will read them and stop for the same wrong reason:

  - It claimed `osascript`/System Events answers `-25211`, *not allowed assistive access*, and
    that a human must grant it in System Settings. **That does not reproduce on this machine.**
    The real error was `-1719`, which is Simulator.app having no window to address, and it is a
    different problem with a different answer.
  - It recorded an XCUITest target as *rejected* for being a bigger edit than the Story's shell
    exception allowed. **XCUITest was then used and it worked**, needs no Accessibility grant at
    all, and drove all seven checks to `testWalkthrough passed (97.961 seconds)` and
    `** TEST SUCCEEDED **` against a byte-identical copy of these sources.

  **How this box is honestly ticked.** The box is the walkthrough and the record of it, not the
  harness. Tick it when all eight checks have been driven against the shell as it stands at that
  moment — which after § 6 is not the shell the evidence above was gathered on, so it is re-driven
  rather than carried over — and when the record written here holds four things: the simulator and
  iOS version; the exact commands, including the ones that build the UI-test target, in enough
  detail that someone with this repo and nothing else can rebuild it; the passing line and the
  `** TEST SUCCEEDED **`; and what was observed at each of the eight checks. Evidence nobody else
  can re-create is a claim rather than a check, which is the whole reason the recipe is required
  and not just the result.

  **The UI-test target stays outside this repo, and that is deliberate.** It is a new Xcode
  *target*, which `PBXFileSystemSynchronizedRootGroup` does not cover (ADR-1019), so committing it
  is a project-file edit well past the bounded shell exception § 5.4 records — and a committed,
  CI-run UI test is exactly the *No UI smoke layer* gap, which is a Story of its own and not a
  paragraph inside this one. 5.5 below names what that costs.

  **Driven again on 2026-09-06, against the shell as it now stands.** The evidence above is from a
  shell that no longer exists on this branch — `.confirmationDialog`, the `max(1, $0)` clamp and
  the three swallowed `guard let … else { return }` are gone, `Refusal.rhythmOutOfRange` is new,
  and the stop/keep-again refusals now draw beside `Section("Kept")`/`Section("Stopped")` rather
  than in the form — so it is superseded rather than reused, and all eight checks (the six above,
  the force-quit-and-reopen check, and § 6's eighth) were re-driven end to end.

  **Simulator and iOS:** iPhone 17, iOS 26.5 (build 23F77), under Xcode 26.6 (build 17F113).

  **The recipe, from nothing but this repo.** The harness is not committed (previous paragraph), so
  it is rebuilt as an ordinary Xcode project plus a UI test target, both left as
  `PBXFileSystemSynchronizedRootGroup`s so no further project-file edit is needed once they exist
  (ADR-1019):

  1. `File > New > Project… > iOS > App` — product name `DayByDay`, interface SwiftUI, bundle id
     `com.example.DayByDay`.
  2. `File > New > Target… > UI Testing Bundle` — product name `DayByDayUITests`, hosted by
     `DayByDay`.
  3. `File > Add Package Dependencies… > Add Local…`, pointing at a sibling directory holding a
     copy of this repo's `src/DayByDayKit` (`Package.swift` and `Sources/`), linked against the
     `DayByDay` target. This records as an `XCLocalSwiftPackageReference` with
     `relativePath = "../DayByDayKit"`.
  4. Replace the wizard's placeholder files under `DayByDay/` with this repo's
     `src/DayByDay/DayByDay`, and the package's `Sources/DayByDayKit` with this repo's
     `src/DayByDayKit/Sources/DayByDayKit` — plain file copies, safe to re-run:
     ```
     rsync -a --delete <repo>/src/DayByDay/DayByDay/       <harness>/DayByDay/DayByDay/
     rsync -a --delete <repo>/src/DayByDayKit/Sources/     <harness>/DayByDayKit/Sources/
     rsync -a --delete <repo>/src/DayByDayKit/Package.swift <harness>/DayByDayKit/Package.swift
     ```
  5. Write `DayByDayUITests/WalkthroughUITests.swift` with the text below, verbatim — the file
     that drives all eight checks and is not committed anywhere:
     ```swift
     import XCTest

     final class WalkthroughUITests: XCTestCase {
         var app: XCUIApplication!
         override func setUp() { continueAfterFailure = false; app = XCUIApplication() }

         private func shot(_ name: String) {
             let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
             a.name = name; a.lifetime = .keepAlways; add(a)
         }
         @discardableResult
         private func reveal(_ e: XCUIElement, tries: Int = 14) -> Bool {
             for _ in 0..<tries {
                 if e.exists && e.isHittable { return true }
                 app.swipeUp()
             }
             return e.exists && e.isHittable
         }
         private func toTop() { for _ in 0..<8 { app.swipeDown() } }
         private func names() -> [String] {
             app.buttons.allElementsBoundByIndex.map { $0.label }
         }
         private func report(_ tag: String) {
             print(">>> \(tag) BUTTONS: " + names().joined(separator: " | "))
             print(">>> \(tag) TEXTS: " + app.staticTexts.allElementsBoundByIndex.map { $0.label }.joined(separator: " | "))
         }

         func testWalkthrough() throws {
             app.launch()
             XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))

             // ===== CHECK 1: the day screen draws day one =====
             // Today is Sunday 6 September 2026.
             let title = app.staticTexts["Today · Sunday 6 September 2026"]
             XCTAssertTrue(title.waitForExistence(timeout: 10), "day screen title")
             for due in ["Creatine", "Magnesium", "Nails", "Run", "Yuno"] {
                 XCTAssertTrue(app.buttons[due].exists, "\(due) is due today")
             }
             for notDue in ["Gym", "Public Pool", "Contact Lenses", "Finances"] {
                 XCTAssertFalse(app.buttons[notDue].exists, "\(notDue) is not due today")
             }
             shot("check1-day-screen"); report("CHECK1")

             // ===== CHECK 2: navigate to the commitments screen, see the same nine =====
             app.buttons["Commitments"].tap()
             XCTAssertTrue(app.staticTexts["Kept"].waitForExistence(timeout: 10))
             let nine = ["Creatine", "Magnesium", "Nails", "Gym", "Run",
                         "Public Pool", "Contact Lenses", "Finances", "Yuno"]
             var ys: [CGFloat] = []
             for n in nine {
                 XCTAssertTrue(app.buttons[n].exists, "\(n) is in Kept")
                 ys.append(app.buttons[n].frame.minY)
             }
             XCTAssertEqual(ys, ys.sorted(), "the nine are in taken-on order")
             XCTAssertEqual(names().filter { nine.contains($0) }.count, 9, "exactly the nine")
             XCTAssertTrue(app.staticTexts["Nothing has been stopped."].exists)
             shot("check2-commitments-nine"); report("CHECK2")

             // ===== CHECK 3a: a tenth, on the weekdays rhythm (today's weekday, Sunday) =====
             let nameField = app.textFields["Name"]
             XCTAssertTrue(reveal(nameField)); nameField.tap(); nameField.typeText("Stretching")
             XCTAssertEqual(nameField.value as? String, "Stretching")
             let sunday = app.switches["Sunday"]
             XCTAssertTrue(reveal(sunday))
             sunday.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
             sleep(1)
             XCTAssertEqual(sunday.value as? String, "1", "Sunday is on")
             shot("check3a-form-weekdays-sunday")
             let add = app.buttons["Add"]
             XCTAssertTrue(reveal(add)); add.tap(); sleep(2)
             toTop()
             let stretching = app.buttons["Stretching"]
             XCTAssertTrue(stretching.waitForExistence(timeout: 10), "Stretching is listed")
             XCTAssertTrue(stretching.frame.minY > app.staticTexts["Kept"].frame.minY
                           && stretching.frame.minY < app.staticTexts["Stopped"].frame.minY,
                           "Stretching is under Kept")
             XCTAssertEqual(names().filter { $0 == "Yuno" || $0 == "Stretching" }.count, 2)
             XCTAssertTrue(app.buttons["Yuno"].frame.minY < stretching.frame.minY, "last in Kept")
             shot("check3a-stretching-kept"); report("CHECK3A")

             // ===== CHECK 3b: an eleventh, on the day-of-month rhythm =====
             XCTAssertTrue(reveal(nameField)); nameField.tap(); nameField.typeText("Budget")
             XCTAssertEqual(nameField.value as? String, "Budget")
             let rhythmPicker = app.buttons["Rhythm, Weekdays"]
             XCTAssertTrue(reveal(rhythmPicker)); rhythmPicker.tap()
             let dayOfMonth = app.buttons["Day of month"]
             if !dayOfMonth.waitForExistence(timeout: 6) {
                 print(">>> PICKER TREE\n\(app.debugDescription)"); XCTFail("no 'Day of month' option")
             }
             dayOfMonth.tap(); sleep(1)
             XCTAssertTrue(app.buttons["Rhythm, Day of month"].waitForExistence(timeout: 6),
                           "the picker now reads Day of month")
             shot("check3b-form-dayofmonth")
             XCTAssertTrue(reveal(add)); add.tap(); sleep(2)
             toTop()
             let budget = app.buttons["Budget"]
             XCTAssertTrue(budget.waitForExistence(timeout: 10), "Budget is listed")
             XCTAssertTrue(budget.frame.minY > app.buttons["Stretching"].frame.minY, "last in Kept")
             shot("check3b-budget-kept"); report("CHECK3B")

             // ===== CHECK 4: back, without backgrounding, and it is drawn =====
             app.buttons["BackButton"].tap()
             XCTAssertTrue(title.waitForExistence(timeout: 10), "back on the day screen")
             XCTAssertTrue(app.buttons["Stretching"].waitForExistence(timeout: 10),
                           "Stretching (Sundays) is drawn without the app being backgrounded")
             XCTAssertFalse(app.buttons["Budget"].exists, "Budget (day 1) is not drawn on the 6th")
             shot("check4-day-screen-after-return"); report("CHECK4")

             // ===== CHECK 5: stop one, with a confirmation =====
             app.buttons["Commitments"].tap()
             XCTAssertTrue(app.staticTexts["Kept"].waitForExistence(timeout: 10))
             XCTAssertTrue(app.buttons["Stretching"].frame.minY < app.staticTexts["Stopped"].frame.minY,
                           "Stretching starts above the Stopped header")
             app.buttons["Stretching"].tap()
             let confirm = app.buttons["Stop keeping Stretching"]
             XCTAssertTrue(confirm.waitForExistence(timeout: 6), "a confirmation is asked for")
             shot("check5-confirmation-alert")
             confirm.tap(); sleep(2)
             toTop()
             XCTAssertTrue(app.buttons["Stretching"].waitForExistence(timeout: 10))
             XCTAssertTrue(app.buttons["Stretching"].frame.minY > app.staticTexts["Stopped"].frame.minY,
                           "Stretching has moved below the Stopped header")
             XCTAssertFalse(app.staticTexts["Nothing has been stopped."].exists)
             shot("check5-stretching-stopped"); report("CHECK5")

             // ===== CHECK 6: take it up again in one tap =====
             app.buttons["Stretching"].tap(); sleep(2)
             XCTAssertFalse(app.buttons["Stop keeping Stretching"].exists,
                            "taking up again asks for no confirmation")
             toTop()
             XCTAssertTrue(app.buttons["Stretching"].frame.minY < app.staticTexts["Stopped"].frame.minY,
                           "Stretching is back above the Stopped header")
             XCTAssertTrue(app.staticTexts["Nothing has been stopped."].exists)
             shot("check6-stretching-kept-again"); report("CHECK6")

             // ===== CHECK 7: force-quit, reopen, the roster still holds it =====
             app.terminate()
             XCTAssertTrue(app.wait(for: .notRunning, timeout: 20))
             app.launch()
             XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
             XCTAssertTrue(app.buttons["Commitments"].waitForExistence(timeout: 10))
             shot("check7-day-screen-after-relaunch")
             app.buttons["Commitments"].tap()
             XCTAssertTrue(app.staticTexts["Kept"].waitForExistence(timeout: 10))
             for n in nine + ["Stretching", "Budget"] {
                 XCTAssertTrue(app.buttons[n].exists, "\(n) survived the relaunch")
             }
             XCTAssertTrue(app.staticTexts["Nothing has been stopped."].exists)
             shot("check7-commitments-after-relaunch"); report("CHECK7")

             // ===== CHECK 8: a rhythm number the calendar will not take is refused, in the =====
             // ===== form's own words — not rewritten, and not silently ignored. =====
             XCTAssertTrue(reveal(nameField)); nameField.tap(); nameField.typeText("ZeroDays")
             XCTAssertEqual(nameField.value as? String, "ZeroDays")
             XCTAssertTrue(reveal(rhythmPicker)); rhythmPicker.tap()
             let everyNDaysOption = app.buttons["Every N days"]
             XCTAssertTrue(everyNDaysOption.waitForExistence(timeout: 6), "an 'Every N days' option exists")
             everyNDaysOption.tap(); sleep(1)
             XCTAssertTrue(app.buttons["Rhythm, Every N days"].waitForExistence(timeout: 6),
                           "the picker now reads Every N days")
             let daysField = app.textFields["Days"]
             XCTAssertTrue(reveal(daysField))
             daysField.tap()
             if let current = daysField.value as? String, !current.isEmpty {
                 daysField.typeText(String(repeating: "\u{8}", count: current.count))
             }
             daysField.typeText("0")
             shot("check8-form-zero-days")
             XCTAssertTrue(reveal(add)); add.tap(); sleep(1)
             let rhythmRefusal = app.staticTexts["That number isn't one this rhythm accepts."]
             XCTAssertTrue(rhythmRefusal.waitForExistence(timeout: 6),
                           "the form refuses the number in its own words")
             XCTAssertEqual(daysField.value as? String, "0", "the 0 is not silently rewritten")
             XCTAssertEqual(nameField.value as? String, "ZeroDays", "a refusal does not clear the typed name")
             XCTAssertFalse(app.buttons["ZeroDays"].exists, "nothing was taken on")
             shot("check8-refused"); report("CHECK8")
         }
     }
     ```
  6. Before running, remove any earlier install so day one is seeded fresh — this machine's
     simulator already held one from the first pass:
     ```
     xcrun simctl uninstall <udid> com.example.DayByDay
     xcrun simctl uninstall <udid> com.example.DayByDayUITests.xctrunner
     ```
  7. `xcodebuild test`, not `build`, is what actually compiles and runs `DayByDayUITests`:
     ```
     xcodebuild test -project DayByDay.xcodeproj -scheme UITests \
       -destination "platform=iOS Simulator,name=iPhone 17" \
       -derivedDataPath <derived-data-path> -resultBundlePath <result-bundle-path>
     ```
     This run's exact invocation, from the `xcodebuild` log:
     ```
     /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild test -project DayByDay.xcodeproj -scheme UITests -destination "platform=iOS Simulator,name=iPhone 17" -derivedDataPath <scratch>/uitest/dd -resultBundlePath <scratch>/uitest/walk2.xcresult
     ```
     against simulator UDID `59430515-851B-41A8-9BE7-76B5F59DE053`.

  **The passing line and the result:**
  ```
  Test Case '-[DayByDayUITests.WalkthroughUITests testWalkthrough]' passed (121.049 seconds).
  Test Suite 'WalkthroughUITests' passed at 2026-09-06 2:19:21.233 PM.
  Test Suite 'DayByDayUITests.xctest' passed at 2026-09-06 2:19:21.234 PM.
  Test Suite 'All tests' passed at 2026-09-06 2:19:21.235 PM.
  	 Executed 1 test, with 0 failures (0 unexpected) in 121.049 (121.054) seconds

  ** TEST SUCCEEDED **
  ```

  **What was observed at each check**, from the run's own `>>> CHECK…` attachments and screenshots:

  - **Check 1 — day one.** Title `Today · Sunday 6 September 2026`; the five commitments due
    that day drawn (`Creatine, Magnesium, Nails, Run, Yuno`) and the four not due (`Gym, Public
    Pool, Contact Lenses, Finances`) absent.
  - **Check 2 — the same nine.** `Kept` held all nine seeded commitments, in taken-on order;
    `Stopped` read "Nothing has been stopped."
  - **Check 3 — a tenth and an eleventh.** `Stretching` (weekdays: Sunday) and `Budget` (day of
    month 1) were each defined through the form and appeared last in `Kept`, in that order.
  - **Check 4 — back, without backgrounding.** Returning to the day screen drew `Stretching`
    (due, since today is Sunday) and not `Budget` (day of month 1, not the 6th).
  - **Check 5 — stop, with a confirmation.** Tapping `Stretching` raised an `.alert` reading
    "Stop keeping this commitment?" with a destructive "Stop keeping Stretching" beside a
    "Cancel"; confirming moved it under `Stopped`.
  - **Check 6 — take up again.** Tapping the stopped `Stretching` row moved it back to `Kept`
    with no confirmation asked.
  - **Check 7 — force-quit and reopen.** After `terminate()`/relaunch, all eleven commitments
    were present under `Kept` and `Stopped` still read "Nothing has been stopped." The roster
    file was then pulled straight from the app's container
    (`xcrun simctl get_app_container <udid> com.example.DayByDay data`) and
    `Library/Application Support/DayByDay/roster.json` holds exactly the eleven commitments —
    Creatine, Magnesium, Nails, Gym, Run, Public Pool, Contact Lenses, Finances, Yuno,
    Stretching, Budget — none carrying a `keptUntil`, confirming the disk state independently of
    what the UI reports.
  - **Check 8 — a rhythm number the calendar will not take.** With `Every N days` selected and
    the day-count field driven to `0`, tapping `Add` left the field reading `0` (not rewritten),
    left the typed name `ZeroDays` untouched, added nothing to `Kept`, and drew "That number
    isn't one this rhythm accepts." beside the form — the shell's own words for
    `.rhythmOutOfRange`, confirmed present in the run's `CHECK8 TEXTS` attachment, not a system
    message.

## 5. Gates, and the files this change is and is not allowed to write

- [ ] 5.1 `cd src/DayByDayKit && swift test` reports **371 tests passing** and no failures, and
  `pnpm run verify` exits 0. The 371 is the 300 that were on `main` at `566297e`, plus the 47 the
  first implementation pass wrote, plus the 1 unit test `d364a25` added for a guard no scenario
  reached, plus the 9 § 6 writes, plus the 14 § 7 writes. **`add-refused-tick-notice` (#100) merged
  to `main` as `b454d16` after this count was taken**, adding tests of its own; whoever rebases this
  branch re-derives the number from the rebased tree and reports the difference rather than editing
  this box to whatever `swift test` happens to print. **The first version of this box said 347
  and was ticked; the count on the branch was already 348** — measured on 2026-09-06 — so a box
  asserting a number was ticked against a different number. The box is unticked again here because
  357 was true of the branch when § 6 finished and is not the number that must be true at the end.
  None of the 357 may change.
- [ ] 5.2 `pnpm exec openspec validate add-commitments-screen --strict` exits 0 and `pnpm run
  checks` reports scenario coverage as 74 of 74 — the 51 of the first version, plus the 5 rhythm
  scenarios and the 4 calendar-date scenarios § 6 adds, plus the 13 refused-change scenarios and the
  1 day-screen scenario § 7 adds. Unticked again for the same reason as 5.1: 60 was true when § 6 finished.
- [ ] 5.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**). Five
  things the reviewer is asked to look for by name: that every one of `define`, `confirmStopKeeping`
  and `keepAgain` assigns `kept` and `stopped` only **after** the `RosterStore` call returns, so
  neither list is ever ahead of the disk; that `Rhythm.everyNDays` reaches `Schedule.everyNDays`
  with the **kept-from day** as its start and nothing else; that `CommitmentsScreen` never writes
  day one, on any path; that `returnedTo()` does not call `shown(asOf:)` and does not touch the
  record; and that `git diff` on the four MODIFIED-requirement tests in `DayScreenTests.swift`
  shows no change at all.

  Three more, added for the second pass: that no line in `src/DayByDay` decides a value or a
  refusal — in particular that no clamp survives on the day-count field and no `guard … else
  { return }` swallows a number `DayOfMonth`, `DayInterval` or `WeeklyQuota` refuses; that the only
  change to `src/DayByDayKit/Sources/DayByDayKit/CalendarDate.swift` in `git diff origin/main` is
  three `let`s becoming `public let` and the doc comment above them; and that
  `openspec/specs/schedule/spec.md` is unchanged in the working tree, since it is `/opsx:archive`'s
  to write and rule 2 admits no exception for a capability this change now claims.

  Three more, added for the third pass: that `src/DayByDay` holds **no state whose lifetime is a
  rule** — in particular that `CommitmentsView.swift` declares no `@State` refusal of any kind and
  that `define()`'s answer is kept in a local rather than a property; that `refusedChange` is
  assigned at every site where one of the three methods answers a `Refusal`, and cleared at every
  site where one of them reaches the roster place and at `shown(asOf:)`, so that no path leaves it
  saying something a caller was not told; and that `refusalText(_:)`'s five sentences are unchanged
  in `git diff origin/main` and that `git diff` on `src/DayByDayKit` adds no string literal a person
  reads.
- [x] 5.4 `docs/adr/1028-a-screen-may-refuse-what-the-engine-accepts.md` is written with this folder,
  `docs/adr/1019-the-app-shell-runs-in-the-simulator.md` carries an `- Amended:` stamp and the
  bounded exception § 4 works under, and `docs/adr/README.md` gains 1028's row. Confirm before the
  PR opens that 1028 is still the lowest free number — `git log --all --name-only -- docs/adr` —
  and report rather than renumber if it is not. Confirmed: `1029` appears nowhere in
  `git log --all --name-only -- docs/adr`, so 1028 is still the lowest free number.

  **Added 2026-09-06:** 1028 now carries an `- Amended:` stamp of its own and a closing section.
  Its Context said that every refusal made by a value is one "every screen simply reports", and
  the screen it was written for reported none of the three rhythm-number refusals. No new ADR is
  written for that: § 6 builds the case 1028 already assumed, and a record that assumed something
  untrue is corrected in place under ADR-1020 rather than argued again in a second file. No new
  ADR is written for the `CalendarDate` widening either — ADR-1004 already decided that the
  instant-to-date conversion lives at the edge, and reading the three components is that decision
  carried out rather than a new one.
- [x] 5.5 `docs/open-questions.md` is not this change's to write (`AGENTS.md` § *Agent roles*). Its
  *No UI smoke layer* gap now covers a second screen, a navigation and a form, which is materially
  more untested SwiftUI than a list of rows; and ADR-1019's bounded exception is a thing to close.
  Land both as a chore commit alongside the merge, exactly as #92, #93 and #103 handled their own
  entries, and name here what is owed rather than writing it.

  **One exception, and it is not this list's:** § *Known gaps*'s read-back entry is edited on this
  branch, in its own commit, because the owner's decision to authorise `CalendarDate`'s three
  public members makes that entry's assignment of them to "a Story of its own against a second
  capability" false the moment this delta lands. That is a correction of a sentence this change
  invalidates, not a new gap; the two below are new gaps and stay owed.

  **Corrected again 2026-09-06, when this folder was reopened a third time.** That edit counted
  wrong: it said "Five faces remain" and then listed six — `Comparable`, `DayOfMonth`,
  `DayInterval`, `WeeklyQuota`, `History` and `Tick` — and then called the ranges
  `CommitmentsView`'s steppers write out "a sixth face", a number the list had already used. It now
  reads six and seventh. Nothing else in the entry moves, and it rides the same commit as this
  folder rather than a chore, because it is arithmetic inside a sentence this branch wrote.

  What is owed, named rather than written:
  1. *No UI smoke layer* (line 132) says "Revisit when there is a second screen to regress
     against" — that trigger has now fired. `CommitmentsView`, its navigation and its four-rhythm
     form are new untested SwiftUI on top of what was there at #91. What the entry does not yet
     carry, and should, is the shape of the fix and its cost: § 4.3 drove all eight checks with an
     **XCUITest target**, which needs no Accessibility grant and works on this machine, but which
     lives outside the repo because a new Xcode target is a project-file edit
     `PBXFileSystemSynchronizedRootGroup` does not cover. So the gap is no longer "nobody can
     verify this" — it is "the thing that verifies it is re-created by hand every time, and CI
     never runs it". The entry wants updating to name `add-commitments-screen` (#104) as the second
     screen and to say that.

     **Do not copy the first version of § 4.3 into this entry.** It claimed `osascript` is refused
     assistive access here and that no agent session can drive a tap; neither is true, `-25211`
     does not reproduce, and the error actually seen was `-1719` — Simulator.app having no window.
     An open question is a durable record and a wrong one costs more than a missing one.
  2. ADR-1019's bounded exception (its 2026-09-04 amendment) is scoped to "the next shell change
     that fails any of [its three conditions]" returning to the `chore/` rule, and names itself as
     "not a general licence." This Story is the one Story the amendment was written for; the
     record wants a line saying it has now been used once, so the next shell change is read
     against "has a second Story claimed the exception yet" rather than a clean slate.
- [x] 5.6 Record here anything the implementation had to absorb that `design.md` did not foresee —
  a mechanism that did not work as § 2 describes, a scenario that turned out to be untestable at
  either seam, a changed test count on `main`. "Nothing." is a valid entry. Record too which of the
  scenarios § 2 and § 3 predicted red actually ran red; a prediction is not evidence.

  **§ 3 (this batch), against the method: every one of `returnedTo()`'s seven tests was written
  and run individually, in delta order.** Only **3.1** ran genuinely red, against
  `DayScreen.swift:271`'s `fatalError("not implemented")` — confirmed by the process exiting with
  signal 5 and the fatal-error message before the fix. The other six — **3.2, 3.3, 3.4, 3.5, 3.6,
  3.7** — passed on first write, all covered by the single `returnedTo()` written for 3.1:

  ```swift
  public func returnedTo() {
      let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: commitments)
      self.rosterStore = openedRoster.store
      self.rosterState = openedRoster.state
      self.roster = openedRoster.roster
      self.dayView = DayView(
          of: openedRoster.roster.commitments(on: shownDay), on: shownDay,
          in: recordStore?.history ?? History())
  }
  ```

  So **1 of 7 new tests in § 3 ran red; 6 of 7 passed on first write.** `design.md` predicted 3.1,
  3.5 and 3.7 as likely red on their own — 3.5 and 3.7 turned out already covered because the one
  implementation above happens to get both right (it reuses `recordStore` rather than reopening
  it, and it passes `commitments` — the day-one array — to `openRoster`, exactly as `shown(asOf:)`
  does), which is evidence the mechanism works as designed rather than evidence the prediction was
  wrong. Nothing in § 3 was untestable at the seam, and `swift test` reported exactly 347 at that
  moment — the 300 from `main` plus the 47 this change adds — with no other count moved.

  **§ 2 (batches one through three, by report to the conductor as the work proceeded, not
  re-verified by me): 10 of 13, 14 of 15 and 10 of 12 new tests respectively passing on first
  write**, each batch's report accounting for every pass against the method it exercised. I did
  not re-run § 2's thirty-three tests individually to re-derive which ones; `swift test` run whole
  is the check that nothing in § 2 regressed under § 3 and § 4's work.

  **Corrected 2026-09-06:** both paragraphs above quoted 347 as the count that would stand at the
  end, and `d364a25` then added a thirty-fourth test to § 2's file — a unit test for the
  `stopped.contains` guard in `keepAgain`, which no scenario reaches. The branch has reported
  **348** since, measured again on 2026-09-06, so 5.1's number was wrong from the moment that
  commit landed and the box was ticked against it anyway. 347 is left in the two sentences above
  because it is what was true when they were written; 5.1 carries the number that must be true at
  the end, which is now 357.

  **One thing `design.md` did not foresee, absorbed in § 4 rather than § 2/§ 3: `CalendarDate`'s
  `year`/`month`/`day` were internal to `DayByDayKit`**, so the shell had no way to read
  `screen.dayToKeepFrom`'s value to seed a SwiftUI `DatePicker`, which speaks `Date`. **Corrected
  2026-09-06:** the paragraph that stood here said no kit API was added and that
  `ContentView.today(_:)` was widened to take an already-read `Date`. Both were false of the
  branch by the time they were written. `4e92da5` made the three components `public` — kit API,
  added — and reverted `today(_:)` to `today()`, because handing the same instant to both sides
  was a second clock read wearing the seam's clothes and left a screen open overnight still
  offering yesterday. Task 4.1 now records what actually happened, `design.md` § *A calendar date
  gives back its three numbers* carries the decision, and `specs/schedule/spec.md` in this folder
  carries the requirement that authorises it.

  **§ 6, worked 2026-09-06, against the same method: every one of the nine new scenarios was
  written and run individually, in task order.** 6.1–6.4, the calendar-date read-backs, all passed
  on first write — expected, since `4e92da5` already ships the behaviour they assert. 6.5 wrote no
  test, as instructed, and left the `nil`-conversion branch of `define` a `fatalError`. **6.6 ran
  genuinely red**, against that `fatalError` — confirmed by the process exiting with signal 5 and
  `DayByDayKit/CommitmentsScreen.swift:89: Fatal error: not implemented` before the one-line fix
  (`return .rhythmOutOfRange`). 6.7 and 6.8 passed on first write, both covered by that same line,
  exactly as `design.md` allowed for. **6.9 and 6.10 also passed on first write** — `design.md`
  flagged them as likely red against a reused `Refusal` case or an off-by-one in one of the three
  ranges, and neither defect was present: `.rhythmOutOfRange` was already its own case and
  `DayOfMonth`/`DayInterval`/`WeeklyQuota`'s existing ranges (`1...31`, `days >= 1`, `1...7`) were
  already right at both ends. So **2 of 9 ran red (6.6 alone counts, since 6.5 wrote none); 7 of 9
  passed on first write** — a prediction proven wrong twice over is still not a defect, and nothing
  in § 6 was untestable at the seam. `swift test` reported 352 after 6.1–6.5 and 357 after 6.6–6.10,
  matching `design.md` exactly, and `xcodebuild -scheme DayByDay -destination 'generic/platform=iOS
  Simulator' build` exited 0 after 6.11.

  **Four more findings from the second review pass were fixed on this branch, outside § 6: they
  carry no scenario and no box, per this file's own § 6 preamble.** All four are shell or seam
  fixes, not new behaviour:

  - **Finding 8** (`CommitmentsScreen.swift`): the five repeated `kept = …; stopped = …` pairs are
    now one `private func refreshLists(from: RosterStore?)`, called from `init`, `define`,
    `confirmStopKeeping`, `keepAgain` and `shown(asOf:)`, in that order, with no change to when
    each is called relative to its `RosterStore` call. A pure reshaping: `swift test` still reports
    357 with no test added, removed or changed.
  - **Finding 4** (`CommitmentsView.swift`): `.confirmationDialog` is now `.alert`. An alert always
    draws every button it is given, on every size class; there is no presentation style left in
    which the destructive button can appear without "Cancel" beside it, and no tap-outside dismissal
    to fail to announce.
  - **Finding 5**: the `isPresented` setter now reads `if !isPresented && screen.awaitingConfirmation
    != nil` before calling `cancelStopKeeping()`, so a dismissal that has already been resolved by
    the destructive button (which clears `awaitingConfirmation` itself, through
    `confirmStopKeeping()`) does not call it a second time.
  - **Finding 6**: the confirm-stop and take-up-again refusals no longer share the `Define a
    commitment` section's message slot. `stopRefusal` is drawn directly under `Section("Kept")`,
    `keepAgainRefusal` directly under `Section("Stopped")`, and the form's own `refusal` stays where
    it was — each shown beside the row or button that produced it, through one shared
    `refusalText(_:)` so the five sentences are written once.

  None of the four needed a requirement: each is a drawing or a reshaping, not a rule, and § 6's
  preamble in this file says as much. `xcodebuild -scheme DayByDay -destination 'generic/platform=iOS
  Simulator' build` was re-run after all four and exited 0.

  **Two residuals recorded 2026-09-06, at the third review pass, on the owner's instruction. Neither
  is fixed here and neither is a defect in what this delta requires** — they are written down
  because a trade-off nobody wrote down is indistinguishable from an oversight the next time
  somebody reads the file.

  1. **One scenario of the seventy-four has no test that can go red.**
     `CommitmentsScreenTests.swift`'s test for *a commitments screen keeps its roster at the place a
     day screen keeps its* is `#expect(CommitmentsScreen.rosterPlace == DayScreen.rosterPlace)`,
     and `CommitmentsScreen.rosterPlace` is declared as `DayScreen.rosterPlace`, so the assertion is
     `X == X` and no change to either side can fail it. That was chosen deliberately: § 2.33 and the
     seam's own doc comment both say the static exists **so that a test can assert the two agree
     without opening the real Application Support directory**, and any test that could go red would
     have to name the path itself — writing the answer twice — or open the place. The trade-off is
     sound and it stands; what was missing is this paragraph. The scenario is still worth its line
     in the spec, because it is the sentence a later Story would have to argue against before giving
     the commitments screen a place of its own. **Closing it needs the kit to publish the path it
     builds**, which is a widening no requirement here asks for.
  2. **One `RosterState` sentence is written out three times.** "The roster could not be read or
     could not be written." appears in `CommitmentsView.swift` twice — once in the `rosterState`
     switch and once as `refusalText(_:)`'s `.notKept` case — and once more in `ContentView.swift`'s
     own `rosterState` switch. `refusalText(_:)` exists so that each sentence is written once, and
     the two `rosterState` switches route around it because they answer about a `RosterState` rather
     than a `Refusal`. Nothing is wrong today: the three copies read the same and § 4.1 authorises
     the words. But a reworded sentence would now have to be found in two files, and the two screens
     would drift apart silently. **This is a chore, not a Story**: it is one shared helper for the
     three `RosterState` cases across both views, it changes no behaviour, it carries no requirement,
     and it is the kind of thing ADR-1019 puts on a `chore/` branch. It is recorded here rather than
     done here because § 7's shell box is scoped to a lifetime and widening it to a refactor of
     `ContentView.swift` is how a reopened folder grows a third reopening.
- [ ] 5.7 **Delete `DayScreen`'s unread roster store.** The first two versions of this box asked
  the human what should become of it and forbade the deletion. **They answered on 2026-09-06, when
  this folder was reopened for its third G4: delete it.** The reason #103's G7 kept
  `private var rosterStore` was that this Story would read it, and this design disproves that rather
  than merely failing to use it — sharing the handle is what `design.md` § *The commitments screen
  opens its own store at the same place* rules out, so no design keeping the two screens apart can
  reach the field. `design.md` § *The store `DayScreen` holds is still not read* carries the
  decision and the two ways out it was chosen over.

  In `Sources/DayByDayKit/DayScreen.swift`, in **its own commit** so it can be read and reverted on
  its own: delete `private var rosterStore: RosterStore?` and the three-line doc comment above it
  (`:30` at the time of writing), and delete the three `self.rosterStore = openedRoster.store`
  assignments (`:73`, `:258`, `:272`). Those three are the only readers of
  `openRoster(at:takingOnIfEmpty:)`'s `store` member, so narrow its return tuple to
  `(state: RosterState, roster: Roster)` in the same commit — the store day one is written through
  is a local inside that function and is unaffected. Nothing else in the file changes.

  This deletes no behaviour and satisfies no scenario, so **no test is written and no test may
  move**: `swift test` reports the same count before and after, and any test that fails is a rule-5
  stop rather than a licence to change one.
- [x] 5.8 **Write down here, before the archive runs, exactly what the janitor must check it
  against.** This box is the *writing*, and it is tickable now; the check itself happens after
  `/opsx:archive` and is an instruction rather than a checkbox, because a box under
  `openspec/changes/archive/**` cannot be ticked — `.claude/settings.json` denies editing there and
  deny beats allow. #103 shipped that mistake and its Story stalled between review and merge.

  The list, for the janitor to work through after running `/opsx:archive` and before its commit —
  `/opsx:archive` dropped the prose of two MODIFIED requirements when it archived #93, which is why
  this is checked by hand at all:

  1. The one MODIFIED block in `openspec/specs/day-screen/spec.md` — *A day screen draws the
     commitments its roster had not stopped keeping on the day it is showing* — matches
     `specs/day-screen/spec.md` in this folder, prose and all four scenarios, character for
     character.
  2. The twelve ADDED requirements landed in `openspec/specs/commitment/spec.md`; the one ADDED
     requirement — *A day screen reads its roster again when it is returned to* — in
     `openspec/specs/day-screen/spec.md`; and the one ADDED requirement — *A calendar date gives
     back the year, the month and the day it names* — in `openspec/specs/schedule/spec.md`, each
     with its scenarios.
  3. `openspec/specs/record/spec.md` does not appear in the archive diff at all.
  4. `openspec/specs/schedule/spec.md` **does** appear, and its diff is one requirement added and
     nothing else: every one of the twelve requirements already in that file, and every one of
     their scenarios, reads afterwards character for character as it reads now. This is the one
     capability of the three whose existing prose nothing in this change was supposed to touch, so
     a single changed word there is the drift most worth catching.

  **Any drift is a stop and a report, never a hand-edit**: rule 2 says those files are written by
  `/opsx:archive` and by nothing else.

## 6. The second review pass

§§ 1–3 above are the record of what was built between the first G4 and the first review, and they
stay ticked: each box was true when it was ticked and nothing here untells it. This section is the
work the second review pass added, and it is written in the same shape — one scenario, one test,
one at a time (`AGENTS.md` rule 3).

The pass raised eight findings. Three changed this folder and are worked here and in §§ 4–5:
the `CalendarDate` widening that shipped unauthorised, the form deciding a value and a refusal,
and the three ticked boxes that had come to assert the opposite of the diff. **Findings 4, 5, 6
and 8 are shell and seam fixes that carry no requirement, and they have no box here** — their text
never reached this folder, so writing one would be inventing an instruction. They come to the
implementer from the review report, not from this file.

### The calendar date read-back, which is already implemented

Four scenarios from `specs/schedule/spec.md`, one test each, appended to the existing
`Tests/DayByDayKitTests/ScheduleTests.swift` as free `@Test` functions beside the twelve
`CalendarDate` tests already there, of the nineteen in that file — not a new file, because the
capability's tests have one home
and a second would be the only reason anyone had to look for them. The behaviour ships already
(`4e92da5`), so all four are expected green on first write; **record in § 5.6 whether they were**,
and treat any red one as a rule-5 stop rather than as a licence to change `CalendarDate`.

- [x] 6.1 `a calendar date gives back the three numbers it was formed from`
- [x] 6.2 `a calendar date gives back its month and its day the way round they were offered` — the
  test that fails a read-back with the month and the day transposed, which the first scenario alone
  cannot catch because 2026-08-31 has no month that could be mistaken for its day.
- [x] 6.3 `a calendar date at each end of the supported years gives back that year`
- [x] 6.4 `a calendar date formed again from what it gives back is the same date` — the round trip
  the edge actually performs, on 29 February 2028 so a read-back that lost the leap day fails.

### The rhythm number a person gave

Five scenarios from `specs/commitment/spec.md`, one test each, appended to
`Tests/DayByDayKitTests/CommitmentsScreenTests.swift` under § 2's own rules — a fresh place per
test, no clock read, no real Application Support directory. `design.md` expects **6.6** to run red
against 6.5's `fatalError`, **6.9** to run red if one `Refusal` case was reused for two things, and
**6.10** to run red against an off-by-one in any of the three ranges. 6.7 and 6.8 may well pass on
first write, covered by whatever 6.6 makes work. **Record which ones actually ran red, in § 5.6**;
a prediction here is not evidence.

- [x] 6.5 Widen `Rhythm`'s three numeric cases to carry an `Int` — `dayOfMonth(Int)`,
  `everyNDays(Int)`, `weeklyQuota(Int)`, `weekdays(Set<Weekday>)` unchanged — make its internal
  `schedule(keptFrom:)` answer `Schedule?`, answering `nil` exactly when `DayOfMonth`,
  `DayInterval` or `WeeklyQuota` refuses the number, and add `case rhythmOutOfRange` to
  `CommitmentsScreen.Refusal`. In `define(name:on:keptFrom:)` the branch that meets a `nil`
  conversion is bodied `fatalError("not implemented")` for now — **this box writes no test and
  satisfies no scenario**, and it is the § 1-shaped step that makes 6.6 run genuinely red instead
  of green on first write. The construction sites in `CommitmentsScreenTests.swift` change
  mechanically — `.dayOfMonth(DayOfMonth(day: 25)!)` becomes `.dayOfMonth(25)` — and **no `@Test`
  display name and no assertion may change**. `swift build` exits 0 and `swift test` still reports
  352 (348 plus § 6's first four); a different number is a rule-5 stop.
- [x] 6.6 `a commitments screen refuses a day of the month that is not one of the thirty-one`
- [x] 6.7 `a commitments screen refuses an interval of fewer than one day` — the negative case is
  what fails an implementation guarding with `days < 1` on an unsigned read of the field rather
  than on the value.
- [x] 6.8 `a commitments screen refuses a weekly quota outside one to seven`
- [x] 6.9 `a rhythm number a commitments screen refuses is told apart from its other refusals` —
  three `define` calls, three distinct `Refusal` cases, asserted distinct from each other and not
  merely each equal to its own expectation.
- [x] 6.10 `a commitments screen accepts the number at each end of what a rhythm allows` — the
  boundary test; an implementation refusing the 31st, or a quota of 7, fails here and nowhere else.

### The shell, which now decides nothing

- [x] 6.11 In `src/DayByDay/DayByDay/CommitmentsView.swift`: delete the `max(1, $0)` from the
  day-count field's binding, delete all three `guard let … else { return }` around `DayOfMonth`,
  `DayInterval` and `WeeklyQuota`, build the `Rhythm` straight from the three `@State` integers,
  and add the message for `.rhythmOutOfRange` beside the four already there — the shell's own
  words, as `RosterState`'s are. The two `Stepper`s keep their `1...31` and `1...7`:
  `design.md` § *Risks* records why bounds that draw a range are not a decision and what the
  residual is. After this, the only thing in the file that can end a `define` early is a
  `CalendarDate` the picker's instant does not convert to, which is unreachable from a
  `DatePicker` and stays a `guard`. `swift build` through the scheme exits 0 and § 4.3's eighth
  check is what proves it to a person.

## 7. The third review pass

§§ 1–6 stay ticked on the same terms § 6 states: each box was true when it was ticked and nothing
here untells it. This section is the work the third review pass added — one finding about the
requirements, and the owner's decision on the one thing §§ 1–6 deliberately left to them. It is
written in the same shape: one scenario, one test, one at a time (`AGENTS.md` rule 3).

The finding is that **how long a refusal is told was left to the shell**. `CommitmentsView.swift`
held three `@State` refusals — `refusal`, `stopRefusal`, `keepAgainRefusal` — so `define`,
`confirmStopKeeping` and `keepAgain` each formed a judgement and immediately forgot it, and three
lifetimes lived in the one layer nothing regresses. Two of them were already wrong: a stop refusal
outlived a later successful take-up-again, and a `rhythmOutOfRange` message outlived a switch to a
rhythm that cannot produce it. `design.md` § *How long a refusal is told is this capability's, and
which change it was is part of it* is the decision, and the thirteen commitment scenarios below are
the rule.

**One thing happened on `main` while this section was being written, and it is not a finding.**
`add-refused-tick-notice` (#100) merged as `b454d16`. It answers the neighbouring question on the
day screen and it landed `public private(set) var refusedChangeRow: DayView.Row?` on `DayScreen`,
cleared on three conditions of its own. Two consequences here, and no more: § 7.17 pins the one
interaction the merge order created — that being returned to is not one of those three conditions,
which § 3's requirement already promised in prose and now has a scenario for — and **this branch no
longer rebases cleanly onto `origin/main`**. The conflict is `DayScreenTests.swift`, where #100 and
§ 3 both appended tests at the end of the file, and `ContentView.swift` will likely be the second.
It is neither the change folder nor `openspec/specs/`, so it is not the stop `AGENTS.md` § *Working a
Story* names; it is an ordinary append-and-append that whoever holds `src/**` resolves, keeping both
sides. Nothing in this folder changes because of it.

**The words are not in scope and must not move.** § 4.1's `refusalText(_:)` keeps its five
sentences and ADR-1022 is unamended: this section moves a *lifetime* out of `src/DayByDay` and
nothing else. A pull request that adds a string to `DayByDayKit` here has gone past the finding.

### The empty seam, before any test is written

- [ ] 7.1 In `Sources/DayByDayKit/CommitmentsScreen.swift`, add
  `public enum RefusedChange: Equatable, Sendable` with `case defining(Refusal)`,
  `case stopping(Commitment, Refusal)` and `case keepingAgain(Commitment, Refusal)`, plus a
  `public var refusal: Refusal` that answers the associated refusal whichever case it is; and add
  `public private(set) var refusedChange: RefusedChange?`, declared and **never assigned**. This box
  writes no test and satisfies no scenario — it is the § 1-shaped step that makes 7.2 run genuinely
  red rather than green on first write. `swift build` exits 0 and `swift test` still reports 357; a
  different number is a rule-5 stop.

### What a commitments screen holds as refused

Six scenarios from `specs/commitment/spec.md`, one test each, appended to
`Tests/DayByDayKitTests/CommitmentsScreenTests.swift` under § 2's own rules — a fresh place per
test, no clock read, no real Application Support directory. **No `@Test` display name and no
assertion already in that file may change**: these thirteen tests are added beside the existing
ones, and every existing test goes on asserting on the `Refusal?` each method answers, because the
answer to the caller does not move.

- [ ] 7.2 `a commitments screen holds a refused definition against defining a commitment`
- [ ] 7.3 `a commitments screen holds a refused stop against the commitment it was asked to stop` —
  the place is made impossible to write in the shape § 2.28's test already uses: remove the roster
  file and create a directory in its path.
- [ ] 7.4 `a commitments screen holds a refused take-up-again against the commitment it was asked to take up again`
- [ ] 7.5 `a commitments screen refused twice holds only the change it was asked for last` — the
  test that fails an implementation keeping a slot per method rather than one slot. Assert both
  that the stop is what is held and that nothing about defining is.
- [ ] 7.6 `a commitments screen that has been asked for no change holds no refused change`
- [ ] 7.7 `a commitments screen holds nothing against a call that changes nothing at all` — three
  calls in one test, because it is one rule: asking to stop a commitment the screen does not keep,
  confirming a stop with nothing awaiting confirmation, and taking up again a commitment that has
  not been stopped.

### How long it holds it

Seven scenarios, same file, same rules.

- [ ] 7.8 `what a commitments screen holds about a refused change ends when the app is shown again`
- [ ] 7.9 `what a commitments screen holds about a refused change ends when the app is shown again where the roster then cannot be read` —
  the test that fails an implementation clearing only on a successful re-open.
- [ ] 7.10 `what a commitments screen holds about a refused change ends when a commitment is defined and kept`
- [ ] 7.11 `what a commitments screen holds about a refused change ends when a stop is kept`
- [ ] 7.12 `what a commitments screen holds about a refused change ends when a commitment is taken up again and kept` —
  this one and 7.11 are the two the third review found genuinely stale in the shipped shell; an
  implementation that clears only the slot the change belongs to passes 7.10 and fails these.
- [ ] 7.13 `what a commitments screen holds about a refused change stands when a call changes nothing at all` —
  the mirror of 7.7 with something already held. An implementation that clears on entry to
  `keepAgain` or `confirmStopKeeping`, rather than where the roster place is reached, fails here.
- [ ] 7.14 `what a commitments screen holds about a refused change stands when a stop is asked for and cancelled`

### The day screen's neighbour, now that it has landed

- [ ] 7.15 `a day screen returned to goes on telling what it was telling on a row` — one test at
  the end of `Tests/DayByDayKitTests/DayScreenTests.swift`, beside § 3's seven, from
  `specs/day-screen/spec.md`. The behaviour ships already, because `returnedTo()` does not touch
  `refusedChangeRow` and #100's own requirement names three things that end a notice, none of them
  being returned to; this test is what stops the next edit to `returnedTo()` taking it out by
  accident. Expect it green on first write and **treat a red one as a rule-5 stop** rather than as a
  licence to change either Story's code.

### The shell, which now holds no lifetime

- [ ] 7.16 In `src/DayByDay/DayByDay/CommitmentsView.swift`: delete the three `@State` refusals —
  `refusal`, `stopRefusal` and `keepAgainRefusal` — and draw whatever `screen.refusedChange` holds,
  switching on the case so that a `.defining` is drawn in the `Define a commitment` section where
  the form's message already sits, a `.stopping` under `Section("Kept")` and a `.keepingAgain` under
  `Section("Stopped")`. That is the placement § 5.6's finding 6 bought, kept, with the state it was
  drawn from moved behind the seam. `screen.confirmStopKeeping()` and `screen.keepAgain(_:)` are
  then called for their effect and their answers dropped; `private func define()` keeps the answer
  in a **local**, because clearing the typed name and the chosen weekdays when nothing was refused
  is drawing rather than a lifetime. `refusalText(_:)` keeps its five sentences exactly as they are
  — no sentence is added, removed or reworded by this box. `swift build` through the scheme exits 0.
### The walkthrough, re-driven

- [ ] 7.17 Re-drive § 4.3's walkthrough against the shell as § 7 leaves it, and add its record
  there under a dated heading rather than replacing what is written. **A ninth check joins the
  eight**: with the "that number isn't one this rhythm accepts" message on screen from check eight,
  tap a stopped commitment to take it up again; the take-up-again must land and the message must go,
  with nothing left under the Add button. That is the one lifetime rule a person can see without a
  disk that refuses to be written. Same standard as § 4.3: the simulator and iOS version, the exact
  commands, the passing line, and what was observed at each of the nine checks.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7,
and `openspec validate --archived` requires every box above to be ticked before it.
