A command that fails or does something unexplained is a stop and a report, not a thing to work
around (`AGENTS.md` rule 5). Rule 3 throughout: one scenario, one acceptance test named identically
to it, one red-green cycle.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they
  are exactly the titles boxed in §§ 2–9. Any other uncovered title is a stop.
- [x] 1.2 Carried tests this delta edits without renaming — each fixture's removal becomes a deletion,
  a stop, or a form-5 roster held removed, as its scenario now says, and nothing else in it moves:
  *a commitment put under a category over a roster kept before categories existed is read back under
  it*; *a roster store holding a commitment removed with no day it was kept until is refused*; *a
  roster store holding a commitment again after holding it stopped or removed is refused*; *a
  commitments screen lists a commitment its roster has removed in neither of its lists*; *a stopped
  commitment between the two places is passed rather than pushed*; *moving a commitment the roster
  is not keeping says it was not moved and leaves the roster as it was*; *putting a commitment the
  roster is not keeping under a category is refused*; *moving a group no commitment the roster is
  keeping is under is refused*; *a commitments screen says nothing about a commitment on neither of
  its lists*; *a commitments screen holds nothing against a change that asks for no change at all*;
  *a restart asked of a commitment that cannot be restarted does nothing and says nothing*; *a save in
  progress for a save its roster took is taken away and nothing else is written*; *renaming a
  commitment to a name another commitment already has is refused*; *putting an era on a commitment a
  roster is not keeping is refused*; *a change to a name another commitment already has is refused,
  kept or stopped alike*; *a commitments screen asked to change a commitment on neither of its lists
  does nothing and says nothing*; *a day screen opened on a roster whose commitments have all been
  removed takes nothing on*; *a commitments screen answers no look-back at a commitment on neither of
  its lists*; *a copy made leaves a commitments screen's lists and what it is awaiting exactly as they
  were*; *a commitments screen asked to restore says the copy's moment and what the copy and the phone
  keep, have stopped and hold as one-offs*; *a restore asked for and cancelled leaves a commitments
  screen and its three places as they were*; *a commitments screen that restored a copy lists what
  the copy holds and has nothing awaiting*; *a take-out made leaves a commitments screen's lists and
  what it is awaiting exactly as they were*. Tick when all twenty-three pass.
- [x] 1.3 Carried tests that change for the API or the form alone, titles and assertions untouched:
  the three typed-back tests now under the deletion requirement drive `askToDelete`; a hand-written
  roster fixture whose scenario says *the form this app writes* moves from form 5 to form 6 (no
  `removed`, an `emptied` key), and one whose scenario names an earlier form stays; a fixture that
  stands for *a later form* moves from 6 to 7. A test edited for any other reason is the design
  being wrong: stop and report it.
- [x] 1.4 Every test of a scenario going under a REMOVED heading's `**Migration:**` is deleted with
  it, and `Roster.remove`, `Roster.supersede`, their store twins and `isRemoved` go; `swift test`
  builds with none of them.

## 2. `Roster` — deleting

- [x] 2.1 deleting a commitment a roster keeps says so and takes it out of every date — catches a delete that only ends the commitment
- [x] 2.2 deleting a commitment a roster has stopped takes it out of the days it was kept on
- [x] 2.3 deleting a commitment takes every era of it with it — catches deleting the newest era alone
- [x] 2.4 deleting one commitment leaves every other where it was, under its category
- [x] 2.5 deleting a commitment a roster does not hold says it was not deleted and leaves the roster as it was
- [x] 2.6 deleting a commitment already deleted says it was not deleted
- [x] 2.7 a roster that has deleted every commitment it held is emptied and not a roster given nothing
- [x] 2.8 an emptied roster given a commitment is the same roster as one given only that commitment — catches a mark that outlives an add
- [x] 2.9 deleting a commitment on a copy of a roster leaves the roster it was copied from unchanged
- [x] 2.10 the offset just after a commitment's own passes nothing, with a stopped commitment lying between
- [x] 2.11 a roster that had stopped keeping everything it holds before a date reads back no groups on that date
- [x] 2.12 a group's stopped commitments travel with it
- [x] 2.13 a roster no longer counts a commitment it has deleted in the earliest day anything it holds is kept from
- [x] 2.14 a name a roster has deleted a commitment under is free
- [x] 2.15 a commitment offered again as itself after the roster deleted it is taken on last — catches a roster remembering a deleted identity

## 3. `RosterStore` — deleting, and form 6

- [x] 3.1 a commitment deleted through a roster store is not read back, on any date
- [x] 3.2 a deletion a roster store refuses is reported and nothing at its place changes
- [x] 3.3 a deletion that cannot be kept is refused and the roster a store reports does not move
- [x] 3.4 a roster store whose last commitment was deleted opens emptied, not holding nothing — catches a mark not written to disk
- [x] 3.5 a roster store declaring the form this app writes and saying something about removal is refused
- [x] 3.6 a roster store declaring the form this app writes and saying nothing about being emptied is refused
- [x] 3.7 a roster store declaring a form written before deletion and saying whether it was emptied is refused
- [x] 3.8 a roster store saying it was emptied while holding a commitment is refused
- [x] 3.9 a commitment deleted over a roster kept before removal existed is not read back

## 4. The upgrade — a commitment held removed is read as deleted

- [x] 4.1 a commitment a stored roster held removed is read as deleted, with every era of it — catches erasing the newest era alone
- [x] 4.2 a stopped commitment beside a removed one is read as it stands
- [x] 4.3 a stored roster whose every commitment was removed is read as emptied
- [x] 4.4 a fold that drops every entry reads an emptied roster
- [x] 4.5 reading a removed commitment as deleted changes nothing at the place, and the next change is written without it
- [x] 4.6 the records of a commitment a stored roster held removed are erased when a commitments screen is opened
- [x] 4.7 the records of a commitment a stored roster held removed are erased when a day screen is opened
- [x] 4.8 a record of a removed commitment is not carried back to a commitment alike to it — catches erasing after the carry-back
- [x] 4.9 a record place that cannot be written keeps a removed commitment's records from every commitment

## 5. `CommitmentsScreen` — deleting by the name typed back

- [x] 5.1 asking a commitments screen to delete a commitment changes nothing until it is confirmed
- [x] 5.2 a commitment whose name ends in a space is deleted by typing the name without it
- [x] 5.3 a deletion confirmed on a name that does not match changes nothing and refuses nothing
- [x] 5.4 a deletion confirmed with nothing awaiting deletion changes nothing
- [x] 5.5 a commitment deleted through a commitments screen is answered on no date by its roster place — catches the old day-before stop
- [x] 5.6 a stopped commitment deleted through a commitments screen is on neither list and on no date
- [x] 5.7 a commitment deleted through a commitments screen is in neither of its lists
- [x] 5.8 a deletion a commitments screen has been asked for and then cancelled changes nothing
- [x] 5.9 a commitments screen asked to delete a second commitment awaits deletion of that one only
- [x] 5.10 a commitments screen asked to delete a commitment on neither of its lists does nothing
- [x] 5.11 asking a commitments screen to delete a commitment leaves no stop awaiting confirmation
- [x] 5.12 a commitments screen shown again leaves nothing awaiting deletion and nothing typed back
- [x] 5.13 a commitments screen opened has nothing awaiting deletion and nothing typed back
- [x] 5.14 the last commitment deleted through a commitments screen leaves its roster place emptied
- [x] 5.15 a commitments screen that cannot read its roster does nothing when it is asked to delete a commitment
- [x] 5.16 what a commitments screen holds about a refused change ends when a deletion is kept
- [x] 5.17 what a commitments screen holds about a refused change stands when a deletion is asked for and cancelled
- [x] 5.18 deleting one of two entries alike in name deletes the one it was asked about
- [x] 5.19 a commitments screen holds a refused deletion against the commitment it was asked to delete
- [x] 5.20 a commitments screen holds nothing against a deletion confirmed on a name that does not match
- [x] 5.21 what a commitments screen holds about a refused change stands when a deletion is asked about a commitment on neither of its lists
- [x] 5.22 what a commitments screen holds about a refused change stands when a deletion is confirmed with nothing awaiting deletion
- [x] 5.23 asking a commitments screen to stop keeping a commitment leaves nothing awaiting deletion
- [x] 5.24 moving a commitment leaves a deletion awaiting confirmation and what has been typed back exactly as they were
- [x] 5.25 a commitments screen takes on a name only a commitment its roster has deleted had
- [x] 5.26 a change to a name only a deleted commitment had is not refused
- [x] 5.27 a commitment defined under the name a deleted commitment had is taken on last, under the category the form carried
- [x] 5.28 an orphaned record is carried back to a stopped commitment beside the records it already holds when a day screen is opened

## 6. A deletion's records, whole or nothing

- [x] 6.1 a deletion erases every tick, number, note and addition of the commitment, from every era — catches erasing the newest era's records alone
- [x] 6.2 a deletion leaves every record of every other commitment as it was
- [x] 6.3 a commitment deleted with no record leaves the record place as it was — catches a rewrite of an unchanged record
- [x] 6.4 a deletion the record place cannot take is refused and keeps nothing at either place — catches writing the roster first
- [x] 6.5 a deletion the roster place refuses puts the record place back as it was
- [x] 6.6 a deletion on a commitments screen that cannot read its record is refused
- [x] 6.7 a commitment defined after a deletion holds none of the deleted commitment's records
- [x] 6.8 a deletion a commitments screen could not keep leaves both its lists as they were — catches a refused deletion that drops a stopped commitment

## 7. `day-screen`

- [x] 7.1 a day screen draws a deleted commitment on no day, the days it was ticked on included
- [x] 7.2 a day screen's day picker no longer reaches back to a commitment its roster has deleted
- [x] 7.3 a day screen opened on a roster whose last commitment was deleted takes nothing on — catches day one written over an emptied roster

## 8. `restore`

- [x] 8.1 a copy of an emptied roster restores an emptied roster, and a day screen takes nothing on — catches a copy dropping the mark
- [x] 8.2 a copy made after a deletion holds neither the commitment nor its records
- [x] 8.3 a copy holding a removed commitment restores none of it and none of its records
- [x] 8.4 a commitment defined, stopped, taken up again and deleted through a commitments screen each write a copy at the copy place

## 9. The shell

- [x] 9.1 `CommitmentsView.swift`: both lists' trash swipe reads *Delete* and calls `askToDelete`; the
  sheet is `design.md` § *What the shell draws*, titled *Delete <name>*, its *Delete* button
  disabled until `nameTypedBackMatches`, the footer drawn only while `copyPlace` is set; refusals
  shown where a removal's were. `grep -rn -i "remov" src/DayByDay` finds no commitment removal left.

## 10. The walk

- [x] 10.1 The delete sheet on "Gym" with no copy place picked and "Gm" typed — *Delete* disabled, no footer.
- [x] 10.2 The same sheet after a copy place is picked and "Gym" typed — *Delete* enabled, the footer naming Files.
- [x] 10.3 The commitments screen after "Gym" is deleted from the kept list and a stopped one from the stopped list — neither shown.
- [x] 10.4 The day screen on a past day "Gym" was ticked on — drawn without a "Gym" row.
- [x] 10.5 The last commitment deleted, the app relaunched — the day screen holding no commitment rows.
- [x] 10.6 Post the pictures to the PR with `pnpm run walk -- --post-only <pr>` before hand-back, and
  tick this on the comment's URL — that command and never `gh pr comment --attach`. https://github.com/dbugmann-labs/daybyday/pull/313#issuecomment-5793861354

## 11. Gates and the archive handover

- [x] 11.1 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` reporting every test
  passing, the count read off the run.
- [x] 11.2 `openspec validate delete-a-commitment-for-good --strict` exits 0 and `pnpm run checks`
  is clean but for what it is expected to warn.
- [x] 11.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`.
- [x] 11.4 The **implementer** ticks this box in its last commit before the archive, on the evidence
  that the change folder is committed, `tasks.md` has no other unticked box and the walk comment's
  URL is in § 10.6. The janitor then runs `/opsx:archive` and checks afterwards that the four specs
  carry every ADDED requirement, no REMOVED one and the MODIFIED ones whole. **Any drift there is a
  stop and a report, never a hand-edit.**
