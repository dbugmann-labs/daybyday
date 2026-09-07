## 1. The baseline, and the one existing edit

This section changes no behaviour and adds no test. It moves the eleven sites that say `3` to mean
*a later form* and pins the starting point, so that everything after it is measured against a number
rather than a memory.

- [x] 1.1 Confirm the branch point before touching anything: from `src/DayByDayKit`, `swift test`
  reports **418 tests passing**. Measured on this machine on 2026-09-06, Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`. A different number means `main` moved under
  the branch; report it rather than working around it (`AGENTS.md` rule 5).
- [x] 1.2 Edit the eleven sites that say `3` to mean *a later form* so they say `4`. Nine JSON
  fixtures — `RecordStoreTests.swift:267`, `RosterStoreTests.swift:323`,
  `CommitmentsScreenTests.swift:1024`, and `DayScreenTests.swift:370`, `:454`, `:585`, `:1673`,
  `:1831`, `:2471` — and two assertions, `RecordStoreTests.swift:270` and `RosterStoreTests.swift:326`,
  whose `laterForm(at:version: 3)` becomes `version: 4`. **No `@Test` display name, no other
  assertion, no date and no commitment may change**, and no test may be added or removed here.
  Five of those eleven are the *roster* store's — `RosterStoreTests.swift:323` and `:326`,
  `CommitmentsScreenTests.swift:1024`, and `DayScreenTests.swift:1673` and `:1831` — and they move to
  `4` for the same reason the record's six do: the roster document does not move in this change, and
  `4` is above its `currentVersion` of `2` as surely as `3` was. `swift test` still reports **418 passing** after this box — a red test is a
  rule-5 stop, because nothing in this box was supposed to change an answer.
- [x] 1.3 Confirm the coverage tool agrees before writing a test: from the repo root,
  `pnpm run checks` reports `scenario coverage — 37/75 scenario(s) covered` for this change and names
  `"a number is recorded for a number commitment on a date it is due on"` as next. A different number
  means something else moved; report it rather than working around it.

## 2. `Number`, before anything holds one

- [x] 2.1 Add `Sources/DayByDayKit/Number.swift` declaring exactly what `design.md` § *`Number` is its
  own type* gives: `public struct Number: Hashable, Sendable` with internal `commitment`, `date` and
  `number` (a `Decimal`) and `public init?(_ number: Decimal, for commitment: Commitment, on date:
  CalendarDate)`; and `struct RecordedDay: Hashable, Sendable` — internal, not public — with
  `commitment` and `date`. **The initializer is a bodied `fatalError("not implemented")`**, so § 3.1
  is red on its first assertion rather than accidentally green. The file opens with
  `import Foundation`, which is where `Decimal` comes from. Nothing else is public.
  `cd src/DayByDayKit && swift build` exits 0 and `swift test` still reports 418 passing.

## 3. `record` — what a number is

Nine scenarios from `specs/record/spec.md` § *A number is of a number commitment on a calendar date
it is due on*, all in `Tests/DayByDayKitTests/RecordTests.swift`. Each task takes exactly one
`#### Scenario:` and writes one acceptance test whose `@Test("...")` display name is that scenario
title **verbatim**, then makes it pass with the smallest change that does. Never write two before the
first is green (`AGENTS.md` rule 3). Verify each with `cd src/DayByDayKit && swift test`: the named
test green, every earlier test still green.

`design.md` expects 3.1 (the first call into the `fatalError`), 3.4 (the range check) and **3.8 (the
one that fails a range-only implementation**, because `Decimal.nan <= Decimal(150)` is `true` and a
commitment with no range runs no check at all) to run red on their own. **Record which ones actually
ran red as you go, in § 9**; a prediction here is not evidence.

- [x] 3.1 `a number is recorded for a number commitment on a date it is due on`
- [x] 3.2 `a number commitment takes no number on a date it is not due on` — all three clauses: not
  due, before the day it is kept from, and a schedule due on no date across seven days.
- [x] 3.3 `a commitment whose kind is not a number takes no number on a date it is due on` — the
  tick, note and total kinds, plus the number-kind control that must still record.
- [x] 3.4 `a number outside the commitment's range is not recorded` — above and below, plus the
  in-range control.
- [x] 3.5 `a number at either end of the commitment's range is recorded` — ends inclusive, and a
  range of exactly one value.
- [x] 3.6 `a number between two whole numbers is recorded on a range of whole numbers` — the owner's
  own answer at the grill: a range is bounds and nothing else, so 5.5 is a mood of one to ten.
- [x] 3.7 `a number commitment with no range takes any number` — negative, zero, very small and very
  large, each recorded as itself.
- [x] 3.8 `a value that is not a number is not recorded` — `Decimal.nan`, with a range and with none.
  The second half is the one that fails an implementation that leans on the range.
- [x] 3.9 `two numbers are the same exactly when their commitment, date and number all are` — all
  four clauses, which is what pins that the value is part of the record rather than beside it.

## 4. `record` — what a history holds and answers

Nine scenarios from § *A history answers what number a commitment has on a day from the numbers it
holds*, in `Tests/DayByDayKitTests/RecordTests.swift`. `History` gains
`private var numbers: [RecordedDay: Decimal]`, `add(_ number: Number)`, `number(for:on:)` and
`removeNumber(for:on:)` per `design.md` § *A history holds numbers in a map keyed by the day*; the
map is what makes 4.5 pass without an explicit remove-then-insert.

- [x] 4.1 `a history that has taken no number has no number for a commitment on a day`
- [x] 4.2 `a number added to a history is the number that commitment has on that day` — assert the
  value exactly, which is what stops a `Double` creeping in later.
- [x] 4.3 `a number on one date is not the number on another date the same commitment is due on`
- [x] 4.4 `a number of one commitment is not the number of another on the same date`
- [x] 4.5 `a number entered again on the same day replaces the one before it` — both halves: the
  later value reads back, and the history equals one the later number alone was added to.
- [x] 4.6 `a history has no number for a commitment whose kind is not a number` — answered rather
  than refused, for all three other kinds and for a date the commitment is not due on.
- [x] 4.7 `a number the commitment refuses leaves the number already on that day standing` — the
  owner's own answer at the grill: 300 over 70.5 on a range of 40 to 150 leaves 70.5.
- [x] 4.8 `two histories holding the same numbers are the same history`
- [x] 4.9 `a history holds ticks and numbers side by side and answers each on its own`

## 5. `record` — taking a number back

Five scenarios from § *A number can be taken back*, in `Tests/DayByDayKitTests/RecordTests.swift`.
The take-back names the commitment and the date, never the number — `docs/adr/1033` and § 8.2.

- [x] 5.1 `a number taken back leaves the day holding no number and the commitment not kept on it`
- [x] 5.2 `taking back a number leaves the same commitment's numbers on other days standing`
- [x] 5.3 `taking back a number leaves another commitment's number on the same day standing`
- [x] 5.4 `taking back a number where the history holds none leaves it unchanged` — three cases: a
  day with nothing on it, a commitment of the wrong kind, and a date it is not due on. None is an
  error.
- [x] 5.5 `a history given a number and then taken back is the same as one never given one`

## 6. `record` — what the two existing answers say now

Five scenarios across the two MODIFIED requirements that change what a history *answers*, in
`Tests/DayByDayKitTests/RecordTests.swift`. Expect 6.1 red — `isKept` has to widen — and the rest
green once it is in; a red test at 6.3, 6.4 or 6.5 is a real finding, not a licence to edit further.

- [x] 6.1 `a number commitment with a number recorded on a date was kept on that date` — widen
  `History.isKept(_:on:)` per `design.md`. This is the one requirement #137 shipped that this Story
  reverses in part.
- [x] 6.2 `a number commitment due on a date with no number recorded was not kept on it`
- [x] 6.3 `every number a commitment accepts keeps its day, whatever the number is` — both ends of a
  range, a value between them, and a negative on a commitment with no range. A range says which
  numbers a commitment takes and never which of them count.
- [x] 6.4 `a commitment of the note kind and one of the total kind were not kept on a date they are
  due on` — what stops this Story quietly keeping the two kinds it does not implement.
- [x] 6.5 `a number commitment with a number on a date still takes no tick on it` — from § *A tick is
  of a commitment on a calendar date it is due on*. `Tick.swift` is **not** edited: its kind guard
  already refuses this, and the test is what pins that it stays refused now that such a commitment
  can be kept.

## 7. The form on disk

Ten scenarios across the three MODIFIED store requirements, all in
`Tests/DayByDayKitTests/RecordStoreTests.swift`. Do 7.1 first as one mechanical step and verify the
suite before writing a test; then one scenario at a time as above.

- [x] 7.1 In `Sources/DayByDayKit/RecordDocument.swift`, add `NumberRecord` — `commitment`, `date`
  and `number` — give `RecordDocument` a `numbers` field, move `currentVersion` from `2` to `3`, and
  sort `numbers` by the same key `ticks` already uses (commitment name, kept-from day, date,
  schedule). `formNumbers()` re-forms every number through `Number.init?` and returns `nil` if any
  one fails, exactly as `formTicks()` does. In `Sources/DayByDayKit/RecordStore.swift`, mirror the
  numbers the store keeps beside the ticks, and add the two writes. **`CommitmentCoding.swift` is not
  edited** — the roster store shares it and does not move. `swift test` still reports 418 passing
  after this box; a red test is a rule-5 stop.
- [x] 7.2 `a number added to a store is held by a second store opened at the same place while the
  first is still open`
- [x] 7.3 `a number taken back is not held by a store opened afterwards at the same place`
- [x] 7.4 `a number entered again is kept once by a store opened afterwards, as the later number`
- [x] 7.5 `a number is read back exactly as it was given, whatever its digits` — five values through
  a real file. This is the test that fails the day someone reaches for a `Double`.
- [x] 7.6 `a store opened again holds exactly the ticks and numbers added and not taken back`
- [x] 7.7 `a number that cannot be kept is refused and not held` — the unwritable place, and the
  store's history left as it was.
- [x] 7.8 `a store holding a number its commitment would refuse is refused` — a hand-written form-3
  fixture, three ways: out of range, wrong kind, not due. All three come from `formNumbers()`
  returning `nil`, so expect this green once 7.1 is in; a red test is a finding.
- [x] 7.9 `a history kept before a day could hold a number is read, and no day in it holds a number`
  — a form-2 fixture. Expect green once 7.1 is in: the version guard already reads `1...3`.
- [x] 7.10 `a number added over a history kept before a day could hold a number is read back beside
  the ticks already there` — a form-2 fixture written over, then reopened at form 3.
- [x] 7.11 `a store whose shape and declared form disagree about numbers is refused` — the guard from
  `design.md` § *Each form is read as the shape that form has*, both directions: a form-2 fixture
  carrying `numbers`, and a form-3 fixture with no `numbers` field at all. Expect red on both halves
  before the guard is written.

## 8. The documents

`docs/adr/1033-a-number-is-taken-back-by-naming-the-day.md`, the 2026-09-06 amendment on
`docs/adr/1031-a-store-reads-the-form-before-it.md`, their two rows in `docs/adr/README.md` and the
two amendments on `CONTEXT.md` — § *Store* and § *Record store* — are **written with this folder**
and are in the G4 diff, so these boxes confirm rather than write.

- [x] 8.1 Confirm before the review that 1033 is still the lowest free ADR number:
  `for r in $(git for-each-ref --format='%(refname)' refs/heads refs/remotes); do git ls-tree --name-only $r docs/adr/; done | sort -u`.
  1032 was the highest on any local or remote ref on 2026-09-06. **Report rather than renumber** if
  another branch has taken it (`AGENTS.md` rule 5).
- [x] 8.2 Confirm 1033 still says what the code does, now that the code exists — in particular that
  `History` really does take a number back by `for:on:` and that nothing acquired an overload of
  `remove(_:)` taking a `Number`.
- [x] 8.3 Confirm 1031's amendment still describes the guard that was actually written: every form
  read, each read as the shape that form has, one comparison against the declared version rather than
  three decode paths, and `kind`'s absence-means-tick rule deliberately untightened. An ADR that has
  drifted from the implementation is edited in place and stamped, per `docs/adr/README.md`; a
  decision that has actually changed is a stop, not an edit.
- [x] 8.4 Confirm `CONTEXT.md` gained its two amendments and **no new term**. The Feature grill
  landed **Number**, **Range** and **Taking back** on `main` before this Story existed, and
  `grill.md` records that this Story's grill added none. A new term appearing here means something
  was decided that should have been asked.

## 9. Closing the Story

- [x] 9.1 Record in this file, under a `## Notes` heading appended at the end, which of the boxes
  predicted red in §§ 3, 6 and 7 actually ran red before the code that satisfies them was written.
  A prediction in a task is not evidence; this is.
- [x] 9.2 `pnpm run verify` green from the repo root, and `pnpm run checks` reporting
  `scenario coverage — 75/75`. `cd src/DayByDayKit && swift test` reports **457 tests passing** —
  418 at the branch point plus the thirty-eight written here plus one added at G7, plus none
  removed. A different number means a test was added or lost outside rule 3; report it.
- [x] 9.3 Open the app on the simulator with `pnpm run phone` and confirm the day screen still draws
  its nine day-one ticks and that ticking one still works. Nothing in the shipped app can reach a
  number record — day one is nine ticks and no screen offers a number until #139 — so what this box
  checks is that the store's third form did not break the two forms a real phone is actually in.
- [ ] 9.4 Run `/opsx:archive` as the last commit on the branch, then push it. **The janitor's own
  instruction, not a box that waits on the archive:** after the archive has run, read
  `openspec/specs/record/spec.md` and confirm that *A store reads a history kept before a commitment
  carried a kind* is still the first requirement and *A tick is of a commitment on a calendar date it
  is due on* still the second — the reading order `design.md` § *Three titles that lag their bodies*
  measured. Any drift there is a stop and a report, never a hand-edit: `openspec/specs/` is written
  by `/opsx:archive` and by nothing else (`AGENTS.md` rule 2).
- [x] 9.5 Add one entry to `docs/open-questions.md` as a **chore commit alongside the merge**, not on
  this branch — `AGENTS.md` § *Agent roles* puts that file outside a Story's reach. The entry: the
  read-back gap has a tenth face, in that `History` now lets a number out and still lets no tick out,
  so one value answers one question with a value and the other with a yes or no.

## Notes

Which boxes predicted red in §§ 3, 6 and 7, and what actually happened, measured as each scenario's
test was written rather than assumed from the prediction:

- **§ 3 — matched the prediction exactly.** 3.1 ran red on `Number.init?`'s `fatalError("not
  implemented")`. 3.4 ran red once the initializer held only the due and kind guards (no range, no
  NaN check) — offering 300 and 39.9 against a 40–150 range both formed a `Number` instead of
  refusing one — and the range guard written to pass it is what made it green. 3.8 ran red the same
  way once the range guard existed but no NaN guard did: `Decimal.nan` formed for the no-range
  commitment (the with-range half was already refused by the range comparison, as measured in
  `design.md` § *Context*). Every other § 3 scenario (3.2, 3.3, 3.5, 3.6, 3.7, 3.9) ran green on
  first write, off guards an earlier scenario in the same section had already driven out.
  - One correction along the way: the first pass at 3.1 wrote all four guards — due, kind, range and
    NaN — at once, which is what `mattpocock-skills:tdd`'s "don't anticipate future tests" rule
    exists to catch. It was caught before 3.1 was ticked: the range and NaN guards were reverted back
    to `fatalError`-adjacent minimalism (due and kind only), 3.1 through 3.3 re-verified still green
    on that smaller shape, and 3.4 and 3.8 then drove the range and NaN guards out for real, red
    first. No test's assertions changed as a result — only `Number.swift`'s intermediate shape did,
    and only before any box here was ticked.
- **§ 6 — 6.1 did not run red.** `isKept`'s widening — `ticks.contains(tick) ||
  numbers[RecordedDay(...)] != nil` — was driven out by **4.9** (`a history holds ticks and numbers
  side by side and answers each on its own`), which asks `history.isKept(weight, on: monday)` for a
  number commitment and is unsatisfiable without the same widening 6.1 names. 4.9 ran red for exactly
  that assertion and the widening landed there, three scenarios before § 6 was reached in task order.
  6.1 through 6.5 all ran green on first write, each confirming a fact the widening (or, for 6.4 and
  6.5, an already-correct refusal) already made true — none of 6.3, 6.4 or 6.5 ran red, so no further
  edit was needed or made.
- **§ 7 — matched the prediction exactly.** 7.2 through 7.10 all ran green on first write once 7.1's
  mechanical step was in, as `design.md` predicted for 7.8, 7.9 and 7.10 by name and as held for the
  rest. 7.11 ran red on both halves — an early-form fixture carrying a `numbers` array, and a
  current-form fixture with none — because `RecordDocument.numbers` decoded leniently (`nil` when
  absent, formed when present) with no check yet that its presence agreed with the declared version;
  the explicit guard added to `RecordStore.init` (`(document.numbers != nil) == (document.version ==
  RecordDocument.currentVersion)`) is what made it green.
- **Stale count in 7.1's own box.** 7.1's text predicts `swift test` reports "418 passing" after that
  box; the actual count there was 446 (418 at the branch point plus the 28 scenarios §§ 3–6 had
  already added by the time task order reaches 7.1). The box's own point — no regression from
  whatever the count already was — held; only the specific number written into the task was stale,
  carried over from § 1's phrasing rather than updated for where 7.1 actually falls in the sequence.
- **9.5's chore landed before the archive, not alongside it.** `docs(open-questions): a tenth
  read-back face and a second ADR collision` merged to `main` as `72bb8b2` (PR #154) ahead of this
  Story's own archive commit. That ordering was the repo owner's call at the gate: `openspec
  validate --archived` requires every archived change's `tasks.md` to have every box ticked, and a
  chore commit that lands *after* the archive would leave 9.5 truthfully unticked at archive time —
  either the archive ships with a false checkmark or the entry waits for a second, unrelated PR
  after the Story is closed. Landing the chore first lets 9.5 be ticked honestly, on evidence
  (`72bb8b2` read directly off `main`) rather than in anticipation of a merge still to come.
- **9.2's count moved from 456 to 457.** The G7 fix round for finding 4 (`RecordDocument.swift:74-87`,
  the sort key not ordering two numbers totally) added one below-the-seam unit test in
  `RecordDocumentTests.swift`, pinning the `kind` tiebreaker at the level the defect lives. Rule 3
  governs one acceptance test per scenario and says nothing about unit tests below the seam, so the
  test stands and the 38 scenario tests § 9.1 counted are unchanged; 9.2's number is 418 at the
  branch point plus 38 scenario tests plus this one G7 unit test. Confirmed by running `swift test`
  from `src/DayByDayKit` on this tree on 2026-09-07: `Test run with 457 tests in 0 suites passed`.
