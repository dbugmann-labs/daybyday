# 1068. A decline holds its day's place, and gives it up to any other record

- Status: accepted — taken while the delta of `decline-a-due-day` (#400) was written, on 2026-10-11,
  on the answers of its Story grill and of the twenty-sixth grooming pass's Feature grill; this
  record is written by that Story and approved at its G4
- Date: 2026-10-11
- Deciders: Diego Bugmann

## Context

A **declined** day is a due day a person chose not to keep and said so, with an optional reason
(`CONTEXT.md` § *Declined*). The Feature grill made it a record of its own, never keeping, and ruled
that a day is kept or declined, never both: keeping a declined day replaces the decline, and a
decline taken back leaves the day holding nothing. The Story grill added that a decline is offered
only on a day holding nothing — not a tick, a number, a note, nor a total's additions short of its
target — and that a stop made on a declined day keeps the commitment until that day, as a tick does.

Until now every record kept its day, a total by reaching its target, and the history held four kinds
side by side, one per commitment per day. A day of a total could already hold additions without
being kept, which is the one precedent for a record that does not keep.

## Decision

**A decline is a fifth record, held by the history and the record store beside the other four, and
it holds its day's place alone.** A history never holds a decline beside another record of the same
commitment on the same day, and the two directions are not symmetric:

- **A decline never overwrites.** Added where the day holds a tick, a number, a note or an addition,
  it leaves the history as it was. A typed value is never lost to a decline; to decline a ticked day,
  the tick is taken back first.
- **Every other record overwrites a decline**, an addition short of its target included. The history
  is then the same value as one never given the decline, so taking that record back leaves the day
  holding nothing, which is what the shipped take-backs already say of a history never given it.

A decline is a record wherever "a record" is asked of a day: it refuses a shift, it keeps a stopped
commitment until the day it stands on, it is carried over, erased by a deletion, and blocks a change
that would leave its day not due. It is never asked whether a day is kept, so a look-back counts it
as unkept until a later Story counts it apart.

The record form moves to 9, adding a list of declines beside the four kinds; an earlier form reads as
holding none. A copy nests the record form as written and keeps its own form.

## Consequences

- **The reason is drawn at rest.** A declined row says its reason under its name, cut to one line,
  against the number and note rows' rule that a row draws nothing of its value. The owner chose it
  at the Story grill, knowingly: the why is what tells a declined day from a forgotten one.
- **Every place the code enumerates the four kinds by hand must learn a fifth** — a history's
  recorded dates, its carry-over, its erasure, a row's record test and a copy's forming. A generic
  "record" in a spec does not reach them.
- **A weekly quota is never declined**, so a standing and the slack mark need no rule for one.

## Alternatives considered

- **A decline as a flag on the day rather than a record.** It would need a second store or a fifth
  field on every record kind, and a stop, a shift and a deletion would each need it named apart.
- **A decline overwritten by nothing**, so keeping a declined day first needs a take-back. Rejected
  at the Feature grill: keeping the day is the act that matters and must be one tap.
- **A decline overwriting whatever the day holds.** Rejected at the Story grill: a typed number or
  note would be lost to a menu item.
- **Both held, the decline beside a record.** A day would then be kept and declined at once, which
  the Feature grill ruled out.
