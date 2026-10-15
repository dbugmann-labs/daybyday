## Why

Days away can only be said ahead, removed only before they start, and listed only until they end,
so a sick week told afterwards, a holiday cut short or one that runs on cannot be said at all
(`CONTEXT.md` § *Days away*). This change lets a span be said over past days, changed in every
part, and removed whenever, and lays it over each commitment's life instead of cutting it into it,
so no move or removal can give back or take away anything but its own days.

## What Changes

- Days away hide the days they cover from the commitments they are over when those are read, and
  never change a commitment's eras, stops or take-ups; a day holding a record is never hidden.
- Days away can be said with a first day however far back; the first-day-has-passed refusal goes.
- Days away listed can be changed — name, days and commitments picked — judged as saying judges
  them and never against themselves; a change hides what it covers and gives back what it leaves.
- Saying or changing days away is refused, naming the commitment and the day, where it would newly
  put a recorded day within them; a first day that is the day handed is not judged.
- A stop, a take-up or a change of rhythm, range or target holds from the day it is made, inside
  days away or not; days away begun keep a commitment stopped while they are under way.
- Every days away is listed, those not over earliest first and past ones apart, latest first; any
  can be removed, begun or over, as though never said.
- Days a reader owes, a weekly quota's share, a look-back's count and a shift's free days all read
  hidden days as days of a gap, an every-N-days count beginning again on the day after them.
- The roster form moves to 11, the shape of form 10 over uncut eras; form 10 is read as written.
- Two days away with one identity are refused; a change of days away writes a copy.
- Outcomes that differ from the delta this replaces: after a removal or a move, a change made while
  away holds from its own day, and a commitment taken up inside days away owes from its take-up day,
  not the day after them; a recorded first day is away again once the record is taken back; a stop
  made while away, or one days away move past, stays on its own day.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: ADDED, MODIFIED and REMOVED — six shipped requirements removed and carried under new
  titles, four modified.
- `day-screen`: two MODIFIED.
- `look-back`: two MODIFIED.
- `restore`: one MODIFIED, one RENAMED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster`, `CommitmentsScreen`, `DaysAway`, `DayView`,
  `DayScreen`, `WeekQuota`, `LookBack`, `RosterDocument` (form 11).
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests, the branch's tests rebuilt to the delta,
  and the carried tests `tasks.md` § 1.2 lists.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the past card, the Edit swipe, the change sheet.
- `docs/adr/1069-days-away-are-a-span-the-roster-holds.md` — amended.
- `docs/open-questions.md` — two known gaps and one open decision close.
