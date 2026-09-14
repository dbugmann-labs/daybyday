# 1052. A one-off follows today until it is done

- Status: accepted — decided by the owner at the Feature grill of B-049 on 2026-09-14, against the
  recommendation; this record is written by `add-one-off` (#242), the Story that first implements it,
  and approved at its G4
- Date: 2026-09-14
- Deciders: Diego Bugmann

## Context

A one-off is a name and a date for something owed once and never again (`CONTEXT.md` § *One-off*).
Everything the app held before it recurs, so the question this record answers had never come up:
**what does a one-off do on the day after its date, still undone?**

A commitment's answer is already settled and does not carry over. A due day left unticked is a miss,
it stays in the day it belongs to, and the commitment comes round again on its next due day — which
is what makes leaving it behind harmless. A one-off has no next day. Whatever is decided here is the
whole of what a person sees, and there is no technical answer to it: the engine can put the row on
any day it is told to.

`CONTEXT.md` § *Product principles* pulls both ways. *Nothing congratulates you* and the app's
refusal to reproach argue against a row that accumulates in front of someone; *the day screen is the
whole of the day* argues that something still owed has to be somewhere a person will look.

## Decision

**A one-off stands on exactly one day at a time, and while it is undone that day follows today.**
In full:

- **Undone, it stands on the later of its date and today** — its own date while that date is still
  to come or is the today itself, and today, wherever today has got to, once its date has passed.
- **Done, it stands on the day it was ticked, for good.** That day never moves again.
- A one-off that nobody holds stands on no day at all.

The day it stands on is therefore a question asked **as of a today**, answered from the one-off, its
tick and that today alone — no clock is read inside the engine, and the answer is a function of its
arguments.

**The recommendation at the grill was the opposite** — leave it on its date and let a past day show
it undone, as a commitment's miss does — and the owner overruled it: a thing owed once, left on a
day that has gone, is invisible the moment the day turns, and it still has to be done.

## Consequences

- **A past day draws an undone one-off nowhere.** Only the day it stands on draws it, so a past date
  shows the one-offs ticked there and no others. The row a person sees on that date after ticking it
  is the record of having done it.
- **A one-off's tick records the day it was done, not the day it was owed.** The date is still what
  it was owed on, which is why a row says its date where that is not the day being shown — a fact
  rather than a reproach (`CONTEXT.md` § *One-off*).
- **A one-off is never made done on a day before its date**, however it is made done: a record of
  having done a thing before it was owed cannot be true, and it would put the day it stands on
  before its own date. This corollary was taken by `add-one-off` at Stage 4 rather than at the
  grill, and it is the cheapest part of this record to reverse.
- **The same past day can draw differently on two different days.** An undone one-off dated last
  Tuesday is on today, so Tuesday's screen changes the moment it is ticked. Commitment rows never
  move like that. Accepted: it is the price of the thing not being lost, and it is why nothing in
  the engine may cache an answer that was asked as of a different today.
- **An old undone one-off is with a person every day until they act**, which is the nearest this
  app comes to nagging. The lesser harm was judged to be the nag; a person who no longer wants it
  removes it outright, in one act, which is why removal takes a done one with its tick.
- **Reversing this is a behaviour Story against one requirement and five scenarios** — *A one-off
  stands on exactly one day at a time* — plus whatever a day screen draws by then.

## Alternatives considered

**It stays on its date and reads as missed there**, exactly as a commitment's unticked due day does.
One rule for both kinds, nothing follows anybody, and a past week reads as what actually happened.
Rejected by the owner: a one-off that has fallen off the bottom of yesterday is gone, and the form
still has to go back.

**It disappears once its date has passed.** The cheapest of all and the most honest about the date
being over. Rejected outright — losing something a person wrote down is the failure this product
exists to remove.

**The person re-dates it.** Keeps every row where the person put it and needs no rule. Rejected
because it makes a person do by hand what the app can answer, and because a one-off is never
re-dated: removing one and adding it to another day is two taps (`CONTEXT.md` § *One-off*).

**It follows today only for a while — a week, say, and then it drops.** Rejected as a rule nobody
asked for, with a number nobody could defend, that loses things quietly at the end of it.
