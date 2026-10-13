## Why

Days away can only be said ahead, removed only before they start, and listed only until they end,
so a sick week told afterwards, a holiday cut short or one that runs on cannot be said at all
(`CONTEXT.md` § *Days away*). This change lets a span be said over past days, changed in every
part, and removed whenever, refusing only what would hide a record.

## What Changes

- Days away can be said with a first day however far back; the first-day-has-passed refusal goes.
- Days away listed can be changed: name, first day, last day and the commitments picked, judged as
  saying judges them and never against themselves.
- A change gives back the days it no longer covers and takes those it newly covers; a commitment is
  taken up again the day after the new last day on what it would have been taken up on, so a change
  of rhythm made while away moves with the day back.
- Saying or changing days away is refused, naming the commitment and the day, where it would put a
  recorded day under them; a first day that is today keeps that commitment through it instead.
- A stopped commitment already in a span stays picked or can be unticked; a span moved past its stop
  keeps it until the day before, and one moved wholly past takes it out.
- Days away remember the day a stop kept each commitment in them until — a stop once they have begun,
  under way included, leaving it in them — so removing, unticking or moving them never makes it owe a
  day after its stop, and moving them back gives those days back.
- A stopped commitment taken up again inside days away over it is taken up on the day after them.
- The roster form moves to 11 to hold what days away remember; form 10 is read without loss.
- Every days away is listed: those not over earliest first, then past ones apart, latest first.
- Any listed days away can be removed, begun or over, erasing it whole, its days owed again.
- A roster holding two days away with one identity is refused.
- A change of days away writes a copy, as saying and removing do.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: ten ADDED, four MODIFIED, one RENAMED, three REMOVED — the three carried whole into
  ADDED without a scenario each retires.
- `restore`: one MODIFIED, one RENAMED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `CommitmentsScreen`, `Roster`, `DaysAway`,
  `RosterDocument` (form 11).
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests, and the carried tests whose scenarios this
  delta retires or adds a clause to, or whose fixtures move to form 11.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the past card, the Edit swipe, the change sheet.
- `docs/adr/1069-days-away-are-a-span-the-roster-holds.md` — amended.
- `docs/open-questions.md` — the known gap of two days away with one identity closes.
