# Grill — place-sheet-refusals

*8 questions over 2 rounds, 2 facts dispatched, 2026-09-15.*

Story #261, first of the third reopening of `FEAT: commitment` (#26), cluster A of the ninth
grooming pass. Grilled against the sheet as `chore/reshape-commitment-sheet` left it (dcd464b): kind
under name, the range on one row, weekday chips Monday first, a wheel for the day of the month, a
one-row interval, a category menu, and red for every refusal.

## Decided before this grill, and not re-asked

Settled at #26's G1 of 2026-09-15 and carried here as given: a refusal is told **under the field it
is about**, and **at the foot of the form** where it is about the whole change; **a new commitment
starts with all seven weekdays offered**, a default being a requirement as the kind's and the day's
already are; the colour is the shell's and already landed. The words a person reads stay the app
shell's: the spec fixes no sentence for this screen, and a commitments screen holds no words
(*A commitments screen holds the change it refused and why it was refused, one at a time*). What
this Story makes a requirement is the **place** a refusal is told at, not its text.

## Facts found, not asked

- **Thirteen refusals**, `CommitmentsScreen.Refusal`, and where each is about, by the field the
  reshaped sheet draws: name says nothing → **name**; weekday set with no days → **the weekday
  chips**; a rhythm number the calendar will not take → **the rhythm's number** (on this sheet only
  the interval field can produce it: the wheel and the quota stepper are bounded); a range that is not
  a range → **the range row**, both ends on one row, whichever end is at fault; a target that is not a
  target → **target**; the three restart refusals → **the restart day picker**, inside the Restart
  section. Whole-change, so the foot: already being kept; the place could not be read or written
  (roster or record); records already exist under that. Two are about either the rhythm or the
  kept-from day and the value does not say which — Settled 1. No refusal is about the category.
- **A change a stopped commitment does not take is unreachable from the sheet.** Every rhythm
  control and the kept-from picker is disabled on a stopped commitment
  (`Change.canChangeRhythmAndKeptFrom`), so the sheet always sends the values it opened with. The
  refusal still exists at the seam and its tests; it needs a place in the delta and no picture.
- **The sheet today** draws every non-restart refusal at the foot of its one section, from a local
  copy of the refusal rather than from `refusedChange`; a restart refusal is a second local copy drawn
  in the Restart section, so the two can be shown at once. A new commitment's chips open **empty**,
  which is exactly the state that gets refused. A change that switches a non-weekday rhythm onto
  weekdays also opens the chips empty.
- **The precedent for "under the field"** is `day-screen`'s one-off entry: told under the entry or
  under the row's name field, one field at a time, ending when that field's text is edited, when the
  day changes and when the app is shown again, and never ended by a change from another field. The
  row notice is a separate thing with its own lifetime. The commitments screen's refused change ends
  on two conditions only: the app shown again, or a change reaching a place.
- **The seam** is `CommitmentsScreen` itself — `define`, `change`, `restart`, `whatItIsMadeOf`,
  `shown(asOf:)` and the values they return and hold. No test reads the shell's sentences.

## Settled

1. **A refusal that could be about the rhythm or the kept-from day** — *a day already recorded on
   that the change would leave not due*, and the stopped-commitment refusal that shares its shape.
   Told under whichever of the two the person changed; at the foot where both changed. *The sheet can
   tell which moved by comparing against what the commitment is made of; the kit's refusal cannot,
   and the foot is where a refusal about two fields belongs.*
2. **Editing the field a refusal is under ends it.** *As the one-off entry's does: "Give it a name."
   standing while the name is typed is stale. This is a third end condition the refused change has
   never had, and how the delta carries it — the refused change gaining a place and an end, or a
   second thing beside it as the day screen has two — is `spec-author`'s to decide.*
3. **Editing a different field does not end it.** *The one-off precedent again: a change from another
   field leaves it standing, so the pointer is still there when they get to it.*
4. **A foot refusal ends on the next save or on closing the sheet**, and not on any edit. *One rule:
   what is told ends when the field it is under is edited, and the foot is under none. A write
   failure should not vanish the moment they touch a field.*
5. **Closing the sheet ends whatever it told.** A sheet opened again, on the same commitment or as a
   new one, is a fresh form telling nothing. *A reopened sheet is a new ask.*
6. **All seven weekdays light whenever the chips appear with nothing behind them** — a new
   commitment's sheet, and a change that switches a non-weekday rhythm onto weekdays. Switching away
   and back keeps whatever was chosen. *Empty chips are the state the screen refuses; offering it as
   the start is offering a refusal.*
7. **One refusal told at a time on a sheet**, the one asked last: a refused save after a refused
   restart replaces it, and the reverse. *At most one refused change is already the rule; the sheet's
   two local copies were the shell's accident, not a decision.*
8. **The walk** — eight pictures, no `phone:` line, since nothing here is a drag or a press: the fresh
   define sheet with all seven chips lit; a refusal told under Name; under the weekday chips; under
   the interval row; under the range row; under Target; one at the foot, already being kept; one under
   the restart day picker. The already-kept picture is driven against the day-one roster the walk
   starts on. *One picture per placement, because each is a distinct line of the delta.*

## Terms landed in CONTEXT.md

- **Refused change** — amended, not a new term: told under the field it is about on the commitment
  sheet, and ended by that field being edited or the sheet closing. Whether that is the refused
  change itself or a second thing beside it is left to the delta, deliberately.

## Left open

None. Every question the frontier raised was answered, and the one the answers raise — how the
model carries a place and a third end condition without contradicting the two-condition lifetime the
list still runs on — is a design question for `design.md`, not a preference.

## Not this Story

- The refusals told beside a row on the two lists — stop, remove, move, group move, take up again —
  are where they were. The intent names the sheet.
- A range or a target changed on the sheet is #262, blocked by this Story.
- #266 and #272 are at Stage 4 in parallel; if either lands a `commitment` delta first, `docs/process.md`
  §7 serialises this one behind it.
