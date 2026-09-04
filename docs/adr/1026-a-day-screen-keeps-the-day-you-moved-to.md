# 1026. A day screen keeps the day you moved to, except when it is on today

- Status: accepted — the decision was the owner's at the Story grill of `add-screen-navigation`
  (#93) on 2026-09-04, answered against the recommendation; this record is written by that change
- Date: 2026-09-04
- Deciders: Diego Bugmann

## Context

Until this Story a day screen was on exactly one day: the one the phone's clock handed it when the
app came to the front. `openspec/specs/day-screen/spec.md` says so — "A day screen SHALL hold that
day until the app is shown again, and SHALL be moved onto another day by nothing else" — and the
requirement that re-reads on being shown adds "This SHALL be the only moment a day screen changes
day."

That rule exists for a good reason, and it is a small one worth stating: put the phone down on Monday
night with the app open, pick it up on Tuesday morning, and land on **Tuesday**. Nothing else in the
product reads a clock (ADR-1004), so being shown is the only moment a day can arrive at all.

`add-screen-navigation` gives a person a second way onto another day: they move there themselves. The
two ways now collide, because **being shown again is not only the next morning**. It is every glance
at another app: a message, a call, a photo checked mid-sentence. On iOS that is `scenePhase` going to
`.active`, and it happens many times an hour.

So: someone is filling in last Thursday, which they missed. Their phone buzzes. They read the
message and come back. What day is the screen on?

Three answers were available.

**Always return to today.** One rule, no state, and the screen is never quietly somewhere the person
has forgotten about. This was the recommendation put to the owner. Its cost is the scenario above:
the work in progress is the day you navigated to, and an app-switch is a normal part of doing it. You
come back to today and have to navigate again — and if you were four days back, four times.

**Never return to today.** Also one rule. Its cost is the Monday-night-to-Tuesday-morning case,
which is the *most common* thing that happens to this app and the reason the shown-again requirement
was written in the first place. A person who never navigates would find the screen showing yesterday
every morning, for ever, which is worse than the failure the first answer has.

**Return to today only from today.** Two behaviours, one comparison.

## Decision

**Being shown again keeps the day the screen is showing, except that a screen showing its today
moves onto the new day.**

The owner's answer, in his words: *"stay where you navigated — ideally also with a button to bring
you back to today with a click."* Both halves were taken: the day survives, and
`add-screen-navigation` also carries a way straight back to today in one step rather than deferring
it, because once the day survives, stepping home is what makes the survival cheap.

**It needs no state of its own.** The same Story splits what a day screen holds into two days — the
**today** it was handed, and the **day it is showing** — for an unrelated and stronger reason: a
screen that moved by writing its today would ask every *as of* question as of the day being
displayed, and a tap would then offer a tick for a day that has not arrived. Given those two days,
the exception is `shownDay == today`, evaluated before the new today is assigned. There is no flag,
no "has been moved" bit, and nothing to reset: a screen stepped back onto today, or sent back to it,
is in exactly the state a screen that never moved is in, and greets the next morning the same way.

## Consequences

- **A day being filled in survives an app-switch**, which is the failure this record exists to
  prevent and the one the owner named.
- **The morning still lands on the morning.** A person who never navigates sees no change at all
  from the behaviour shipped by `add-day-screen` (#91), and the shown-again scenarios written for it
  pass unedited.
- **One comparison produces two opposite behaviours, and that is the surprising part.** A reader
  meeting `if shownDay == today { shownDay = day }` will reasonably wonder why the day sometimes
  follows the clock and sometimes does not. Both "fixes" — always assign, never assign — break one of
  the two cases above. That is the whole reason this file exists.
- **A screen can be left on a day that is not today, indefinitely.** Accepted knowingly. Two things
  make it survivable, and neither is optional: `add-screen-date` (#92) put the day on the screen in
  words the day before this Story, so a person can always read where they are; and the way home is in
  this Story rather than a later one, so getting back is one tap. Removing either would make this
  decision wrong.
- **The exception is invisible to a caller.** A day screen answers no question about whether it is
  on today — no `isShowingToday`, no way to ask what it would do next time it is shown. What it says
  is its day, in words, which is the thing a person reads. Adding the predicate would be adding
  surface no requirement asks for.
- **Reversal trigger.** If the owner is observed repeatedly finding the app on a day he did not mean
  to be on — reaching for the way home as a reflex on opening — the answer is not to reset on every
  showing but to make *where you are* harder to miss, since resetting reintroduces the loss this
  record was written to prevent. A time-based middle answer ("return to today after an hour away")
  was considered and rejected outright: it is a rule about the clock in the one capability that reads
  none, and the number could not be defended.
