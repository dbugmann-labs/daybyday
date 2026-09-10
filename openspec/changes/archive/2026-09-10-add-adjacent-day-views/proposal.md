## Why

The day screen has been moved by a horizontal swipe since `chore/swipe-the-day` (#177, ADR-1042),
and the swipe has never had anything to show for itself: the title changes and the rows are
replaced, with nothing in between. `chore/day-screen-motion` specified the cheap answer to that —
motion played once the finger is already up — built it, and put it on the owner's phone on
2026-09-09, where it was rejected. Their words are the finding: *"during the drag itself, nothing
happens, only when the finger is released, so it looks and feels very odd.. My goal is that it
feels like I am moving from screen to screen, same as if I were to navigate on an ios homescreen"*.
An acknowledgement is not a thing that can be paid late. ADR-1043 carries the whole of it and the
motion is reverted; the day change replaces instantly today.

**The remedy is a day screen that pages under the finger, and the kit is what blocks it.** A screen
can only page if the day being dragged toward is *already drawn* while the current day is still on
screen, and `DayByDayKit` will not answer that: `DayScreen` gives out one `DayView` — the day being
shown — and keeps its roster, its record store and both its dates private. `DayView.previousDay(of:in:)`
and `nextDay(of:in:)` are public but each needs a roster's commitments *and* a `History` to build
from, and the shell holds neither. So the Story's delta is the kit's: **a day screen says the day
view either side of the one it is showing, without moving onto it**, and says nothing about how a
shell draws them.

The Story grill settled fourteen answers over three rounds. The two the delta turns on are **whose
day a neighbour's commitments are read for** — the neighbour's own, never the shown day's, so that
what is seen arriving is what is got when it lands — and **what is at the ends of the calendar**,
where the answer is nothing on that side, which is what a drag at 1 January 1583 resists against.

## What Changes

- **A day screen says the day view of the day before the one it is showing and the day view of the
  day after**, as two answers beside the one it already gives. Not folded into one value the way
  `Reach` folds two dates: `Reach`'s two dates are only meaningful together and a caller must not
  derive one from the other, and neither of those reasons carries here. No shipped requirement or
  scenario naming `dayView` moves.
- **Each is formed exactly as the shown day's is** — from the commitments the screen's roster had
  not stopped keeping **on that adjacent day**, and from the record the screen already holds — so it
  is the day view the screen would hold had it been moved there. A commitment stopped yesterday
  therefore has a row on the page arriving from the left and none on the day being stood on. Forming
  a neighbour against the *shown* day's roster would make the page change under the person at the
  moment it landed, which is the one thing a page must not do.
- **Saying either neighbour reads nothing and moves nothing.** The roster and the record are asked
  as they last stood, exactly as a move asks them; the day being shown does not change, the today
  does not move, nothing is kept, and **what is being told on a row is left exactly as it was.** That
  last clause is the one that closes ADR-1043's rejected workaround by name: a shell that stepped the
  screen onto a neighbour and back to sample it would wipe a refusal the person has not read yet.
- **Exactly one day either side, never a run.** Each move lands before the next drag begins and the
  screen answers its new neighbours the moment it does, so a fast run of swipes is served without the
  screen ever holding more than three days.
- **At the ends of the calendar the answer is nothing on that side.** A screen showing 1 January 1583
  says no day before it; one showing 31 December 9999 says no day after it. The shell needs that
  absence — it is what a drag at the end resists against, rather than revealing an empty page.
- **A neighbour is drawn and never acted on.** Every tick, number, note, addition and take-back is
  made on the day being shown and on no other; a row that only a neighbour holds changes nothing at
  all. The shipped tick requirement already says *a row the screen's day view does not hold SHALL
  change nothing at all*, and this delta says the rest so that nobody later reads a drawn neighbour
  as a live one.
- **A screen that cannot read a store still answers its neighbours**, formed exactly as its shown day
  is. An unreadable record gives three days of rows saying nothing is kept; an unreadable roster gives
  three days of no rows. Withholding them would let a store failure silently take the gesture away as
  well.
- **One shipped requirement is modified, and only in what it refuses.** *A move with nowhere to go
  leaves a day screen exactly as it was* says a day screen SHALL NOT say whether it can move either
  way, in any direction, at any date. An absent neighbour at 1 January 1583 is visible to a caller,
  so that refusal is narrowed here in the same way that requirement already narrows itself for the
  way back to today: **what the screen can draw is not whether it can move.** The refusal itself
  stands, the three scenarios under it are unchanged, and a caller still MUST NOT skip asking for a
  move on the strength of an absent neighbour, because staying put is the move's own answer.
- **The paged `ContentView` rides this branch**, in its own `tasks.md` section, under ADR-1019's
  2026-09-04 amendment — so that G7 shows something that can actually be swiped. It draws three day
  lists under one fixed row of controls, tracks the drag, and calls the same `showPreviousDay()` and
  `showNextDay()` the chevrons already call. **With a rule-5 stop attached**: Apple documents nothing
  either way about a vertically scrolling `List` inside a horizontally paging container, and only the
  phone settles it. ADR-1019's guard does not move.
- **ADR-1043 is amended rather than replaced.** It posed two of this grill's questions by name — what
  a chevron tap draws, and what Reduce Motion governs — named this Story as owing them, and still
  reads `proposed` against a remedy now being built. The four answers that outlive the Story land
  there.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: **three requirements added** — a day screen says the day view either side of the one
  it is showing; there is no such day view before the first supported date or after the last; and
  every change is made on the day being shown and on none either side of it. **One requirement
  modified** — *A move with nowhere to go leaves a day screen exactly as it was*, whose refusal to
  say whether the screen can move is narrowed to leave room for an answer about what it can draw.
  Its three scenarios are restated unchanged.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — two computed properties,
  `previousDayView` and `nextDayView`, and one private helper that generalises the existing
  `dayViewOfShownDay()` to any day. No stored state, no new type, no existing signature changed, and
  no existing method's body changed beyond that one call.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift` — twenty-three new tests, one per new
  scenario. **No existing test is renamed, moved, or has an assertion changed**: the modified
  requirement's three scenarios are restated word for word, so the three tests already carrying those
  names must survive untouched.
- `src/DayByDay/DayByDay/ContentView.swift` — the day list becomes three day lists paged under the
  finger, with the chevrons, the day picker and the `Today` button lifted into a fixed row above them.
  Under ADR-1019's exception; it computes nothing, holds no day of its own and calls the two moves the
  chevrons already call.
- `docs/adr/1043-a-day-change-pages-under-the-finger.md` — amended with the four decisions that
  outlive this Story: what a chevron tap draws, what Reduce Motion governs, what pages and what stays
  put, and that the day picker always replaces.
- `CONTEXT.md` — **adjacent day view** landed as a term, and § *Day navigation* amended alongside it.
  `grill.md` § *Terms landed in CONTEXT.md* lists both; neither had reached the file, so this Story
  lands them.
- `src/DayByDay/DayByDayUITests/WalkthroughUITests.swift` — **nothing.** That layer proves the shell
  drew and says nothing about what (ADR-1029). Its one test swipes the day list and asserts the
  `Today` button and that rows are drawn; both must go on passing, and neither is a claim about
  motion.
- **Not touched:** the `commitment`, `record` and `schedule` capabilities; `DayView`, `Roster`,
  `RecordStore`, `RosterStore`, `History` and `CommitmentsScreen`; `dayView`, `title`,
  `offersGoingBackToToday`, `dayPickerReach`, `notice`, `tick`, `enter`, `takeBackLast`,
  `showPreviousDay`, `showNextDay`, `showToday`, `showDay`, `shown(asOf:)` and `returnedTo()`, every
  one of which goes on doing exactly what it does today.
