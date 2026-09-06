## Why

`add-commitment-kind` (#137) gave a commitment a **kind** and, in the same breath, closed every one
of its days: a commitment of the number kind can be ticked by nothing, so a weight or a mood has a
row that offers nothing and a day that holds nothing. This Story gives a number commitment's day
something to hold, and it is the first record in this app that is not a tick.

It is the second of the six Stories under `FEAT: record` (#53) and nothing else in the Feature can
start before it in its lane: #139's row has to have a number to enter and read back, and #140's note
and #141's total will each copy the shape this one settles.

## What Changes

- **A number is a record: a number commitment, a calendar date it is due on, and one decimal.** It
  is formed the way a tick is and refused the same way — a date the commitment is not due on takes
  none, and a commitment whose kind is not a number takes none on any date. Two further refusals are
  its own: a number outside the range its commitment declares, and a value that is not a number at
  all.
- **A history answers what number is on a day, not only whether the day was kept.** This is the
  first read-back this capability has: `History` has never let anything out of it but a yes or a no,
  and a row that has to draw "70.5" cannot get it from `isKept`. Settled at the grill, against the
  Story's own intent line, because a record nothing can read back is not a record.
- **A number keeps its day by being there, whatever the number is.** So *A history answers whether a
  commitment was kept…* changes: it has said since #137 that a commitment whose kind is not a tick
  is *not kept* on every date, and that stops being true for a number commitment with a number on
  it. A note and a total commitment stay not kept until #140 and #141.
- **A number entered again on the same day replaces the one before it**, and nothing remembers the
  one that was there. There is still one record per commitment per day.
- **A number the commitment refuses leaves the day exactly as it was.** 300 entered against a range
  of 40 to 150, over a day already holding 70.5, leaves 70.5 — the refusal changes nothing, which is
  the shape a refused tick already has.
- **A range is bounds and nothing else.** A mood of one to ten takes 5.5, and 1 and 10 themselves. A
  step, a scale and a set of allowed values are not things this product has.
- **Taking a number back names the commitment and the day, not the number.** A tick is taken back by
  handing back the same tick; a day holds at most one number, and someone who mistyped 300 must be
  able to clear it without reading it back first. Recorded as
  `docs/adr/1033-a-number-is-taken-back-by-naming-the-day.md`.
- **A value that is not a number is refused where the record is formed**, not left to the range to
  catch. Three measured reasons, all on this machine on 2026-09-06: a range check refuses a
  not-a-number only through its *lower* bound (`Decimal.nan <= Decimal(150)` is `true`), so a
  commitment with no range would accept one; `Decimal.nan == Decimal.nan` is `true`, so one would
  compare and dedupe as an ordinary value; and `JSONEncoder` writes it as the bare token `NaN`,
  which is not valid JSON, so **one such value in the file refuses the whole history** on the next
  open, not its own record. `design.md` § *A value that is not a number* has the measurements.
- **The record store moves to a third form, and reads all three.** This is the reversal trigger
  `docs/adr/1031` named in as many words, and that ADR is **amended in place** (ADR-1020) rather
  than superseded: the version guard already reads `1...currentVersion`, so reading form 1 and form 2
  is free, and what the amendment adds is the strictness 1031 asked for in exchange — **the record
  document's shape is checked against the form it declares**, so a file in an earlier form carrying
  numbers, or a file in the current form carrying none, is refused as content this app never wrote
  rather than read leniently.
- **The roster store does not move.** Both stores share `CommitmentCoding.swift`, which is why #137
  moved both; this Story changes the record document's payload and not a commitment's wire form, so
  the roster stays at form 2 and `commitment` is untouched.
- **Not in this change:** entering a number in a row or drawing one there, including the mood slider
  the owner asked for (#139); a note (#140); a total (#141); choosing a kind on the commitments
  screen (#142); starting a weight entry from the last weight given (B-032, whose own *Open* lines
  say it cannot be taken before a weight is recordable at all); carrying either store to a new phone
  (B-009).

## Capabilities

### New Capabilities

None. A number is a record of a commitment on a day, which is what `record` is — a `number`
capability would put the second kind of record in a different file from the first, and `History`
answers both questions from one value.

### Modified Capabilities

- `record`: three requirements **ADDED** and five **MODIFIED**.
  - ADDED *A number is of a number commitment on a calendar date it is due on* — what a number is,
    the four refusals, and what makes two numbers the same number.
  - ADDED *A history answers what number a commitment has on a day from the numbers it holds* — the
    read-back, the replacement rule, and what a refused number leaves standing.
  - ADDED *A number can be taken back* — by naming the commitment and the day, the way *A tick can
    be taken back* does it by naming the tick.
  - MODIFIED *A tick is of a commitment on a calendar date it is due on*: it says today that "until
    there is such a record, those commitments simply have no record here" and that "a history holds
    ticks and nothing else". Both stop being true. The tick's own refusals do not move.
  - MODIFIED *A history answers whether a commitment was kept on a day from the ticks it holds*: a
    number commitment is kept on a date it has a number on. This is the requirement #137 shipped the
    same week and this Story reverses in part.
  - MODIFIED *A store keeps a history at a place, across the app being closed and opened again*: it
    holds and persists numbers as well as ticks, and a number reads back digit for digit.
  - MODIFIED *A store that cannot be read is refused rather than emptied*: a store holding what
    could not be a **record** is refused, which now includes a number its commitment would refuse.
    It names a fourth thing it cannot read — a store whose shape and its declared form disagree —
    and hands it to the requirement below, where the rule about forms lives.
  - MODIFIED *A store reads a history kept before a commitment carried a kind*: the forms a store
    reads are **every** form this app has written, not the current one and the one before it.

**Three requirement titles now undercount their own bodies, and that is deliberate.** *A history
answers whether a commitment was kept on a day from the **ticks** it holds* answers from numbers as
well; *A store reads a history kept **before a commitment carried a kind*** reads two earlier forms;
*A tick is of a commitment on a calendar date it is due on* now says what a history holds beside
ticks. All three were considered as `RENAMED` and none is renamed, for the reason #137 measured and
`design.md` § *Three titles that lag their bodies* re-measures on this branch: **`openspec` 1.10.0
moves a renamed requirement to the bottom of the recomposed spec**, and `openspec/specs/` may not be
hand-edited afterwards (rule 2). A stale title is a blemish one line of `RENAMED` fixes the day the
tool preserves position; a wrecked reading order is permanent.

Every requirement restated under MODIFIED keeps its existing scenarios **verbatim**, and **no test
written for one of them may be renamed or have an assertion changed**. Thirty-seven of the delta's
seventy-five scenarios are restatements already carried by passing tests; thirty-eight are new.
`tasks.md` § 1 fixes the one mechanical edit an existing test needs — the fixtures that say `3` to
mean *a later form* become `4` — and a red test in that section is a rule-5 stop.

`commitment`, `day-screen`, `schedule` and `cli-version` are untouched. `day-screen` hands "whether
it is kept" to `record` by name and recomputes nothing, so a number commitment's row goes green
through a requirement that already passed G4; and its row still offers nothing, because giving it
something to offer is #139's.

## Impact

- **`src/DayByDayKit`** — one new file, `Sources/DayByDayKit/Number.swift`, holding `Number` and the
  internal `RecordedDay` key that makes "at most one number per commitment per day" structural
  rather than a rule someone maintains. Three existing files are edited: `History.swift` gains the
  numbers it holds, the reader, the take-back and a widened `isKept`; `RecordDocument.swift` gains
  `NumberRecord`, moves `currentVersion` to `3` and checks its shape against the form it declares;
  `RecordStore.swift` gains the two writes and mirrors the numbers it keeps. `Tick.swift`,
  `Commitment.swift`, `CommitmentKind.swift`, `CommitmentCoding.swift`, `DayView.swift`,
  `Roster*.swift` and `Package.swift` are **not** edited — `Decimal` comes from `Foundation`, which
  `CommitmentKind.swift` already imports, so there is no dependency and no platform floor change.
- **`src/DayByDay`** — nothing. Day one is nine ticks, #142 is what puts a kind on the commitments
  screen and #139 is what enters a number in a row, so nothing shipped can reach a number record
  until then. `tasks.md` § 7 still opens the app on the simulator, because a store that reads two
  earlier forms is exactly the thing no unit test can prove about a real file on the owner's phone.
- **Tests** — thirty-eight new acceptance tests, one per new scenario: twenty-eight in
  `Tests/DayByDayKitTests/RecordTests.swift` and ten in
  `Tests/DayByDayKitTests/RecordStoreTests.swift`. Eleven existing sites that say `3` to mean *a
  later form* become `4`; `tasks.md` § 1 lists every one by file and line. Measured on this machine
  on 2026-09-06, Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`:
  `cd src/DayByDayKit && swift test` reports **418 tests passing** at `0df7fbb`, the branch point;
  this change takes it to 456. `openspec` is 1.10.0 and `node --version` is v24.19.0.
- **`openspec/specs/`** — `record/spec.md` alone, rewritten at archive time by `/opsx:archive` and
  nothing else. One capability is claimed and one is edited, so CI check 2 stays green.
- **ADRs** — one new, `1033-a-number-is-taken-back-by-naming-the-day.md`. 1033 is the lowest number
  no file and no branch has used: 1032 is the highest on any local or remote ref, checked on
  2026-09-06. `docs/adr/1031-a-store-reads-the-form-before-it.md` is **amended in place** with an
  `Amended` stamp, per ADR-1020, because its own reversal trigger is what fired. `docs/adr/README.md`
  gains one row.
- **`CONTEXT.md`** — no new term; the Feature grill landed **Number**, **Range** and **Taking back**
  on 2026-09-06, before this Story existed. Two entries are amended, both because writing the delta
  made them wrong rather than merely incomplete: **Store**, which says a store reads "the one it
  writes now and the one before it", and **Record store**, which says it keeps "every tick added and
  not since taken back". Both ship in this folder, in the G4 diff.
- **`docs/open-questions.md`** is not this change's to write (`AGENTS.md` § *Agent roles*).
  `tasks.md` § 7 names the one entry it owes as a chore commit alongside the merge: the read-back gap
  now has a tenth face — `History` lets a number out and still lets no tick out, so the same value
  answers one question with a value and the other with a yes or no.
- **`docs/backlog.md`** — the **mood-slider want is still not on disk**, and this change does not put
  it there: it is #139's affordance, `grill.md` records that capturing it on `chore/backlog` was lost
  on 2026-09-06 to another session's rebase, and a want is written by `/atlas idea` on that branch
  rather than by a Story. B-032 and B-009 stay where they are; nothing here promotes one.
- **No new dependency, no CI change, and no change to any command.**
