# Grill — add-screen-navigation

*7 questions over 2 rounds, 2026-09-04.*

## Settled

1. **The one `today` a day screen keeps splits into two.** The day it is showing and the day it
   is asked as of become separate things, and the screen holds both. *Not asked: this grill was
   owed the decision by `docs/open-questions.md` and the record settles it. A row refuses the tick
   for a day later than the day it is asked as of, and that day is the screen's `today`, so moving
   the screen by writing the same field would leave the tick asked as of the day being displayed —
   two steps forward and a tap would write a tick for a day that has not arrived.*
2. **The screen steps back as far as the calendar goes, and adds no bound of its own.** *Asked
   because the settled record question left "whether a screen offers all of it" to this
   capability. The 2026-09-02 grooming line had already answered the direction — "bounded by
   navigation rather than by a rule" — and any other bound is a rule the screen invents and has to
   restate whenever the roster changes. A day before anything was kept from simply has no rows.*
3. **It steps forward the same way, onto days that have not arrived.** *A row on such a day
   already refuses its tick, so a bound at today would be a second rule stacked on a refusal that
   already protects the record.*
4. **Being shown again keeps the day being shown rather than returning to today.** *Asked, and
   answered against the recommendation: "stay where you navigated — ideally also with a button to
   bring you back to today with a click." Being shown includes every app-switch, and losing the
   day you are filling in to a glance at another app is the cost that decided it.*
5. **Except that a screen on today follows.** A screen showing the day it was last handed as
   today moves onto the new day; a screen showing any other day keeps it. *This is what the
   existing shown-again requirement exists for — put the phone down on Monday night, pick it up on
   Tuesday morning, land on Tuesday. It needs no extra state: it is a comparison of the two days
   item 1 gives the screen. Stepping back onto today re-arms it. Surprising enough on a first
   reading to be worth an ADR, which is `spec-author`'s call.*
6. **A way straight back to today is in this Story**, and it goes to today only rather than to any
   given day. *Asked, and answered against the recommendation, in the same breath as item 4:
   stepping home costs a tap a day once the past is unbounded. Today only, because going to an
   arbitrary date needs something to pick one with and that screen does not exist. The day it
   returns to is the one the screen was last handed — it reads no clock, like everything else here.*
7. **A move with nowhere to go does nothing and leaves the screen exactly as it was**, and the
   screen says nothing about whether it can move either way. *The day view refuses rather than
   handing back the same day precisely so a caller can tell it has reached the end; a screen is
   stateful, so "stays where it is" is an answer where for a value it was not. The ends are
   1 January 1583 and 31 December 9999, so a pair of answers about them would be permanently true.*
8. **A move does not read the record again.** It forms the day view from the record the screen
   already holds, exactly as making a tick does. *Not asked: the existing requirements give the
   re-read to being shown alone, and a move is not a moment the record can have changed under the
   person looking at it. The way home is a move like any other in this respect.*
9. **The controls carry no requirement and are the shell's.** Two arrows and a way home are
   `tasks.md`'s, not a spec's. *Not asked: ADR-1019, and `add-screen-date` (#92), which drew its
   own title in `tasks.md` § 3 under no scenario.*

## Terms landed in CONTEXT.md

No new term. The two days a day screen now holds already have names — **today** and *the date a
day view is of* — and § *Today* already separates them, saying in as many words that "confusing
the two is what would let a screen offer a tick for a day that has not happened". What this grill
changed is that a day screen now keeps both rather than one, so four existing entries were amended
rather than a fifth added:

- **Today** — a day screen keeps a today *and* a day it is showing; the two coincided only while a
  screen could be on no day but today.
- **Day screen** — it holds the day it is showing as well as the today it was handed, moves one
  calendar day either way and straight back to today, and a move with nowhere to go leaves it as
  it was.
- **Shown** — no longer the only moment a day screen changes day, and it moves the day being shown
  only when the screen is on today.
- **Day navigation** — the same stepping, now something a day screen does and not only a day view.

## Left open

None. The one question the rounds raised and did not answer is whether the shell draws the two
controls as arrows, as a swipe, or as both — and that is a layout question with no requirement
under it either way, so it is the shell's and `tasks.md`'s, exactly as `add-screen-date` (#92)
recorded the same shape of question for its own title.
