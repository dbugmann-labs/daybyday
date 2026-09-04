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

- [ ] 2.29 `a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps`
- [ ] 2.30 `a commitment taken up again through a commitments screen is in the place it was taken on in`
  — "Water plants" is first of three, so an implementation that appends on take-up-again fails.
- [ ] 2.31 `taking a commitment up again through a commitments screen asks for no confirmation` —
  `awaitingConfirmation` is `nil` before and after, and `keepAgain` alone did the work.
- [ ] 2.32 `a commitments screen asked to take up again a commitment it has not stopped does nothing`

### The place, and being shown again

- [ ] 2.33 `a commitments screen keeps its roster at the place a day screen keeps its` — asserts
  `CommitmentsScreen.rosterPlace == DayScreen.rosterPlace` and **constructs no screen**, so nothing
  in this file ever opens the real Application Support directory.
- [ ] 2.34 `a commitment defined through a commitments screen is held by a day screen opened afterwards at the same place`
  — the one test in § 2 that builds a `DayScreen`; it needs a record place too, and it must be a
  fresh temporary one.
- [ ] 2.35 `a commitments screen shown again reads its roster again`
- [ ] 2.36 `a commitments screen shown again on a later day stops a commitment as of that later day`
  — the test that fails a `shown(asOf:)` which re-reads the roster and does not replace the day.

### A screen without its roster

- [ ] 2.37 `a commitments screen that cannot read its roster lists nothing and says it is not keeping one`
- [ ] 2.38 `a roster written in a later form than this app knows makes a commitments screen that says the roster is from a later version`
  — write `{"version": 2, "commitments": []}` by hand, as #103's own tests do.
- [ ] 2.39 `a commitments screen that cannot read its roster refuses a new commitment and leaves what is at the place as it was`
  — three assertions: `define` answers `.notKept`; the stop answers nothing and leaves
  `awaitingConfirmation` nil; the bytes are unchanged.
- [ ] 2.40 `a commitments screen that could not read its roster starts keeping one when it is shown again and the roster can be read`

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

- [ ] 3.1 `a commitment taken on at a day screen's roster place is drawn when the screen is returned to`
- [ ] 3.2 `a commitment stopped at a day screen's roster place is not drawn when the screen is returned to`
- [ ] 3.3 `a day screen returned to goes on showing the day it was showing` — quote the expected
  title in full, `"Sunday 30 August 2026"`; an expectation assembled from the same pieces the code
  uses proves nothing.
- [ ] 3.4 `a day screen returned to keeps the today it was handed` — `"Today · Monday 31 August
  2026"`, quoted in full for the same reason.
- [ ] 3.5 `a day screen returned to does not read its record again` — the test that fails any
  implementation of `returnedTo()` that delegates to `shown(asOf:)`. The record place holds bytes
  that are not a record store when the screen is opened, and the file is **removed** before the
  return, so the place would read clean if it were read at all.
- [ ] 3.6 `a day screen that could not read its roster starts keeping one when it is returned to and the roster can be read`
- [ ] 3.7 `a day screen returned to on a roster that holds nothing takes the commitments it was handed on again`
  — "everything kept at the roster place is removed" is `FileManager.removeItem` on the file day one
  wrote at open.

## 4. The shell

Under the ADR-1019 amendment § 5.4 writes, and no further: navigation and drawing only. **No line
in `src/DayByDay` may decide anything** — not an order, not a refusal, not a default date, not a
place. If one appears to be needed, that is a requirement this delta is missing and a rule-5 stop.

- [ ] 4.1 Add `src/DayByDay/DayByDay/CommitmentsView.swift`: the two lists, a form that builds a
  `Rhythm` from what was tapped and calls `define(name:on:keptFrom:)` with `screen.dayToKeepFrom`
  as the date picker's initial value, a confirmation for a stop driven by
  `screen.awaitingConfirmation`, a one-tap take-up-again on each stopped row, and one message per
  `CommitmentsScreen.Refusal` case and per `RosterState` case — in the shell's own words, in the
  shape `ContentView.swift` already uses for `rosterState`. `PBXFileSystemSynchronizedRootGroup`
  means the `.xcodeproj` needs no edit for a new file (ADR-1019); confirm that it builds without
  one and report if it does not.
- [ ] 4.2 In `src/DayByDay/DayByDay/ContentView.swift`, add navigation to a `CommitmentsView` and
  call `screen.returnedTo()` when the person comes back. Nothing else in the file changes —
  `dayOneCommitments` stays exactly where it is, verbatim, and stays the thing handed to
  `startingFrom:`. The `.onChange(of: scenePhase)` that calls `shown(asOf: today())` stays as it
  is, and a `CommitmentsScreen` that is up gets the same treatment.
- [ ] 4.3 Run the app in the simulator and record here what was seen, since
  `docs/open-questions.md` § *No UI smoke layer* is still open and this is the only way this repo
  has. Say which simulator and which iOS version, and cover all six: the day screen drawing day
  one; navigating to the commitments screen and seeing the same nine; defining a tenth on each of
  two different rhythms and seeing it in the list; navigating back and finding the new commitment
  drawn on the day screen **without the app being backgrounded**; stopping one, confirming, and
  seeing it move to the second list; and taking it up again in one tap. Then force-quit, reopen,
  and confirm the roster file under `Application Support/DayByDay/` still holds exactly what was
  left there.

## 5. Gates, and the files this change is and is not allowed to write

- [ ] 5.1 `cd src/DayByDayKit && swift test` reports **347 tests passing** and no failures — the
  forty-seven here plus the 300 from before, none of which may change — and `pnpm run verify`
  exits 0.
- [ ] 5.2 `pnpm exec openspec validate add-commitments-screen --strict` exits 0 and `pnpm run
  checks` reports scenario coverage as 51 of 51.
- [ ] 5.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**). Five
  things the reviewer is asked to look for by name: that every one of `define`, `confirmStopKeeping`
  and `keepAgain` assigns `kept` and `stopped` only **after** the `RosterStore` call returns, so
  neither list is ever ahead of the disk; that `Rhythm.everyNDays` reaches `Schedule.everyNDays`
  with the **kept-from day** as its start and nothing else; that `CommitmentsScreen` never writes
  day one, on any path; that `returnedTo()` does not call `shown(asOf:)` and does not touch the
  record; and that `git diff` on the four MODIFIED-requirement tests in `DayScreenTests.swift`
  shows no change at all.
- [ ] 5.4 `docs/adr/1028-a-screen-may-refuse-what-the-engine-accepts.md` is written with this folder,
  `docs/adr/1019-the-app-shell-runs-in-the-simulator.md` carries an `- Amended:` stamp and the
  bounded exception § 4 works under, and `docs/adr/README.md` gains 1028's row. Confirm before the
  PR opens that 1028 is still the lowest free number — `git log --all --name-only -- docs/adr` —
  and report rather than renumber if it is not.
- [ ] 5.5 `docs/open-questions.md` is not this change's to write (`AGENTS.md` § *Agent roles*). Its
  *No UI smoke layer* gap now covers a second screen, a navigation and a form, which is materially
  more untested SwiftUI than a list of rows; and ADR-1019's bounded exception is a thing to close.
  Land both as a chore commit alongside the merge, exactly as #92, #93 and #103 handled their own
  entries, and name here what is owed rather than writing it.
- [ ] 5.6 Record here anything the implementation had to absorb that `design.md` did not foresee —
  a mechanism that did not work as § 2 describes, a scenario that turned out to be untestable at
  either seam, a changed test count on `main`. "Nothing." is a valid entry. Record too which of the
  scenarios § 2 and § 3 predicted red actually ran red; a prediction is not evidence.
- [ ] 5.7 **Tell the human what became of `DayScreen`'s unread roster store.** `design.md` § *The
  store `DayScreen` holds is still not read* records that the reason #103's G7 kept
  `private var rosterStore` — that #104 would read it — did not survive this design, and that this
  Story leaves the field untouched rather than overturning that decision quietly. Say so at G7 with
  the three ways out, and record their answer here. **Do not delete the field to tick this box**; a
  deletion is a separate decision and, if it is taken, its own commit.
- [ ] 5.8 **Write down here, before the archive runs, exactly what the janitor must check it
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
  2. The nine ADDED requirements landed in `openspec/specs/commitment/spec.md` and the one ADDED
     requirement — *A day screen reads its roster again when it is returned to* — in
     `openspec/specs/day-screen/spec.md`, each with its scenarios.
  3. `openspec/specs/record/spec.md` and `openspec/specs/schedule/spec.md` do not appear in the
     archive diff at all.

  **Any drift is a stop and a report, never a hand-edit**: rule 2 says those files are written by
  `/opsx:archive` and by nothing else.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7,
and `openspec validate --archived` requires every box above to be ticked before it.
