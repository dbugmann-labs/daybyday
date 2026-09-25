# Grill — carry-birthdays-in-a-copy

*8 questions over 4 rounds, 2026-09-24. Grilled after #328 `draw-birthdays-on-day-screen` merged
(PR #336), which named the birthday place (`birthday-ticks.json`) and left copy, restore and a
tick's copy to this Story — its `design.md` § Non-Goals, "#329 owns all three".*

## Settled

1. **Who owns what, now that #328 has shipped.** This Story carries the birthday place in a copy,
   in a restore, in the take-out, in the copy place's stop, in the undo of a torn restore, and
   writes a copy at the copy place after a birthday tick. *First asked as a split with #328; the
   owner pointed out #328 had merged, and its design hands all of it here.*
2. **Restoring a copy of an earlier form, which holds no birthday ticks.** It holds none: the
   phone's ticks go, like everything else the copy does not hold. *Asked twice — the first
   recommendation wrongly assumed no tick could exist before this ships; asked again on the true
   premise (ticks made since #328 are lost by restoring an older copy), the owner kept it: whole,
   never merged, and the window closes on the first kept change after update.*
3. **The restore sheet.** It counts no birthday ticks, on either side, as it counts nothing of the
   record; it names them only where the phone's cannot be read. *A tick is history, and history is
   not counted there.*
4. **Birthday ticks that cannot be read, or were written by a later version.** They refuse the copy
   exactly as the other three stores do: the take-out is offered and carries the birthday file, and
   the copy place's stop names them. *A copy is whole or not at all; the alternative was a copy that
   restores as no ticks.*
5. **What the store is called on screen.** "birthday ticks" — *Your birthday ticks could not be
   read.*, *…were written by a newer version of DayByDay…*, *The birthday ticks could not be taken
   out.* *The birthdays are the calendar's; what the app keeps, and can lose, is the ticks.*
6. **The day screen's restore line.** A day screen says a copy can be restored because of its
   birthday ticks exactly while it is saying they could not be read — birthdays on and the calendar
   answered — and not while birthdays are off, where #328 keeps it silent, nor for a later-version
   file, as with the other stores. Said once however many stores are unread.
7. **Birthdays switched off.** Unreadable ticks refuse the copy and offer the take-out on the
   commitments screen whatever the switch says. *Turning birthdays off forgets nothing, so the ticks
   are still part of what a copy carries whole, and the commitments screen is where stored things
   are looked after.*
8. **The walk.** In the simulator, with birthdays off and a damaged `birthday-ticks.json`: the
   commitments screen with its refused copy and take-out naming the birthday ticks; the restore
   sheet saying under the phone that its birthday ticks cannot be read. On the phone, because the
   simulators cannot get calendar access today (`docs/open-questions.md`, found at #328's walk):
   tick a birthday, make a copy, take the tick back, restore that copy, and the tick is back on the
   day screen; tick a birthday, and the commitments screen's copy-place line shows a new last copy.

Not asked, because it was on disk: a birthday tick made or taken back is a change kept, so the copy
at the copy place follows it (`CONTEXT.md` § *Copy*, amended at #268); turning the switch on or off
writes no copy, since a copy holds nothing of the switch (`birthday/spec.md`, the switch
requirement); a restore that cannot be made whole leaves the birthday place as it was with the rest.

## Terms landed in CONTEXT.md

No new term. Amended, 2026-09-24: **Copy** (carried whatever the switch says, named *birthday
ticks*, followed by a tick, an earlier-form copy holds none), **Restore** (the ticks put back and
not counted; the day screen's restore line), **Take-out** (the birthday place is the fourth file).

## Layout

No layout question, the designer's finding: every surface this Story reaches already lists the
stores one caption line each — the refused copy, the take-out's causes and its refusal, the restore
sheet under *Your phone* after the one-offs line, the copy place's stop — and the birthday ticks add
one line in that order. The day screen already draws both its ticks line and *A copy can be restored
from Commitments*; Settled 6 changes when the second shows, not what the screen looks like. No
mockup was drawn.

## Left open

None. Every question the frontier raised was answered, and the one whose premise was wrong was
asked again on the true one.
