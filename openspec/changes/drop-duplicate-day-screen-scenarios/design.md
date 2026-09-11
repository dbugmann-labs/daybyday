## Context

`proposal.md` § *Why* says what this is for, and `grill.md`'s settled answers are what the delta is
written on. `openspec/specs/day-screen/spec.md` holds 51 requirements and 399 scenarios; the delta
carries 19 requirements and 174 scenarios, and drops 29.

The archiver in `openspec` 1.10.0 refuses a MODIFIED block omitting a current scenario and takes
REMOVED plus ADDED under a new heading, appending each added requirement after every surviving one in
delta order (ADR-1047 decision 2). `pnpm run check:scenarios` reads scenario → test only, so a test
whose scenario is gone passes every check. Every dropped test sits in `DayViewTests.swift` or
`DayScreenTests.swift`, in the `DayByDayKitTests` target; none is a UI test.

## Goals / Non-Goals

**Goals:** the twenty-nine scenarios of grill item 2 and their tests gone, with everything each
asserted still asserted by its keeper; grill item 9's false sentence made true; the two kept tests of
grill item 4 brought to their unchanged scenarios, or withdrawn where that goes red.

**Non-Goals:** no requirement prose changed but the three sentences below; no scenario title changed;
no test added, and no kept test edited but those two; no line under `Sources/` changed; the five
route-driven pairs of grill item 3 kept; ADR-1047 and `CONTEXT.md` unedited (grill item 10).
`docs/backlog.md`'s quote (grill item 12), #199's box 14 and its outcome comment follow the merge.

## Decisions

### The seam

No member is new or changed, which makes this a *pruning Story*. The keepers' tests attach at:
```swift
DayView.init(of commitments: [Commitment], on date: CalendarDate, in history: History)
DayView.rows: [DayView.Row]
DayView.title: String
DayView.Row.name: String
DayView.Row.isKept: Bool
DayView.Row.tick(asOf today: CalendarDate) -> Tick?
DayView.Row.numberEntry(asOf today: CalendarDate) -> NumberEntry?
DayView.Row.noteEntry(asOf today: CalendarDate) -> NoteEntry?
DayView.Row.totalEntry(asOf today: CalendarDate) -> TotalEntry?
DayScreen.init(startingFrom dayOne: [Commitment], asOf today: CalendarDate, keepingRecordAt recordPlace: URL, keepingRosterAt rosterPlace: URL)
DayScreen.dayView: DayView
DayScreen.title: String
DayScreen.recordState: RecordState
DayScreen.notice: Notice?
DayScreen.offersGoingBackToToday: Bool
DayScreen.dayPickerReach: Reach
DayScreen.tick(_ row: DayView.Row) throws
DayScreen.enter(_ text: String, on row: DayView.Row) throws
DayScreen.takeBackLast(on row: DayView.Row) throws
DayScreen.showPreviousDay()
DayScreen.showNextDay()
DayScreen.showToday()
DayScreen.shown(asOf today: CalendarDate)
DayScreen.returnedTo()
```

### Twenty-nine scenarios are dropped, and seventeen headings change as little as keeps each true

| # | Dropped | Keeper, which asserts the same | Test file |
|---|---|---|---|
| 1 | a commitment ticked on the date has a row that says it is kept | a tick on another date does not make the row say it is kept | `DayViewTests` |
| 1 | a commitment not ticked on the date has a row that says it is not kept | a tick for a commitment the day view was not handed adds no row | `DayViewTests` |
| 2 | a row offers the tick for its commitment on the date the day view is of | a row's answer follows the day it is asked as of rather than the day the day view was formed | `DayViewTests` |
| 3 | rows are in the order the commitments were handed over | a kept commitment keeps its place among the ones that are not kept | `DayViewTests` |
| 4 | two day views of the same commitments, date and history are the same day view | two day views differing only in a tick for a commitment neither was handed are the same day view | `DayViewTests` |
| 5 | ticking a row that says its commitment is not kept makes the day screen say it is kept | ticking one row leaves the other rows of the day as they were | `DayScreenTests` |
| 5 | a tick made on a day screen is held by a day screen opened afterwards at the same place | ticking a row on a day a day screen has moved back to keeps the tick on that day | `DayScreenTests` |
| 6 | a day screen shown again reads the record again | a day screen that could not read its record starts keeping one when it is shown again and the record can be read | `DayScreenTests` |
| 7 | a refused tick is told on the row that was tapped | a refused tick is told on the row that was tapped and on no other row | `DayScreenTests` |
| 7 | a value that is not a number is told on the row, saying so | a value that is not a number committed in a total entry is told the same thing a number entry tells | `DayScreenTests` |
| 8 | what a day screen tells on a row ends when the same change is made again and is kept | what a day screen tells on a row ends when a change is kept on another row | `DayScreenTests` |
| 9 | a commit on a day screen that is not keeping a record is told nothing on the row; a commit on a note row on a day screen that is not keeping a record is told nothing on the row | a commit on a total row on a day screen that is not keeping a record is told nothing on the row | `DayScreenTests` |
| 9 | a commit on a row for a day that has not arrived is told nothing on the row; a commit on a note row for a day that has not arrived is told nothing on the row | a commit on a total row for a day that has not arrived is told nothing on the row | `DayScreenTests` |
| 9 | a tap on a row a day screen's day view does not hold is told nothing on the row | a tap on a row a day screen's day view does not hold does not end what is already told | `DayScreenTests` |
| 9 | a commit on a row that offers no number entry is told nothing on the row | a commit on a row that offers no entry at all is told nothing on the row | `DayScreenTests` |
| 10 | what a day screen tells on a row stands when the screen is returned to and reads its record again | a day screen returned to goes on telling what it was telling on a row | `DayScreenTests` |
| 11 | entering a number on a row makes the day screen say the commitment is kept; a number entered on a day screen is held by a day screen opened afterwards at the same place; the number entry a row offers says the number just entered on it | a number the commitment refuses keeps nothing and leaves the day as it was | `DayScreenTests` |
| 12 | a note entry says the note the history holds for that commitment on that date | a note entry says a note of many lines and many characters whole | `DayViewTests` |
| 13 | entering a note on a row makes the day screen say the commitment is kept | entering a note on one row leaves the other rows of the day as they were | `DayScreenTests` |
| 13 | the note entry a row offers says the note just entered on it | a note entered on a day that already holds one replaces it | `DayScreenTests` |
| 14 | reaching the target makes the day screen say the commitment is kept; an addition entered on a day screen is held by a day screen opened afterwards at the same place | committing nothing at all in a total entry keeps nothing and takes nothing back | `DayScreenTests` |
| 15 | a day screen showing the today it was handed offers no way back to today | going back to today on a day screen that offers no way back leaves it showing that today | `DayScreenTests` |
| 16 | a day view says its day as the three-letter name of its weekday | every weekday is said by its own name | `DayViewTests` |
| 17 | a day screen says the day it is showing | a day screen says the day it was handed rather than the day it really is | `DayScreenTests` |

Grill items 2, 5 and 6; `#` is the row of the table below, and each new heading restates a clause of
its own prose. Rows 1, 2, 4–8 and 11 and both MODIFIED requirements stay over 150 words, verbatim;
row 17 reaches 154 only by its renamed reference. Rejected: the five route pairs (item 3); sparing
base cases (item 2); a split Story, which reorders the same (item 6); RENAMED (ADR-1047).

| # | Removed | Added |
|---|---|---|
| 1 | A day view is the commitments due on a date, each with whether it is kept | A day view holds the commitments due on a date, each with whether it is kept |
| 2 | A row offers the tick that keeps its commitment, and refuses one for a day that has not arrived | A row offers the tick that keeps its commitment, and offers none for a day that has not arrived |
| 3 | A day view is in the order it was handed its commitments | A day view's rows are in the order it was handed its commitments |
| 4 | A day view is a value | A day view is a value made of its groups and its date |
| 5 | A day screen makes and takes back the tick a row offers, and keeps it before the day view says so | A day screen makes and takes back the tick a row offers, and keeps the change before the day view says so |
| 6 | A day screen re-reads its day and its record when the app is shown again | A day screen re-reads its day, its record and its roster when the app is shown again |
| 7 | A day screen tells on the row that was tapped that a change could not be kept | A day screen tells on the row that was tapped that the change the row offers could not be kept |
| 8 | What a day screen tells on a row lasts until the app is shown again, a change is kept, or the day it is showing changes | What a day screen tells on a row lasts until the app is shown again, a change is kept at the record's place, or the day it is showing changes |
| 9 | A day screen tells nothing on a row where there was no tick to refuse | A day screen tells nothing on a row where there was no change to refuse |
| 10 | A day screen reads its roster again when it is returned to | A day screen reads its roster again whenever it is returned to |
| 11 | A day screen enters the number a row's entry takes, and keeps it before the day view says so | A day screen enters the number a row's entry takes, and keeps the change before the day view says so |
| 12 | A note entry says the note the day already holds, and says nothing else | A note entry says the whole note the day already holds, and says nothing else |
| 13 | A day screen enters the note a row's entry takes, and keeps it before the day view says so | A day screen enters the note a row's entry takes, and keeps the change before the day view says so |
| 14 | A day screen adds what is committed in a row's total entry, and keeps it before the day view says so | A day screen adds what is committed in a row's total entry, and keeps the change before the day view says so |
| 15 | A day screen says whether it offers the way back to today | A day screen says whether it offers the way back to the today it was handed |
| 16 | A day view says its day as a weekday | A day view says its day as the name of its weekday |
| 17 | A day screen says the day it is showing | A day screen says the day it is showing as its day view's day title |

### Three sentences follow, and two kept tests are brought to their scenarios

Grill items 4 and 7–9. *A day screen draws the commitments…* cites row 4's new heading and row 17
cites row 15's; *A day screen holds the day view of the day it was handed…* names a pick among what
changes the day shown. References by description stay true because the ADDED blocks keep spec order.
ADR-1026's live reference follows row 4 in this change; ADR-1037, ADR-1038 and `docs/open-questions.md`
§ *Settled* quote inside dated entries and stay, and its § *Known gaps* quotes row 7 by a prefix the
new heading keeps. `tasks.md` § 2's two tests take their scenarios' values or are withdrawn, never bent.

## Risks / Trade-offs

- **A keeper that does not assert what it is said to** loses a rule no check sees. → A `tasks.md` § 3
  box is ticked only once its keeper's own `#expect` has been read, and `reviewer` confirms each pair
  in source at G7.
- **A test left behind, or the wrong one deleted**, passes `check:scenarios`. → The gates search `src/`
  for all twenty-nine titles and read the test count off a run on this branch and on `main`.
- **A strengthened test that goes red** shows a kept test never proved its scenario. → Withdrawn, never
  bent (grill item 4); the defect becomes a Story of its own, and the rest proceeds.
- **Seventeen requirements move to the end of the spec**, the day view's definition among them. →
  Accepted at the grill (item 6); `docs/backlog.md`'s quote follows on `chore/backlog` after the archive.

## Open Questions

None. `grill.md` § *Left open* is "None.", every drop and every surveyed candidate has a verdict, and
the seventeen headings were the only wording left to this change, written to grill item 1's rule. No
residual round was raised.
