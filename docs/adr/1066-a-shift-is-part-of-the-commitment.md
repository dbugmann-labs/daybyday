# 1066. A shift is part of the commitment

- Status: accepted — taken while the delta of `shift-a-due-day` (#392) was written, on 2026-10-07;
  this record is written by that Story and approved at its G4
- Date: 2026-10-07
- Deciders: Diego Bugmann
- Amended: 2026-10-08 — `shift-an-interval-day` (#393): an every-N-days shift runs its count on from
  where it landed, the record store keeps that shift beside every record its count reaches, and the
  roster form moves with no change of shape so an older app refuses it

## Context

A **shift** puts one due day of a commitment on a free day (`CONTEXT.md` § *Shift*, § *Free day*):
one of its week for a weekday set or a day of the month, one between the due days either side for
every N days, whose count then runs on from where it landed.
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
its schedule — an every-N-days schedule counting from the latest day on or before the date that a
shift of one of its own due days put a due day on, in place of its start date. A shift counts as one
of its own where the day it took the due day from is on or after that start date, so a shift made
under an older interval never reaches a new one, and one made before a range or target change,
which keeps the count, still does. Every era of a commitment carries the same shifts, as it carries the same name, so
the answer does not depend on which era is asked or on an era beginning between a shift's two days.
Identity stays the whole of equality: two values of one commitment differing only in shifts are the
same commitment.

**Each store keeps the shifts it needs and no more.** The roster store writes every shift on every
era. The record store writes, beside a record on a day a shift put due, the day that shift took it
from — enough for the record to re-form; beside a record on a later day an every-N-days count
reaches from a landing, both days of that shift, for the same reason; and nothing beside any other
record, so a history does not grow with every shift ever made.

## Consequences

- **Every asker is right without being touched.** Ticks, entries, look-backs, the day view and the
  recorded-day refusal all ask the commitment they were handed, and that commitment knows.
- **Both store forms move**, the roster's and the record's, each additively: an earlier form reads
  as holding no shift. The every-N-days shift moves both again — the record's for the landing kept
  beside a later record, the roster's with no change of shape, because an app reading the earlier
  form would take an every-N-days shift for a weekday one and answer the wrong days due. A copy
  nests both as written and needs no form of its own.
- **The roster store's week rule spares an every-N-days shift** where an era holding either of its
  days runs every N days, or no era holds either. A rule judged by the era holding one day alone
  would refuse a whole store after a change made on that day.
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
- **An every-N-days shift as an era begun where it landed**, as a restart is kept. The day it came
  from would still need the map to say where it went, every shift would draw an era boundary, and
  each would read as a later change to the next.
- **An every-N-days shift written as a new start date on its era.** Every due day of that era before
  the shift would move under the records already kept on them.
- **Every shift written beside every record.** Simplest for the record writer; the history would
  then grow with the product of records and shifts.
