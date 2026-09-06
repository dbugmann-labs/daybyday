## Why

`FEAT: record` (#53) was reopened at the fifth grooming pass's Feature grill on 2026-09-06 for the
three kinds of record the owner's week actually needs — a **number** for a weight or a mood, a
**note** for a sentence about the day, a **total** for protein accumulated across it — beside the
**tick** that is all a day can hold today. Every one of them needs the same thing first: a
commitment has to say what its days take. Until it does, `add-number-record` (#138) has nothing to
hang a number off, #139's row has nothing to read before deciding what to offer, and `#142`'s
commitments screen has no fourth field to fill in.

This is the first of the Feature's six Stories and the only one nothing else can start before. It
also closes a hole that opens the moment a kind exists: a number commitment that could be ticked
would read as *kept* on a day nobody entered a weight for.

## What Changes

- **A commitment becomes four things, not three.** A name, a schedule, the day it is kept from, and
  **the kind its days take**. The kind is readable back, like the name, because #139's row has to
  know what to offer before anything has been recorded. Two commitments are the same commitment when
  all **four** match, so a roster holds a weight and a mood on one rhythm as two commitments.
  Recorded as `docs/adr/1030-the-kind-is-a-commitments-fourth-part.md`, which ADR-1023 owes: that
  one refused a fourth part for *kept until* because a tick embeds the whole commitment by value, so
  a part that changes re-keys every tick already recorded. A kind never changes once a commitment is
  defined — changing it is what changing a commitment is (B-014) — and every commitment that existed
  before kinds did is of the plain kind, so nothing already recorded is re-keyed.
- **A commitment formed without naming a kind is of the plain kind, a tick.** That is what makes the
  day-one seed of nine ticks, `CommitmentsScreen.define` and every existing test go on saying exactly
  what they said. Choosing a kind on the commitments screen is #142's.
- **A number commitment may declare a range, and a total commitment must declare a target.** A range
  is a lowest and a highest, both or neither, ends inclusive — mood is one to ten and takes 1 and 10
  — and a lowest above its highest is refused when the range is formed, the way 32 is refused as a
  day of the month. Equal ends are a range of exactly one value. A target is a number above zero:
  zero would make every day kept before anything was added. Both are decimals; both are refused when
  the value handed in is not a number at all.
- **A tick is of a commitment whose kind is a tick.** `record` refuses to form one for a commitment
  of any other kind, exactly as it already refuses a date the commitment is not due on. A history
  holds ticks and nothing else, so it answers *not kept* for a number commitment on every date —
  there is no tick of one it could hold. This is the first thing the kind actually does, and leaving
  it to #138 would ship a window in which a weight commitment could be ticked.
- **A row for a commitment whose kind is not a tick offers nothing.** `day-screen` says today that
  "being due on the date is the whole of what makes a tick formable, so the only row that offers
  nothing is one asked as of a day earlier than its own", and that stops being true above. The row
  stays — a due commitment does not leave the day — and it offers nothing until #139 gives it a
  number to offer instead. **This is what makes the Story touch a third capability**, and it is a
  consequence the grill did not trace; § *Impact* names the ordering hazard it leaves behind.
- **Both stores persist the kind, in a new form of their file, and read the form before it.** The
  roster store and the record store share one hand-written coding of a commitment
  (`CommitmentCoding.swift`), so both files change shape and both move to the next form. A file in
  the form written before a commitment carried a kind is **read**, with every commitment in it of
  the plain kind, rather than refused — which is what makes the owner's phone survive this Story.
  Today's code refuses an earlier form as *not a store*, and no requirement pins that. Recorded as
  `docs/adr/1031-a-store-reads-the-form-before-it.md`.
- **A store rewrites an earlier form only when the next change is kept there**, because a store
  writes nothing on opening. A person who opens the app and changes nothing leaves the file exactly
  as it was.
- **A number is a decimal, and this repo's first one.** `Decimal` rather than `Double`, recorded as
  `docs/adr/1032-a-recorded-number-is-a-decimal.md`: #141's total sums the additions made across a
  day, and ten additions of 0.1 come to 0.9999999999999999 in binary floating point and to exactly 1
  in `Decimal`. Both measured on this machine, 2026-09-06, on Apple Swift 6.3.3.
- **Not in this change:** recording a number, a note or a total (#138, #140, #141); entering one in a
  row, or a row offering anything but a tick (#139); choosing a kind when a commitment is defined
  (#142); changing a commitment's kind, which is B-014's *change a commitment* and would be a new
  commitment as things stand; carrying either store to a new phone (B-009); any grouping of
  commitments by kind (B-029, B-030).

## Capabilities

### New Capabilities

None. The kind is part of what a commitment *is*, so it belongs in `commitment` beside the name and
the schedule — a `kind` capability would put a commitment's fourth part in a different file from its
other three. `record` and `day-screen` both already exist.

### Modified Capabilities

- `commitment`: three requirements **MODIFIED** and four **ADDED**.
  - MODIFIED *A commitment is a name, a schedule, and the day it is kept from*: a commitment is
    exactly **four** things now, and the kind is the fourth. Its title keeps the three — see
    below, it is a tool finding rather than a choice.
  - MODIFIED *A roster refuses a commitment it already holds*: the sameness it judges by is four
    things now, not three, so two commitments alike in every way but their kind are both held.
  - MODIFIED *A roster store keeps a roster at a place…*: it persists the kind, the range where
    there is one and the target, along with the other three parts.
  - ADDED *A commitment's kind is a tick, a number, a note or a total* — the four kinds and what
    each carries.
  - ADDED *A range is a lowest and a highest, and the lowest is not above the highest* — the
    number kind's optional parameter, with its own validity rule, exactly as `schedule` gives *A
    day of the month is a number from the first to the thirty-first* its own.
  - ADDED *A target is a number above zero* — the total kind's required parameter, the same way.
  - ADDED *A roster store reads a roster kept before a commitment carried a kind* — and refuses a
    form number no build of this app has ever written, which nothing pins today.
- `record`: three requirements **MODIFIED** and one **ADDED**.
  - MODIFIED *A tick is of a commitment on a calendar date it is due on*: a tick is also of a
    commitment **whose kind is a tick**, and is refused for one of any other kind on every date.
  - MODIFIED *A history answers whether a commitment was kept on a day from the ticks it holds*:
    a commitment whose kind is not a tick is answered *not kept*, because no tick of one can be
    formed for it to hold.
  - MODIFIED *A store keeps a history at a place…*: what it persists of a tick's commitment is
    four things now. The wording says "and nothing else", so keeping the kind needs the change.
  - ADDED *A store reads a history kept before a commitment carried a kind* — the same, and it
    adopts an orphan test that already asserts the second half.
- `day-screen`: one requirement **MODIFIED** — *A row offers the tick that keeps its commitment, and
  refuses one for a day that has not arrived*. Its title is left exactly as it is: #139 is what turns
  the row into something that offers more than a tick, and renaming it here to say "or a commitment
  whose kind is not a tick" would name an interim state twice.

**Two requirement titles now undercount their own bodies, and that is deliberate.** *A commitment
is a name, a schedule, and the day it is kept from* covers four things below it, and *A tick is of a
commitment on a calendar date it is due on* covers a kind as well. Both were written as `RENAMED` at
first. **`openspec` 1.10.0 moves a renamed requirement to the bottom of the spec**: its recomposition
walks the original blocks and looks each up under its *old* name, so a renamed one is dropped from
that walk and appended after everything else. Measured on 2026-09-06 by archiving this change into a
throwaway copy of `openspec/` — with the renames, *what a commitment is* landed at line 1584 of 1855,
below all fourteen commitments-screen requirements, and *what a tick is* fell from first to fifth;
without them both specs keep their reading order and the same archive is clean. A stale title is a
blemish a one-line `RENAMED` fixes the day the tool preserves position; a wrecked reading order is
permanent, because `openspec/specs/` may not be hand-edited (rule 2). `design.md` § *Two titles that
lag their bodies* has the evidence and the exact commands.

Every requirement restated under MODIFIED keeps its existing scenarios **verbatim**, and **no test
written for one of them may be renamed or have an assertion changed**. Sixty-four of the delta's
ninety-two scenarios are restatements already carried by passing tests; twenty-eight are new. Where a
restated scenario's construction line has to change — a `Commitment(…)` call that now names a kind,
or the form number a later-form test writes — `tasks.md` § 1 fixes the exact mechanical form of the
edit, and a red test in that section is a rule-5 stop.

`schedule` is untouched. Nothing here asks a new question about a date, a weekday or an interval.

## Impact

- **`src/DayByDayKit`** — one new file, `Sources/DayByDayKit/CommitmentKind.swift`, holding
  `Commitment.Kind`, `Commitment.Range` and `Commitment.Target`. Four existing files are edited:
  `Commitment.swift` gains the fourth stored part and a defaulted initializer label;
  `CommitmentCoding.swift` gains the kind's wire form inside the shared `CommitmentRecord`;
  `RosterStore.swift` and `RecordStore.swift` each read an earlier form instead of refusing it, and
  `RosterDocument.swift` and `RecordDocument.swift` each move their `currentVersion` on by one.
  `Tick.swift` gains one guard. `DayView.swift` changes not at all — `Row.tick(asOf:)` already
  returns whatever `Tick.init?` gives it, so the new refusal reaches the row for free, which is why
  `day-screen`'s delta is one requirement and no code. `Package.swift` is untouched: `Decimal` comes
  from `Foundation`, so there is no dependency and no platform floor change.
- **`src/DayByDay`** — nothing. Day one is nine ticks and stays nine ticks; every
  `Commitment(name:schedule:keptFrom:)` call in `ContentView.swift` stays valid on the default.
  `tasks.md` § 5 still opens the app in the simulator, because a store that reads an earlier form is
  exactly the thing no unit test can prove about a real file already on the owner's phone.
- **Tests** — twenty-seven new acceptance tests and one existing test renamed, one per new scenario:
  fourteen in `CommitmentTests.swift`, one in `RosterTests.swift`, six in `RosterStoreTests.swift`,
  two in `RecordTests.swift`, four in `RecordStoreTests.swift` — of which one is the rename, not a
  new test — and one at the end of `DayViewTests.swift`. Eleven existing sites that say
  `2` to mean *a later form* — nine JSON fixtures and two `laterForm(at:version:)` assertions —
  become `3`; `tasks.md` § 6 lists every one by file and line. Measured on this machine on 2026-09-06, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3),
  target `arm64-apple-macosx26.0`: `cd src/DayByDayKit && swift test` reports **391 tests passing**
  at `2dff3f1`; this change takes it to 418. `openspec` is 1.10.0 and `node --version` is v24.19.0.
- **`openspec/specs/`** — `commitment/spec.md`, `record/spec.md` and `day-screen/spec.md` are
  rewritten at archive time by `/opsx:archive` and nothing else. Three capabilities are claimed and
  all three are edited, so CI check 2 stays green.
- **ADRs** — `1030-the-kind-is-a-commitments-fourth-part.md`,
  `1031-a-store-reads-the-form-before-it.md` and `1032-a-recorded-number-is-a-decimal.md`. 1030 is
  the lowest number no file and no branch has used: 1029 is the highest on any ref, checked across
  every local and remote branch on 2026-09-06. `docs/adr/README.md` gains three rows.
- **`CONTEXT.md`** — the Feature grill already landed six terms (**Kind**, **Number**, **Range**,
  **Note**, **Total**, **Target**) and amended **Commitment**, **Record**, **History** and
  **Untick**, all on `main`. This change adds nothing new to the vocabulary and stamps one
  amendment: **Store** — the entry that says what both stores have in common — gains the form rule,
  that a store reads the form written before it, leaves the file in that form until the next change
  is kept there, and refuses a form number no build ever wrote. It ships with this folder, in the G4
  diff, rather than waiting for the implementation.
- **`docs/open-questions.md`** is not this change's to write (`AGENTS.md` § *Agent roles*). Two
  entries are owed and `tasks.md` § 6 names them as a chore commit alongside the merge. The first:
  **a commitment of a kind nothing can yet record shows a dead row** — #142 may land before #139, and
  a person who chooses "number" on the commitments screen would then see a row that does nothing when
  tapped. Nothing in the shipped app can reach that state until #142, and #139 removes it, but the
  ordering makes it possible and no requirement forbids it. The second: the read-back gap's ninth
  face — `Commitment.kind` is public while `schedule` and `keptFrom` stay internal, so the entry
  listing the eight now has a fourth part that is readable and two that are not.
- **`docs/backlog.md`** — B-014 (*change a commitment*), B-029 and B-030 stay where they are;
  nothing here promotes one. This change does not edit that file.
- **No new dependency, no CI change, and no change to any command.**
