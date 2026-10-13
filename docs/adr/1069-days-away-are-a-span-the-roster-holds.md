# 1069. Days away are a span the roster holds, and their gaps are eras

- Status: accepted — taken while the delta of `say-days-away` (#401) was written, on 2026-10-12, on
  the answers of its Story grill and of the twenty-sixth grooming pass's Feature grill; this record is
  written by that Story and approved at its G4
- Date: 2026-10-12
- Deciders: Diego Bugmann
- Amended: 2026-10-13 — `change-days-away` (#402): days away can be said over past days, changed in
  every part and removed whenever. A change moves the gap's ends rather than erasing and saying
  again: days given back before the new first day go to the era held the day before the old one, and
  the era a commitment is taken up on moves with the day back. A span moved past a stop moves it to
  the day before the span in the eras, and — settled at G7, because the eras store that and a stop
  the day after a span alike, and made one model at the next G7 — a span remembers, per commitment,
  every stop made once it has begun or that its days come to hide, each with its take-up: none, a
  day, or the day back wherever it moves, falling back to the one it was taken up for where it would
  come no later than the day after the stop. Every give-back reads those and the eras outside the span,
  never what the last move left, and the store refuses only what no write could produce, checking
  nothing against the eras. § *Decision* and § *Consequences* are changed in place to say so; the
  decision stands.

## Context

**Days away** are a span of dates a person says, over the commitments they pick, on which those
commitments owe nothing (`CONTEXT.md` § *Days away*). The Feature grill made each commitment picked
take a **gap** over the span, so a day away means everything a gap means: no row, a weekly quota owing
only for the days it keeps, an every-N-days count beginning again on the day back. The Story grill
then made the span a thing of its own: listed, named or not, removed whole before it starts, kept
after it ends, carried by a copy, said on the day screen, left by a commitment that is stopped or
deleted, and kept through a change of rhythm.

A gap already exists in the roster, as two eras of one commitment with days between them, and every
reader of a commitment's days — a day's rows, a quota's standing and part weeks, a look-back — reads
it there. Until now every gap was in the past, because a stop and a resume are only ever made on the
day they are made.

## Decision

**The roster holds each days away beside its commitments, and gives each commitment picked its gap
as eras.** A days away carries an identity of its own, a name or none, a first and a last day, the
identities of the commitments it is over, and, for each, the stops of it that it remembers with
their take-ups. Saying it ends each picked commitment's era on the day
before the first day and begins a new one on the day after the last; changing it moves those two
ends, the era begun the day after the last moving with it; removing it, begun or not, re-forms those
eras as though it had never been said. Saying, removing, a change, a stop and a
deletion each form the next roster, eras and days away together, and write it in one write.

The roster form moves to 10, adding the list of days away; an earlier form reads as holding none.
Form 11 adds what each days away remembers; form 10 reads as remembering, for each stopped
commitment a span is over, a stop not taken up on the later of the span's last day and its own last
day kept. A copy nests
the roster form as written and keeps its own form.

## Consequences

- **A gap can now lie ahead**, so a commitment's newest era may be kept from a day after today. Every
  reader that met only past gaps meets one; the change and the interval shift had to learn it.
- **Removing is a re-forming, not a delete of two eras**: the era before the gap runs through it, so
  an every-N-days count runs on unbroken, and a change made since stands from the day it was made.
- **A span remembers stops, not a first day kept through.** A first day a commitment was kept
  through lives only in its eras, so a change keeps it only while the first day stays. The stops and
  take-ups a span remembers are the person's acts, which no change moves; the eras are formed from
  them on every move, so removing, unticking or moving a span, in any order, makes a commitment owe
  no day between a stop and its take-up, and a span moved back gives back what a move took.
- **The span and the gaps cannot drift apart at rest**, since one write carries both. What keeps them
  agreeing is that every act that moves either forms the other with it.

## Alternatives considered

- **The span alone, with gaps derived at read time.** Every reader of a commitment's days would learn
  a second kind of gap; the eras, which already carry one, would carry it no longer.
- **Gaps alone, with no span.** Rejected at the Story grill: a span's gap looks exactly like a pause,
  and nothing could list it, remove it whole or say it on the day screen.
- **The span in a store of its own.** It would not be written with the eras it gives, and a copy
  would need a sixth place.
