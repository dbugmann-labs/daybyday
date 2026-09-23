## Why

A second rhythm, range or target change on one day stacks an era that holds no day. A third, or a
change back on the day the commitment was defined, writes a roster the store then refuses to read:
the commitments screen lists nothing and every copy after it stops. A restart reaching behind a later
era leaves the two overlapping. An era nobody kept a day on is not one, whatever began it.

## What Changes

- Putting an era on drops every era it leaves holding no day, cuts the one it reaches behind, and
  joins the new era to an alike one behind it. A change back on one day leaves the commitment as it was.
- A change back of an interval rhythm on the same day keeps the start date the era had.
- A change made before a commitment's future day kept from keeps that day.
- A restart may reach behind any later era back to the day kept from, replacing every era begun
  after the picked day; a record the restart would leave not due still refuses it.
- The already-due refusal of a restart is read against the newest era, as it is today.
- A stored roster is mended when read: an era holding no day is dropped, overlaps are cut, alike
  neighbours join. The newest era is never dropped. A copy is mended when restored.
- The store no longer refuses one era held twice in a roster that carries identities, because
  mending leaves none; a legacy roster holding one commitment twice is still refused.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: two ADDED, four MODIFIED.

## Impact

- `openspec/specs/commitment/spec.md` — at archive.
- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster`, `RosterDocument`, `CommitmentsScreen`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the roster, store, screen and restore tests.
- `docs/adr/1059-equality-is-the-identity-and-an-era-is-an-entry.md` — amended in place.
- `CONTEXT.md` — **Superseding** and the older **Era** entry brought up to date.
