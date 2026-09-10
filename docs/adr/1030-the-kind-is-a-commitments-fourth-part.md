# 1030. The kind its days take is a commitment's fourth part

- Status: accepted
- Date: 2026-09-06
- Deciders: Diego Bugmann
- Amended: 2026-09-09 — B-014 was taken and this record's revisit trigger fired; a commitment gained
  no identity, and the kind is still the one part no change reaches

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
  is *changing a commitment* — B-014's want — and a changed commitment is a different commitment.
  *Kept until* is the opposite: it is set by an act a person performs on a
  commitment they are already keeping, which is precisely why it re-keys. **B-014 has since been
  taken and this sentence is what survived it** (2026-09-09): a person can now change a name, a rhythm
  and a day kept from, and the kind is the one part of the four that no change reaches. The changed
  commitment is still a *different* commitment — that is exactly how the change is carried — so the
  ground this decision stands on is untouched.
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
- **A kind cannot be changed**, and the day someone wants to the answer is a new commitment, which
  starts a new history. That cost is real and is the price of the stability above, and it is now the
  one place where that is still the answer.

  **The revisit this record named has happened, and the trigger's premise did not.** B-014 was taken
  by `add-commitment-editing` (#148) on 2026-09-09, and a commitment gained **no** identity of its own:
  changing a part still re-keys its records, and that is met head-on rather than avoided. A **name** or
  a **day kept from** is changed by forming a second commitment and having `record` **carry every
  record of the first over to it**, all of them or none, before the roster puts the second where the
  first was — so nothing is orphaned, because afterwards every record embeds a commitment the roster
  still holds. A **rhythm** is changed by the roster **superseding**, which carries nothing over at
  all: the old commitment is kept until the day before and held removed, and every past day goes on
  answering against the value it was written against. ADR-1023 carries the mechanism and is amended in
  the same diff.

  **The kind takes neither route, and that is this record's answer rather than an omission.** A
  carry-over refuses where a record could not be a record of the second commitment, and a record of one
  kind is never a record of another — so a kind change would refuse for every commitment that has ever
  been recorded against, and succeed only for one that has not, which is a change nobody needs and a
  rule nobody could predict. Superseding would work mechanically and would say something false: it
  would put a weight and a mood under one name in one place as though the second replaced the first,
  when what a person means by changing the kind is that they want a different thing recorded. The
  answer stays a new commitment.

  **A further revisit would need a different trigger from this one**, because this one has fired. The
  shape that would move this decision is a commitment gaining an identity of its own — the same
  condition, still unmet — and the two records to amend in place would still be this one and ADR-1023
  (ADR-1020).
- **Every file written before this change stays readable**, because the plain kind is the default and
  the form before this one holds no kind at all. ADR-1031 carries how.
- **A fifth kind is a compile error rather than a silent gap**, because the kind is an enum with
  associated values converted through an exhaustive `switch` in one place, the same property
  `ScheduleRecord` already gives a fifth schedule shape.
