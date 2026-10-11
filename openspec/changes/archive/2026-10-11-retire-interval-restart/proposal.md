## Why

A **shift** of an every-N-days due day now runs the count on from where it landed, which is what
restarting was for, and the owner chose the shift to replace restarting outright. The change sheet
still offers a restart beside it: two ways to move a count, one of which leaves the day it came from
due and unkept. This withdraws restarting, and keeps every restart already made exactly as made.

## What Changes

- **BREAKING** The change sheet of an every-N-days commitment offers no restart; the commitments
  screen says nothing of whether one can be restarted and takes no restart.
- A sheet refusal is about a definition or a change only: the restart day field is gone, and a
  refusal is replaced by the next definition or change refused.
- A refused change is one of ten kinds: restarting leaves the count, and taking out the files,
  already held as one, joins it.
- A change alone puts eras on through a commitments screen, and nothing reaches behind a later era.
- A copy follows every kept change as before, a restart no longer among them.
- Eras a restart already made stay as made: two neighbouring every-N-days eras of one interval,
  counting from different days, are read back as two, each due on its own count.
- Torn saves are undone exactly as before; the one scenario titled for a restart is renamed.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: four ADDED (carried under new headings), three MODIFIED, seven REMOVED.
- `restore`: one MODIFIED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `CommitmentsScreen`, `History`, `RecordStore`,
  `SaveInProgress`, `DayScreen` (citations only).
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the restart tests deleted, one carried test edited,
  one renamed, two new.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the sheet's restart section and words go.
- `docs/adr/1067-restarting-is-retired-for-the-shift.md` — new.
- `CONTEXT.md` — **Restarting** deleted, and every mention of it in other entries.
