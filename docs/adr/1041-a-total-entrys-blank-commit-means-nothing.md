# 1041. A total entry's blank commit means nothing, and its take-back is its own act

- Status: accepted — the owner's decision at the Story grill of `add-total-record` (#141) on
  2026-09-08 (answers 4 and 9); this record is written by that change
- Date: 2026-09-08
- Deciders: Diego Bugmann

## Context

Three of the four kinds of record are taken back the same way, and two of those three use the same
gesture for it. `add-number-entry` (#139) settled that an entry **committed empty takes the number
back**; `add-note-record` (#140) copied it word for word for the note. `CONTEXT.md` § *Number entry*
and § *Note entry* both say so. It reads well: a field is what the day holds, and clearing the field
clears the day.

It works because the day holds **one** record and the field shows it. A person clearing a field can
see exactly what they are about to lose, and the outcome — the day holds nothing — is what an empty
field means.

A **total** breaks both halves of that. `CONTEXT.md` § *Total*: the record is the day's additions,
in the order they were made, and taking back removes the **last addition** rather than the day. And
its field, settled at #141's grill (answer 8), **opens empty every time**, because a commit is an
addition and a field opening on 90 committed unread would make the day 180.

So the gesture that clears a number would, on a total, delete the most recent thing a person added —
from a field that was already empty when they opened it, showing nothing of what would go.

## Decision

**A commit in a total entry that says nothing keeps nothing, takes nothing back, and tells
nothing.** It is the one commit in this system that is read and then means nothing at all: the
person asked for no change and gets none, and there is no message, because there was no refusal.

**Taking back a total's last addition is its own act on the row.** `DayScreen.takeBackLast(on:)`,
taking a row and nothing else — no text, because the day's order names the addition that goes.

**A row offers that act only where its day holds an addition to take back**, read off the day's sum
being above zero. Every addition is above zero, so *sum above zero* and *the day holds an addition*
are the same question, and the row answers the second from the first without ever seeing the list.

**There is no act that clears a day.** Repeated take-back is the only way back.

## Consequences

- **One gesture now means two things across two kinds of row**, and that is the cost. Committing an
  empty field on a weight clears the day; on a protein count it does nothing. It is written into
  `CONTEXT.md` § *Total entry* and into the requirement on reading what is committed in a total
  entry, in both places as *where a total entry parts from the other two*, so that nobody later
  "fixes" the inconsistency by making blank mean take-back-last.
- **A total row is the first row that offers two things**, and the second is the only affordance in
  this system that appears and disappears with what the history says. Every other row offers exactly
  one thing and offers it regardless of what the day holds.
- **A row that offers no take-back is a row with one thing on it, not a disabled control.** The grill
  weighed a control that is always there and does nothing on an empty day, against one that comes and
  goes, and chose the second: a visible control that answers a tap with silence is already an open
  question against this product (B-035), and adding one on purpose would be adding to it.
- **`takeBackLast(on:)` is a second public member on `DayScreen`, and #140 rejected exactly that
  shape.** It rejected two members taking `(String, DayView.Row)` and differing only in name, each
  answering the other's row with silence — a caller could not be told apart from a bug. This is not
  that: it takes **no text**, so no call site can confuse the two, and it answers a row that offers no
  take-back with silence for the same reason `enter` answers a row that offers no entry with silence.
- **The alternative was measurable in one sentence and that is why it lost.** "The same gesture would
  silently delete the last thing added, and a person would have to remember what it was to know what
  they lost." A record that cannot be seen before it goes is the failure this product exists to
  remove; every other take-back in the system shows a person what they are clearing.
- **Nothing about the number entry or the note entry moves.** Their blank commit is still the
  take-back, and this record does not reopen it.

## Alternatives considered

**Blank commits the take-back, as it does for the other two.** Consistent, and no second member on
the screen. Rejected on the sentence above: it deletes the most recent addition from a field that
opened empty, showing nothing of what is about to go. It also means a person who opens the field and
changes their mind has to close it rather than confirm it, which is the opposite of what every other
entry teaches.

**Blank clears the whole day, so that the gesture means "this day holds nothing" everywhere.**
Consistent in a different direction, and it does show a person what they are clearing — the row says
the sum. Rejected at the grill (answer 7): one act erasing six records is a bigger undo than any
other kind has, nothing has asked for it, and repeated take-back reaches every outcome it would. If
it turns out to be wanted it is a want and its own change.

**Take back by naming the amount — commit "-30" to remove a 30.** Rejected twice over. A negative
amount is refused where the record is formed, because it would be a second way back competing with
this one and could take a day below where it started; and two additions of 30 on one day are the
same addition, so an amount names no particular one of them.

**A take-back that names which addition goes.** It would need the day's list to reach
`day-screen`, which the requirement on what a total entry says exists to keep out of it — a row
gives out the sum and never the additions. And nothing has asked for it: a person who added the wrong
thing added it last.

**Always offer the take-back, and make it do nothing on an empty day.** Simpler at the seam — one
fewer question a row answers — and it matches how a take-back behaves at the record level, where
taking back from a day holding none is nothing rather than an error. Rejected at the row: the record
level has no person looking at it, and the row does.
