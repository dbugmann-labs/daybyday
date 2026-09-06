# 1030. The kind its days take is a commitment's fourth part

- Status: accepted
- Date: 2026-09-06
- Deciders: Diego Bugmann

## Context

`FEAT: record` (#53) was reopened on 2026-09-06 for three kinds of record beside the tick: a
**number** for a weight or a mood, a **note** for a sentence about the day, a **total** for protein
accumulated across it. Every one of them needs the same thing answered first — **where does a
commitment say what its days take?** — and that question was the one thing the Feature grill and the
commitment lifecycle (B-029) had in common.

The obvious answer is "on the commitment", and until this change it was the forbidden one.
**ADR-1023 refused a fourth part**, for *kept until*: a tick embeds the whole commitment by value, so
a commitment part that changes re-keys every tick already recorded, orphaning the history for that
commitment on every day it was ever kept. *Kept until* is held one level up, on the roster, for
exactly that reason.

That argument is sound and it has to be met head-on rather than quietly stepped around, because a
kind on the commitment is structurally the same move ADR-1023 rejected.

## Decision

**A commitment is four things: a name, a schedule, the day it is kept from, and the kind of record
its days take. The kind is on the commitment, and ADR-1023 stands unamended.**

Two facts separate a kind from *kept until*, and both are load-bearing:

- **A kind never changes once the commitment is defined.** There is no operation that moves a
  commitment from one kind to another, and there is deliberately none. Changing what a person keeps
  is *changing a commitment* — B-014's want — and as things stand a changed commitment is a
  different commitment. *Kept until* is the opposite: it is set by an act a person performs on a
  commitment they are already keeping, which is precisely why it re-keys.
- **Every commitment that existed before kinds did is of the plain kind.** A commitment formed
  without a kind named is a tick, so every record already written is a record of a commitment whose
  kind is `tick`, and reading a file written before this change back with `tick` on every commitment
  reproduces exactly the commitments that were there. Nothing already recorded is re-keyed, and no
  history reads empty.

Together those give the property ADR-1023 was protecting: **the value a record embeds is stable for
the life of that record.** A fourth part that cannot change does not break it; a fourth part that can
does.

The kind is readable back, like the name and unlike the schedule and the kept-from day. A row has to
know what to offer before anything has been recorded, and a screen has to draw what a commitment is;
a kind nobody can read is a kind that may as well not be there.

## Alternatives considered

**Hold the kind on the roster, beside *kept until*.** The move ADR-1023 made, and the one to beat.
Rejected because it puts the answer out of reach of everything that needs it: a `Tick`, a `History`
and a `DayView.Row` are handed a commitment and never a roster, so a row could not tell a weight from
a press-up, and `record` could not refuse a tick for a number commitment — the refusal that stops a
day reading as kept because someone tapped a weight. It also says something false about the domain: a
kind is what a commitment *is*, while *kept until* is something a person did to one.

**A fifth schedule-like type, so that "weight, weekly" is one value.** Rejected as a category error.
A schedule answers *which days*; a kind answers *what those days hold*. Folding them would multiply
four schedule shapes by four kinds into sixteen cases and would put a range and a weekday set in the
same type.

**Leave the kind out of a commitment's identity, so two commitments alike in three parts are one.**
Rejected: a weight and a mood on one rhythm under one name would then be indistinguishable to the
roster, which is the exact condition the roster's duplicate refusal exists to prevent — nothing could
say which of the two a screen was pointing at. Identity is all four parts.

## Consequences

- **Two commitments differing only in kind are two commitments**, so a roster holds both, and the
  duplicate refusal judges four parts rather than three.
- **A kind cannot be changed**, and the day someone wants to — B-014 — the answer is a new
  commitment, which starts a new history. That cost is real and is the price of the stability above.
  **The trigger for revisiting this decision is B-014 being taken**: if a commitment ever gains an
  identity of its own, so that changing a part does not re-key its records, both this ADR and
  ADR-1023 are amended in place rather than superseded (ADR-1020).
- **Every file written before this change stays readable**, because the plain kind is the default and
  the form before this one holds no kind at all. ADR-1031 carries how.
- **A fifth kind is a compile error rather than a silent gap**, because the kind is an enum with
  associated values converted through an exhaustive `switch` in one place, the same property
  `ScheduleRecord` already gives a fifth schedule shape.
