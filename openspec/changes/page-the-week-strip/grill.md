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
5. **Where a page lands.** On the Monday of the new week. *The owner chose Monday over the same
   weekday, the recommendation.*
6. **A page whose Monday is earlier than the reach.** It lands on the reach's earliest day instead,
   so the reach's week can always be paged to; once the shown day's week is that week, a swipe back
   does nothing.
7. **A page into the week holding the today.** It lands on the today, whichever direction it came
   from — over the Monday, and over the earliest day. *The owner, adding to 6: "if the week has
   'today' in it, it should land on today"; the scope was confirmed as every page into that week.*
8. **The today against the reach.** Where every commitment is kept from a later date and the reach's
   earliest day falls after the today, a page into the today's week still lands on the today.
   *`Today` shows the today whatever the reach, so the strip refuses nothing the screen offers
   anyway.*
9. **The motion of a page.** The strip slides under the finger to the other week; once it lands the
   rows are replaced where they stand, with no slide. *The strip is what is being dragged, and the
   rows' neighbour page is the next day, not the next week.*
10. **The strip under a day swipe.** Unchanged from #346: a swipe on the rows that carries the day
    into another week redraws the strip in place once the day lands. The strip slides only when it
    is the thing being dragged. *#346's W.6 was walked and accepted at G7.*
11. **The walk.** Three pictures, on a fresh install where everything is kept from Friday 4
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

## Terms landed in CONTEXT.md

- **Week strip** — amended: a page moves the day, where it lands, how far it goes, and how it moves.
  No new term.

## Left open

None. Every question the frontier raised was answered. What is left is `spec-author`'s rather than
the owner's: the seam's shape, and whether a page is one requirement or joins the strip's existing
ones.
