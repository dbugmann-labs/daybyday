# Grill — page-the-week-strip

*11 questions over 4 rounds, 2026-09-28. Two were overtaken by the answer to Q3 and are recorded
as such; a fifth, drafted for round 1 and never asked, died with the same answer.*

## Settled

1. **The gesture.** A horizontal swipe on the strip itself pages it. Nothing new is drawn, and no
   arrows come back. *The day swipe lives on the rows, not the head, so the two gestures sit on
   different parts of the screen; the chevrons left in #346.*
2. **How far it pages.** Back as far as the week holding the reach's earliest day, and forward as
   far as the calendar goes. *A week of seven faded days is a dead page; the reach is open forward.*
3. **A page moves the day.** This reverses the premise of the B-065 grooming pass, #346's grill and
   #347's own intent sentence, all of which said the strip pages *without* moving the shown day.
   *The owner: "I want, when the strip is paged, that the day moves as well - it's more intuitive
   for me".* It is what Calendar's week row does, and it removes the one state the old reading
   needed: a week on screen with no day shown in it. `CONTEXT.md` § *Week strip* is amended, and
   #347's intent sentence is rewritten to match.
4. **Leaving the screen while paged.** *Overtaken by 3.* Answered "the paged week is kept" under
   the old premise; with a page moving the day there is no paged week to keep.
5. **Where a page lands.** *Superseded at G7 by 12.* On the Monday of the new week. *The owner chose Monday over the same
   weekday, the recommendation.*
6. **A page whose Monday is earlier than the reach.** It lands on the reach's earliest day instead,
   so the reach's week can always be paged to; once the shown day's week is that week, a swipe back
   does nothing.
7. **A page into the week holding the today.** *Superseded at G7 by 13.* It lands on the today, whichever direction it came
   from — over the Monday, and over the earliest day. *The owner, adding to 6: "if the week has
   'today' in it, it should land on today"; the scope was confirmed as every page into that week.*
8. **The today against the reach.** *Moot after G7: 13 drops the today's exception.* Where every commitment is kept from a later date and the reach's
   earliest day falls after the today, a page into the today's week still lands on the today.
   *`Today` shows the today whatever the reach, so the strip refuses nothing the screen offers
   anyway.*
9. **The motion of a page.** The strip slides under the finger to the other week; once it lands the
   rows are replaced where they stand, with no slide. *The strip is what is being dragged, and the
   rows' neighbour page is the next day, not the next week.*
10. **The strip under a day swipe.** Unchanged from #346: a swipe on the rows that carries the day
    into another week redraws the strip in place once the day lands. The strip slides only when it
    is the thing being dragged. *#346's W.6 was walked and accepted at G7.*
11. **The walk.** *Superseded at G7 by 18.* Three pictures, on a fresh install where everything is kept from Friday 4
    September 2026: from today, the strip swiped left — the next week's Monday in the capsule, its
    rows, `Today` in the toolbar; swiped right from there — back on today; swiped right until the
    week of 31 August — Friday 4 September in the capsule, 31 to 3 faded. One `phone:` step: the
    strip follows the finger and the rows swap once it lands; a swipe that starts on a day's number
    does not tap that day; one more swipe right in the third picture does nothing.

The question drafted for round 1 and never asked — which month a paged week is in, given the strip
says none and the date row says the shown day — died with 3: the date row moves with the day.

### Consequences drawn from rules already on the record, not asked

- **Left is the week after, right the week before**, as on the rows (the 2026-09-08 swipe line in
  `docs/backlog.md`).
- **A page is a day move like the others.** It commits a focused one-off field for departure
  first, as a swipe, `Today`, the day picker and a strip tap do.
- **A swipe that starts on a day's number must not also tap it.** B-064 is this defect on the rows.
- **Past the calendar's ends there is nothing to page to**: the week of 31 December 9999 has no week
  after it, and the week of 1 January 1583 has no dated Monday, so 6 lands a page into it on the
  earliest day.

### Facts the answers rest on

- The strip is a plain `HStack` in `dayControls`, a sibling of `pagedDayContent`; the day swipe
  (`DragGesture(minimumDistance: 40)`) is attached only to `pagedDayContent`, so a drag on the strip
  is not contested today (`src/DayByDay/DayByDay/ContentView.swift`, `weekStrip` and
  `.simultaneousGesture(daySwipeGesture…)`).
- The kit's `DayScreen.weekStrip` takes no parameter and holds the shown day's week only;
  `showDay(_:)` is the tap's target and returns without moving below the reach's earliest day
  (`src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift`). No public way to move by a week exists.
  The seam's shape is `spec-author`'s.
- `Today` is offered exactly where the shown day is not the today (`offersGoingBackToToday`), and a
  strip tap, `Today` and a day picker pick all replace the day with no animation; only the day swipe
  slides.

## Settled after G7

*Four rounds, 7 questions, the third the layout round, on 2026-09-28, asked after the owner walked the first build on the phone and
answered G7 with changes. It reopens G4.* The owner's words: "I would actually like to still have
the chevrons to click thorugh weeks"; "when swiping, I think the day should stay the one it is (not
always hop on monday)"; "it's not ideal that the monday of the next week is already marked as
selected.. therefore, during the swipe, 2 pills are filled out, which is confusing".

12. **Where a page lands, again.** On the same weekday of the new week. *Replaces 5; the capsule
    keeps its column.*
13. **The today's week.** No exception: a page into it lands on the same weekday too, not on the
    today. *Replaces 7; `Today` is one tap away.*
14. **A weekday that cannot be shown.** It lands on the nearest day there is: the reach's earliest
    day paging back (6 stands), and the calendar's last day, Friday 31 December 9999, paging forward.
    *Every week a page can reach can be landed in.*
15. **The week sliding in.** Marks no day as shown until it lands; the today keeps its mark if it is
    in that week. *Two filled capsules at once read as two days chosen.*
16. **The chevrons come back, for weeks.** A chevron tap is a page, the same as a swipe: same
    landing, same edges, same selection tick. Where a page would do nothing the chevron is drawn
    faded and takes no tap. *The owner, having used the swipe alone; round 1 had declined "both".
    Where they sit is the layout round's.*

17. **A chevron tap's motion.** The strip slides a week over, as a finished swipe does, and the rows
    are replaced where they stand once it lands. *The two ways of paging look like one; a page is
    always exactly a week, so the rule that a jump of any distance must not slide is not broken.*

18. **The walk, redone.** Supersedes 11. Four pictures on a fresh install, everything kept from
    Friday 4 September 2026: today, with the chevrons either side of the strip; `›` tapped — the same
    weekday of the next week in the capsule, `Today` in the toolbar; the strip swiped right from
    there — back on today; `‹` tapped until the week of 31 August — Friday 4 September in the
    capsule, 31 to 3 faded, `‹` faded. One `phone:` step: a swipe follows the finger from its first
    movement with no hop, and the week sliding in has no filled capsule; a chevron tap slides the
    strip; a tap at either screen edge beside the strip does not page; `‹` in the fourth picture
    does nothing.

### Defects the owner found on the phone, not questions

- **A tap at the strip's left screen edge pages to the week before.** The owner: "on the left edge,
  however, when I click, it goes to the previous week (while keeping the weekdday that was
  previously selected)". The right edge is clean.
- **The swipe hops before it follows the finger.** The owner: "it feels a bit weird that the
  'scrolling' does not start fluently, but it 'hops' a bit at the beginning".
- The reviewer's finding 1 of the re-review: a code comment counts the wrong sentence of a
  requirement. Comment-only.

## Terms landed in CONTEXT.md

- **Week strip** — amended: a page moves the day, where it lands, how far it goes, and how it moves;
  rewritten at G7 for the same weekday, the chevrons and the week sliding in. No new term.

## Layout

Option A, beside the strip, chosen at G7 from three at https://claude.ai/artifact/WDABFfjUCLnVw7tdomKRdR,
**against the designer's recommendation of B** (a pair at the end of the date row). *The owner chose
the chevrons next to the thing they move; the costs the designer named and the owner took are a
narrower strip, a capsule that turns into an upright pill, and a `‹` on the left screen edge where
the stray-tap defect sits.* The pictures before G7 were judged against #346's archived wireframe,
since the first grill drew nothing new; the designer's "no layout question here" at that grill was
not recorded, which the reviewer's finding 6 named.

The wireframe follows, verbatim from the designer:

```
┌─────────────────────────────────────┐
│ (Today)            (Commitments  +) │
│ Wednesday                           │
│ 30 September 2026                   │
│ ‹  M   T   W   T   F   S   S  ›     │
│    28  29 (30)  1   2   3   4       │
├─────────────────────────────────────┤
│ rows …                              │
```

The chevrons stay put while the strip slides between them, clipped to its own narrower width. On
the reach's first week, the `‹` is faded beside the faded 31 1 2 3.

## Left open

None. Every question the frontier raised was answered. What is left is `spec-author`'s rather than
the owner's: the seam's shape, and whether a page is one requirement or joins the strip's existing
ones.
