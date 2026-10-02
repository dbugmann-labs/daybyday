# Grill — change-or-take-back-occurrence

*13 questions over 5 rounds, the last the layout round, and one fact agent, 2026-10-02.*

## Settled

1. **Taking back asks first, always.** A confirmation — "Take back this occurrence?" — before
   every take-back, a note or not. *The owner chose it over the record's immediate take-back; an
   occurrence can carry a typed note that goes with it.*
2. **A change can clear.** The time back to no time and the note back to none, both. *An
   occurrence may hold neither already, so a change can return it there.*
3. **The wrong happening is taken back and noted again.** A change never moves an occurrence to
   another happening — only its time and its note change, as moving to another day is already a
   take-back and a note (`CONTEXT.md` § *Occurrence*).
4. **Reached by tapping the happening row.** It opens that day's occurrences of that happening,
   each with its time and its note; tapping one opens it. The row stays the one #376 shipped.
   *#376 left the row's tap free for this Story (its grill Q15).*
5. **On today a changed time is bounded at now, as noting is.** A later time is refused with the
   same words, "That time has not come yet." *One rule for a new occurrence and a changed one.*
6. **One occurrence that day opens directly.** No list of one. *The change view says its time
   and note anyway.*
7. **The change view is the noting sheet, filled in.** The occurrence's time and note in place;
   Save keeps the change, Cancel leaves it untouched, and a destructive *Take back* at its foot
   asks (1) before acting. *One sheet to learn.*
8. **Cancel discards silently**, as noting does. *The occurrence is untouched; nothing kept is lost.*
9. **The list says them in the row's order** — earliest time first, then each with no time.
   *It reads the same as the row tapped.*
10. **The list notes nothing.** Noting stays with the bolt button alone. *Outside the intent.*
11. **Saving or taking back lands on the day**, never back on the list. *The act is done and the
    row shows it; a second change is one more tap.*
12. **The walk, eight pictures, no `phone:` line.** (1) a day holding two Kopfweh occurrences;
    (2) the list after tapping its row, times and notes; (3) one opened, filled in; (4) the row
    after its time is changed; (5) the take-back confirmation; (6) the row with one left;
    (7) tapping it again opens that one directly; (8) after the last is taken back, no row.
    *Nothing here is a drag or a feel only the phone shows.*

Facts the fact agent settled, recorded so `spec-author` need not re-find them: an occurrence has
no identity of its own, and two alike in every part are both held — so changing or taking back
either of two alike is the same act, and no identity is needed for it (#376 `design.md` deferred
minting one to here). The day view's happening row carries no occurrence today, only a name and
its times in words. Happenings are in no copy until #380, so a change writes none.

## Terms landed in CONTEXT.md

- **Happening row** — amended: a tap now opens that day's occurrences of its happening.

## Layout

Option B, a row popover, chosen from three at https://claude.ai/artifact/B4ckFo2bkooA2SHKfqZGDC —
*the app already opens a row's contents in a popover anchored to the row (the chosen-values
popover), so the day and the tapped row stay in view and the filled-in noting sheet is the only
sheet; the take-back question rises at the foot, as "Discard changes?" does.* The change sheet
opens with the keyboard down, so it never covers *Take back* — a layout choice, not a
requirement. The wireframe follows, verbatim from the designer; the times and note are examples.

```
B · Row popover   (recommended)
              [☰ ⚙]
Friday
Today, 2 October 2026
‹ M28 T29 W30 T1 (F2) S3 S4 ›
┌ Creatine - Every day
│ …
└ Weight - Every day  ›
┌ Kopfweh · 09:10, 18:40        ← tapped
   ╭─▲──────────────────╮       popover under the row, the day stays
   │ 09:10            › │
   │ Hinter dem Auge    │
   │ links              │
   │ 18:40            › │
   ╰────────────────────╯       tap outside closes it
( New one-off              ) (⚡)
tap one → popover closes, noting sheet rises filled in:
[Cancel]   Kopfweh    [Save]
┌ Time          [09:10] ⓧ
┌ Hinter dem Auge
│ links
│
└ Take back                     red, at the sheet's foot
Take back → dialog rising at the foot:
┌ Take back this occurrence?
└ Take back                     red
┌ Cancel
```

## Left open

None for the owner. Every question the frontier raised was answered. Where an occurrence stands in
the order noted once changed, and what a refused take-back or change says when the write fails,
are the delta's, not preferences, and go to `spec-author`. So do three the drawing turned up: what
a listed occurrence says with no note (drawn as its time alone) and with no time (drawn "no time",
as the row says), and the confirmation's button words (drawn *Take back* and *Cancel*).
