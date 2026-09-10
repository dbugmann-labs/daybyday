# Grill — add-adjacent-day-views

*14 questions over 3 rounds, 2026-09-10. Story #184. Two facts dispatched to agents; nothing below
was asked of the owner that either agent could have answered.*

The Story is owed by ADR-1043, which specified a day change drawn as motion played on release,
built it, put it on a phone and was rejected there — the drag itself did nothing, so the screen
read as unresponsive until the finger lifted. Paging under the finger is the remedy, and it needs
the kit to say the day either side of the one being shown without moving onto it. That answer is
this Story's delta. The paged `ContentView` is its immediate consumer and rides the branch.

## Settled

1. **The shape of the answer: two answers, beside `dayView`.** A day screen says the day view of
   the day before and the day view of the day after, as two answers alongside the one it already
   gives. *`Reach` folds two days into one answer because a caller must not derive one from the
   other; nothing here derives one neighbour from the other, so that reason does not carry, and no
   existing requirement or scenario that names `dayView` has to move.*

2. **At the ends of the calendar the answer is nothing on that side.** A screen showing
   1 January 1583 says no day before it; one showing 31 December 9999 says no day after it.
   *This deliberately narrows "A move with nowhere to go leaves a day screen exactly as it was",
   which today says a day screen SHALL NOT say whether it can move either way in any direction.
   The distinction is the one that requirement already draws for the way back to today: this is an
   answer about what the screen can draw, not about whether it can move. The shell needs the
   absence — it is what a drag at the end resists against.*

3. **Exactly one day either side, never a run.** *Each move lands before the next drag begins and
   the screen answers its new neighbours the moment it does, so a fast run of swipes is served
   without the screen holding more than three days.*

4. **A neighbour is drawn, never acted on.** The screen makes and takes back ticks, numbers, notes
   and additions on the day it is showing and on no other. *The existing rule that a row the
   screen's day view does not hold changes nothing gets most of the way there; the delta says the
   rest, so nobody later reads a drawn neighbour as a live one.*

5. **A neighbour's roster is asked about the neighbour's own day.** *This widens the existing
   MUST NOT — "MUST NOT ask the roster about the today or about any day other than the one it is
   showing" — to any day it is not drawing. A commitment stopped yesterday therefore has a row on
   the page arriving from the left and none on the day being stood on, so what is seen arriving is
   what is got when it lands. Forming a neighbour against the shown day's roster would make the
   page change under the person at the moment it landed, which is the one thing a page must not
   do.*

6. **A screen that cannot read a store still answers its neighbours**, formed exactly as the shown
   day is, from whatever the screen holds. *An unreadable record gives three days of rows saying
   nothing is kept; an unreadable roster gives three days of no rows. Withholding the neighbours
   would make a store failure silently take the gesture away as well.*

7. **What is told on a row ends at the landing, and only if the day changed.** A drag released
   early settles back and changes nothing at all, the notice included. *This is already what the
   kit does — `showPreviousDay` and `showNextDay` clear the notice only after their guard. Saying
   it makes explicit that the shell MUST NOT step the screen mid-drag to sample a neighbour:
   ADR-1043 rejected that approach precisely because stepping wipes a refusal the person has not
   read yet.*

8. **The chevron plays the same settle the drag ends with**, in the same direction — leftwards
   onto the next day, rightwards onto the previous. *A tap has no "during", so the evidence that
   rejected released motion does not reach it. One move drawn two different ways depending on how
   it was asked for is the worse outcome.*

9. **What pages is the day's rows; the header stays put.** The chevrons, the weekday, the day
   picker and the `Today` button are a fixed row of controls; the commitments beneath them page.
   *This is the home-screen model the owner named — the icons travel, the dock stays — and it
   needs nothing from the kit beyond the two answers above. The accepted cost: mid-drag the
   weekday still names the day being left.*

10. **The day picker always replaces, never slides**, including when the day picked happens to be
    one day away. *Same reason `Today` never animates (ADR-1043): a control that can jump any
    distance should not sometimes slide, or the drawing becomes a fact about the number of days
    rather than about the act.*

11. **Reduce Motion governs the played half only.** The drag goes on tracking the finger; the
    settle at release and a chevron tap become an instant change rather than a slide. *Apple
    documents no automatic Reduce Motion behaviour for SwiftUI paging at all, and the HIG lists
    "tracking animations directly with people's gestures" as a recommended way to reduce motion —
    direct manipulation is the mitigation, not the target.*

12. **The four decisions that outlive the Story amend ADR-1043** rather than opening a new record.
    *It is the file that posed two of them by name and named this Story as owing them; answering
    elsewhere makes a reader hold two files. Its status line also still reads "proposed" against a
    remedy now being built.*

13. **The paged `ContentView` rides this branch**, under ADR-1019's 2026-09-04 amendment, with its
    own named section in `tasks.md`. *So that G7 shows something that can actually be swiped.
    **With a rule-5 stop attached**: Apple documents nothing either way about nesting a vertically
    scrolling `List` inside a horizontally paging container — not supported, not unsupported, only
    the phone settles it. If the paging cannot be had without moving a line that could be wrong in
    a way a test would catch, that is reported and stopped, not pushed through. ADR-1019's guard
    does not move.*

14. **The whole day and never its rows** — inherited from ADR-1043 and restated because paging
    makes the temptation worse. The neighbour is a real list beside a real list, and handing the
    two to a diff is one line away. Nothing here changes the shell's `ForEach` keying or asks the
    kit to widen `DayView.Row`.

## Settled by derivation, not asked

- **The reach still bounds the picker and never the screen.** Paging back past the picker's
  earliest day is allowed, exactly as the chevrons already allow it — `openspec/specs/day-screen/spec.md`
  § *A day screen says the reach of its day picker* says so outright, so the neighbours are not
  floored by it.
- **A tick kept on the shown day cannot change a neighbour**: every record is held against a date.
  What does move all three together is a roster or record read — being shown again, or returned
  to — which follows from settlement 6.
- **A neighbour that is a day not yet arrived draws its rows recessed**, because the shell already
  asks each row `offersAnything(asOf:)` and ADR-1045 already says what offers nothing recedes.
  Nothing new is owed.
- **The drag at either end has nothing to page toward and settles back.** Whether it rubber-bands
  is the shell's to draw, and 1 January 1583 is not a day anyone reaches.

## Terms landed in CONTEXT.md

- **Adjacent day view** — the day view of the day before or the day after the one a **day screen**
  is showing, answered without moving onto it. There is none past either end of the calendar. It
  is formed exactly as the shown day's is, from the screen's record and from the commitments its
  **roster** had not stopped keeping *on that adjacent day*, so it is what the screen would hold
  had it been moved there. A day screen draws nothing and acts on nothing through it: every tick,
  number, note and addition is still made on the day being shown. Agreed 2026-09-10 at the grill
  of `add-adjacent-day-views` (#184).

  § *Day navigation* is amended alongside it: the day change that "draws no motion" now **pages
  under the finger** for a drag and plays the same settle for a chevron, while the `Today` button
  and the **day picker** both replace where they stand.

## Left open

None. Every question the frontier raised was answered, and the two questions ADR-1043 handed this
grill by name — what a chevron tap draws, and what Reduce Motion governs — are settlements 8 and
11 above.

**One risk is carried forward rather than left open**, because it is a fact about the platform and
not a question for anyone here: nesting a vertically scrolling `List` inside a horizontally paging
container is undocumented by Apple in both directions, and the app target is iOS 26.0. Settlement
13 says what happens if it does not work.
