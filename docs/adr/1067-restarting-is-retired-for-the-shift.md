# 1067. Restarting is retired for the shift

- Status: accepted — taken at the twenty-fifth grooming pass's Feature grill on 2026-10-06, for
  B-054, and confirmed at the grill of `retire-interval-restart` (#394) on 2026-10-11; this record
  is written by that Story and approved at its G4
- Date: 2026-10-11
- Deciders: Diego Bugmann

## Context

Restarting began an every-N-days commitment's count again from a day the person picked, because it
was kept late: nails due on day 3 and done on day 4 run three days on from day 4. It was reached
from the change sheet, and it put a new era on the commitment from the picked day, alike in name,
interval and kind, its count starting there, with the era before kept until the day before. No ADR
held it; the glossary and the specs did.

The **shift** of an every-N-days due day (ADR-1066, amended by `shift-an-interval-day`, #393) does
what a restart was for — the count runs on from the day the due day was put on — and differs in one
thing a person sees: the day it came from stops being due, where a restart left it due and unkept.
Both reached the same person from two places, the row of the day and the change sheet.

## Decision

**The shift replaces restarting outright.** The change sheet offers no restart, the commitments
screen takes none and says nothing of whether one could be made, and the specs and the glossary no
longer describe one. The words *restart* and *restarting* leave `CONTEXT.md` entirely rather than
standing as a retired entry: the glossary describes what the app does now, and the archived change
folders keep their own record of the word.

**Restarts already made stay as made.** A restart wrote an ordinary era, and nothing on disk or in
the model marks one as a restart's, so every roster reads exactly as it did and needs no migration.
The one rule that keeps such a roster's meaning is already the mend's: two neighbouring eras are
joined only where they are alike in schedule, an every-N-days count's start date included, so a
restart's two counts stay two.

**Three things a restart could do have no replacement, and that is accepted.**

- Reaching behind a rhythm change, or an earlier restart, to count again from a day the older era
  holds. A shift is refused while a later era stands. It needs a rhythm change and a late regret
  within days of each other.
- Moving a due day that is ticked, or that has a record on a later day. A shift refuses both; a
  kept-from correction gives the same due days, at the cost of moving the day kept from.
- Moving a due day while the commitment already holds a shift with a day after it, which refuses a
  new shift.

## Consequences

- **One way to move a count.** Every-N-days due days move only by a shift, from the day's row, and
  the change sheet changes only what a commitment is.
- **A refused change has one kind fewer**, and a sheet refusal one field fewer.
- **The code a restart alone used goes with it**, the dated record carry-over included, which had
  no caller left from an older restart design that carried records.
- **No want is captured** for the three cases above; a later one would start from this record.

## Alternatives considered

- **Keep restarting beside the shift.** Two ways to move one count from two places, one leaving the
  day it came from missed; the owner chose one.
- **A retired stub for *Restarting* in the glossary.** Recommended at the grill and declined: the
  glossary is the app's current vocabulary, not its history.
- **Rewrite the eras a restart made as shifts.** Nothing marks them, so a migration could not tell
  them from a rhythm changed and changed back to the same interval, and they already read correctly.
