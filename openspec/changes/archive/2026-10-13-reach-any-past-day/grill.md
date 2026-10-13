# Grill — reach-any-past-day

*5 questions over 2 rounds, 2026-10-13, the second the layout round, and three fact agents; on top of 8 questions over 5 rounds at
the B-082 grooming pass the same day, whose answers are carried here so this file stands alone.*

## Settled

### Carried from the B-082 pass (`docs/backlog.md` § *Decided*, 2026-10-13)

1. **What the owner was reaching for.** Entering a one-off of something done, and noting an older
   happening, on a day before the first kept-from day. *The specs already allow both on any past
   day and draw them there; the day swipe reaches those days and the picker and strip do not.
   ADR-1048's one reason for the floor, "a run of empty years", is wrong for that reason.*
2. **How far back.** The day picker and the week strip reach every past day to the calendar's
   start, 1 January 1583, as the day swipe does. No floor, no horizon. *A horizon re-creates the
   mismatch further back; a floor at the earliest entry of any kind is circular.* So a day before
   the first kept-from day is no longer drawn faded on the strip, and paging back no longer stops
   at the floor's week.
3. **The reach as a term.** Retired, with no new term in its place. *With no floor it only ever
   says "opens on the day shown, reaches the calendar's start".* ADR-1048 is **amended**, not
   superseded, per `docs/adr/README.md`'s amendment rule; the pass's "supersede" was the
   conductor's error and is corrected here.
4. **A mark on the earliest kept-from day.** The week strip marks the earliest day anything on the
   roster is kept from. *Chosen by the owner against the conductor's recommendation of no mark,
   so a person can tell they have gone back before tracking began.*
5. **Which day.** The roster's existing answer, *A roster answers the earliest day anything it
   still holds has been kept from*: stopped commitments count, deleted ones do not. *The pass
   said "stopped and removed"; removed is a retired state and § Reach was never updated. A
   deleted commitment's records are erased, so its days hold nothing and the mark would point at
   nothing.*
6. **Where.** The week strip only. The day picker stays the stock SwiftUI graphical `DatePicker`,
   which cannot mark a day; replacing it with a `UICalendarView` was declined.
7. **No new term.** The marked day is described in place under *Day picker* and *Week strip* in
   `CONTEXT.md`.

### This grill

8. **A future earliest kept-from day is marked.** One rule: the mark sits on that day wherever it
   falls, past, today or future. *It then reads as where tracking begins; hiding it would need a
   second rule.*
9. **No kept-from day, no mark.** An empty roster marks nothing, and nor does a roster that cannot
   be read, since both answer that there is none. The picker and the strip still reach every past
   day. *Falling back to the today, as the reach did, would mark a day where nothing began.*
10. **The walk: four screens, no `phone:` line.** (a) The strip on a week before the first
    kept-from day, every day drawn plainly and tappable; (b) the strip on the week holding the
    mark; (c) the picker open on a month before the first kept-from day, those days pickable;
    (d) a one-off entered on a day reached that way. *No new gesture, so nothing only a phone
    can prove.*

11. **VoiceOver says nothing of the mark.** A strip day's spoken label stays its full date, as it
    does for the days-away dot. *Asked at the layout round, since words would be a string the
    screen says.*

### Found while drawing, for `spec-author`

- **The neighbour weeks carry the mark too.** While a strip page slides, the shell draws the week
  coming in from `previousWeekStrip` or `nextWeekStrip`; a mark only the shown week carried would
  pop in when the page lands.

### Facts found, not asked

- **The mark and the days-away dot never fall on the same day.** Days away are refused over a
  commitment kept from their first day or later, and a stop or deletion takes the commitment out
  of them, so every day away lies strictly after the earliest kept-from day.
- **Readers of the floor in the kit**: `showDay(_:)` refuses a day earlier than the reach (the
  strip's tap goes through it), the backward week page lands on the reach, and the strip's offers
  are computed from it. The shell reads the floor in one place, the picker's range.
- **What is left not offered on the strip**: the day being shown, and a day past either end of the
  calendar, which holds no date.
- **Paging back to the calendar's start** has a forward twin to mirror: past the last date a page
  lands on that date, and where no week follows it leaves the screen as it was.
- **No helper gives the calendar's first day** as a date; only `DayScreen`'s private
  `lastSupportedDate` exists for the other end.

## Terms landed in CONTEXT.md

None in this grill. *Reach* is retired and *Day picker*, *Week strip* and *Date row* are amended
by `spec-author` with the delta, since they describe shipped behaviour until the Story lands.

## Layout

Option B, a short dash under the number, chosen from three at
https://claude.ai/artifact/Ufy5JFguE11pzsDuYe7phK — *it takes the days-away dot's slot, which is
always free on the marked day, and is drawn as the dot is, so the strip gains no new place to
draw; the owner judged the dash and the dot apart side by side.* The wireframe follows, verbatim
from the designer; everything on the screen but the strip is unchanged.

```
B · Dash under
  ‹   M    T    W    T    F    S    S   ›
     (14)  15   16   17   18   19   20
                ▬         ·                    a short grey dash in the dot's slot under the number
  shown on the marked day:
  ‹   M    T   (W)   T    F    S    S   ›
      14   15  (16)  17   18   19   20
               (▬)        ·                    the dash inside the capsule, in its text colour, as the dot is
```

`( )` is the filled capsule of the day being shown, and `·` is the days-away dot.

## Left open

None. Every question the frontier raised was answered, the layout included.
