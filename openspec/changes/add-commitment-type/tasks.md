## 1. The public surface

- [x] 1.1 Add `Sources/DayByDayKit/Commitment.swift` declaring `public struct Commitment: Hashable,
  Sendable` exactly as `design.md` § *The seam* gives it — `public let name: String`, internal
  `schedule: Schedule` and `keptFrom: CalendarDate`, `public init?(name:schedule:keptFrom:)` and
  `public func isDue(on:) -> Bool`, with both bodies `fatalError("not implemented")`. Nothing else
  public. Verify with `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.2 Confirm nothing else in the package moved: `Schedule.swift`, `CalendarDate.swift`,
  `DayOfMonth.swift`, `DayInterval.swift`, `Weekday.swift` and `Package.swift` are untouched in
  `git diff --stat`, and `cd src/DayByDayKit && swift test` still reports the forty-five tests from
  #8, #9 and #10 passing. `CalendarDate` in particular gains no member: `design.md` measures that the
  floor is answered by the internal `days(until:)` it already has, whose sign is the whole comparison.
- [x] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/19 covered` for this change and names `"a commitment reads back the name it was given"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/commitment/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass
with the smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3).
Put them in a new `Tests/DayByDayKitTests/CommitmentTests.swift` — the three existing test files are
each one schedule shape, and this is not one. Verify each with `cd src/DayByDayKit && swift test`:
the named test green, every earlier test still green.

Expect most of these to pin rather than drive, as on #8, #9 and #10 — the smallest honest change that
turns 2.1 green answers a good deal of the type. **Record which ones actually ran red as you go, in
this file**, the way #9's and #10's `tasks.md` did; a prediction here is not evidence. The ones most
likely to run red on their own are 2.6 and 2.7, if 2.1 was made green without the name guard, and
2.15 through 2.19, if it was made green without the floor.

- [x] 2.1 `a commitment reads back the name it was given` — ran red: `fatalError` in the
  initializer.
- [x] 2.2 `two commitments alike in name, schedule and kept-from day are the same commitment` —
  ran green immediately: synthesised `Hashable`/`Equatable` over the stored properties already
  answers it, so this pins rather than drives.
- [x] 2.3 `two commitments differing only in name are different commitments` — ran green
  immediately (pins synthesised `Equatable`).
- [x] 2.4 `two commitments differing only in schedule are different commitments` — with 2.5, the only
  observable proof that what was handed in is what is kept. Neither can be written by reading the
  property back: both are internal, and the test target imports `DayByDayKit` plainly, without
  `@testable`. Ran green immediately.
- [x] 2.5 `two commitments differing only in the day they are kept from are different commitments`
  — ran green immediately.
- [x] 2.6 `an empty name is not a commitment` — ran red: no blank-name guard existed yet. Made
  green with `guard !name.allSatisfy(\.isWhitespace) else { return nil }`.
- [x] 2.7 `a name of only whitespace is not a commitment` — one test, two assertions: three spaces,
  and a tab followed by a newline. `design.md` measures that
  `guard !name.allSatisfy(\.isWhitespace)` covers 2.6 and this one together; an implementation that
  instead checks `name.isEmpty` passes 2.6 and fails here. Ran green immediately, confirming the
  guard already covers both.
- [x] 2.8 `a name with a space at each end is stored exactly as given` — the scenario that pins *no
  trimming*, which is the owner's answer to question 2. It also asserts the padded name is a
  different commitment from the unpadded one, the observable half of the same decision. Ran green
  immediately — no trimming logic was ever added.
- [x] 2.9 `a name of a single emoji is a commitment` — one grapheme cluster, the shape a length or
  character-class check gets wrong. Ran green immediately.
- [x] 2.10 `a commitment on a weekday-set schedule is due on a listed weekday and not on another`
  — ran red: `fatalError` in `isDue(on:)`. Made green with plain delegation,
  `schedule.isDue(on: date)`, deliberately without the floor yet — 2.15 through 2.19 drive that.
- [x] 2.11 `a commitment on a day-of-month schedule is due on the last day of a month too short for
  its day` — deliberately the short-month clamp rather than a plain hit, so it fails if the
  delegation reimplements the rule instead of asking the schedule. Ran green immediately.
- [x] 2.12 `a commitment on an every-N-days schedule is due on its start date and not on the day
  before it` — deliberately the start-date boundary, for the same reason. Ran green immediately.
- [x] 2.13 `two commitments with different names and the same schedule are due on the same dates` —
  seven dates each, asserting the two answer identically; the name must not reach the rule. Ran
  green immediately.
- [x] 2.14 `a commitment on a schedule that is due on no date is never due` — a commitment that can
  never come due is a legal value and answers, rather than erroring. `schedule` already requires this
  of the empty weekday set; this asserts a commitment does not add a refusal on top of it. Ran green
  immediately.
- [x] 2.15 `a commitment is not due on a date before the day it is kept from` — the floor's plain
  case: the schedule says due, the floor says no, and the floor wins. Ran red: no floor existed.
  Made green with `guard keptFrom.days(until: date) >= 0 else { return false }` ahead of the
  delegation.
- [x] 2.16 `a commitment is due on the day it is kept from when its schedule is due that day` — the
  boundary is inclusive. Ran green immediately: `>= 0` already made it so.
- [x] 2.17 `a commitment is not due on the day it is kept from when its schedule is not due that day`
  — the floor is a floor, not a phase. An implementation that starts the schedule at the kept-from
  day passes 2.15 and 2.16 and fails this. Ran green immediately — the floor-then-delegate
  implementation never touched the schedule's own phase.
- [x] 2.18 `a commitment is due on none of the dates in the month before it is kept from` — a
  thirty-one-date sweep, the regression pin that catches a floor that is right about single dates and
  wrong about a run of them. Ran green immediately.
- [x] 2.19 `an every-N-days occurrence before the day it is kept from is not due` — the two-date
  interaction, and the last scenario deliberately: an implementation that conflates the interval's
  start date with the floor passes everything above and fails here. `design.md` § *Two dates, and why
  neither is the other* has the reasoning; the measured answer is that 28 and 31 August are not due
  and 3 September is. Ran green immediately.

## 3. Gates

- [x] 3.1 `cd src/DayByDayKit && swift test` reports 64 tests passing and no failures — the nineteen
  here plus the forty-five from #8, #9 and #10, none of which may change — and `pnpm run verify`
  exits 0.
- [x] 3.2 `pnpm exec openspec validate add-commitment-type --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 19 of 19.
- [ ] 3.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
