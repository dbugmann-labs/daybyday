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
- Days away remember every stop and take-up of a commitment they are over that is made once they
  have begun, under way included, or that their days come to hide; removing, unticking or moving them,
  in any order, never makes it owe a day between a stop and its take-up, and a move back restores.
- A commitment taken up again inside days away is taken up the day after them, moving with it, but
  never to a day no later than the day after its stop.
- The roster form moves to 11 to hold what days away remember, refused only where no roster the app
  writes could hold it; form 10 is read without loss.
- Every days away is listed: those not over earliest first, then past ones apart, latest first.
- Any listed days away can be removed, begun or over, erasing it whole, its days owed again.
- A roster holding two days away with one identity is refused.
- A change of days away writes a copy, as saying and removing do.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: twelve ADDED, four MODIFIED, one RENAMED, three REMOVED — the three carried whole into
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
