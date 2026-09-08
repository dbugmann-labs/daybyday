Every scenario task below takes exactly one `#### Scenario:` from this change's delta and writes
**one** acceptance test whose `@Test("...")` display name is that scenario title **verbatim**, then
makes it pass with the smallest change that does. Never write two before the first is green
(`AGENTS.md` rule 3). Verify each with `cd src/DayByDayKit && swift test`: the named test green,
every earlier test still green.

## 1. The baseline, and the two mechanical edits

This section changes no behaviour and adds no test. It pins the starting point, moves the six sites
that say `5` to mean *a form later than the record store writes*, and labels the parameter list
`docs/open-questions.md` recorded against this Story.

- [x] 1.1 Confirm the branch point before touching anything: from `src/DayByDayKit`, `swift test`
  reports **705 tests passing**. Measured on this machine on 2026-09-08, Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`. A different number means `main` moved under
  the branch; report it rather than working around it (`AGENTS.md` rule 5).
- [x] 1.2 Edit the six sites that say `5` to mean *a form one later than the record store writes* so
  they say `6`, and leave every other `4` and `5` in the tests exactly as it is. Five JSON fixtures
  move — `DayScreenTests.swift:370`, `:454`, `:585`, `:2471` and `RecordStoreTests.swift:295` — and
  one assertion, `RecordStoreTests.swift:298`, whose `laterForm(at:version: 5)` becomes `version: 6`.
  **No `@Test` display name, no other assertion, no date and no commitment may change**, and no test
  may be added or removed here. Four sites at `4` are the *roster* store's own and do **not** move:
  `RosterStoreTests.swift:323` and `:326`, and `DayScreenTests.swift:1673` and `:1831` stay at `4`,
  because `RosterDocument.currentVersion` is `3` and this change does not move it.
  `CommitmentsScreenTests.swift:1129` stays at `5`: its scenario says only "later than this app
  writes", and `5` is later than the roster's `3` exactly as it was. The **form-4 record fixtures**
  at `RecordStoreTests.swift:619`, `:1001`, `:1026`, `:1051` and `:1236` also stay: after this change
  form 4 is an earlier form carrying numbers and notes and no additions, which is exactly what those
  fixtures are, and each still answers as its scenario says. `swift test` still reports **705
  passing** after this box — a red test is a rule-5 stop, because nothing in this box was supposed to
  change an answer.
- [x] 1.3 Label the two parameter lists `docs/open-questions.md` recorded against this Story:
  `RecordStore.write(_:_:_:)` becomes `write(ticks:numbers:notes:)` and `RecordDocument.init(_:_:_:)`
  becomes `init(ticks:numbers:notes:)`, at every call site including
  `RecordDocumentTests.swift:52`'s bare `RecordDocument([], numbers, [:])`. Do it **before** the
  fourth parameter is added, so the diff that adds `additions:` is one word rather than a rewrite. No
  behaviour changes and no `@Test` display name changes; `swift test` still reports 705 passing.
  `design.md` § *`RecordStore.write` and `RecordDocument.init` take labels* is the decision.
- [x] 1.4 Confirm the coverage tool agrees before writing a test: from the repo root, `pnpm run
  checks` reports `scenario coverage — 146/248 scenario(s) covered` for this change, and names *a row
  offers the total entry for its commitment on the date the day view is of* as next. Measured on
  2026-09-08. A different number means something else moved; report it rather than working around it.
  The scenario it names as *next* is a `day-screen` one, because the checker walks the delta's spec
  files in alphabetical order; the task order below is `record` first, because a row cannot offer an
  entry for a record that does not exist. That mismatch is expected and is not a finding.

## 2. `Addition` and `Digits`, before anything holds one

- [ ] 2.1 Add `Sources/DayByDayKit/Addition.swift` declaring exactly what `design.md` § *The seam*
  gives: `public struct Addition: Hashable, Sendable` with internal `commitment`, `date` and
  `amount`, and `public init?(_ amount: Decimal, for commitment: Commitment, on date: CalendarDate)`.
  **The initializer is a bodied `fatalError("not implemented")`**, so § 3.1 is red on its first
  assertion rather than accidentally green. `RecordedDay` already exists in `Number.swift` and is not
  moved or copied. Nothing else is public. `cd src/DayByDayKit && swift build` exits 0 and
  `swift test` still reports 705 passing.
- [ ] 2.2 Add `Sources/DayByDayKit/Digits.swift` declaring the internal `enum Digits` from
  `design.md` § *The seam* — `significant(in:)` and `canAdd(_:to:)` — both as bodied
  `fatalError("not implemented")`. Nothing calls them until § 11. They are declared here so that the
  package has **one** place that decides how many significant digits a decimal holds, in the way
  `Blank` is the one place that decides what says nothing; § 15.2 is the box that proves it right.
  `swift build` exits 0 and `swift test` still reports 705 passing.

## 3. `record` — what an addition is

Seven scenarios from `specs/record/spec.md` § *An addition is of a total commitment on a calendar
date it is due on*, all in `Tests/DayByDayKitTests/RecordTests.swift`.

`design.md` expects 3.1 (the first call into the `fatalError`) to run red on its own. #140's § 3.4
predicted a second red and did not get one, because the whole guard was written in a single pass from
the shape the earlier kinds already had. Expect the same here. **Record which boxes actually ran red
as you go, in § 17**; a prediction is not evidence.

- [ ] 3.1 `an addition is recorded for a total commitment on a date it is due on`
- [ ] 3.2 `a total commitment takes no addition on a date it is not due on` — all three clauses: not
  due, before the day it is kept from, and a schedule due on no date across seven days.
- [ ] 3.3 `a commitment whose kind is not a total takes no addition on a date it is due on` — the
  tick kind, both number kinds and the note kind, plus the total-kind control that must still record.
- [ ] 3.4 `an amount that is not above zero is not an addition` — zero, a plainly negative amount, a
  negative amount too small to see, and the smallest positive control. This is the guard that has no
  counterpart in `Number` or `Note`.
- [ ] 3.5 `a value that is not a number is not an addition` — refused where the record is formed and
  never left to the comparison with zero, which answers *false* in both directions.
- [ ] 3.6 `an addition takes any amount above zero, at either end of what this system holds` — four
  amounts read back exactly, plus the clause that an amount past the target is still an addition.
  `record` has no ceiling of its own; § 11 is where the day's does.
- [ ] 3.7 `two additions are the same exactly when their commitment, date and amount all are` — all
  four clauses. Two additions of 30 on one day being the *same addition* is what § 4.3 then has to
  hold a day of 60 against, so write this one before that one.

## 4. `record` — what a history holds and answers about a day's additions

Ten scenarios from § *A history answers what a commitment has added on a day from the additions it
holds*, in `Tests/DayByDayKitTests/RecordTests.swift`. `History` gains
`private var additions: [RecordedDay: [Decimal]]`, `add(_ addition: Addition)` and
`total(for:on:)` per `design.md` § *The seam*. The list, rather than a value, is what makes 4.3 and
4.9 pass; a `Set` fails both, and a dictionary of `Decimal` fails 4.3.

- [ ] 4.1 `a history that has taken no addition answers a total of zero for a commitment on a day` —
  both clauses, including that it answers **zero rather than nothing**. A reader typed `Decimal?`
  fails the second clause and is the shape this box exists to refuse.
- [ ] 4.2 `an addition added to a history is the total that commitment has on that day`
- [ ] 4.3 `additions made on one day accumulate rather than replace one another` — three additions,
  two of them alike, and the day is 105.5 rather than 75.5. The box that fails a `Set` and a
  replacing map alike.
- [ ] 4.4 `the additions of one day are not counted in another day's total`
- [ ] 4.5 `the additions of one commitment are not counted in another's total on the same date`
- [ ] 4.6 `a history answers a total of zero for a commitment whose kind is not a total` — answered
  rather than refused, for all three other kinds and for a date the commitment is not due on.
- [ ] 4.7 `an amount the system refuses leaves the day's additions standing`
- [ ] 4.8 `two histories holding the same additions in the same order are the same history`
- [ ] 4.9 `two histories holding one day's additions in different orders are different histories` —
  the box that pins order as part of what a history *is*. An implementation sorting the day's amounts,
  or holding them in a multiset, passes 4.3 and fails this.
- [ ] 4.10 `a history holds ticks, numbers, notes and additions side by side and answers each on its
  own` — the box that drives out `isKept`'s third and last widening, exactly as #138's and #140's did
  theirs. `isKept` reads `total(for:on:) >= target` for a total commitment, **in that order**
  (`design.md` § *`kept` stops being "is there a record"*).

## 5. `record` — taking the last addition back

Seven scenarios from § *The last addition a day holds can be taken back*, in
`Tests/DayByDayKitTests/RecordTests.swift`. `History.removeLastAddition(for:on:)` is the fourth
take-back and the first that removes one thing rather than the record — ADR-1033 as amended by this
change, and § 16.2.

- [ ] 5.1 `the last addition taken back leaves the day short by exactly that amount`
- [ ] 5.2 `taking back the last addition twice removes the two most recent, in the order they were
  made` — both clauses, including that the history then equals one the first addition alone was added
  to. An implementation removing the *smallest* or the *first* passes 5.1 and fails this.
- [ ] 5.3 `taking back the only addition a day holds leaves the day holding none` — including that the
  history is then the same as one that has taken no record. A day left holding an empty list rather
  than no entry at all fails the last clause, and that is the point: it is also what would let § 7.1
  write an empty day to disk.
- [ ] 5.4 `taking back the last addition leaves the same commitment's other days standing`
- [ ] 5.5 `taking back the last addition leaves another commitment's day standing`
- [ ] 5.6 `taking back where the day holds no addition leaves the history unchanged` — three cases: a
  day with nothing on it, a commitment of the wrong kind, and a date it is not due on. None is an
  error.
- [ ] 5.7 `a history given additions and taken back one by one is the same as one never given any` —
  including the fourth take-back, which must change nothing.

## 6. `record` — what the four existing answers say now

Seven scenarios across four MODIFIED requirements, plus one confirmation, in
`Tests/DayByDayKitTests/RecordTests.swift`.
Expect 6.2 to be already satisfied by § 4.10's widening. A red test at 6.1, 6.7 or 6.8 is a real
finding, not a licence to edit further: `Tick.swift`, `Number.swift` and `Note.swift` already refuse
a total-kind commitment, and these boxes pin that they stay refused now that such a commitment can be
kept.

- [ ] 6.1 `a total commitment whose day is at its target still takes no tick on it` — from § *A tick
  is of a commitment on a calendar date it is due on*. `Tick.swift` is **not** edited.
- [ ] 6.2 `a total commitment whose day's additions reach its target was kept on that date` — the
  requirement #137 shipped that this Story reverses, for the last kind.
- [ ] 6.3 `a total commitment whose day's additions fall short of its target was not kept on it` —
  all three clauses, the third of which crosses the target by 0.01 and must flip the answer.
- [ ] 6.4 `additions past the target keep the day and change nothing else about it` — kept, **and**
  the day answers 150 rather than 120. An implementation clamping the sum at the target passes the
  first clause and fails the second.
- [ ] 6.5 `a total commitment is kept on one day and not on another from each day's own additions`
- [ ] 6.6 *(not a new test)* Confirm the archived scenario `a commitment of the note kind and one of
  the total kind were not kept on a date they are due on` is still green and its body unchanged: its
  total clause asks a history holding no addition, which is still *not kept*. If it is red, the kept
  rule reads the wrong way round; that is a rule-5 stop, not a test to update.
- [ ] 6.7 `a total commitment with additions on a date still takes no number on it` — from § *A
  number is of a number commitment on a calendar date it is due on*. `Number.swift` is **not** edited.
- [ ] 6.8 `a total commitment with additions on a date still takes no note on it` — from § *A note is
  of a note commitment on a calendar date it is due on*. `Note.swift` is **not** edited.

## 7. The form on disk

Twelve scenarios across the three MODIFIED store requirements, all in
`Tests/DayByDayKitTests/RecordStoreTests.swift`. Do 7.1 first as one mechanical step and verify the
suite before writing a test; then one scenario at a time as above.

- [ ] 7.1 In `Sources/DayByDayKit/RecordDocument.swift`, add `AdditionsRecord` — `commitment`,
  `date` and `amounts: [Decimal]` — conforming to `DatedCommitmentRecord` so it sorts on the same
  five-part key with **no sixth key**, because one record per commitment-day cannot tie
  (`design.md` § *A day's additions are a list*); give `RecordDocument` an `additions` field, move
  `currentVersion` from `4` to `5`, and add `additionsIntroducedInVersion = 5` beside its two
  siblings. `formAdditions()` re-forms **every amount on its own** through `Addition.init?` and
  returns `nil` if any one fails or if any day's `amounts` is empty. In
  `Sources/DayByDayKit/RecordStore.swift`, mirror the additions the store keeps beside the ticks, the
  numbers and the notes; add the two writes; extend the version guard to `1...5` and the
  shape-against-form guard to a third clause of the same shape; and add `additions:` to the two
  labelled parameter lists § 1.3 created. **`CommitmentCoding.swift` is not edited** — the roster
  store shares it and does not move. `swift test` reports no new failures after this box beyond
  whatever §§ 3–6 added; a red test among the ones already passing is a rule-5 stop.
- [ ] 7.2 `an addition made in a store is held by a second store opened at the same place while the
  first is still open`
- [ ] 7.3 `a day's additions are read back in the order they were made` — including the last clause,
  which takes the last addition back **on the reopened store** and so proves the order survived the
  file rather than only the process. A document sorting a day's amounts passes the sum clause and
  fails this one.
- [ ] 7.4 `a day's last addition taken back is not held by a store opened afterwards at the same
  place` — including that taking the last one back leaves a store that reads as one that has taken no
  record. A day left as an empty array on disk fails that clause and is what § 7.9's fixture then
  refuses.
- [ ] 7.5 `two additions alike in every way on one day are both read back`
- [ ] 7.6 `an amount is read back exactly as it was given, whatever its digits`
- [ ] 7.7 `a store opened again holds exactly the ticks, numbers, notes and additions added and not
  taken back`
- [ ] 7.8 `an addition that cannot be kept is refused and not held` — the unwritable place, and the
  store's history left as it was.
- [ ] 7.9 `a store holding what could not be an addition is refused` — a hand-written form-5 fixture,
  five ways: zero, a negative amount, the wrong kind, a date it is not due on, and a day carrying an
  empty list of amounts. All five come from `formAdditions()` returning `nil`, so expect this green
  once 7.1 is in; a red test is a finding.
- [ ] 7.10 `a store holding a day whose additions sum past what can be kept exactly is read rather
  than refused` — the box that pins `design.md` § *Where the sum cap lives*. A form-5 fixture holding
  a whole number of thirty-eight nines and then 0.5 on one day: each amount is an addition on its own,
  their exact sum is not one this app could have written, and the store **opens**. An implementation
  that checks the day's sum on read fails this, and that failure is the whole reason the box exists.
- [ ] 7.11 `a history kept before a day could hold an addition is read, and no day in it holds one` —
  a form-4 fixture. Expect green once 7.1 is in: the version guard reads `1...5`.
- [ ] 7.12 `an addition made over a history kept before a day could hold an addition is read back
  beside the records already there` — a form-4 fixture written over, then reopened at form 5.
- [ ] 7.13 `a store whose shape and declared form disagree about additions is refused` — both
  directions, plus the third clause that is the real point: a **form-3** fixture holding neither notes
  nor additions must still be read without error. That clause is what fails a guard written against
  `currentVersion` instead of against each field's own introduced-at constant.

## 8. `day-screen` — what a row offers

Seven scenarios from `specs/day-screen/spec.md` § *A row offers the total entry its commitment takes,
and offers none for a day that has not arrived*, in `Tests/DayByDayKitTests/DayViewTests.swift`, plus
two edits to existing tests. `DayView.Row` gains the internal `total` and the public
`totalEntry(asOf:)`, per `design.md` § *The seam*.

- [x] 8.1 `a row offers the total entry for its commitment on the date the day view is of`
- [x] 8.2 `a row for a commitment whose kind is not a total offers no total entry`
- [x] 8.3 `a row offers a tick, a number entry, a note entry or a total entry and never two of them`
- [x] 8.4 `a row for a date later than the day it is asked as of offers no total entry`
- [x] 8.5 `a row for a date later than the day it is asked as of offers no total entry even where the
  day holds additions`
- [x] 8.6 `a row for a date earlier than the day it is asked as of offers the total entry`
- [x] 8.7 `a row offers the total entry whether or not the day is already kept`
- [x] 8.8 **Not a new test.** The existing test named `a row offers a tick or a number entry and never
  both` gains the one clause the delta added to that scenario: a row for a commitment of the total
  kind offers neither of them either. Its `@Test` display name does not change, and no other
  assertion in it changes.
- [x] 8.9 **Not a new test.** The existing test named `a row offers a tick, a number entry or a note
  entry and never two of them` gains the one clause the delta added: a row for a commitment of the
  total kind offers none of those three. Its `@Test` display name does not change.

  8.8 and 8.9 exist because both scenarios are already *covered* by
  `scripts/check-scenario-coverage.ts` — the checker maps title to test and cannot see that the body
  moved — so nothing but these boxes would make the added clauses get written.

## 9. `day-screen` — what a row is

Three scenarios from the MODIFIED § *A row is a commitment's line on a date*, in
`Tests/DayByDayKitTests/DayViewTests.swift`. Expect 9.1 and 9.2 green once § 8's stored `total` is in,
since `Row` is `Hashable` with synthesized conformance.

- [ ] 9.1 `two rows for the same total commitment and date whose days have added different amounts are
  different rows`
- [ ] 9.2 `two rows for the same total commitment and date whose days have added the same amount are
  the same row`
- [ ] 9.3 `two rows whose days hold different additions summing alike are the same row` — the box that
  pins `design.md` § *The entry says the words*: a row holds the **sum** and never the list, so [30,
  30] and [60] give one row. A `Row` that stored the additions to tell them apart fails this, and that
  failure is the point.

## 10. `day-screen` — what a total entry says, and the take-back a row offers

Nine scenarios across two ADDED requirements, in `Tests/DayByDayKitTests/DayViewTests.swift`.
`DayView.TotalEntry` carries one member, `soFarOfTarget`, composed inside the kit — `design.md`
§ *The entry says the words*. Do not add a `Decimal` for a field to bind to; § 12.2 is what a
prefilled field would break, and there is no way to write it if the value is not there.

- [x] 10.1 `a total entry says the day's sum and the commitment's target` — both clauses, the second
  with a fractional target, so `"0.5"` is pinned rather than `"0.500000"`.
- [x] 10.2 `a total entry of a day holding no addition says a sum of zero` — "0 of 120" from an empty
  history and from one taken back to empty.
- [x] 10.3 `a total entry says the true sum once it has passed the target` — "150 of 120", never "120
  of 120".
- [x] 10.4 `a row for a total commitment says its name, its rhythm and whether the day is kept, and
  never its sum`
- [x] 10.5 `a row whose day holds an addition offers taking the last one back` — `Row` gains
  `offersTakeBackLast(asOf:)`, read off the day's sum being above zero and never off a count.
- [x] 10.6 `a row whose day holds no addition offers no take-back`
- [x] 10.7 `a row for a commitment whose kind is not a total offers no take-back` — all three other
  kinds, each with a record on the day, so a row that read *kept* rather than *sum* fails it.
- [x] 10.8 `a row for a date later than the day it is asked as of offers no take-back`
- [x] 10.9 `a row goes on offering the take-back while the day still holds an addition`

## 11. `day-screen` — the sum cap, at the row

Five scenarios and the one piece of arithmetic this change invents, in
`Tests/DayByDayKitTests/DayViewTests.swift` and `Tests/DayByDayKitTests/DayScreenTests.swift`.
`DayView.TotalRecord` and `Row.totalRecord(_:asOf:)` arrive here, and `Digits` gets its body.

**Read `design.md` § *Measured, not recalled* before writing a line of `Digits`.** Measurement A is
the trap: the significant digits of the sum `Decimal` *hands back* are not the significant digits of
the sum, and a rule read off the first accepts exactly the case it exists to refuse.

- [x] 11.1 Give `Digits` its body and `Row` its `totalRecord(_:asOf:)`, on the shape `design.md`
  § *The seam* gives: `nil` when the row offers no total entry, `.notAboveZero` when `Addition.init?`
  refuses the amount, `.tooLargeToAdd` when `Digits.canAdd(_:to:)` says the day cannot take it, and
  `.addition` otherwise. No test is written in this box; §§ 11.2–11.5 and 13 are what prove it. It is
  its own box because the three answers must exist before any of them can be told apart.
- [ ] 11.2 `an amount that would take the day's sum past what can be kept exactly is refused and told
  on the row` — a day at thirty-eight nines refusing 0.5, and the day's additions standing. **Expect
  red on any predicate that reads the digits off `soFar + amount` alone**, which is measurement A row
  two.
- [ ] 11.3 `an amount that takes the day's sum to a number that can be kept exactly is added` — the
  same day taking 1, which sums to 1 followed by thirty-eight zeros: one significant digit, held
  exactly. **Expect red on any predicate written on magnitude rather than on significant digits.**
  Together with 11.2 these two are the whole rule, and neither alone pins it.
- [ ] 11.4 `an amount of zero or below is refused and told on the row` — three amounts, each leaving
  the day's additions standing, and the cause "Must be more than 0", word for word.
- [ ] 11.5 `an amount that is not above zero is told on the row, saying so` — from the MODIFIED
  § *A day screen tells on the row that was tapped that a change could not be kept*: the cause is
  told on the row committed on last and on no other, which is what 11.4 does not pin.
- [ ] 11.6 `an amount too large to add to the day is told on the row, saying so` — the cause "Too
  large to add", word for word, and that it is neither of the other two.

## 12. `day-screen` — adding, and reading what was committed

Eighteen scenarios across § *A day screen adds what is committed in a row's total entry* and § *A day
screen reads what is committed in a total entry*, in `Tests/DayByDayKitTests/DayScreenTests.swift`.
`DayScreen.enter(_:on:)` gains a **fourth branch** — `design.md` § *`enter(_:on:)` gains a fourth
branch* — and the number and note branches are not touched. `DayScreen.read(_:)` is **shared, not
copied**: a second reading here would make "Not a number" two causes instead of one, which § 13.3 is
what catches.

- [x] 12.1 `adding on a total row makes the day screen say what the day has added`
- [x] 12.2 `a day's additions accumulate rather than replace one another` — "30" twice leaves 60.
  The single most important box in this section: an implementation copying the number branch replaces
  and leaves 30.
- [x] 12.3 `reaching the target makes the day screen say the commitment is kept`
- [x] 12.4 `an addition past the target keeps the day and says the true sum`
- [x] 12.5 `an addition entered on a day screen is held by a day screen opened afterwards at the same
  place`
- [x] 12.6 `an addition that cannot be kept is refused and leaves the day view as it was`
- [x] 12.7 `committing nothing at all in a total entry keeps nothing and takes nothing back` — empty,
  two spaces and three line breaks, none of which may remove the last addition. The box that fails an
  implementation reusing the note branch's `Blank.saysNothing` → take-back shape.
- [x] 12.8 `adding on a row the day screen's day view does not hold changes nothing`
- [x] 12.9 `committing on a row that offers no total entry changes nothing`
- [x] 12.10 `a commit is read as the entry the row it was made on offers, for all four kinds` — "120"
  on each of the four rows in turn: nothing, the number 120, the note "120", and "120 of 120". A
  screen that read the text before asking the row fails it.
- [x] 12.11 `adding on a day screen that is not keeping a record changes nothing and keeps nothing`
- [x] 12.12 `adding on one row leaves the other rows of the day as they were`
- [x] 12.13 `adding on a day a day screen has moved back to keeps it on that day`
- [x] 12.14 `adding writes nothing to the roster's place`
- [ ] 12.15 `an amount committed with space around it is added`
- [ ] 12.16 `an amount typed with a comma is added as the same amount as one typed with a full stop` —
  both clauses. This is the box that proves `read(_:)` is shared rather than reimplemented.
- [ ] 12.17 `a value that is not a number committed in a total entry is refused and told on the row` —
  six texts including a lone zero-width space, which `Blank` does not call blank and `read(_:)` calls
  not a number.
- [ ] 12.18 `a commit saying nothing in a total entry changes nothing and tells nothing` — including
  that it leaves a standing notice standing, which is the fifth case of *A day screen tells nothing on
  a row where there was no tick to refuse*.

## 13. `day-screen` — taking back on a row, and what is told

Seventeen scenarios across § *A day screen takes back the last addition a row offers* and three
MODIFIED requirements, plus one rewrite, in `Tests/DayByDayKitTests/DayScreenTests.swift`.
`DayScreen.takeBackLast(on:)` arrives here, and `RecordStore.removeLastAddition(on:)` joins its two
private twins at the foot of `DayScreen.swift`.

- [ ] 13.1 `taking back the last addition on a row leaves the day short by exactly that amount`
- [ ] 13.2 `taking back the last addition twice removes the two most recent`
- [ ] 13.3 `a take-back is held by a day screen opened afterwards at the same place`
- [ ] 13.4 `a take-back that cannot be kept is refused and leaves the day view as it was` — refused
  with an error **and** told on the row naming no cause. The place's refusal never names a cause,
  whichever act asked.
- [ ] 13.5 `taking back on a row that offers no take-back changes nothing`
- [ ] 13.6 `taking back on a row for a day that has not arrived changes nothing`
- [ ] 13.7 `taking back on a row the day screen's day view does not hold changes nothing`
- [ ] 13.8 `taking back on a day screen that is not keeping a record changes nothing and keeps
  nothing`
- [ ] 13.9 `taking back writes nothing to the roster's place`
- [ ] 13.10 `a value that is not a number committed in a total entry is told the same thing a number
  entry tells` — word for word on both rows. The box that would fail a second reading with its own
  wording.
- [ ] 13.11 `an addition refused by the place is told on the row and names no cause`
- [ ] 13.12 `what a day screen tells on a row ends when an addition is made and kept`
- [ ] 13.13 `what a day screen tells on a row ends when a last addition is taken back and kept`
- [ ] 13.14 `a commit saying nothing in a total entry leaves what a day screen is telling standing`
- [ ] 13.15 `a commit on a total row on a day screen that is not keeping a record is told nothing on
  the row` — four clauses, including the take-back.
- [ ] 13.16 `a commit on a total row for a day that has not arrived is told nothing on the row`
- [ ] 13.17 `taking back on a row that offers no take-back is told nothing on the row` — and does not
  end what is already told on another row.
- [x] 13.18 **Not a new test, and it is a rewrite.** The existing test named `a commit on a row that
  offers no entry at all is told nothing on the row` is written against a **total** row today, and a
  total row now offers an entry, so its body no longer matches its scenario. Rewrite the body to the
  delta's: a **tick** row, told nothing for a text and for a blank commit alike. Its `@Test` display
  name does not change. Expect it **red** before the rewrite once § 12 is in — a total row now answers
  "Not a number" to "Ran 8k." — and that red is the finding this box exists for, not a regression.

## 14. The app shell

This section rides this Story's branch under `CONTEXT.md` § *App shell*'s third condition — it exists
only to make the Story usable, its consumer lands in the same PR, and it introduces no behaviour the
kit does not specify. It is not tested (`docs/open-questions.md` § *No UI smoke layer*).

- [ ] 14.1 In `src/DayByDay/ContentView.swift`, give a row that offers a total entry a tap that opens
  a sheet holding **one decimal field that opens empty every time**, a Save that calls
  `try? screen.enter(text, on: row)` and closes, a Cancel that closes and calls nothing, and — only
  where `row.offersTakeBackLast(asOf: today())` — a *Take back last* button calling
  `try? screen.takeBackLast(on: row)`. Draw `entry.soFarOfTarget` on the row itself, beside the name,
  the way the kit hands it over. **The field must not be prefilled from anything**: there is nothing
  in `TotalEntry` to prefill it from, and inventing one would double a day committed unread.

## 15. The measurements this change owes

Neither box writes a test of its own; both check something a test cannot, and both are named in
`design.md`.

- [ ] 15.1 Confirm the branch-point measurement in `design.md` § *Context* still holds on the
  toolchain the work was actually done on: `swift --version` reports Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`. A different toolchain does not invalidate
  the delta, but it does invalidate the measurement tables, and that is a report rather than a
  silent edit (`AGENTS.md` rule 5).
- [ ] 15.2 Re-run measurement B's ten cases **through `DayByDayKit`** — driving the real
  `Digits.canAdd(_:to:)` from a temporary test in
  `Tests/DayByDayKitTests/DayViewTests.swift`, never from a re-implementation of it beside the
  package. `0 + 30`, `30 + 90`, `70.5 + 0.25`, `0.000001 + 0.000001`, `1e38 + 1e38`, `37 nines + 0.5`
  and `38 nines + 1` admit; `38 nines + 0.5`, `1e38 + 0.5` and `38 nines + 38 nines` refuse. Record
  the ten answers in § 17. Then **delete the temporary test** — §§ 11.2 and 11.3 are the two that
  ship, and a test not named for a scenario fails CI check 4. #139's carried-over note 3 is why this
  box says "through `DayByDayKit`" twice: that Story's own measurement re-implemented the function it
  was checking, ran a hundred thousand cases and proved nothing.

## 16. The documents

`docs/adr/1040-a-days-sum-is-capped-where-a-typed-number-is.md`,
`docs/adr/1041-a-total-entrys-blank-commit-means-nothing.md`, the 2026-09-08 amendment on
`docs/adr/1033-a-number-is-taken-back-by-naming-the-day.md`, and their rows in `docs/adr/README.md`
are **written with this folder** and are in the G4 diff, so these boxes confirm rather than write.
`CONTEXT.md` needs nothing: the grill landed **Addition** and **Total entry** and amended **Total**
and **Row**, and writing the delta turned up no further term.

- [ ] 16.1 Confirm before the review that 1040 and 1041 are still the lowest free ADR numbers:
  `for r in $(git for-each-ref --format='%(refname)' refs/heads refs/remotes); do git ls-tree --name-only $r docs/adr/; done | sort -u`.
  1039 was the highest on any local or remote ref on 2026-09-08. **Report rather than renumber** if
  another branch has taken either (`AGENTS.md` rule 5).
- [ ] 16.2 Confirm 1033's amendment still says what the code does, now that the code exists — in
  particular that `History` takes the last addition back by `for:on:` as it takes a number and a note
  back, that nothing acquired an overload of `remove(_:)` taking an `Addition`, that no general
  take-back over a shared record type was introduced, and that its filename is unchanged, since
  `openspec/changes/archive/2026-09-07-add-number-record/tasks.md` § 8 names that path and the archive
  may not be edited.
- [ ] 16.3 Confirm 1040 describes the code that was actually written: **one** `Digits`, called only
  from `DayView.Row.totalRecord(_:asOf:)`, with `record` carrying no digit bound of any kind.
  `grep -rn "38\|thirty-eight" src/DayByDayKit/Sources/` should reach `Digits.swift` and
  `DayScreen.read(_:)`'s existing bound and nothing in `Addition.swift`, `History.swift` or
  `RecordStore.swift`. An ADR that has drifted from the implementation is edited in place and
  stamped, per `docs/adr/README.md`; a decision that has actually changed is a stop, not an edit.
- [ ] 16.4 Confirm 1041 describes what `enter(_:on:)` actually does on a total row: a blank commit
  returns having kept nothing, taken nothing back and told nothing, and `takeBackLast(on:)` is the
  only way an addition leaves a day.

## 17. Closing the Story

- [ ] 17.1 Record in this file, under a `## Notes` heading appended at the end, which of the boxes
  predicted red in §§ 3, 6, 7, 9, 11 and 13 actually ran red before the code that satisfies them was
  written — 11.2, 11.3 and 13.18 above all, since each is predicted red for a *stated* reason and a
  green one means the reason was wrong. Record § 15.2's ten answers here too. A prediction in a task
  is not evidence; this is.
- [ ] 17.2 `pnpm run verify` green from the repo root, and `pnpm run checks` reporting
  `scenario coverage — 248/248`. `cd src/DayByDayKit && swift test` reports **807 tests passing** —
  705 at the branch point plus the hundred and two written here, plus none removed and none left
  behind by § 15.2. A different number means a test was added or lost outside rule 3; report it.
- [ ] 17.3 Open the app on a phone or the simulator with `pnpm run phone`, **without deleting and
  reinstalling it first** — the existing install holds a record file in the store's fourth form, this
  branch's code writes the fifth, and a fresh install would write form 5 from the start, proving
  nothing about reading form 4. Confirm by hand that the day screen still draws whatever commitments
  the install already holds, that ticking one still works, and that the tick survives a force-quit
  and reopen. The total hand-check — add twice, watch "60 of 120" become "120 of 120" and the row go
  kept, take the last one back, force-quit and reopen — is deliberately **not** here, because no
  total commitment can exist on a phone until `add-kind-to-commitments-screen` (#142) lands, and it
  is carried there.
- [ ] 17.4 Run `/opsx:archive` as the last commit on the branch, then push it. **This box is the
  `implementer`'s to tick, in its last commit before the archive, on the evidence that everything
  above it is in place — not the janitor's, and not a box that waits on the archive.** What follows
  is the janitor's instruction: after the archive has run, read `openspec/specs/record/spec.md` and
  confirm that *A store reads a history kept before a commitment carried a kind* is still the first
  requirement and *A tick is of a commitment on a calendar date it is due on* still the second, and
  that `openspec/specs/day-screen/spec.md` still opens with *A day view is the commitments due on a
  date, each with whether it is kept*. Any drift there is a stop and a report, never a hand-edit:
  `openspec/specs/` is written by `/opsx:archive` and by nothing else (`AGENTS.md` rule 2).
- [ ] 17.5 Land the `docs/open-questions.md` entries as a **chore commit that merges before this
  Story's archive**, not on this branch — `AGENTS.md` § *Agent roles* puts that file outside a
  Story's reach, and landing it first is what lets this box be ticked on evidence rather than in
  anticipation of a merge still to come. Three edits:

  **The thirteenth and fourteenth faces of the public-surface gap.** A row gives a day's sum out
  through the `TotalEntry` its `totalEntry(asOf:)` offers — as words rather than as a number, which is
  narrower than the number's and the note's — and it gives out a second, conditional affordance
  besides, `offersTakeBackLast(asOf:)`, which is the first thing a row offers that depends on what the
  history says. `History.total(for:on:)` lets a sum out at the record level, so a history now answers
  four questions four ways: ticks as a boolean from `isKept(_:on:)`, numbers and notes as a value
  **or nothing**, and additions as a value **always**.

  **The general record reader, and what the fourth kind taught about it.** `grill.md` § *Left open*
  and `design.md` § *Open Questions*: #138's deferral named this Story as where its stated reason
  expires, and it has expired. What replaces it is that folding four readers into one is a
  no-behaviour refactor across two capabilities, rewriting requirements three merged Stories have
  signed — and that the four are **not** the same shape, since three answer *a value or nothing* and
  the fourth answers *a value, always*. It is a design question and its own change, not a merge.

  **Close *A commitment of a kind nothing can yet record is a row that does nothing when tapped*.**
  This Story spends the last of it: every kind's row now offers something. The ordering hazard it
  named is spent with it — there is no kind a person can define on `add-kind-to-commitments-screen`
  (#142) that lands on a dead row.

  **The data clump entry is closed rather than carried**, by § 1.3: `RecordStore.write` and
  `RecordDocument.init` take labels, so the fourth kind arrived without four unlabelled positional
  parameters of the same shape. Say so where the entry stands, rather than deleting it silently.
