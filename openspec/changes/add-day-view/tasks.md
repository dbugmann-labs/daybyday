## 1. The public surface

- [x] 1.1 Add `Sources/DayByDayKit/DayView.swift` declaring `public struct DayView: Hashable,
  Sendable` exactly as `design.md` § *The seam* gives it — a nested `public struct Row: Hashable,
  Sendable` with an internal stored `commitment: Commitment`, a `public let isKept: Bool` and a
  `public var name: String` reading the commitment's; an internal stored `date: CalendarDate`; a
  `public let rows: [Row]`; and `public init(of commitments: [Commitment], on date: CalendarDate, in
  history: History)` with a body of `fatalError("not implemented")`. Nothing else public, and the
  initializer is not failable. Verify with `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.2 Confirm nothing else in the package moved: `Commitment.swift`, `History.swift`,
  `Tick.swift`, `Schedule.swift`, `CalendarDate.swift`, `DayOfMonth.swift`, `DayInterval.swift`,
  `Weekday.swift`, `WeeklyQuota.swift` and `Package.swift` are untouched in `git diff --stat`, and
  `cd src/DayByDayKit && swift test` still reports the ninety-seven tests from #8, #9, #10, #11, #42
  and #55 passing.
- [x] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/21 covered` for this change and names `"a day view holds a row for each commitment due on the
  date"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/day-screen/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass
with the smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3).
Put them in a new `Tests/DayByDayKitTests/DayViewTests.swift` — the existing test files are each one
capability, and this is a new one.

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. Every date below was measured in `design.md` § *Context* rather than recalled; do not
re-derive a weekday, and do not substitute a date the delta does not name.

Expect most of these to pin rather than drive, as on #42 and #55. The ones `design.md` expects to run
red on their own are 2.1 (the initializer's `fatalError`), 2.2 (no due-ness filter yet, if 2.1 was
made green by mapping every commitment to a row), 2.3 (the first kept-ness, if 2.1 was made green
with a hard-coded `false`), 2.7 (if the filter asks the schedule rather than the commitment), 2.18 (if
the rows were built from a `Set` or otherwise deduplicated), and 2.20 and 2.21 (if the date was not
stored on the day view). **Record which ones actually ran red as you go, in this file**, the way #42's
and #55's `tasks.md` did; a prediction here is not evidence.

- [x] 2.1 `a day view holds a row for each commitment due on the date` — three commitments handed
  over, two due; two rows, named "Gym" and "Run". Ran red against the seam's `fatalError`, as
  `design.md` predicted.
- [x] 2.2 `a commitment not due on the date has no row` — Mon/Wed/Sat asked about a Tuesday; the
  filter. Pinned rather than drove: 2.1's implementation already filtered on `isDue(on:)`.
- [x] 2.3 `a commitment ticked on the date has a row that says it is kept` — the first
  `History.isKept`, and the pin that a ticked commitment stays in the view rather than leaving it.
  Pinned rather than drove: 2.1's implementation already read `history.isKept(_:on:)`.
- [x] 2.4 `a commitment not ticked on the date has a row that says it is not kept` — the other side
  of 2.3, against a history that has taken no tick. Pinned rather than drove.
- [x] 2.5 `a day view of no commitments at all has no rows` — the empty input, answered rather than
  refused. Pinned rather than drove.
- [x] 2.6 `a day view holds no rows when none of the commitments is due` — a day-of-month and an
  interval commitment, neither due on 31 August 2026 (the arithmetic is in `design.md` § *Context*);
  an empty view is an answer, not an error. Pinned rather than drove.
- [x] 2.7 `a commitment whose schedule is due but which is kept from a later day has no row` — the
  ADR-1013 catch. An implementation that reaches past `Commitment.isDue(on:)` to `Schedule.isDue(on:)`
  passes 2.2 and fails only here. Two assertions: no row on 31 August, one row on 2 September.
  Pinned rather than drove: 2.1's implementation already asks `Commitment.isDue(on:)`.
- [x] 2.8 `a tick for a commitment the day view was not handed adds no row` — pins that rows come
  from the commitments handed over and never from the history.
- [x] 2.9 `a tick on another date does not make the row say it is kept` — pins that the day view's
  date is the one passed to `isKept`; two assertions, 31 August not kept and 5 September kept.
- [x] 2.10 `two commitments with the same name and different schedules each have their own row` —
  two rows, both named "Gym", kept independently. Pins that a row is a commitment's line rather than
  a name's, and that nothing collapses them.
- [x] 2.11 `a commitment on a weekly quota has a row on every day of the week` — ADR-1015's cost made
  visible: a seven-date sweep with an empty history, then the same sweep with three ticks. The four
  unticked days still hold a row.
- [x] 2.12 `a day view is formed in the first supported year and in the last` — the *no clock* pin:
  3 January 1583 and 27 December 9999 are both Mondays. An implementation that compares against
  `Date()` in any way fails one of them.
- [x] 2.13 `a row carries the commitment's name exactly as it was given` — " Gym " with both spaces,
  and a single emoji; pins that the day view neither trims nor rewrites what `commitment` stored.
- [x] 2.14 `rows are in the order the commitments were handed over` — three due commitments, rows in
  the order given.
- [x] 2.15 `handing the same commitments in the opposite order reverses the rows` — with 2.14, the
  pair that fails any sort by name.
- [x] 2.16 `a kept commitment keeps its place among the ones that are not kept` — the middle row is
  the kept one and stays in the middle. Fails an implementation that floats unticked rows to the top.
- [x] 2.17 `dropping a commitment that is not due leaves the others in their order` — a not-due
  commitment removed from the middle; the two that remain keep their relative order.
- [ ] 2.18 `a commitment handed twice has two rows` — no deduplication. Fails an implementation
  backed by a `Set` or one that filters duplicates out.
- [ ] 2.19 `two day views of the same commitments, date and history are the same day view` — expected
  to pin synthesised `Equatable`.
- [ ] 2.20 `two day views of the same commitments and history on different dates are different day
  views` — the rows are identical on both dates, so this fails unless the date is part of the value.
  The scenario that justifies storing it.
- [ ] 2.21 `a day view does not change when the history it was built from is ticked afterwards` — the
  snapshot pin, and the one that would fail a `DayView` holding a reference to a live history. Three
  assertions: the old view unchanged, a freshly formed one kept, the two unequal. Deliberately last.

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 118 tests passing and no failures — the
  twenty-one here plus the ninety-seven from #8, #9, #10, #11, #42 and #55, none of which may change —
  and `pnpm run verify` exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-day-view --strict` exits 0 and `pnpm run checks` reports
  scenario coverage as 21 of 21.
- [ ] 3.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
