# Grill — add-day-picker

*10 questions over 3 rounds, 2026-09-09.*

## Settled

1. **The floor bounds the control, never the screen.** The chevrons, the swipe and `showToday`
   keep stepping as far back and as far forward as the calendar goes. *The existing requirement "A
   day screen moves the day it is showing one calendar day either way" says in terms that a day
   screen adds no bound of its own and must not stop at the earliest day a commitment its roster
   answers with is kept from; that requirement stands unchanged. `add-offered-today-control` (#174)
   already drew this line — a screen answers about a control without the position being bounded.*

2. **The earliest day the picker reaches is the earliest day anything on the roster has been kept
   from.** *The Story's intent, and B-040's decision at the sixth grooming pass.*

3. **Every commitment the roster holds counts, the stopped and the removed included.** *Their days
   still hold records that were kept, and a floor that rose when a commitment was retired would put
   a day you actually kept out of reach.*

4. **Where there is nothing to take an earliest day from, it is the today the screen was handed.**
   *That case is a roster that cannot be read — on a first launch the screen takes on the
   commitments it was handed, so a floor exists. The screen keeps drawing the control rather than
   going dark, which is how it already behaves when it cannot read a roster.*

5. **Where the day being shown is earlier than that day, the picker reaches back to the day being
   shown instead.** The earliest end is the earlier of the two. *Settled 1 makes this routine rather
   than exotic: the chevrons step below the floor freely. A control that opens on a day it says it
   cannot reach is incoherent, and a person who stepped below it can always get back.*

6. **The earliest day is read again whenever the roster is, and a rise never moves the screen.** If
   it rises above the day being shown — a commitment edited, the roster read again on being returned
   to — that day stays showing and the control simply offers less than the day you are on. *A screen
   that moved under someone looking at it is worse than a control that reaches shorter.
   `add-screen-navigation` (#93) rejected bounding navigation on this ground; settled 5 and 6
   together are what let the bound exist at all.*

7. **A pick of a day earlier than the picker reaches leaves the screen exactly as it was.** Not
   clamped to the earliest day. *The same answer the calendar's two ends already give; clamping shows
   a day nobody asked for.*

8. **The screen answers with one offer about the control, rather than giving out the day it is
   showing as a bare fact.** *The day screen has twice refused to give out either the today it was
   handed or the day it is showing, and that refusal is why the screen itself answers whether the
   way back to today is offered. The picker follows the same pattern instead of reversing it.*

9. **The picker is always offered.** *Forward it reaches to the last supported date, so there is
   always another day to pick; a "whether it is offered" answer would be yes on every day anyone
   will ever look at, which is the ground `add-screen-navigation` (#93) refused `canShowPreviousDay`
   on.*

10. **It is a day picker, and what it says about itself is its reach.** *The commitments screen
    already has a date picker — the one that seeds a commitment's kept-from day — and the sixth
    grooming pass called this one a date picker too. Two controls under one name is the collision
    the glossary exists to stop.*

## Inherited, not asked

Recorded so the delta does not re-open them.

- **Open forward, and its own control.** B-040, at the sixth grooming pass: "the date picker is its
  own control, floored at the earliest kept-from day and open forward, and not a calendar grid" —
  beside the `Today` button rather than on the day title. Forward reaches the last date the system
  supports; there is nothing past it to bound.
- **A pick of the day already being shown changes nothing, so a notice on a row survives it.**
  Already answered by "What a day screen tells on a row lasts until the app is shown again, a change
  is kept, or the day it is showing changes": the rule is the day being shown *changing*, never the
  gesture made.
- **The today does not move on a pick**, and every question asked as of a today is still asked as of
  it. Already answered for every other move.

## Terms landed in CONTEXT.md

- **Day picker** — the control a day screen offers for reaching a day without stepping through every
  day between; its own control, always drawn, and not the commitments screen's date picker.
- **Reach** — what a day screen says about its day picker: the day it opens on and the earliest day
  it reaches. Bounds the control and never the screen.

## Left open

None. Every question the frontier raised was answered, and the three questions that turned out to
have answers already on disk are under *Inherited, not asked* above rather than in the round.
