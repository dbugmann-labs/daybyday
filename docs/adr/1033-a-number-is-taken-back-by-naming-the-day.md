# 1033. A record is taken back by naming the commitment and the day

- Status: accepted
- Date: 2026-09-06
- Deciders: Diego Bugmann
- Amended: 2026-09-08 — widened from the number to any record taken back by naming its day; the note follows this shape, and the total is now the only kind that will not

## Context

`add-number-record` (#138) gives a number commitment's day a record, and every record in this product
can be **taken back** — `CONTEXT.md` § *Record* says so, because a tap that cannot be undone is a
permanent false record. The tick already has its shape:

```swift
public mutating func remove(_ tick: Tick)
```

A caller hands back the same value it added. That works for a tick because a tick is *nothing but* a
commitment and a calendar date: whoever wants to take one back already knows both, so re-forming the
tick costs nothing and the history's own storage — a `Set<Tick>` — takes exactly that.

A number has a third part. Copying the tick's shape would give
`removeNumber(_ number: Number)`, and a caller would have to build a `Number` carrying the value it
wants gone. That is the whole of the question this record answers, and it was put to the owner at the
Story grill on 2026-09-06 because it decides a public signature that #140's note and #141's total
will each copy or contradict.

**#140's note copied it, on 2026-09-08**, and that is what this record was amended for. A note has a
third part too — its text — and it is longer and less memorable than a number, so every argument
below reads more strongly for it than for the number it was written about. A record reading as
number-specific while two kinds follow it is one a later reader has to reconstruct, so it is written
here as what it always was: a rule about **a record whose day names it**.

## Decision

**A record is taken back by naming its commitment and its date, and never by naming what it holds.**

```swift
public mutating func removeNumber(for commitment: Commitment, on date: CalendarDate)
public mutating func removeNote(for commitment: Commitment, on date: CalendarDate)
```

- A day holds **at most one record per commitment**, so the commitment and the date name it exactly.
  There is nothing the third part could disambiguate.
- **A person who entered the wrong thing must be able to clear it without reading it back first.**
  Someone who meant 70.5 and entered 300 wants the day empty; requiring them to hand back 300 makes
  undoing a mistake depend on knowing what the mistake was. A screen would have to read the record,
  hold it, and hand it back — three steps where the day is already in front of them. For a note the
  same argument is stronger still: handing back a paragraph exactly in order to delete it is a
  requirement no caller should carry, and the one place a note can be read is the entry the person is
  standing in.
- **Taking back where nothing is there is nothing, not an error**, exactly as *Untick* already says.
  That covers a day nothing was entered on, a commitment whose kind is not the record's, and a date
  the commitment is not due on.
- The name is `removeNumber` and `removeNote`, not overloads of `remove`. An overload set where one
  member takes a value and another takes two coordinates reads as an oversight rather than a
  decision, and two members that differ only in the type of a value they do not take could not be
  told apart at a call site at all.

**The tick keeps its own shape.** It is not changed to match, and that asymmetry is the point rather
than a wart: a tick has no third part, so `remove(_ tick:)` already names a day and nothing is gained
by rewriting a signature that eleven scenarios and every existing test are written against.

## Alternatives considered

**`removeNumber(_ number: Number)` — symmetry with the tick.** Rejected on the mistyped-number
argument above. Symmetry of signature is worth less than a caller that can clear a day it can see,
and the symmetry is false anyway: the two types do not have the same number of parts.

**One `remove(_ record: Record)` over a shared record type, taking the whole record for every
kind.** Rejected as premature when this was written, because two of the four kinds did not exist;
still rejected after #140, and the reason has narrowed to one kind. A total's take-back is *removing
its last addition* rather than removing the record at all, and its record is a list rather than one
value, so a general signature designed over a tick, a number and a note would be designed over three
records that are all "one value keyed by day" and would have to be redesigned the moment the fourth
arrived. Fixing it now would fix it around a record nobody has grilled.

**`History.clear(for:on:)`, taking back whatever the day holds of any kind.** Rejected: it would take
back a tick and a number through one call, and a commitment has one kind, so the call could only ever
reach one of them. It reads as more general than it is.

## Consequences

- **`History` carries three take-back shapes**, `remove(_ tick:)`, `removeNumber(for:on:)` and
  `removeNote(for:on:)`, and will carry a fourth as #141 lands. That is the cost, and it is visible
  in one file.
- **#140 copied this shape and #141 is expected to**: a note is taken back by naming the day, and a
  total loses its last addition — which is `for:on:` again, with a different verb. When all four
  exist, the general shape they share is worth naming, and the tick will be the one that has to be
  brought into line.
- **A screen never has to read a record in order to remove it.** That is what #139's row needed and
  what #140's needs more, and it is what makes "take it back" one gesture on a day rather than a read
  followed by a write.
- **The reversal trigger is the fourth kind, and only the fourth.** #140 was not it: a note is a
  third record of the same shape and moving to a general take-back over three lookalikes would have
  been the premature fix rejected above. When the **total** is recordable, a single take-back over a
  shared record type may be worth having, and the tick would move with it. Amend this record in place
  when that day comes (ADR-1020); do not add a fifth signature quietly.
- **The filename says `a-number-is-taken-back` and the title no longer does.** Deliberate:
  `openspec/changes/archive/2026-09-07-add-number-record/tasks.md` § 8 names that path, and
  `.claude/settings.json` denies editing anything under `openspec/changes/archive/`, so a rename
  would leave a dead path in a file nobody may fix. Cross-references resolve by number
  (`docs/adr/README.md` § *Numbering*), and this file's number has not moved.
