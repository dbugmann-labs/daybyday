## Why

A holiday or a sick week can only be told to the app today by stopping each commitment and resuming
it afterwards, on the days those happen, and the gaps that leaves look exactly like pauses. **Days
away** let a person say the span once, ahead, over the commitments they pick, so those commitments
owe nothing on its days (`CONTEXT.md` § *Days away*). Moving either end, removing a span already
under way and saying one over past days are a later Story's.

## What Changes

- A commitments screen says days away from a name or none, a first day from today onward, a last day
  not before it, and the commitments it keeps that are picked, none picked to start with.
- Each commitment picked takes a gap over the span: kept until the day before its first day — until
  that day itself where it is today and holds a record — and taken up again the day after its last,
  an every-N-days count beginning again there.
- Days away are refused where they overlap others on a commitment the two share, over a commitment
  kept from their first day or later, or over one with a shift that has a day inside them.
- The commitments screen lists days away until their last day passes, under a card of their own, and
  removes them, after asking, only before they start, leaving every commitment as though never said.
- A stop or a deletion takes a commitment out of its days away, and days away left over none go. A
  change of rhythm, range or target keeps them, and the day kept from cannot be moved into them.
- An every-N-days due day before days away can still be shifted.
- A day screen says each day inside days away by one line above its rows, the name or "Away", and its
  week strip marks those days with a dot. A quota's slack counts only the days it is kept on.
- The roster place keeps days away after their last day; a roster kept before reads as holding none.
  A copy carries them and a restore puts them back.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: eight ADDED, two MODIFIED.
- `day-screen`: two ADDED, two MODIFIED.
- `restore`: one ADDED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — a new `DaysAway.swift`; `Roster`, `RosterDocument`,
  `RosterStore`, `CommitmentsScreen`, `DayView`, `DayScreen`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests beside the carried ones, and the carried
  lines that name roster form 10 as a later form.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the Days away card, its sheet and its alert.
- `src/DayByDay/DayByDay/ContentView.swift` — the away line and the week strip's dot.
- `docs/adr/1069-days-away-are-a-span-the-roster-holds.md` — new.
