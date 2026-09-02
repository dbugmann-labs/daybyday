# 1010. A weekly quota is due every day, and completion is not a schedule question

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann

## Context

`CONTEXT.md` records four rule shapes the product needs: a set of weekdays, every N days, a day of
the month, and **N times within a week on any days**. ADR-1004 fixed the seam all four answer at —
`Schedule.isDue(on: CalendarDate) -> Bool`, a pure function of a year, a month and a day, with no
clock, no time zone and no history — and `add-weekday-set-schedule` (#8) claimed that seam would
carry all four without moving.

The first three fit it without argument, because each is a function of the calendar alone. The
fourth does not obviously fit it at all, and the design documents of #8, #9 and #10 each ended with
the same sentence: *"#11 may still not fit this seam — a weekly quota needs tick history."*

The reason is the product behaviour the shape comes from. `docs/parking-lot.md` records it in the
owner's words: *"reading — an obligation of three times a week, any nights, open until the week
turns over."* Read literally, such a commitment is due until three completions exist and then quiet
until the week turns — which is a function of a date **and** of everything ticked before it. That is
not what ADR-1004 put at the seam, and answering it there would break the writable past `CONTEXT.md`
insists on: ticking today would change what yesterday's screen says about yesterday.

So the question is not "how do we implement a quota", it is **what a quota can honestly mean when
the only thing you are given is a date.**

## Decision

**A weekly quota is due on every calendar date, and whether the week's quota has been met is not a
question the `schedule` capability answers.**

A schedule decides *which days a commitment runs on*. A quota constrains *how many times*, not which
days, and the honest answer to "which days does 'three times a week, any nights' run on" is *all of
them*. The quota's number is a second fact about the commitment rather than a fact about a date, so
`isDue(on:)` does not consult it: `.weeklyQuota(1)`, `.weeklyQuota(7)` and a weekday set naming all
seven days are indistinguishable through the seam, and that is correct rather than a defect.

Three consequences are part of the decision rather than incidental to it:

- **The limitation is normative, not advisory.** It is written into
  `openspec/specs/schedule/spec.md` as requirement prose — that this capability does not answer
  whether a quota has been met, and that a surface hiding a completed quota must decide it from tick
  records. A design document would have been archived out of the reader's path; a requirement is
  what the next agent reads.
- **The seam does not move, and #8's claim is discharged.** All four shapes answer
  `isDue(on: CalendarDate) -> Bool`. Widening it to take a completion count was considered and
  rejected below.
- **A quota is one to seven.** Zero is a commitment with nothing to do and eight is a promise no
  week can keep, because a day records at most one completion of a commitment. Out-of-range numbers
  are refused at construction, the stance `CalendarDate`, `DayOfMonth` and `DayInterval` already
  take.

This ADR takes effect when the Story that carries it merges. It records an answer the repo owner
gives at G4, alongside the change folder it belongs to; if that answer had been *wait for ticks*,
this file would have been deleted with the branch rather than superseded.

## Consequences

- **A consumer that draws every due commitment will show a three-times-a-week commitment on all
  seven days of its week** — correct for the first three, unhelpful for the last four. This is the
  cost, it is stated in the spec rather than hidden, and it is the day screen's to fix with ticks.
- **`schedule` is finished as a capability at four shapes**, and every commitment on the owner's
  day-one list can be expressed by one of them.
- **A future "has this week been met?" belongs somewhere else** — a capability that can see ticks —
  and arriving there is an addition rather than a reversal of this decision. Nothing here forecloses
  it, and no signature has to change for it to exist.
- **Where a week begins is still undecided, and this decision is why.** Because a quota is due on
  every date, no week boundary is ever consulted, so the question cannot be settled by any test in
  this capability. It stays in `docs/parking-lot.md` for the first Story that counts ticks within a
  week. This corrects three earlier design documents that assigned the question to the quota Story.
- **Reversing this is expensive**, which is why it is an ADR rather than a line in a design document
  that gets archived: the alternatives all touch either the signature every rule shape shares or the
  vocabulary the product is defined in.

## Alternatives considered

**Make due-ness depend on what has been ticked** — the literal reading of the product behaviour.
Rejected on a fact rather than a preference: it makes due-ness a function of a date plus a
commitment's whole history, which the seam does not take, and it makes a past day's answer change
after the fact, which `CONTEXT.md` forbids and which #10 already rejected once when it declined to
anchor an interval to the last tick.

**Widen the seam to take a completion count**, `isDue(on:completedThisWeek:)`. Rejected because it
taxes the three shapes that cannot use the argument — the same tax #10 refused when it declined to
give every shape a start date — and because nothing in the system can compute the argument: no tick
record exists, so every caller would pass zero until one did. A signature designed around a value
nothing can supply is speculation with an API attached.

**Give the quota a type of its own, outside `Schedule`**, so that no caller can ask `isDue` of a
quota and be misled by the `true`. The strongest of the alternatives, and it buys real type safety.
Rejected because it contradicts vocabulary already agreed with the owner — `CONTEXT.md` names four
*schedule* shapes and the quota is one of them — and because it moves the problem rather than
removing it: a commitment would hold either a schedule or a quota, and every consumer would switch
over that pair, which is the enum that already exists with one more layer around it. The safety is
bought more cheaply by the spec stating what `true` does and does not mean.

**Ship nothing until ticks exist.** Genuinely defensible: a shape whose number nothing reads is a
data carrier, not behaviour. Rejected because the wait has no end date — no tick capability, Story
or spec exists, and `FEAT: day-screen` has not been decomposed — while the next Story on the tracker
defines a commitment as a name and a schedule, and without this shape would ship a commitment type
unable to express one of the eight commitments the product was specified from.
