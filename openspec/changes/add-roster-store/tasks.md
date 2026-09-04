## 1. The two places, before anything else moves

This section changes no behaviour and adds no test. It exists because `DayScreen` gains a second
place, so every existing construction of one has to name it — 68 sites in
`Tests/DayByDayKitTests/DayScreenTests.swift`, in the file whose 59 tests are the evidence that this
change moves *where* a day screen gets its commitments and not what it does with them.

- [x] 1.1 In `Sources/DayByDayKit/Roster.swift`, widen `Entry` and `entries` from `private` to
  module-internal, and nothing else — no member added, no member renamed, no body changed. Verify with
  `cd src/DayByDayKit && swift build` exiting 0 and `swift test` still reporting **263 tests
  passing**. A behaviour change here is a rule-5 stop.
- [x] 1.2 Add `Sources/DayByDayKit/CommitmentCoding.swift` and move `CommitmentRecord`, `DateRecord`
  and `ScheduleRecord` into it **verbatim** from `RecordDocument.swift`, including their doc comments.
  `RecordDocument.swift` keeps `RecordDocument`, `RecordDocumentEnvelope` and `TickRecord` and loses
  nothing else; `RecordDocument.currentVersion` stays `1`. Verify with `swift test` reporting 263
  passing and `git diff` showing no line of the three types altered.
- [x] 1.3 Add `Sources/DayByDayKit/RosterStore.swift` declaring `public final class RosterStore` and
  `public enum RosterStoreError: Error, Equatable, Sendable` exactly as `design.md` § *The seam* gives
  them — `public init(at place: URL) throws`, `public private(set) var roster: Roster`,
  `@discardableResult public func add(_:) throws -> Bool`,
  `@discardableResult public func retire(_:keptUntil:) throws -> Bool`; the three cases
  `notAStore(at:)`, `laterForm(at:version:)`, `cannotWrite(at:)` — with the initializer and both
  methods bodied `fatalError("not implemented")`. Nothing else public. `swift build` exits 0.
- [x] 1.4 Add `Sources/DayByDayKit/RosterDocument.swift` declaring the `internal` document type for
  version 1 as `design.md` § *The form on disk* fixes it — `version`, `commitments`, each entry a
  `commitment` (the shared `CommitmentRecord`) and an optional `keptUntil` (a `DateRecord`) — plus a
  `RosterDocumentEnvelope` reading `version` alone, with `init(_ roster: Roster)` and
  `func formRoster() -> Roster?` bodied `fatalError("not implemented")`. The array is in the roster's
  own order; it is **not** sorted. `swift build` exits 0.
- [x] 1.5 In `Sources/DayByDayKit/DayScreen.swift`, change the initializer to
  `init(startingFrom dayOne: [Commitment], asOf today: CalendarDate, keepingRecordAt recordPlace: URL
  = DayScreen.recordPlace, keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace)`, add
  `public static var rosterPlace: URL`, `public enum RosterState`, `public private(set) var
  rosterState: RosterState`, and the private roster store and roster it needs. **Behaviour stays
  exactly as it is in this task:** the day view is still formed from `dayOne` directly, `rosterPlace`
  is unread, and `rosterState` is `.kept`. `swift build` exits 0 once 1.6 is done with it.
- [x] 1.6 Edit the two callers. In `Tests/DayByDayKitTests/DayScreenTests.swift`, add a helper
  returning both places under one fresh temporary directory — a record file and a roster file beside
  it — and change all 68 construction sites to the new labels, passing both. Where a test opens a
  second screen "at the same place", it passes the **same pair**. In
  `src/DayByDay/DayByDay/ContentView.swift`, change the one construction to `startingFrom:`.
  **No `@Test` display name, no assertion, no date, no commitment and no ordering may change**, and no
  test may be added or deleted. Verify with `swift test` reporting **263 tests passing**; a red test
  here is a rule-5 stop, because nothing in this section was supposed to change an answer.
- [x] 1.7 Confirm the starting point before writing a test: `pnpm run checks` reports
  `scenario coverage — 33/70 scenario(s) covered` for this change — the thirty-three restated verbatim
  by the five MODIFIED requirements, already carried by `DayScreenTests.swift` — and names
  `"a roster store opened where nothing has been kept holds a roster holding nothing"` as next. A
  different number means something else moved; report it rather than working around it.

## 2. `commitment` — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/commitment/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass
with the smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3).

All fifteen go in a new `Tests/DayByDayKitTests/RosterStoreTests.swift`. Each test opens its stores at
a fresh place — a URL under `FileManager.default.temporaryDirectory` with a `UUID` in the path, the
file one level under it so a directory has to be created — and reads bytes back with
`Data(contentsOf:)` where a scenario says *byte-for-byte*. No test reads a clock, sets a time zone or
touches a path outside its own place, and **no test touches the real application-support directory.**
Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green.

**This section is green on its own with no change to `DayScreen` at all**, which is where to stop if
the Story has to be split.

`design.md` expects these to run red on their own: 2.1 (the initializer's `fatalError`), 2.2 (the
first `add` and the first file on disk), 2.3 (order, if the document sorted the way the record's
does), 2.4 (the first `retire`), 2.6 and 2.7 (a refused change that still wrote), 2.12 (a write that
fails must leave `roster` untouched — an implementation that assigns before writing passes everything
before it and fails here), 2.13 (the first refusal), 2.14 (the version read on its own, ahead of the
body) and 2.15 (if the replay does not check what `add` and `retire` answer). **Record which ones
actually ran red as you go, in § 5**; a prediction here is not evidence.

- [x] 2.1 `a roster store opened where nothing has been kept holds a roster holding nothing` — opens
  at a place under a directory that does not exist yet; asserts no throw and `roster == Roster()`.
- [x] 2.2 `a commitment taken on through a roster store is held by a second store opened at the same
  place while the first is still open` — the write-through: the first store is a live local, the
  second is opened without any save or close on the first.
- [x] 2.3 `a roster store opened again holds its commitments in the order they were taken on` —
  "Water plants", "Gym", "Journaling"; assert the read-back array **and** `Roster` equality. Fails a
  document that sorted by name.
- [x] 2.4 `a commitment stopped through a roster store is read back stopped, on the day it was kept
  until` — observed through `commitments(on:)` on 31 January and 1 February 2026, since a stopped
  commitment has no public read-back of its own.
- [x] 2.5 `a commitment taken up again through a roster store is read back kept, in the place it was
  taken on in` — the kept-until day must be **cleared** on disk, not merely on the roster in memory.
- [x] 2.6 `a commitment a roster store is already keeping is refused and nothing at its place changes`
  — `add` answers `false` and does **not** throw; a store opened afterwards agrees.
- [x] 2.7 `a stop a roster store refuses is reported and nothing at its place changes` — both
  refusals in one test: a second stop of an already-stopped commitment, and a stop of one the roster
  does not hold. Neither throws, neither writes, and the day first given stands.
- [x] 2.8 `commitments on every schedule shape are read back as the same commitments` — one
  commitment per `Schedule` case, in the order the scenario names. This is the test that proves each
  payload round-trips through the shared `CommitmentRecord`, since no payload is public.
- [x] 2.9 `a commitment name is read back out of a roster store exactly, whatever it contains` — the name in the scenario,
  with the line break written as `\n` in the Swift literal. Observed through `Roster` equality and the
  read-back name (Swift `String ==`, not byte-for-byte).
- [x] 2.10 `a roster kept from the first supported date and stopped on the last is read back
  unchanged` — the ADR-1004 pin for this document: 1 January 1583 and 31 December 9999 both survive
  the round trip, in a `keptFrom` and in a `keptUntil`. An implementation that encoded through `Date`
  or a `DateFormatter` fails one of them.
- [x] 2.11 `roster stores at different places hold different rosters` — two places; the second opens
  holding nothing and the first still holds its commitment.
- [x] 2.12 `a change that cannot be kept is refused and not held` — the place is
  `<temporaryDirectory>/<uuid>/blocker/roster.json` where `blocker` is an ordinary file written by the
  test. Opening succeeds holding nothing, `add` throws `RosterStoreError.cannotWrite(at:)` (use
  `#expect(throws:)` with the exact case), `roster` is still `Roster()`, and a store opened afterwards
  is empty too.
- [x] 2.13 `content that is not a roster store is refused and left as it was` — a run of bytes that is
  not JSON; `.notAStore(at:)`; the bytes read back equal what was written.
- [x] 2.14 `a roster store written in a later form than this app knows is refused` — write
  `{"version": 2, "commitments": []}`; `.laterForm(at:version: 2)`; the bytes are unchanged.
- [x] 2.15 `a roster store holding what could not be a roster is refused` — three places, each
  written by hand in the test in the form `design.md` fixes and never through the store: a commitment
  named `"   "`, a commitment whose `keptFrom` is `{2026, 2, 30}`, and a document listing the same
  commitment twice. Each throws `.notAStore(at:)` and each file is byte-for-byte unchanged.

## 3. `day-screen` — one acceptance test each, in delta order

Twenty-two new tests, at the end of the existing `Tests/DayByDayKitTests/DayScreenTests.swift`, whose
suite is already `@MainActor` and whose fresh-places helper from § 1.6 they reuse. The other
thirty-three scenarios in this delta are #91's, #92's and #93's, already covered, and **no test for
them may be renamed or have an assertion changed** — they are the evidence that this change moves
where the commitments come from and not what a day screen does with them, and one of them going red
is a rule-5 stop.

Where a scenario says a commitment "is taken on at a roster place" by something other than the screen,
the test does that through a `RosterStore` opened directly at that place — which is also how #93's
"kept at that place by something else" tests already work for the record.

`design.md` expects these to run red on their own: 3.1 (the screen still draws what it was handed),
3.2 (if the roster were asked once rather than per day), 3.4 (if a tick wrote both files), 3.5 (day
one), 3.7 (if the trigger were "reads back no commitments"), 3.8 and 3.9 (if a refused roster were
seeded over), 3.11 (`rosterPlace`), 3.15 (the state), 3.20 (if being shown again did not re-read the
roster) and 3.22 (if what the screen says about the roster were carried over). **Record which ones
actually ran red as you go, in § 5.**

### The roster the screen draws from

- [x] 3.1 `a day screen draws the commitments its roster keeps, in the order they were taken on` —
  the screen is handed **no commitments at all**, so this fails any implementation still drawing its
  argument.
- [x] 3.2 `a day screen draws a commitment on the day it was kept until and not on the day after it`
  — the whole reason the roster is asked per day; assert both days in one test, as the scenario says.
- [x] 3.3 `moving a day screen does not read its roster again`
- [x] 3.4 `a tick made on a day screen leaves what is kept at its roster place as it was` —
  byte-for-byte, read with `Data(contentsOf:)` immediately after opening and again after the tick.

### Day one

- [x] 3.5 `a day screen opened where no roster has been kept takes on the commitments it was handed`
  — assert both the day view **and** what a `RosterStore` opened afterwards at that place reads back.
- [x] 3.6 `a day screen opened a second time does not take the commitments on again`
- [x] 3.7 `a day screen opened on a roster whose commitments have all been stopped takes nothing on`
  — the test that fails an implementation whose trigger is `roster.commitments.isEmpty` rather than
  `roster == Roster()`. `design.md` § *Day one is the app's content and the engine's moment* carries
  the standing obligation this test protects.
- [x] 3.8 `a day screen that cannot read its roster takes nothing on and leaves what is at the place
  as it was`
- [x] 3.9 `a day screen that could not keep the commitments it was handed says it is not keeping a
  roster` — the blocker-file place again, and the screen must still say it **is** keeping a record.
- [x] 3.10 `a day screen shown again on a roster that holds nothing takes the commitments on again`

### The roster's place

- [x] 3.11 `the place a day screen keeps its roster is under Application Support, in a directory of
  the app's own`
- [x] 3.12 `the place a day screen keeps its roster is neither the caches directory nor the temporary
  directory`
- [x] 3.13 `the place a day screen keeps its roster is the same place every time it is asked`
- [x] 3.14 `the place a day screen keeps its roster is not the place it keeps its record`

### A screen without its roster

- [x] 3.15 `a day screen opened where the roster cannot be read holds no rows and says it is not
  keeping one`
- [x] 3.16 `a roster written in a later form than this app knows makes a day screen that says the
  roster is from a later version` — write `{"version": 2, "commitments": []}` by hand.
- [x] 3.17 `a day screen opened where the roster can be read says it is keeping one`
- [x] 3.18 `a day screen that cannot read its roster still says the day and goes on keeping its
  record` — quote the expected title in full; an expectation assembled from the same pieces the code
  uses proves nothing.
- [x] 3.19 `a day screen that cannot read its record still draws the commitments its roster keeps` —
  the other half of the independence, and the one a single "something is wrong" state would fail.

### Being shown again

- [x] 3.20 `a day screen shown again reads its roster again`
- [x] 3.21 `a day screen that could not read its roster starts keeping one when it is shown again and
  the roster can be read`
- [x] 3.22 `a day screen that was keeping a roster stops when it is shown again and the roster cannot
  be read`

## 4. The shell, and the two files this change cannot write

- [ ] 4.1 `src/DayByDay/DayByDay/ContentView.swift` draws what a day screen says about its roster:
  two more rows beside the record's two, one for a roster that could not be read and one for a roster
  written by a later version, in the kit's own words and with no branch of its own. Nothing else in
  the file changes — `dayOneCommitments` stays exactly where it is, verbatim, and stays the thing
  handed to `startingFrom:`.
- [ ] 4.2 Run the app in the simulator and record here what was seen, since
  `docs/open-questions.md` § *No UI smoke layer* is still open and this is the only way this repo has:
  a first launch drawing the eight commitments; the app force-quit and reopened still drawing them;
  and the roster file present under `Application Support/DayByDay/` beside the record's. Say which
  simulator and which iOS version.
- [ ] 4.3 `docs/adr/1027-day-one-is-written-into-an-empty-roster.md` is written with this folder and
  `docs/adr/README.md` gains its row. Confirm before the PR opens that 1027 is still the lowest free
  number — `git log --all --name-only -- docs/adr` — and report rather than renumber if it is not.
- [ ] 4.4 `docs/open-questions.md` is not this change's to write (`AGENTS.md` § *Agent roles*). Its
  *Known gaps* entry about opening the store under `Library/Application Support/` now has a second
  file under it. Land that as a chore commit alongside the merge, exactly as #92 and #93 handled their
  own entries.

## 5. Gates, and things that moved while this Story was open

- [ ] 5.1 `cd src/DayByDayKit && swift test` reports **300 tests passing** and no failures — the
  thirty-seven here plus the 263 from before, none of which may change — and `pnpm run verify` exits 0.
- [ ] 5.2 `pnpm exec openspec validate add-roster-store --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 70 of 70.
- [ ] 5.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**). Four
  things the reviewer is asked to look for by name: that `roster` is assigned only **after** the file
  write returns, in both `add` and `retire`; that a refusal by `Roster` itself neither throws nor
  writes; that `RosterDocument`'s replay checks what `Roster.add` and `Roster.retire` answer rather
  than trusting the document; and that no `@Test` display name in `DayScreenTests.swift` changed in
  § 1.6's edit — `git diff` on that file should show construction lines and nothing else.
- [ ] 5.4 **The archive is checked requirement by requirement before its commit.** `/opsx:archive`
  dropped the prose of two MODIFIED requirements when it archived #93 (`design.md` § *A defect found
  in `openspec/specs/day-screen/spec.md` on `main`*). After running it, diff the five MODIFIED blocks
  in `openspec/specs/day-screen/spec.md` against `specs/day-screen/spec.md` in this folder. Any drift
  is a **stop** and a report, never a hand-edit: rule 2 says that file is written by `/opsx:archive`
  and nothing else.
- [ ] 5.5 Record here anything the implementation had to absorb that `design.md` did not foresee — a
  fifth `Schedule` case, a changed test count on `main`, a scenario that turned out to be untestable at
  the seam — so the reviewer and the archive read the folder against what was actually true.
  "Nothing." is a valid entry. Record too which of the scenarios § 2 and § 3 predicted red actually ran
  red; a prediction is not evidence.
- [ ] 5.6 Two things `main` carries that this Story does **not** fix, left for the human to decide
  about: the five scenarios belonging to *A day screen re-reads its day and its record when the app is
  shown again* that #93's archive appended under *A day view says its day as a weekday and a date…*
  instead, and the two requirement headers glued to the preceding line at
  `openspec/specs/day-screen/spec.md:949` and `:1050`. Moving the first would need a MODIFIED block on
  a requirement this Story has no business in; the second cannot be hand-edited under rule 2.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
