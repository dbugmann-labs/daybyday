## Context

`proposal.md` § *Why* says what this is for, and `grill.md`'s settled answers are what the delta is
written on. `openspec/specs/record/spec.md` holds 19 requirements; the delta carries 10 of them
whole, every existing scenario verbatim, and 12 new scenarios appended at their ends.

`RecordStore`'s change methods each compute the next state and write it unconditionally; only
`carryOver` returns before writing where the history would not move. Its writes are byte-stable, so
a needless rewrite cannot be seen in the bytes — only by making the place impossible to write, the
technique the shipped carry-over scenario already uses. `Blank.saysNothing` is
`Character.isWhitespace`, which measured calls a zero-width space not whitespace while Foundation's
`.whitespacesAndNewlines` trims it (ADR-1039). Read in source, eleven new scenarios are expected
green on arrival and one red.

## Goals / Non-Goals

**Goals:** every uncovered rule the grill's rules re-derive gets exactly one scenario and its test;
the one red is fixed and nothing else in `src/` moves; the unprovable rules and the NaN finding are
recorded in `docs/open-questions.md` in this commit (grill answers 6, 8, 11).

**Non-Goals:** no rule reworded, no scenario dropped or edited, no other capability, no ADR amended
(grill answer 8), no mutation run, and no decision about a day whose sum is NaN (grill answer 5).

## Decisions

### The seam

No member is new and no signature changes. Every new scenario is driven at shipped members, and the
file at a store's place is part of this seam (grill answer 7):

```swift
RecordStore.init(at place: URL) throws
RecordStore.add(_ tick: Tick) throws
RecordStore.remove(_ tick: Tick) throws
RecordStore.add(_ number: Number) throws
RecordStore.removeNumber(for commitment: Commitment, on date: CalendarDate) throws
RecordStore.add(_ note: Note) throws
RecordStore.removeNote(for commitment: Commitment, on date: CalendarDate) throws
RecordStore.removeLastAddition(for commitment: Commitment, on date: CalendarDate) throws
RecordStore.carryOver(_ commitment: Commitment, to changed: Commitment) throws -> Bool
History.carryOver(_ commitment: Commitment, to changed: Commitment) -> Bool
History.isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool
Note.init?(_ text: String, for commitment: Commitment, on date: CalendarDate)
```

### One scenario per uncovered sentence, each built against a wrong implementation

Grill answers 1 and 9. Uncovered members of one sentence are AND lines of its one scenario.

| Requirement — sentence | New scenario catches |
|---|---|
| *…refused rather than emptied* — what cannot be read includes | a reader skipping the tick's kind, or trimming only ASCII spaces |
| same — each addition re-formed on its own | a reader checking a day's first amount, or its sum |
| *A note can be taken back* — every other number stands | a take-back clearing the whole day |
| *The last addition…* — every other record stands | the same, for an addition |
| *A history carries…* — all of them or none | moving records one at a time and stopping at the first misfit |
| *A store carries…* — held under the second, none under the first | a store moving ticks but not numbers, notes or additions |
| same — the form on disk does not move | a carry-over adding a key, a field or a version |
| *A store reads every form…* — write only when a change is kept | every change method but `carryOver` (red today) |
| *A store persists…* — MUST NOT persist the day's sum | a writer storing the sum beside the amounts |
| *A history answers whether…kept* — never widen the question | matching on name and kind alone |
| *A note is of a note commitment…* — what the test does not call whitespace | a `CharacterSet` blank test |
| *A store keeps every change…* — a change not kept is refused | a take-back changing the history before it writes |

### The one red, and its fix

Grill answers 3 and 4. *a change that leaves a store's history as it was writes nothing at its
place* is expected red. The least fix is a return before writing in each `RecordStore` change method
whose next state equals the current one, as `carryOver` already does; nothing else moves, and the
PR body names it. Rejected: rewording the rule, and a Story of its own — both refused at the grill.

### Covered elsewhere, pointers skipped, partials left

Grill answers 2 and 10 and ADR-1047 decision 7.3.

- *As SHALL every tick* (*A number can be taken back*) — *a store opened again holds exactly the
  ticks and numbers added and not taken back*; a note take-back leaving a tick, by its sibling for
  ticks, numbers and notes. An addition's *no position of its own* — *two additions are the same
  exactly when their commitment, date and amount all are*. *A note SHALL NOT be read back more
  leniently* — the first new scenario above.
- Pointers: *due-ness SHALL be the `commitment` capability's answer*; *blank space SHALL mean
  whitespace judged by the test a commitment name is judged by*; *say so as for every other change*.
- Partials left: a range fixing a step from its lowest value (the grill's own example); a carry-over
  sorting a day's additions, which the palindromic 30, 12.5, 30 fixture cannot see and nothing
  plausible does; a store reader skipping the date for one record kind, which the compiler forces it
  to unwrap; a history dropping additions past a ceiling, where past thirty-eight digits there is no
  exact sum to assert.

### What cannot be proven

Grill answers 5–8: the five groups are the `record` bullet under *Known gaps*, not restated here.
The sum scenario shows the writer adds no sum and cannot show that nothing reads one.

### No rule is reworded

Every MODIFIED block is byte-identical to the current spec but for its appended scenarios. Five
carried blocks are over the 150-word prose budget (282, 167, 167, 304, 171), as
`condense-record-spec` disclosed; a covering Story rewords no rule to meet it.

## Risks / Trade-offs

- **The all-or-none scenario rests on set order for the implementation it catches.** A
  move-as-you-go carry-over passes only when the one misfit of 59 records is visited first. → The
  fixture makes that one run in 59; `reviewer` reads the test against the table row.
- **The red fix touches seven methods**, so more can slip in than the scenario needs. → `tasks.md`
  § 4 names the only shape the diff may take, and G7 reads it.
- **A carried block drifting from the current spec** changes a rule silently. → `tasks.md` 2.1.
- **Three open Stories add bullets beside this one** under *Known gaps* and will conflict on
  rebase. → Each keeps its own bullet; the conflict is resolved by keeping both, not a rule-5 stop.

## Open Questions

None. `grill.md` § *Left open* is "None.", and writing the delta turned up no preference the grill
had not answered: which sentences are uncovered is re-derived above against grill answer 1, which is
a fact about the spec and the code rather than the owner's question.
