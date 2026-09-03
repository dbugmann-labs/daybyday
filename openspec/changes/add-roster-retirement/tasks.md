## 1. The public surface

- [ ] 1.1 Widen `Sources/DayByDayKit/Roster.swift` to exactly the four members `design.md`
  § *The seam* gives, and no others: `public init()`, `public var commitments: [Commitment]`
  (computed, reading back only what has not been stopped), `public mutating func add(_:) -> Bool`,
  `public mutating func retire(_ commitment: Commitment, keptUntil date: CalendarDate) -> Bool`, and
  `public func commitments(on date: CalendarDate) -> [Commitment]`. The storage becomes a private
  array of a private `Hashable` entry carrying a commitment and a `CalendarDate?`, so the synthesised
  equality sees the order *and* the kept-until days. Give the two new members bodies of
  `fatalError("not implemented")`; leave `add` exactly as it is for now. Do **not** mark either new
  result `@discardableResult` — the discard being visible at every call site is #101's decision and
  it applies to `retire` for the same reason. Nothing existing becomes public: `Commitment.schedule`
  and `Commitment.keptFrom` stay internal, and `CalendarDate` stays as it is. Verify with
  `cd src/DayByDayKit && swift build` exiting 0.
- [ ] 1.2 Confirm the thirteen tests #101 wrote still pass, **unedited**, after 1.1:
  `cd src/DayByDayKit && swift test` reports 205 passing. Those thirteen are restated verbatim by
  this delta's two MODIFIED requirements and are the evidence that this change modifies wording and
  not behaviour. **If one goes red, stop** — that is a behaviour change the delta does not carry, and
  it is a rule-5 stop rather than a test to edit (`design.md` § *Risks*).
- [ ] 1.3 Confirm the starting point before writing a test: `pnpm run checks` reports scenario
  coverage as `13/27 covered` for this change — the thirteen already carried by `RosterTests.swift`
  — and names `"adding a commitment the roster has stopped keeping says it was not added"` as next.
  A different number here means something else moved; report it rather than working around it.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/commitment/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass
with the smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3).
They go at the end of the existing `Tests/DayByDayKitTests/RosterTests.swift`, in the style already
there. The fourteen tasks below are the fourteen scenarios this delta adds; the other thirteen
scenarios in the delta are #101's, already covered, and **no test for them may be rewritten**.

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. **No test in this change asserts that anything is due**, so no weekday is claimed anywhere —
do not add one, and do not substitute a date the delta does not name.

`design.md` expects every one of these to run red on the `fatalError` stubs first, except where a
task says otherwise. **Record which ones actually ran red as you go, in this file** — a prediction
here is not evidence.

- [ ] 2.1 `adding a commitment the roster has stopped keeping says it was not added` — needs `retire`
  to work, so implement `retire`'s happy path here and let 2.2–2.7 pin the rest of it. Three
  assertions: the equal addition is refused, the roster still reads back nothing, and a commitment
  alike but kept from 1 March 2026 *is* added. The third is the half that stops the refusal being
  read as "you may never take this up again".
- [ ] 2.2 `stopping a commitment a roster keeps says so and takes it out of the commitments read
  back` — the report and the empty read-back.
- [ ] 2.3 `stopping one commitment leaves the others where they were` — "Water plants", "Gym",
  "Journaling", stop "Gym"; the other two read back in that order. Fails an implementation that
  removes and re-appends, or that reads back in storage order without filtering.
- [ ] 2.4 `stopping a commitment a roster does not hold says it was not stopped and leaves the roster
  as it was` — the report is false and the roster equals one never asked. The equality assertion is
  the one that catches a stub that records a kept-until day against nothing.
- [ ] 2.5 `stopping a commitment already stopped says it was not stopped and keeps the day first
  given` — stop as of 31 January 2026, stop again as of 28 February 2026; the report is false and the
  roster equals one asked only the first time. Fails any implementation that overwrites the day.
- [ ] 2.6 `a commitment kept until a day before the day it is kept from is accepted` — kept from
  1 March 2026, stopped as of 1 January 2026, reported as stopped. Fails an implementation that
  judges the date against the commitment's own floor, which `design.md` § *A day once given does not
  move* forbids.
- [ ] 2.7 `two rosters differing only in the day one commitment was kept until are different rosters`
  — 31 January against 28 February, different; a third stopped on 31 January, equal to the first.
  Fails an implementation whose equality does not see the kept-until day.
- [ ] 2.8 `stopping a commitment on a copy of a roster leaves the roster it was copied from
  unchanged` — value semantics for the new mutation, the twin of #101's copy scenario for `add`.
- [ ] 2.9 `a roster answers with every commitment it keeps, in the order they were taken on` — the
  first scenario for `commitments(on:)`; two commitments, nothing stopped, order preserved.
- [ ] 2.10 `a stopped commitment is in the answer on the day it was kept until and out of it on the
  next day` — the boundary the whole Story turns on, and the one that changes if question 1 comes
  back the other way. Three dates: 31 January 2026 answers with it, 1 February 2026 and 1 March 2026
  answer with nothing.
- [ ] 2.11 `a stopped commitment keeps its place in the answer for a date it was still kept on` —
  three commitments, the middle one stopped; on the kept-until day the answer is all three in
  order with the stopped one still in the middle, and the day after it is the other two. Fails an
  implementation that appends the stopped ones to the end.
- [ ] 2.12 `stopping a commitment leaves every earlier date answering as it did` — the Story's
  headline promise, asserted as three answers taken before the stop and compared with the same three
  taken after it, including 1 January 1583.
- [ ] 2.13 `a commitment kept from a later date is in the answer for a date before it` — kept from
  1 March 2026, asked about 1 January 2026, in the answer. Fails an implementation that applies the
  commitment's own kept-from floor here, which `design.md` § *The roster subtracts only what it
  knows* forbids: the floor is `Commitment.isDue(on:)`'s and stating it twice is two places to be
  wrong.
- [ ] 2.14 `a roster that holds nothing answers with nothing on every date` — 1 January 1583,
  1 January 2026 and 31 December 9999, an answer each time and a refusal on none.

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 219 tests passing and no failures — the fourteen
  here plus the 205 measured at `ab7ef41`, none of which may change — and `pnpm run verify` exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-roster-retirement --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 27 of 27.
- [ ] 3.3 `git diff --stat` names only `Roster.swift` and `RosterTests.swift` under `src/`. The app
  shell is not touched by this Story: `ContentView.swift` still hands `DayScreen` its
  `dayOneCommitments` array, and wiring a roster into a screen is #104's and a second capability's
  delta (rule 5).
- [ ] 3.4 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**). This
  box records the reviewer's report; it is not an instruction to the implementer to review its own
  work. `AGENTS.md`'s routing table gives G7 to a separate agent that may write nothing, and
  `docs/open-questions.md` § *Known gaps* records that the template's wording has already been read
  the other way once. Tick it after that agent has reported.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
