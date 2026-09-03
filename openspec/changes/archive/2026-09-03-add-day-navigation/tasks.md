## 1. The public surface

- [x] 1.1 Add the internal step to `Sources/DayByDayKit/CalendarDate.swift`: one member,
  `func adding(days: Int) -> CalendarDate?`, built on the private UTC `Calendar` the type already
  holds and returning through the existing `init?(year:month:day:)` so that the 1583–9999 guard is
  not restated. It stays **internal** — nothing in `openspec/specs/schedule/spec.md` moves, and a
  `public` here would be a delta this change does not carry (`design.md` § *The seam*).
- [x] 1.2 Widen `Sources/DayByDayKit/DayView.swift` exactly as `design.md` § *The seam* gives it:
  two new public members, `func previousDay(of commitments: [Commitment], in history: History) ->
  DayView?` and `func nextDay(of commitments: [Commitment], in history: History) -> DayView?`, each
  with a body of `fatalError("not implemented")`. Nothing else becomes public — `DayView.date`,
  `Row.date` and `Row.commitment` all stay internal — and no other file in the package is touched.
  Verify with `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.3 Confirm nothing else moved: `git diff --stat` names only `CalendarDate.swift` and
  `DayView.swift`, and `cd src/DayByDayKit && swift test` still reports the 149 tests from #8, #9,
  #10, #11, #42, #55, #56, #70 and #71 passing. This delta is ADDED throughout and is expected to
  change **no** existing test; if one goes red here, stop — that is a MODIFIED requirement this
  delta does not carry, and it is a rule-5 stop rather than a test to edit.
- [x] 1.4 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/15 covered` for this change and names `"moving to the day after gives the day view of the next
  date"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/day-screen/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it
pass with the smallest change that does. Never write two before the first is green (`AGENTS.md`
rule 3). They go in the existing `Tests/DayByDayKitTests/DayViewTests.swift` — same capability, same
seam, one file, as #71 did.

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. Every date below was measured in `design.md` § *Context* rather than recalled; do not
re-derive a weekday, and do not substitute a date the delta does not name.

`design.md` expects these to run red on their own: 2.1 (the `fatalError`), 2.2 (if the step was
written in one direction only), 2.4 (if the move reused the day view's own commitments or history
rather than the arguments), 2.5 (if the move refused a date that has not arrived), 2.7 (if the move
consulted the commitments to decide where it lands), 2.11 (if the month length was assumed), 2.12
(if a leap day was skipped), and 2.13, 2.14 (if the bound was not taken from
`CalendarDate.init?`). **Record which ones actually ran red as you go, in this file** — a prediction
here is not evidence.

- [x] 2.1 `moving to the day after gives the day view of the next date` — three commitments on
  Monday 31 August 2026, of which only the daily one is due on Tuesday 1 September; two assertions,
  the row and equality with a day view formed directly on that date. Runs red against the seam's
  `fatalError`. **Confirmed red**: `Fatal error: not implemented` at `DayView.swift:38` (the
  `nextDay` stub), before `nextDay` was implemented with `date.adding(days: 1)`.
- [x] 2.2 `moving to the day before gives the day view of the previous date` — the mirror, from
  Wednesday 2 September 2026 onto the same Tuesday. The scenario that catches a transposed
  direction. **Confirmed red**: `Fatal error: not implemented` at `DayView.swift:32` (the
  `previousDay` stub), before it was implemented with `date.adding(days: -1)`.
- [x] 2.3 `the rows of the day moved to are asked again rather than carried across` — a tick on the
  day moved from and none on the day moved to; two assertions, kept before and not kept after. Pins
  that no row travels. Ran green immediately: `nextDay` already re-forms a fresh `DayView`, which
  necessarily re-asks `history.isKept` rather than carrying a row across.
- [x] 2.4 `a move uses the commitments and history it is handed rather than the ones the day view
  came from` — moved from a "Gym" day view while handed only "Vitamins" and a history holding its
  tick. Fails any implementation that captured the first day view's arguments. Ran green
  immediately: neither `nextDay` nor `previousDay` captures anything from `self` but `date`.
- [x] 2.5 `a day view moves onto a date that has not arrived, and its rows offer no tick` — the
  composition with #71: three assertions, the row exists, it offers nothing as of the earlier day,
  and it offers a tick as of its own. Fails an implementation that bounded the move at today. Ran
  green immediately: neither `nextDay` nor `previousDay` takes or consults a clock, so #71's
  `Row.tick(asOf:)` composes unmodified.
- [x] 2.6 `moving to the day after and back again gives the day view it started from` — the round
  trip both ways round, two assertions. Pins that the two steps are inverses. Ran green
  immediately: `adding(days: 1)` then `adding(days: -1)` (and the reverse) round-trip through the
  same UTC `Calendar`.
- [x] 2.7 `moving does not skip a date on which nothing is due` — from Monday 31 August 2026 with
  "Gym" alone: the day moved to holds no rows, and the day after that holds one. Fails an
  implementation that stepped to the next date something is due on. Ran green immediately:
  `adding(days:)` steps the calendar unconditionally and never consults `commitments`.
- [x] 2.8 `moving across the end of a month` — Wednesday 30 September 2026 to Thursday 1 October
  2026, and back. Ran green immediately: `adding(days:)` delegates month-length arithmetic to
  `Calendar.date(byAdding:to:)`.
- [x] 2.9 `moving across the turn of a year` — Thursday 31 December 2026 to Friday 1 January 2027,
  and back. Ran green immediately: the same `Calendar.date(byAdding:to:)` delegation carries the
  year rollover too.
- [x] 2.10 `moving across the leap day of a leap year` — Monday 28 February 2028 to Tuesday
  29 February 2028 to Wednesday 1 March 2028. Fails an implementation that added a fixed number of
  days per month or skipped 29 February. Ran green immediately: `Calendar.date(byAdding:to:)`
  neither skips nor doubles the leap day.
- [x] 2.11 `moving across the end of February in a year that is not a leap year` — Sunday
  28 February 2100 to Monday 1 March 2100. 2100 is a century year that is not a leap year, measured
  in `design.md` § *Context*; do not substitute another year. Ran green immediately: the same
  `Calendar.date(byAdding:to:)` delegation, itself Gregorian and so century-year aware.
- [x] 2.12 `the first supported date has no day before it` — Saturday 1 January 1583: nothing given
  moving back, and the day view of Sunday 2 January 1583, which holds no rows, moving forward. Ran
  green immediately: `adding(days:)` already returns through `CalendarDate.init?`, whose
  `(1583...9999)` guard refuses 1582-12-31 without a second copy of the bound.
- [x] 2.13 `the last supported date has no day after it` — Friday 31 December 9999: nothing given
  moving forward, and Thursday 30 December 9999 moving back. Ran green immediately: no crash at the
  upper bound either — `Calendar.date(byAdding:to:)` hands back a valid `10000-01-01` `Date`, which
  `CalendarDate.init?` then refuses via the same guard, exactly as measured in `design.md` §
  *Context*.
- [x] 2.14 `the date one day inside each end of the supported dates moves onto that end` — the
  off-by-one at both ends, two assertions. An implementation that refused a day early fails here
  while 2.12 and 2.13 still pass. Ran green immediately: `adding(days:)` steps exactly one day and
  the bound is `CalendarDate.init?`'s own guard, not an off-by-one written here.
- [x] 2.15 `the refusal at either end does not depend on what the day view holds` — an empty day
  view at 1 January 1583 and a ticked one at 31 December 9999, both refusing. Pins that the bound
  reads the date and nothing else. Ran green immediately: the refusal comes from `date` alone
  through `adding(days:)` and `CalendarDate.init?`, never from `commitments` or `history`.

## 3. Gates

- [x] 3.1 `cd src/DayByDayKit && swift test` reports 164 tests passing and no failures — the fifteen
  here plus the 149 from #8, #9, #10, #11, #42, #55, #56, #70 and #71, none of which may change —
  and `pnpm run verify` exits 0.
- [x] 3.2 `pnpm exec openspec validate add-day-navigation --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 15 of 15.
- [x] 3.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
