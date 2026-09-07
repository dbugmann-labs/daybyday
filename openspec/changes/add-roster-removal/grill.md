# Grill — add-roster-removal

*12 questions over 4 rounds, 2026-09-07.*

## Settled

1. **A removed commitment stays held by the roster, and the record is untouched.** The owner
   answered past all three shapes offered — leave the record alone and drop the entry, delete the
   record too, refuse removal where records exist — with *"Past days should not lose their rows,
   they should still be there even after a commitment was stopped or removed."* So **removed** is
   a third state a roster holds a commitment in, beside kept and stopped; nothing ever leaves the
   roster; and the record store is not written by a removal. *This also discharges ADR-1027's
   standing obligation without a marker: a roster that has ever taken something on never again
   equals a roster holding nothing, so day one cannot be written back over a roster emptied by
   removal.*
2. **A removed commitment's row is drawn on every due day up to the day it was kept until**,
   exactly as a stopped one is. *Against the recommendation of "only on days it was actually
   kept". The cost was stated and taken: a mistyped commitment, or one of day one's eight the
   owner never kept, stays on every past due day as an unticked row.*
3. **A kept commitment that is removed is kept until the day before the screen was handed — and
   from now on so is one that is stopped.** *Against the shipped requirement that stopping keeps
   until the day the screen was handed, and against ADR-1023's reason for it. Asked again with the
   cost — a tick made this morning on a commitment stopped this afternoon leaves today's screen
   with it, though the record stands — and reaffirmed: "The day before, but it must also be like
   that for stopping." A row that lingers after a stop reads as a stop that failed. ADR-1023 is
   amended in place; the kept-until day stays inclusive and the roster's to judge, what changes
   is the day the screen hands. A commitment defined and stopped on the same day becomes one kept
   on no day at all, which the roster already accepts. The first supported date has no day before
   it: what the screen does there is `design.md`'s, no phone will reach it.*
4. **A stopped commitment that is removed keeps the kept-until day it already had.** *Implied by
   1 and 2; written down so the delta does not move a day a person cannot see.*
5. **Defining the identical commitment again takes it up again, in its old place, with its
   history**, as offering a stopped one does. *A refusal pointing at nothing visible on either
   list was the alternative; the owner took the recommendation.*
6. **The confirmation is the commitment's name, typed back.** Stronger than stopping's one alert,
   by the owner's choice; typing the name over a double confirmation and over "stop first, remove
   only from the stopped list". The typed name matches when it equals the name **exactly after
   surrounding whitespace is trimmed** — case and inner spacing must match. **A name that does not
   match is not a refusal and nothing is said**: the owner — *"the button to confirm the removal is
   not clickable until it is correct. this is enough for the user to know."* So at the seam the
   screen must answer whether what has been typed matches, and confirming on a non-matching name
   changes nothing, like confirming when nothing is awaiting confirmation.
7. **The verb is *remove*.** The roster removes a commitment and the spec says so; "delete" stays a
   file-system word. What the person reads is the shell's, as every other sentence is.
8. **The affordance is swipe actions, and every action moves into the swipe.** A kept row swipes
   to stop or remove, a stopped row to resume or remove, and the row's own tap does nothing.
   *Against the recommendation of the two icons the owner had sketched, and against leaving the
   shipped tap-to-stop and tap-to-resume in place. Recorded although it is the shell's, because it
   changes shipped shell behaviour and is in this Story's tasks.*

Facts settled without asking, for `spec-author`, from the code as it stands: `Roster` has
`add`, `retire(_:keptUntil:)` and `commitments(on:)` and no removal; an entry is a commitment and
an optional kept-until day, and `RosterDocument.currentVersion` is 2, so a third state is a form
change ADR-1031 already says how to make. `DayScreen` writes day one on `store.roster == Roster()`,
which decision 1 leaves correct. `CommitmentsScreen` holds one optional `awaitingConfirmation:
Commitment?` and one optional `refusedChange`, with `askToStopKeeping`, `cancelStopKeeping`,
`confirmStopKeeping` and `keepAgain`; whether a removal awaiting confirmation shares that one slot
with a stop, and how the typed name reaches the seam, are `design.md`'s. `History` and
`RecordStore` take back one tick at a time and enumerate nothing by commitment, which decision 1
makes irrelevant. `DayScreen.refusedChangeRow` holds a commitment by value and is cleared when the
app is shown or the day moves; a day screen returned to reads its roster again. In the shell,
`CommitmentsView` rows are plain `Button`s and the stop confirmation is an `.alert`. Decision 1
looks like an ADR of its own — hard to reverse once a file form carries it, surprising to a reader
who expects "for good" to mean gone, and chosen against two real alternatives — and decision 3 is
an amendment to ADR-1023 in place; both are `spec-author`'s to write.

## Terms landed in CONTEXT.md

- **removed** — the third state a roster holds a commitment in: still held, in its place, with its
  kept-until day and every record, shown in neither list and owed on no later day; taken up again
  by being defined again exactly. **Removing** is the roster's verb.
- **kept until** — amended: the day a commitments screen hands on a stop is now the day before the
  one it was handed.
- **roster**, **roster store**, **commitments screen** — each amended for the third state, and the
  screen for the typed-name confirmation.

## Left open

None. Every question the frontier raised was answered, two of them against the recommendation and
one of them reaffirmed after its cost was stated. What the delta may still surface — the day
before the first supported date, and whether one confirmation slot serves both stop and removal —
is design and not a preference.
