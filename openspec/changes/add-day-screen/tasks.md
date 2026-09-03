## 1. The public surface

- [ ] 1.1 Add `platforms: [.iOS(.v17), .macOS(.v14)]` to `src/DayByDayKit/Package.swift`, above
  `products:`. Nothing else in the manifest changes — same tools version, same language mode, same
  targets. Verify with `cd src/DayByDayKit && swift build` exiting 0 and `swift test` still
  reporting the 164 tests from #8, #9, #10, #11, #42, #55, #56, #70, #71 and #72 passing. If any
  goes red here, stop: a platform floor is not supposed to change behaviour and that is a rule-5
  stop, not a test to edit.
- [ ] 1.2 Add `Sources/DayByDayKit/DayScreen.swift` with exactly the surface `design.md` § *The
  seam* gives — `@MainActor @Observable public final class DayScreen`, the static `recordPlace`,
  the three-argument `init` with `keeping` defaulted, `dayView`, `keepsRecord`, `tick(_:)` and
  `shown(asOf:)` — every body being `fatalError("not implemented")` except what the stored
  properties need to compile. Nothing else becomes public and no existing source file is touched.
  Verify with `swift build` exiting 0.
- [ ] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/26 covered` for this change and names `"a day screen opened where nothing has been kept holds
  the day view of that day with nothing kept"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/day-screen/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it
pass with the smallest change that does. Never write two before the first is green (`AGENTS.md`
rule 3). They go in a new `Tests/DayByDayKitTests/DayScreenTests.swift` — a new seam gets its own
file, as `RecordStoreTests` did for #56 — and the suite is `@MainActor`, because `DayScreen` is.

Every test that needs a place gets a directory of its own under the system temporary directory,
created before and removed after, exactly as `RecordStoreTests` already does. **No test may touch
the real application-support directory**: 2.12 to 2.14 ask `DayScreen.recordPlace` for a path and
must never write to it.

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. Every date below was measured in `design.md` § *Context* rather than recalled; do not
re-derive a weekday, and do not substitute a date the delta does not name.

`design.md` expects these to run red on their own: 2.1 (the `fatalError`), 2.2 (if opening ignored
what is at the place), 2.3 (if the day were read from a clock), 2.8 (if the day view were altered in
place rather than formed again), 2.15 (if opening were allowed to throw), 2.19 (if a screen without
a record still wrote), 2.21 (if `shown` did not replace the day), 2.23 (if `shown` re-used the store
it already held) and 2.24 (if `shown` did not re-open the store). **Record which ones actually ran
red as you go, in this file** — a prediction here is not evidence.

- [ ] 2.1 `a day screen opened where nothing has been kept holds the day view of that day with
  nothing kept` — the first tick of the seam: one row for "Gym", none for "Run", and the row not
  kept. Runs red against the `fatalError`.
- [ ] 2.2 `a day screen opened where a tick was kept holds a day view that says the commitment is
  kept` — a `RecordStore` opened directly at the place and given the tick first, then the screen
  opened over it. The half of "find the day you left" that reads.
- [ ] 2.3 `a day screen holds the day it was handed rather than the day it really is` — 3 January
  1583 and 27 December 9999, both Mondays. Any implementation that reaches for `Date()` fails both
  halves; the assertion is against a `DayView` formed directly, so it pins "adds nothing" too.
- [ ] 2.4 `a day screen holds the same day view as one formed directly from the same commitments,
  day and history` — two commitments, one tick added and one taken back at the place first, then
  the whole day view compared for equality with a directly formed one. The strongest single
  assertion that the screen delegates rather than recomputes.
- [ ] 2.5 `ticking a row that says its commitment is not kept makes the day screen say it is kept` —
  the tap. Takes the screen's own row from `dayView.rows`, not one built by the test.
- [ ] 2.6 `ticking a row that says its commitment is kept takes the tick back` — the second tap,
  taking the row from the day view *as it then stands*, which is the row `isKept` is read off.
  Second assertion: the day view is equal to the one held at opening, so the untick left nothing.
- [ ] 2.7 `a tick made on a day screen is held by a day screen opened afterwards at the same place` —
  **the Story's headline**: the tick survives a quit. A second `DayScreen` at the same place.
- [ ] 2.8 `a tick taken back on a day screen is not held by a day screen opened afterwards at the
  same place` — the same round trip in the other direction.
- [ ] 2.9 `ticking one row leaves the other rows of the day as they were` — three commitments, the
  middle one ticked; assert three rows, the order unchanged, and only the middle kept.
- [ ] 2.10 `a change that cannot be kept is refused and leaves the day view as it was` — a place
  beneath an existing ordinary file, which opens empty (`fileExists` is false) and then refuses the
  write. Three assertions: `tick` throws, the day view is unchanged, and a screen opened afterwards
  agrees. This is `RecordStoreError.cannotWrite` reaching the caller.
- [ ] 2.11 `a row the day screen's day view does not hold changes nothing` — a row taken from a
  screen on Wednesday 2 September 2026 and handed to a screen on Monday 31 August 2026. Fails an
  implementation with no `contains` guard, in both assertions: the Monday screen would be unchanged
  but a tick for the Wednesday would have been written.
- [ ] 2.12 `the place a day screen keeps its record is under Application Support, in a directory of
  the app's own` — ask `DayScreen.recordPlace`; assert the path contains the platform's
  application-support directory, and that the file sits inside a directory within it rather than
  directly in it. Read only; nothing is written.
- [ ] 2.13 `the place a day screen keeps its record is neither the caches directory nor the
  temporary directory` — the two places `design.md` § *The place* rules out by name.
- [ ] 2.14 `the place a day screen keeps its record is the same place every time it is asked` — two
  reads, equal.
- [ ] 2.15 `a day screen opened where the record cannot be read still holds the day view of that
  day` — a run of bytes that is not a record. The screen opens rather than throwing, and still
  answers the day. ADR-1021's first half.
- [ ] 2.16 `a day screen opened where the record cannot be read says it is not keeping one` —
  `keepsRecord` is false.
- [ ] 2.17 `a record written in a later form than this app knows makes a day screen that is not
  keeping one` — the second of `record`'s three refusal shapes, treated identically. Build the
  bytes the same way `RecordStoreTests` builds its later-form case.
- [ ] 2.18 `a day screen opened where the record can be read says it is keeping one` — the positive
  control, both at an empty place and at one holding a tick. Without it, `keepsRecord` could be a
  constant.
- [ ] 2.19 `ticking a row on a day screen that is not keeping a record changes nothing and keeps
  nothing` — ADR-1021's second half: the tap is silent, `tick` does not throw, the day view does not
  move and `keepsRecord` stays false.
- [ ] 2.20 `a day screen opened where the record cannot be read leaves what is at the place as it
  was` — read the bytes before, tick, read them after, compare byte for byte. The scenario that
  makes "keeps nothing" mean something on disk rather than only in memory.
- [ ] 2.21 `a day screen shown again on a later day holds that day's day view` — Monday to Tuesday,
  "Gym" out and "Run" in.
- [ ] 2.22 `a day screen shown again on the day it is already on holds that day's day view` —
  equality against the day view it held at opening.
- [ ] 2.23 `a day screen shown again reads the record again` — a tick written at the place by a
  separate `RecordStore` between the two, then `shown`. Fails an implementation that re-uses the
  store it already holds.
- [ ] 2.24 `a day screen that could not read its record starts keeping one when it is shown again
  and the record can be read` — the recovery case `design.md` § *Showing the app again* exists for.
  Replace the unreadable bytes with a real record holding the tick, then `shown`.
- [ ] 2.25 `a day screen that was keeping a record stops when it is shown again and the record
  cannot be read` — the same axis in reverse, so `keepsRecord` is not one-way.
- [ ] 2.26 `a day screen does not change day when a tick is made on it` — tick, then compare the
  whole day view with one formed directly on the same date from a history holding that one tick.
  The last pin on "only being shown again changes the day".

## 3. The shell

No scenario covers this section — `docs/open-questions.md` § *No UI smoke layer* — so keep it to
what has no judgement in it, and change nothing in `DayByDayKit` from here.

- [ ] 3.1 Rewire `src/DayByDay/DayByDay/ContentView.swift`: keep `dayOneCommitments` and `today()`
  exactly as #81 wrote them, hold a `DayScreen` in `@State`, draw `screen.dayView.rows` with a tap
  calling `try? screen.tick(row)`, draw something when `screen.keepsRecord` is false, and call
  `screen.shown(asOf: today())` from `.onChange(of: scenePhase)` when the phase becomes active. No
  `if`, no date arithmetic and no place-choosing in the body; the seam's default place is used by
  not naming one.
- [ ] 3.2 Build and run it: `xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay
  -destination 'platform=iOS Simulator,name=iPhone 17' build`, then `xcrun simctl` boot, install and
  launch as ADR-1019 records. Tick a row, quit the app from the simulator, launch it again, and
  confirm the tick is still there. Record what you saw here — that round trip is the Story's
  intent and nothing in CI can observe it.

## 4. Gates

- [ ] 4.1 `cd src/DayByDayKit && swift test` reports 190 tests passing and no failures — the
  twenty-six here plus the 164 from #8, #9, #10, #11, #42, #55, #56, #70, #71 and #72, none of which
  may change — and `pnpm run verify` exits 0.
- [ ] 4.2 `pnpm exec openspec validate add-day-screen --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 26 of 26.
- [ ] 4.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.

Two documentation moves fall outside this change folder and outside `spec-author`'s reach, so they
are named here rather than done here: `docs/open-questions.md` § *Known gaps* loses "The store must
be opened under `Library/Application Support/`" and gains a line under *Settled* naming this Story,
and the same file's "`RecordStore.init` can throw outside `RecordStoreError`" gains a line saying
this Story met it and left it open on purpose. A chore commit alongside the merge, as `d1f99dc` was
for #71 and #72.
