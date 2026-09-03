## 1. The public surface

- [x] 1.1 Add `Sources/DayByDayKit/Roster.swift` with exactly the three members `design.md`
  § *The seam* gives: `public struct Roster: Hashable, Sendable` with `public init()`,
  `public private(set) var commitments: [Commitment]`, and
  `public mutating func add(_ commitment: Commitment) -> Bool` whose body is
  `fatalError("not implemented")`. Do **not** mark the result `@discardableResult` — the discard
  being visible at every call site is the decision, not an oversight. No other file in the package
  is touched, and nothing existing becomes public: `Commitment.schedule` and `Commitment.keptFrom`
  stay internal, and the roster compares whole commitments through the synthesised `Hashable`.
  Verify with `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.2 Confirm nothing else moved: `git diff --stat` names only `Roster.swift` (and, from 2.x
  onwards, `RosterTests.swift`), and `cd src/DayByDayKit && swift test` still reports the 192 tests
  from #8, #9, #10, #11, #42, #55, #56, #70, #71, #72 and #91 passing. This delta is ADDED
  throughout and is expected to change **no** existing test; if one goes red, stop — that is a
  MODIFIED requirement this delta does not carry, and it is a rule-5 stop rather than a test to
  edit.
- [x] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/13 covered` for this change and names `"a roster that has been given no commitment holds
  none"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/commitment/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it
pass with the smallest change that does. Never write two before the first is green (`AGENTS.md`
rule 3). They go in a new `Tests/DayByDayKitTests/RosterTests.swift` — a new seam, so a new file,
as `CommitmentTests.swift` and `DayViewTests.swift` each were.

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. **No test in this change asserts that anything is due**, so no weekday is claimed anywhere —
do not add one, and do not substitute a date the delta does not name.

`design.md` expects these to run red on their own: 2.1 (the `fatalError`), 2.2 (if the commitments
were held in anything but insertion order), 2.5 (if equality did not see the order), 2.6 (if the
roster were made a reference type), 2.9 (if the duplicate were accepted), 2.10 (if a refused
addition moved the one already held), and 2.11–2.13 (if sameness were coarser than the commitment's
own). **Record which ones actually ran red as you go, in this file** — a prediction here is not
evidence.

- [x] 2.1 `a roster that has been given no commitment holds none` — an empty roster reads back no
  commitments. Runs red against the seam only if the initialiser is wrong; expect it green once
  `commitments` starts empty, and say so rather than claiming a red that did not happen. Ran
  **green** on first run, as predicted — `init()` already sets `commitments = []`.
- [x] 2.2 `a roster reads its commitments back in the order they were added` — "Water plants",
  "Gym", "Journaling", added in that order and read back in it, deliberately not alphabetical order.
  Runs red against the `fatalError` in `add`. Ran **red** as predicted — `not implemented` fatal
  error — then green once `add` appended to `commitments` and returned `true`.
- [x] 2.3 `a roster does not order its commitments by the day they are kept from` — "Gym" kept from
  1 March 2026 added before "Run" kept from 1 January 2026; "Gym" still first. Fails any
  implementation that sorts by `keptFrom`. Ran **green** — insertion order was already the
  implementation from 2.2.
- [x] 2.4 `two rosters holding the same commitments in the same order are the same roster` — two
  rosters built the same way, compared equal. Ran **green** — synthesised `Hashable` over an
  array already gives this.
- [x] 2.5 `two rosters holding the same commitments in a different order are different rosters` —
  the same two commitments each way round, compared unequal. Fails any implementation that stores
  the commitments in a `Set` or sorts them before comparing. Ran **green** — the array-backed
  storage from 2.2 never had a chance to fail this; it was never a `Set` and nothing sorts it.
- [x] 2.6 `adding to a copy of a roster leaves the roster it was copied from unchanged` — three
  assertions: the copy holds two, the original still holds one, and the two are not equal. Fails a
  reference type. Ran **green** — `Roster` is already a `struct`, so copy-on-write value
  semantics apply for free.
- [x] 2.7 `a roster holds a commitment kept from the last supported date like any other` — kept from
  31 December 9999, added before one kept from 1 January 2026, both held in that order with their
  days unchanged. Fails an implementation that filtered or ordered on a date. Ran **green** —
  `add` consults no date.

- [x] 2.8 `adding a commitment a roster does not hold places it after the ones already there and
  says it was added` — two assertions, the report and the resulting order. Ran **green** —
  `add`'s current body already appends and returns `true` unconditionally.
- [x] 2.9 `adding a commitment a roster already holds says it was not added and leaves the roster as
  it was` — three assertions: the report is false, one commitment is held, and the roster equals one
  given that commitment once. The scenario the whole Story exists for. Ran **red** as predicted —
  the duplicate was accepted — then green once `add` guarded on `commitments.contains(commitment)`.
- [x] 2.10 `a refused commitment does not move the one already held` — "Gym", "Run", "Journaling",
  then "Gym" again; the order is unchanged and "Gym" is still first. Fails an implementation that
  removed and re-appended. Ran **green** — the guard-then-append implementation from 2.9 never
  removes anything.
- [x] 2.11 `two commitments alike in name but on different schedules are both held` — Mon/Wed/Sat
  against Tue/Thu, both named "Gym", both held. Ran **green** — `Commitment`'s synthesised
  equality already includes `schedule`.
- [x] 2.12 `two commitments alike in name and schedule but kept from different days are both held` —
  1 January 2026 against 2 January 2026, both held. Ran **green** — `Commitment`'s synthesised
  equality already includes `keptFrom`.
- [x] 2.13 `two names differing only by a space at the end are different commitments and both are
  held` — "Gym" and "Gym ", both held and each reading its own name back. Fails any implementation
  that trims or folds a name; `openspec/specs/commitment/spec.md` forbids doing either. Ran
  **green** — `Roster` normalises nothing, and `Commitment.name` is already stored exactly as
  given.

## 3. Gates

- [x] 3.1 `cd src/DayByDayKit && swift test` reports 205 tests passing and no failures — the
  thirteen here plus the 192 from #8, #9, #10, #11, #42, #55, #56, #70, #71, #72 and #91, none of
  which may change — and `pnpm run verify` exits 0.
- [x] 3.2 `pnpm exec openspec validate add-commitment-roster --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 13 of 13.
- [x] 3.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**). This
  box records the reviewer's report; it is not an instruction to the implementer to review its own
  work. `AGENTS.md`'s routing table gives G7 to a separate agent that may write nothing, and
  `docs/open-questions.md` § *Known gaps* records that the template's wording has already been read
  the other way once. Tick it after that agent has reported.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
