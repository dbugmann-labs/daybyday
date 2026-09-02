## Why

`schedule` (#6) can answer *is this rule due on this date* three ways, and there is nothing to ask
it about. A schedule with no commitment attached to it is a rule about nobody's gym: the day screen
(#27) cannot draw a row from one, because a row needs a name, and no tick can be recorded against
one, because a tick is recorded against a thing rather than against a rule. `commitment` (#26) is
the capability that supplies the missing half, and this Story is the whole of it — the Feature has
exactly one Story, so what lands here is what a commitment is.

It is a small type and a short delta, and that is the point of doing it before the day screen rather
than inside it. Three of the four Stories in `schedule` wrote the phrase *"a commitment whose
schedule is …"* into normative prose without anything in the repository being one. This change makes
the word real, and fixes what every screen after it will assume about it.

Two questions in it were not the agent's to close and went to the owner as a **question round**.
Both came back on 2026-09-02, and **the first came back against the recommendation**: a commitment
carries a third thing, the day it is kept from, and is not due before it. His reason is the one the
round existed to surface — *"I don't want to have due ticks in the past I was never able to fulfill
because the commitment was not there yet."* Without it, a commitment created this afternoon on
Mon/Wed/Sat answers *due* for every such day back to 1583, and since an unticked due day is what a
miss looks like, the product would open with a history of failures nobody could have avoided. That
answer is written up as **ADR-1011**, which this proposal undertook to do if it went this way. The
second came back on the recommendation: a name is stored exactly as typed, never trimmed.

## What Changes

- Creates the `commitment` capability with its first requirements: a commitment is a name, the
  schedule it runs on, and the day it is kept from; it is due on a calendar date exactly when that
  schedule is, from that day onwards.
- **Adds the floor that stops the product inventing a history.** A commitment is not due on any date
  before the day it is kept from, whatever its schedule says about that date. The floor is required
  and has no default — the engine may not consult the clock (ADR-1004) and an epoch default would be
  the fabricated history reintroduced. It is deliberately not a creation timestamp: someone who has
  kept the gym since June may say June.
- **Keeps the every-N-days start date and the kept-from day distinct**, because they do different
  jobs: the start date decides which dates an interval lands on, the floor suppresses landings before
  itself. Nothing in `schedule` changes, and an interval starting 25 August under a floor of
  1 September is a rhythm whose first three occurrences are simply never owed.
- **Fixes that a commitment carries nothing beyond those three.** No identifier of its own, no
  position in a list, no paused or archived state, no tick history. Two commitments alike in all
  three are the same commitment — the observable way of saying there is no hidden identity, and the
  thing that stops a `UUID` being added on reflex.
- **Fixes that due-ness from the floor onwards is pure delegation.** A commitment adds nothing to its
  schedule's answer there, so the fourth rule shape (#11) and any shape after it are answered without
  a requirement changing here. The name never enters the rule.
- Makes a nameless commitment unrepresentable rather than a blank row: a name that is empty or made
  only of whitespace forms nothing, and — per the round's second answer — every other name is stored
  exactly as it was given, with no trimming and no length, script or emoji restriction.
- Adds one public type to `DayByDayKit` beside `Schedule`. `Schedule.isDue(on:)` does not move, does
  not change signature, and gains nothing; `CalendarDate` gains nothing either, public or internal,
  because the floor comparison is answered by the internal `days(until:)` that #10 already added.
  This change adds the package's second seam rather than widening the first.
- **Not in this change:** the weekly quota (#11); ticking, and anything that reads a tick; an end
  date, a pause or a window — a floor is not one; a list of commitments, their order, or uniqueness
  among them; editing, renaming, archiving or deleting one; storage and the SwiftData/GRDB question
  `docs/open-questions.md` still holds open; reading a schedule or a kept-from day back out of a
  commitment to render it; anything on screen.

## Capabilities

### New Capabilities

- `commitment`: what a commitment is to DayByDay — a name, the schedule it runs on and the day it is
  kept from — and how it answers whether it is due on a calendar date.

### Modified Capabilities

None. `schedule`'s requirements are untouched: they are stated about schedules, and the prose in
them that already says *"a commitment whose schedule is …"* is describing the same relationship this
capability now defines from the other side. The every-N-days start date in particular keeps its
meaning exactly. Nothing in `openspec/specs/schedule/spec.md` needs a word changed, so CI check 2 has
exactly one claimed capability.

## Impact

- **Code:** `src/DayByDayKit/Sources/DayByDayKit/` only. One new file, `Commitment.swift`, holding one
  public struct. No change to `Schedule`, `CalendarDate`, `DayOfMonth`, `DayInterval` or `Weekday`, no
  change to `Package.swift`, no new dependency in either language.
- **Specs:** creates `openspec/specs/commitment/spec.md` at archive time, and touches nothing else.
- **Tests:** nineteen acceptance tests in a new `Tests/DayByDayKitTests/CommitmentTests.swift`, one
  per scenario, taken one at a time. The existing forty-five tests are untouched and must stay green.
- **ADR:** `docs/adr/1011-a-commitment-is-kept-from-a-day.md`, written with this change and listed in
  `docs/adr/README.md`. It records the floor, its three consequences, and the two alternatives that
  were weighed — answering it in storage, and anchoring every schedule shape instead.
- **`docs/open-questions.md`:** two entries move, and neither is this change's to write. Under *Open
  product questions*, **How far back the past stays writable** is now half answered — the clause
  *"and what a day before the commitment existed shows"* is settled by ADR-1011 and should be struck,
  while how far back the past stays writable is about ticks and stays open. Under *Known gaps*, **A
  schedule's payload cannot be read back out** grows a third case: a `Commitment` gives back neither
  its `Schedule` nor its kept-from day, for the same reason `DayOfMonth` does not give back its day,
  and the first Story that renders a rule widens all of them in one delta.

  These paths are new. `docs/parking-lot.md` was replaced on 2026-09-02 by `docs/backlog.md` and
  `docs/open-questions.md` (ADR-1010), which landed on `main` while this Story was being written and
  collided with it — see the branch's second commit.
