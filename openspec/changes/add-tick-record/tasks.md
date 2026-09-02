## 1. The public surface

- [x] 1.1 Add `Sources/DayByDayKit/Tick.swift` declaring `public struct Tick: Hashable, Sendable`
  exactly as `design.md` § *The seam* gives it — internal stored `commitment: Commitment` and
  `date: CalendarDate`, `public init?(_ commitment: Commitment, on date: CalendarDate)` with a body
  of `fatalError("not implemented")`. Nothing else public. Verify with `cd src/DayByDayKit && swift
  build` exiting 0.
- [x] 1.2 Add `Sources/DayByDayKit/History.swift` declaring `public struct History: Hashable,
  Sendable` as § *The seam* gives it — `public init()`, `public mutating func add(_ tick: Tick)`,
  `public mutating func remove(_ tick: Tick)`, `public func isKept(_ commitment: Commitment, on date:
  CalendarDate) -> Bool`, the three methods bodied with `fatalError("not implemented")`, over an
  internal `Set<Tick>`. Nothing else public. Verify with `swift build` exiting 0.
- [x] 1.3 Confirm nothing else in the package moved: `Commitment.swift`, `Schedule.swift`,
  `CalendarDate.swift`, `DayOfMonth.swift`, `DayInterval.swift`, `Weekday.swift` and `Package.swift`
  are untouched in `git diff --stat`, and `cd src/DayByDayKit && swift test` still reports the
  sixty-four tests from #8, #9, #10 and #42 passing.
- [x] 1.4 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/23 covered` for this change and names `"a tick is formed for a commitment on a date it is due
  on"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/record/spec.md` and writes one acceptance
test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass with the
smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3). Put them
in a new `Tests/DayByDayKitTests/RecordTests.swift` — the four existing test files are each one type
or shape, and this capability is two types that only work together. Verify each with `cd
src/DayByDayKit && swift test`: the named test green, every earlier test still green.

Expect most of these to pin rather than drive, as on #42, where fourteen of nineteen ran green
immediately. **Record which ones actually ran red as you go, in this file**, the way #42's `tasks.md`
did; a prediction here is not evidence. The ones `design.md` expects to run red on their own are
2.1 (the initializer's `fatalError`), 2.2 (no due-ness guard yet, if 2.1 was made green by returning
a value unconditionally), 2.12 (the first `isKept`), 2.17 if `add` was made green with anything other
than a set, 2.19 (the first `remove`), and 2.22 and 2.23 if `remove` left any residue behind.

- [x] 2.1 `a tick is formed for a commitment on a date it is due on` — ran red (the
  initializer's `fatalError`), as expected.
- [x] 2.2 `a commitment takes no tick on a date it is not due on` — the refusal; made green with
  `guard commitment.isDue(on: date) else { return nil }` and nothing more. Ran red as expected.
- [x] 2.3 `a commitment takes no tick on a date before the day it is kept from` — pins that the
  guard asks the *commitment* and not the schedule: an implementation that reaches past
  `Commitment.isDue(on:)` to `Schedule.isDue(on:)` passes 2.2 and fails here. Pinned green.
- [x] 2.4 `a commitment on a schedule due on no date takes no tick on any date` — a seven-date
  sweep on the empty weekday set; a legal commitment that can never be ticked, answered rather than
  errored. Pinned green.
- [x] 2.5 `a tick is formed on the last day of a month too short for the scheduled day` —
  delegation reaches the short-month clamp; two assertions, 28 February 2027 formed and 1 March
  2027 not. Pinned green.
- [x] 2.6 `an interval landing before the day it is kept from takes no tick and the first landing
  after it does` — the two-date interaction from ADR-1013, seen from the tick's side; 28 August
  2026 not formed, 3 September 2026 formed. Pinned green.
- [x] 2.7 `a tick is formed on a due date in the first supported year and in the last` — the *no
  clock* pin: 3 January 1583 and 27 December 9999 are both Mondays (measured in `design.md`
  § *Context*) and both form. An implementation that compares against `Date()` in any way fails one
  of them. Pinned green.
- [x] 2.8 `two ticks alike in commitment and date are the same tick` — expected to pin synthesised
  `Equatable`. Pinned green.
- [x] 2.9 `two ticks of the same commitment on different dates are different ticks` — with 2.10,
  the only observable proof that both parts are carried; neither is public. Pinned green.
- [x] 2.10 `two ticks of different commitments on the same date are different ticks` — Pinned green.
- [x] 2.11 `an empty history has kept nothing` — `History()` answers `false`; may pin or drive
  depending on how 1.2's `fatalError` was replaced. Ran red (the `isKept` `fatalError`); made green
  by implementing `isKept` as `Tick(commitment, on: date).map(ticks.contains) ?? false`-shaped logic
  (a `guard let tick` and `ticks.contains(tick)`).
- [x] 2.12 `a commitment ticked on a date was kept on that date` — the first `add` and the first
  true `isKept`; expected to run red. Ran red (the `add` `fatalError`); made green with
  `ticks.insert(tick)`.
- [x] 2.13 `a commitment ticked on one date was not kept on another date it is due on` — Pinned
  green.
- [x] 2.14 `a tick of one commitment does not keep another on the same date` — two assertions,
  "Run" not kept and "Gym" kept; pins that the key is the commitment value, not the date alone.
  Pinned green.
- [x] 2.15 `a commitment was not kept on a date it is not due on` — the history *answers* for a
  date that could never hold a tick, rather than refusing; there is no `Tick` to look up, so the
  test asks `isKept` directly with a date the commitment is not due on. Pinned green.
- [x] 2.16 `a history answers each date on its own across a week` — a seven-date sweep with two
  ticks; the regression pin against a history that is right about one date and wrong about a run.
  Pinned green.
- [x] 2.17 `adding a tick the history already holds leaves it unchanged` — asserts equality with a
  history the tick was added to once. Fails an implementation backed by an array. Pinned green
  (the `Set<Tick>` backing already dedupes).
- [x] 2.18 `two histories holding the same ticks are the same history` — added in opposite order;
  pins that order is not part of the value. Pinned green.
- [x] 2.19 `a tick taken back leaves the commitment not kept on that date` — the first `remove`;
  expected to run red. Ran red (the `remove` `fatalError`); made green with `ticks.remove(tick)`.
- [x] 2.20 `taking back a tick leaves the same commitment's ticks on other dates standing` — two
  assertions, 5 September kept and 31 August not. Pinned green.
- [x] 2.21 `taking back a tick leaves another commitment's tick on the same date standing` — two
  assertions, "Run" kept and "Gym" not. Pinned green.
- [x] 2.22 `taking back a tick the history does not hold leaves it unchanged` — equality with the
  history as it stood before, and 5 September still kept. Fails an implementation that records the
  attempt. Pinned green (`Set.remove` of an absent member is a no-op).
- [x] 2.23 `a history ticked and then unticked is the same as one never ticked` — equality with
  `History()`; the scenario that fails any tombstone, counter or flag left behind by `remove`.
  Deliberately last: an implementation that passes 2.19 through 2.22 by marking a tick removed
  rather than removing it fails only here. Pinned green (`Set.remove` leaves no residue).

## 3. Gates

- [x] 3.1 `cd src/DayByDayKit && swift test` reports 87 tests passing and no failures — the
  twenty-three here plus the sixty-four from #8, #9, #10 and #42, none of which may change — and
  `pnpm run verify` exits 0.
- [x] 3.2 `pnpm exec openspec validate add-tick-record --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 23 of 23.
- [ ] 3.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
