# 1066. A shift is part of the commitment

- Status: accepted — taken while the delta of `shift-a-due-day` (#392) was written, on 2026-10-07;
  this record is written by that Story and approved at its G4
- Date: 2026-10-07
- Deciders: Diego Bugmann

## Context

A **shift** puts one due day of a commitment on a free day of its week (`CONTEXT.md` § *Shift*).
Whether a commitment is due on a date is answered in one place, `Commitment.isDue(on:)`, and that
answer is asked everywhere a due day matters: a tick, a number, a note and an addition each refuse
to form on a day their commitment is not due; a history re-forms a tick to say whether a day is
kept; a day view drops what is not due; a look-back walks the days an era says are due; and the
change sheet refuses a change that would leave a recorded day not due.

The record store writes each record beside the commitment it was made against and re-forms it
through those same refusals when it is read. A record that does not form refuses the whole store,
which is the store's protection against holding what could not be a history.

So a shift kept anywhere but on the commitment would leave every one of those askers answering
"not due" on the day it landed on: a tick there could not be made, and one made by another path
would make the record store unreadable the next time the app opened.

## Decision

**A shift is part of the commitment, beside its schedule, and `isDue(on:)` answers it.** A date a
shift took a due day from is not due, a date it put one on is due, and every other date answers
its schedule. Every era of a commitment carries the same shifts, as it carries the same name, so
the answer does not depend on which era is asked or on an era beginning between a shift's two days.
Identity stays the whole of equality: two values of one commitment differing only in shifts are the
same commitment.

**Each store keeps the shifts it needs and no more.** The roster store writes every shift on every
era. The record store writes, beside a record on a day a shift put due, the day that shift took it
from — enough for the record to re-form — and nothing beside any other record, so a history does
not grow with every shift ever made.

## Consequences

- **Every asker is right without being touched.** Ticks, entries, look-backs, the day view and the
  recorded-day refusal all ask the commitment they were handed, and that commitment knows.
- **Both store forms move**, the roster's and the record's, each additively: an earlier form reads
  as holding no shift. A copy nests both as written and needs no form of its own.
- **Equality cannot see a shift.** Nothing may decide whether to write, redraw or carry by comparing
  commitments, entries or rosters; a day view's row stores its shift for exactly that reason.
- **A shift outlives the era it was made in.** One whose day is today survives a rhythm change made
  today, its landing still due in the new era; one made in an era later replaced still answers on
  its own two days.

## Alternatives considered

- **Shifts held by the roster beside the commitment, as usual amounts are.** Every one of the askers
  above would need the roster as well as the commitment, and the record store, which has no roster,
  could not re-form a record on a landing day at all.
- **A shift as a one-week era with its own weekday set.** No new concept on disk, but a day of the
  month cannot be said as a weekday set, the row could not say where its day came from, and every
  shift would draw an era boundary through the look-back.
- **Every shift written beside every record.** Simplest for the record writer; the history would
  then grow with the product of records and shifts.
