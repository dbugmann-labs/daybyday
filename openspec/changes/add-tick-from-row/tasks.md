## 1. The public surface

- [x] 1.1 Widen `Sources/DayByDayKit/DayView.swift` exactly as `design.md` § *The seam* gives it:
  add an internal stored `let date: CalendarDate` to `DayView.Row`, passed down from `DayView`'s own
  date in the initializer, and one new public member `func tick(asOf today: CalendarDate) -> Tick?`
  with a body of `fatalError("not implemented")`. Nothing else becomes public — `commitment` and
  `date` stay internal, `DayView`'s own `date` is not exposed, and no other file in the package is
  touched. Verify with `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.2 Confirm nothing else moved: `git diff --stat` names only `DayView.swift`, and `cd
  src/DayByDayKit && swift test` still reports the 135 tests from #8, #9, #10, #11, #42, #55, #56
  and #70 passing. Adding `date` to `Row` changes row equality (`design.md` § *Row equality gains
  the date*) and is expected to change **no** existing test; if one goes red here, stop — that is a
  MODIFIED requirement this delta does not carry, and it is a rule-5 stop rather than a test to
  edit.
- [x] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports `0/14
  covered` for this change and names `"a row offers the tick for its commitment on the date the day
  view is of"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/day-screen/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it
pass with the smallest change that does. Never write two before the first is green (`AGENTS.md` rule
3). They go in the existing `Tests/DayByDayKitTests/DayViewTests.swift` — this is the same
capability and the same seam as #70, so it is one file.

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. Every date below was measured in `design.md` § *Context* rather than recalled; do not
re-derive a weekday, and do not substitute a date the delta does not name.

`design.md` expects these to run red on their own: 2.1 (the `fatalError`), 2.5 (no day comparison
yet, if 2.1 was made green by always returning the tick), 2.7 (if the refusal was written to depend
on `isKept`), 2.8 (if the day was captured when the day view was formed rather than read from the
argument), 2.9 (if the comparison reaches for `Date()` rather than the argument), and 2.13 (if `Row`
did not gain its date). **Record which ones actually ran red as you go, in this file** — a
prediction here is not evidence.

- [x] 2.1 `a row offers the tick for its commitment on the date the day view is of` — the row asked
  as of its own date; two assertions, that a tick comes back and that it equals one formed directly
  by `Tick(commitment, on:)`. Runs red against the seam's `fatalError`. Confirmed red: `swift test`
  trapped with `Fatal error: not implemented` (signal 5) before this task's fix.
- [x] 2.2 `adding the tick a row offers makes a day view formed again say the commitment is kept` —
  the offered tick handed to `History.add(_:)`, then a second day view formed from the history as it
  now stands. The first half of the round trip, and the scenario that makes "tick from the row" more
  than a getter. Passed immediately on 2.1's implementation — it composes existing `record` behaviour
  rather than driving new logic, so no red run for the right reason was available here.
- [x] 2.3 `taking back the tick a row offers makes a day view formed again say the commitment is not
  kept` — the same tick handed to `History.remove(_:)`. The Story's second half; two assertions, the
  original row kept and the re-formed one not. Passed immediately, same reason as 2.2.
- [x] 2.4 `a row already saying the commitment is kept offers the same tick` — two day views on one
  date, one history empty and one holding the tick; the rows differ in `isKept` and offer an equal
  tick. Pins that the offer does not consult the history. Passed immediately — the current
  implementation never reads the history for `tick(asOf:)`.
- [x] 2.5 `a row for a date later than the day it is asked as of offers no tick` — a day view on
  Wednesday 2 September 2026 asked as of Monday 31 August 2026. The refusal itself. Confirmed red:
  `swift test` reported the offered tick equal to a formed one rather than `nil`, because 2.1's
  implementation always returned a tick.
- [x] 2.6 `a row for a date earlier than the day it is asked as of offers the tick` — a day view on
  Monday 31 August 2026 asked as of Saturday 5 September 2026: the past is writable. Fails an
  implementation that compares for equality rather than for "later than". Passed immediately: 2.5's
  fix already compares `> 0`, not equality.
- [x] 2.7 `a row for a date later than the day it is asked as of offers no tick even where it says
  the commitment is kept` — the future row that is already ticked. Two assertions: it says kept, and
  it offers nothing. This is the scenario the question round turned on; the owner answered *refuse
  whole* on 2026-09-03, which is what it already said, so write it as it stands. Passed immediately —
  the refusal never consulted `isKept`.
- [x] 2.8 `a row's answer follows the day it is asked as of rather than the day the day view was
  formed` — one row, asked twice, either side of its own date. The midnight pin, and the test that
  fails an implementation that took the day at construction. Passed immediately — `tick(asOf:)` takes
  its argument at call time, never at construction.
- [x] 2.9 `a row offers the tick in the first supported year and in the last` — 3 January 1583 and
  27 December 9999, both Mondays; three assertions, the third being the 9999 row asked as of 1583,
  which offers nothing. Any implementation that reaches for `Date()` fails one of the three. Passed
  immediately.
- [x] 2.10 `every row of a day view whose date has not arrived offers no tick` — three commitments
  on three different schedule shapes, all due on Wednesday 2 September 2026, none offering a tick as
  of Monday 31 August 2026. Pins that the refusal is the day view's date and not something per-row.
  Passed immediately.
- [ ] 2.11 `a row for a commitment on a weekly quota offers a tick even where its quota is already
  met` — ADR-1015's cost, still unfixed and now visible on the tap as well as in the view: three
  ticks in the seven days up to Sunday 6 September 2026 and the row still offers a fourth.
  Deliberately does not name a week — where a week begins is undecided (`CONTEXT.md` § *Weekly
  quota*).
- [ ] 2.12 `two rows for the same commitment and date saying the same thing are the same row` —
  expected to pin synthesised `Equatable` rather than drive anything.
- [ ] 2.13 `two rows for the same commitment on different dates are different rows` — the scenario
  that justifies storing the date on the row. Under #70's `Row` these two were equal; this is the
  one observable equality change in the delta.
- [ ] 2.14 `two rows for the same commitment and date differing in whether it is kept are different
  rows` — the other axis of row identity, expected to pin.

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 149 tests passing and no failures — the
  fourteen here plus the 135 from #8, #9, #10, #11, #42, #55, #56 and #70, none of which may change
  — and `pnpm run verify` exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-tick-from-row --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 14 of 14.
- [ ] 3.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
