## 1. The public surface

- [ ] 1.1 Add `Sources/DayByDayKit/Commitment.swift` declaring `public struct Commitment: Hashable,
  Sendable` exactly as `design.md` § *The seam* gives it — `public let name: String`, an internal
  `schedule: Schedule`, `public init?(name:schedule:)` and `public func isDue(on:) -> Bool`, with
  both bodies `fatalError("not implemented")`. Nothing else public. Verify with
  `cd src/DayByDayKit && swift build` exiting 0.
- [ ] 1.2 Confirm nothing else in the package moved: `Schedule.swift`, `CalendarDate.swift`,
  `DayOfMonth.swift`, `DayInterval.swift`, `Weekday.swift` and `Package.swift` are untouched in
  `git diff --stat`, and `cd src/DayByDayKit && swift test` still reports the forty-five tests from
  #8, #9 and #10 passing.
- [ ] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/13 covered` for this change and names `"a commitment reads back the name it was given"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/commitment/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass
with the smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3).
Put them in a new `Tests/DayByDayKitTests/CommitmentTests.swift` — the three existing test files are
each one schedule shape, and this is not one. Verify each with `cd src/DayByDayKit && swift test`:
the named test green, every earlier test still green.

Expect most of these to pin rather than drive, as on #8, #9 and #10 — the smallest honest change that
turns 2.1 green answers a good deal of the type. **Record which ones actually ran red as you go, in
this file**, the way #9's and #10's `tasks.md` did; a prediction here is not evidence. The two most
likely to run red on their own are 2.5 and 2.6, if 2.1 was made green without the guard, and 2.10 and
2.11, if the delegation was written per-shape instead of once.

- [ ] 2.1 `a commitment reads back the name it was given`
- [ ] 2.2 `two commitments with the same name and the same schedule are the same commitment`
- [ ] 2.3 `two commitments differing only in name are different commitments`
- [ ] 2.4 `two commitments differing only in schedule are different commitments` — the only
  observable proof that the schedule handed in is the schedule kept, short of the delegation
  scenarios. It cannot be written by reading `schedule` back: that property is internal, and the test
  target imports `DayByDayKit` plainly, without `@testable`.
- [ ] 2.5 `an empty name is not a commitment`
- [ ] 2.6 `a name of only whitespace is not a commitment` — one test, two assertions: three spaces,
  and a tab followed by a newline. `design.md` measures that
  `guard !name.allSatisfy(\.isWhitespace)` covers 2.5 and this one together; an implementation that
  instead checks `name.isEmpty` passes 2.5 and fails here.
- [ ] 2.7 `a name with a space at each end is kept as given` — the scenario that pins *no trimming*.
  It also asserts the padded name is a different commitment from the unpadded one, which is the
  observable half of the same decision.
- [ ] 2.8 `a name of a single emoji is a commitment` — one grapheme cluster, the shape a length or
  character-class check gets wrong.
- [ ] 2.9 `a commitment on a weekday-set schedule is due on a listed weekday and not on another`
- [ ] 2.10 `a commitment on a day-of-month schedule is due on the last day of a month too short for
  its day` — deliberately the short-month clamp rather than a plain hit, so it fails if the
  delegation reimplements the rule instead of asking the schedule.
- [ ] 2.11 `a commitment on an every-N-days schedule is due on its start date and not on the day
  before it` — deliberately the start-date boundary, for the same reason.
- [ ] 2.12 `two commitments with different names and the same schedule are due on the same dates` —
  seven dates each, asserting the two answer identically; the name must not reach the rule.
- [ ] 2.13 `a commitment on a schedule that is due on no date is never due` — a commitment that can
  never come due is a legal value and answers, rather than erroring. `schedule` already requires this
  of the empty weekday set; this asserts a commitment does not add a refusal on top of it.

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 58 tests passing and no failures — the thirteen
  here plus the forty-five from #8, #9 and #10, none of which may change — and `pnpm run verify`
  exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-commitment-type --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 13 of 13.
- [ ] 3.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
