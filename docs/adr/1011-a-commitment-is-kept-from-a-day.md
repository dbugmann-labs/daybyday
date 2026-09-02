# 1011. A commitment is kept from a day, and is not due before it

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann

## Context

Three of the four schedule shapes are built, and every one of them is a function of the calendar
and nothing else. A weekday set is due on every Monday there has ever been; a day-of-month rule is
due on the 25th of every month back to 1583, the first year the engine supports. Only the
every-N-days shape carries a date of its own, and `add-every-n-days-schedule` (#10) gave it one —
a start date — with a requirement that it is not due before it, for a reason it stated plainly: a
rule reaching backwards manufactures a history of misses that never happened. That reasoning was
scoped to the interval shape, and #10 said in as many words that the general case — *what happens
to days before a thing existed* — was not its Story to answer. `docs/parking-lot.md` has carried
the question since 2026-08-28.

`add-commitment-type` (#42) is the Story that defines what a commitment is, so it is the last
honest place to leave the question open. Without an answer, a commitment created this afternoon on
"Mon/Wed/Sat" answers *due* for every Monday, Wednesday and Saturday since the sixteenth century.

That would not merely be untidy. DayByDay has no streaks and no congratulation; the entire signal
it gives a person is which due days carry a tick and which do not, so **an unticked due day is what
a miss looks like.** A rule anchored only to the calendar therefore opens the record with hundreds
of failures nobody could have avoided, in a product whose one job is to say honestly what was
actually kept.

The question was put to the owner as a question round at Stage 4, with the recommendation that the
commitment stay two things — a name and a schedule — and that "this did not exist yet" be answered
later, by whatever stores commitments and therefore knows when each was created. He answered
against it: *"I don't want to have due ticks in the past I was never able to fulfill because the
commitment was not there yet."*

## Decision

**Every commitment carries a calendar date it is kept from, and is not due on any date before it.**

The rule is a floor, applied ahead of the schedule: on the kept-from day and after it, the
commitment is due exactly when its schedule is due; before it, the commitment is not due whatever
the schedule says.

Four things are part of the decision rather than incidental to it:

- **It is required, with no default.** The engine cannot default it to "today" — ADR-1004 keeps the
  clock at the edges, and a rule that consulted the present moment would stop giving a past day the
  same answer tomorrow that it gives now. Nor can it default to an epoch, which is the fabricated
  history this decision exists to prevent, reintroduced for every caller who omits the argument.
- **It is not a creation timestamp.** It is the day the person began keeping the commitment, which
  they may set in the past: someone who has been going to the gym since June and only writes it down
  in September says June. Calling it a created-on date would make backdating look like falsifying an
  audit trail rather than stating a fact.
- **It is a floor, never a phase.** It does not have to be a day the schedule is due on, and it does
  not shift the schedule to begin there. A commitment kept from a Tuesday on a Mon/Wed/Sat rule is
  first due that Wednesday.
- **It does not replace the every-N-days start date.** An interval commitment carries two dates
  doing two jobs: the start date decides which dates the rhythm lands on, the kept-from day
  suppresses landings earlier than itself. A start date of 25 August under a floor of 1 September is
  a rhythm whose first three occurrences are simply never owed.

## Consequences

- **The engine stays pure.** The floor is a value the commitment carries, not something the rule
  reaches outside itself for, so `isDue(on:)` remains a function of a calendar date exactly as
  ADR-1004 requires — the same property #10 established for the interval's start date.
- **Due-ness stays in one place.** The alternative would have put a second due-ness rule in whatever
  draws a day, so that answering "is this owed" needed both the engine and the screen. Every screen
  and every stored tick now rests on one predicate.
- **The word "start date" is now taken twice over, so a second word was needed.** The schedule's is
  a *start date*; the commitment's is the day it is **kept from**. They can hold different values on
  one commitment, and a shared name would make the one place they interact unreadable.
- **Every caller must supply a day**, including tests and every future edge that creates a
  commitment. This is intended: a missing floor is the failure mode, so it is made impossible rather
  than defaulted.
- **The parking-lot question is half answered.** *What happens to days before a thing existed* is
  settled for due-ness. Its other half — how far back the past stays writable, which is about ticks
  and storage — is untouched by this and remains open.
- **An end date is not implied and is not decided here.** A floor is not a window. Nothing has asked
  for the other side of one, and a commitment that has been stopped is a different idea from one
  that has not started.

## Alternatives considered

**Leave it out; let storage answer it.** The recommendation the round carried. A commitment stays a
name and a schedule, and the day screen suppresses rows for commitments that did not exist on the
date being drawn, using a creation date the store already has. Rejected by the owner, and the
argument for rejecting it is stronger than the argument that was made for it: the suppression has to
happen on every row of every past day regardless, so the only question was whether the rule lives
next to the other due-ness rules or somewhere else. Splitting it would mean neither the engine nor
the screen could answer "is this owed" alone.

**Anchor every schedule shape instead, by giving the weekday-set and day-of-month shapes start dates
of their own.** Puts the floor where the interval already keeps one, so there is one concept rather
than two. Rejected because it is the same fact stated three times, and because it is a fact about
the commitment rather than about the rule: two commitments sharing a "Mon/Wed/Sat" schedule but
begun in different months would need two schedules that are otherwise identical.

**Make the floor a phase, so the schedule begins at the kept-from day.** Rejected because it changes
what the schedule means. A commitment kept from a Tuesday on a Mon/Wed/Sat rule would become due on
Tuesdays, which is not what its owner wrote down, and an interval's start date would be silently
overridden by a date chosen for an unrelated reason.
